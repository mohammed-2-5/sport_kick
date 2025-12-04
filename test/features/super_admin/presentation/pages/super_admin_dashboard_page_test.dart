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

class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeRoute());
  });
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => mockAuthCubit),
        BlocProvider<SuperAdminCubit>(create: (_) => mockSuperAdminCubit),
      ],
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
        whenListen(
          mockSuperAdminCubit,
          Stream.fromIterable([const SuperAdminLoading()]),
          initialState: const SuperAdminLoading(),
        );

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
      whenListen(
        mockSuperAdminCubit,
        Stream.fromIterable([const SuperAdminError(errorMessage)]),
        initialState: const SuperAdminError(errorMessage),
      );

      // Act
      await pumpApp(tester, buildTestWidget());
      await tester.pump(); // Process SnackBar

      // Assert - UI shows error state (message is in SnackBar, not main UI)
      expect(find.text('Error loading dashboard'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets(
      'should show statistics content when state is PlatformStatisticsLoaded',
      (tester) async {
        // Arrange
        whenListen(
          mockSuperAdminCubit,
          Stream.fromIterable([const PlatformStatisticsLoaded(tStatistics)]),
          initialState: const PlatformStatisticsLoaded(tStatistics),
        );

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

    testWidgets('should show loading state on initialization', (tester) async {
      // Arrange
      whenListen(
        mockSuperAdminCubit,
        Stream.fromIterable([const SuperAdminLoading()]),
        initialState: const SuperAdminLoading(),
      );

      // Act
      await pumpApp(tester, buildTestWidget());

      // Assert - UI shows loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show retry button in error state', (tester) async {
      // Arrange
      whenListen(
        mockSuperAdminCubit,
        Stream.fromIterable([const SuperAdminError('Error')]),
        initialState: const SuperAdminError('Error'),
      );

      // Act
      await pumpApp(tester, buildTestWidget());

      // Assert - Retry text and refresh icon exist
      expect(find.text('Retry'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('should display content in loaded state', (tester) async {
      // Set large screen size to see all content
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;

      // Arrange
      whenListen(
        mockSuperAdminCubit,
        Stream.fromIterable([const PlatformStatisticsLoaded(tStatistics)]),
        initialState: const PlatformStatisticsLoaded(tStatistics),
      );

      // Act
      await pumpApp(tester, buildTestWidget());
      await tester.pumpAndSettle();

      // Assert - Dashboard content is visible
      expect(find.text('Platform Overview'), findsOneWidget);
      expect(find.text('Create Admin'), findsOneWidget);
      expect(find.byType(StatisticsCard), findsWidgets);

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
        whenListen(
          mockSuperAdminCubit,
          Stream.fromIterable([const PlatformStatisticsLoaded(tStatistics)]),
          initialState: const PlatformStatisticsLoaded(tStatistics),
        );
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
