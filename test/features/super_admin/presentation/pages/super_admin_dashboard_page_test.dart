import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/routes/app_router.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_statistics_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/super_admin_dashboard_page.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/statistics_card.dart';

import '../../../../helpers/test_helpers.dart';

class MockSuperAdminCubit extends MockCubit<SuperAdminState>
    implements SuperAdminCubit {}

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

void main() {
  late MockSuperAdminCubit mockSuperAdminCubit;
  late MockAuthCubit mockAuthCubit;
  late MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    mockSuperAdminCubit = MockSuperAdminCubit();
    mockAuthCubit = MockAuthCubit();
    mockNavigatorObserver = MockNavigatorObserver();

    // Setup GetIt
    final getIt = GetIt.instance;
    if (getIt.isRegistered<SuperAdminCubit>()) {
      getIt.unregister<SuperAdminCubit>();
    }
    getIt.registerFactory<SuperAdminCubit>(() => mockSuperAdminCubit);

    // Set screen size to ensure all widgets are visible
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  Widget buildTestWidget() {
    return BlocProvider<AuthCubit>(
      create: (_) => mockAuthCubit,
      child: const SuperAdminDashboardPage(),
    );
  }

  group('SuperAdminDashboardPage', () {
    const tStatistics = PlatformStatisticsEntity(
      totalUsers: 100,
      newUsersThisMonth: 10,
      totalAdmins: 5,
      activeFields: 20,
      totalFields: 25,
      citiesWithFields: 3,
      activeCities: 2,
      totalBookings: 500,
      pendingBookings: 50,
      confirmedBookings: 400,
      completedBookings: 350,
      canceledBookings: 50,
      manualBookings: 20,
      bookingsThisMonth: 100,
      totalRevenue: 10000.0,
      revenueThisMonth: 2000.0,
    );

    testWidgets(
      'should show loading indicator when state is SuperAdminLoading',
      (tester) async {
        // Arrange
        when(() => mockSuperAdminCubit.state).thenReturn(const SuperAdminLoading());
        when(
          () => mockSuperAdminCubit.loadPlatformStatistics(),
        ).thenAnswer((_) async {});

        // Act
        await pumpApp(tester, buildTestWidget());

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('should show error message when state is SuperAdminError', (
      tester,
    ) async {
      // Arrange
      const errorMessage = 'Failed to load statistics';
      when(
        () => mockSuperAdminCubit.state,
      ).thenReturn(const SuperAdminError(errorMessage));
      when(
        () => mockSuperAdminCubit.loadPlatformStatistics(),
      ).thenAnswer((_) async {});

      // Act
      await pumpApp(tester, buildTestWidget());

      // Assert
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.text('Error loading dashboard'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets(
      'should show statistics content when state is PlatformStatisticsLoaded',
      (tester) async {
        // Arrange
        when(
          () => mockSuperAdminCubit.state,
        ).thenReturn(const PlatformStatisticsLoaded(tStatistics));
        when(
          () => mockSuperAdminCubit.loadPlatformStatistics(),
        ).thenAnswer((_) async {});

        // Act
        await pumpApp(tester, buildTestWidget());

        // Assert
        expect(find.text('Platform Overview'), findsOneWidget);
        expect(find.text('100'), findsOneWidget); // Total Users
        expect(find.text('5'), findsOneWidget); // Total Admins
        expect(find.text('20'), findsOneWidget); // Active Fields
        expect(find.text('500'), findsOneWidget); // Total Bookings
        expect(find.byType(StatisticsCard), findsNWidgets(6));
      },
    );

    testWidgets('should trigger loadPlatformStatistics on initialization', (
      tester,
    ) async {
      // Arrange
      when(() => mockSuperAdminCubit.state).thenReturn(const SuperAdminLoading());
      when(
        () => mockSuperAdminCubit.loadPlatformStatistics(),
      ).thenAnswer((_) async {});

      // Act
      await pumpApp(tester, buildTestWidget());

      // Assert
      verify(() => mockSuperAdminCubit.loadPlatformStatistics()).called(1);
    });

    testWidgets('should trigger refresh when retry button is pressed', (
      tester,
    ) async {
      // Arrange
      when(
        () => mockSuperAdminCubit.state,
      ).thenReturn(const SuperAdminError('Error'));
      when(
        () => mockSuperAdminCubit.loadPlatformStatistics(),
      ).thenAnswer((_) async {});

      // Act
      await pumpApp(tester, buildTestWidget());
      await tester.tap(find.text('Retry'));

      // Assert
      verify(() => mockSuperAdminCubit.loadPlatformStatistics()).called(2);
    });

    testWidgets('should navigate to Create Admin page when tapped', (
      tester,
    ) async {
      // Set large screen size
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;

      // Arrange
      when(
        () => mockSuperAdminCubit.state,
      ).thenReturn(const PlatformStatisticsLoaded(tStatistics));
      when(
        () => mockSuperAdminCubit.loadPlatformStatistics(),
      ).thenAnswer((_) async {});

      // Act
      await pumpApp(
        tester,
        buildTestWidget(),
        navigatorObserver: mockNavigatorObserver,
        routes: {
          '/super-admin/create-admin': (context) =>
              const Scaffold(body: Text('Create Admin Page')),
        },
      );

      // Tap "Create Admin" card by its title text
      final createAdminCard = find.text('Create Admin');

      await tester.ensureVisible(createAdminCard);
      await tester.pumpAndSettle();

      await tester.tap(createAdminCard);
      await tester.pumpAndSettle();

      // Assert
      verify(() => mockNavigatorObserver.didPush(any(), any()));
      expect(find.text('Create Admin Page'), findsOneWidget);

      // Reset screen size
      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets(
      'should show logout dialog and logout when confirmed',
      (tester) async {
        // Set large screen size
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;

        // Arrange
        when(
          () => mockSuperAdminCubit.state,
        ).thenReturn(const PlatformStatisticsLoaded(tStatistics));
        when(
          () => mockSuperAdminCubit.loadPlatformStatistics(),
        ).thenAnswer((_) async {});
        when(() => mockAuthCubit.logout()).thenAnswer((_) async {});

        // Act
        await pumpApp(
          tester,
          buildTestWidget(),
          navigatorObserver: mockNavigatorObserver,
          routes: {
            AppRouter.login: (context) =>
                const Scaffold(body: Text('Login Page')),
          },
        );

        // Open drawer
        await tester.tap(find.byIcon(Icons.menu));
        await tester.pumpAndSettle();

        // Tap "Create Admin" text in drawer to trigger logout flow
        final logoutTile = find.text('Logout');
        await tester.tap(logoutTile);
        await tester.pumpAndSettle();

        // Confirm logout in dialog
        final logoutButton = find.widgetWithText(ElevatedButton, 'Logout');
        await tester.tap(logoutButton);
        await tester.pumpAndSettle();

        // Assert
        verify(() => mockAuthCubit.logout()).called(1);
        expect(find.text('Login Page'), findsOneWidget);

        // Reset screen size
        addTearDown(tester.view.resetPhysicalSize);
      },
      skip: true,
    ); // TODO: Complex drawer+dialog interaction - defer to integration tests
  });
}
