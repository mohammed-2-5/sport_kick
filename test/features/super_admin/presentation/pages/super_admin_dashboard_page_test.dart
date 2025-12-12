import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_statistics_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/pages/super_admin_dashboard_page.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_dashboard/super_admin_dashboard_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_dashboard/super_admin_dashboard_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/dashboard/premium_super_admin_activity_card.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/dashboard/premium_super_admin_quick_actions.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/dashboard/premium_super_admin_revenue_card.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/dashboard/premium_super_admin_stats_grid.dart';

import '../../../../helpers/test_helpers.dart';

class MockSuperAdminDashboardCubit extends MockCubit<SuperAdminDashboardState>
    implements SuperAdminDashboardCubit {}

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

void main() {
  late MockSuperAdminDashboardCubit mockSuperAdminDashboardCubit;
  late MockAuthCubit mockAuthCubit;

  void setCubitState(SuperAdminDashboardState state) {
    when(() => mockSuperAdminDashboardCubit.state).thenReturn(state);
    whenListen(
      mockSuperAdminDashboardCubit,
      Stream.value(state),
      initialState: state,
    );
  }

  setUp(() {
    mockSuperAdminDashboardCubit = MockSuperAdminDashboardCubit();
    mockAuthCubit = MockAuthCubit();

    setCubitState(const SuperAdminDashboardLoading());
    when(
      () => mockSuperAdminDashboardCubit.loadDashboard(),
    ).thenAnswer((_) async {});
    when(() => mockSuperAdminDashboardCubit.refresh()).thenAnswer((_) async {});
    when(() => mockSuperAdminDashboardCubit.close()).thenAnswer((_) async {});
    when(
      () => mockSuperAdminDashboardCubit.getGreeting(),
    ).thenReturn('Good Morning');
    when(
      () => mockSuperAdminDashboardCubit.getFormattedDate(),
    ).thenReturn('Mon, Jan 1');
    when(
      () => mockSuperAdminDashboardCubit.formatCurrency(any<double>()),
    ).thenAnswer((invocation) {
      final value = invocation.positionalArguments.first as double;
      return '${value.toStringAsFixed(0)} SAR';
    });
    when(
      () => mockSuperAdminDashboardCubit.getUserGrowthPercentage(),
    ).thenReturn(0);
    when(
      () => mockSuperAdminDashboardCubit.getBookingGrowthPercentage(),
    ).thenReturn(0);
    when(
      () => mockSuperAdminDashboardCubit.getRevenueGrowthPercentage(),
    ).thenReturn(0);

    // Setup GetIt
    final getIt = GetIt.instance;
    if (getIt.isRegistered<SuperAdminDashboardCubit>()) {
      getIt.unregister<SuperAdminDashboardCubit>();
    }
    getIt.registerFactory<SuperAdminDashboardCubit>(
      () => mockSuperAdminDashboardCubit,
    );

    // Set screen size to ensure all widgets are visible
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  tearDown(() async {
    await GetIt.instance.reset();
  });

  Widget buildTestWidget() {
    return MultiBlocProvider(
      providers: [BlocProvider<AuthCubit>.value(value: mockAuthCubit)],
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
      'shows loading indicator when state is SuperAdminDashboardLoading',
      (tester) async {
        // Arrange
        setCubitState(const SuperAdminDashboardLoading());

        // Act
        await pumpApp(tester, buildTestWidget());

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        verify(() => mockSuperAdminDashboardCubit.loadDashboard()).called(1);
      },
    );

    testWidgets('shows error message when state is SuperAdminDashboardError', (
      tester,
    ) async {
      // Arrange
      const errorMessage = 'Failed to load statistics';
      setCubitState(const SuperAdminDashboardError(errorMessage));

      // Act
      await pumpApp(tester, buildTestWidget());
      await tester.pump();

      // Assert - UI shows error state
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets(
      'renders premium dashboard content when state is SuperAdminDashboardLoaded',
      (tester) async {
        // Arrange
        const loadedState = SuperAdminDashboardLoaded(
          adminName: 'Admin',
          stats: tStatistics,
        );
        setCubitState(loadedState);
        when(
          () => mockSuperAdminDashboardCubit.getUserGrowthPercentage(),
        ).thenReturn(12.5);
        when(
          () => mockSuperAdminDashboardCubit.getBookingGrowthPercentage(),
        ).thenReturn(8.0);
        when(
          () => mockSuperAdminDashboardCubit.getRevenueGrowthPercentage(),
        ).thenReturn(4.2);
        when(
          () => mockSuperAdminDashboardCubit.formatCurrency(any<double>()),
        ).thenReturn('1000 SAR');

        // Act
        await pumpApp(tester, buildTestWidget());

        // Assert
        expect(find.byType(PremiumSuperAdminStatsGrid), findsOneWidget);
        expect(find.byType(PremiumSuperAdminRevenueCard), findsOneWidget);
        expect(find.byType(PremiumSuperAdminQuickActions), findsOneWidget);
        expect(find.byType(PremiumSuperAdminActivityCard), findsOneWidget);
        expect(find.text('Total Users'), findsOneWidget);
        expect(find.text('Total Bookings'), findsOneWidget);
      },
    );

    testWidgets('should show loading state on initialization', (tester) async {
      // Act
      await pumpApp(tester, buildTestWidget());

      // Assert - UI shows loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show retry button in error state', (tester) async {
      // Arrange
      setCubitState(const SuperAdminDashboardError('Error'));

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
      const loadedState = SuperAdminDashboardLoaded(
        adminName: 'Admin',
        stats: tStatistics,
      );
      setCubitState(loadedState);
      when(
        () => mockSuperAdminDashboardCubit.getUserGrowthPercentage(),
      ).thenReturn(12.5);
      when(
        () => mockSuperAdminDashboardCubit.getBookingGrowthPercentage(),
      ).thenReturn(8.0);
      when(
        () => mockSuperAdminDashboardCubit.getRevenueGrowthPercentage(),
      ).thenReturn(4.2);
      when(
        () => mockSuperAdminDashboardCubit.formatCurrency(any<double>()),
      ).thenReturn('1000 SAR');

      // Act
      await pumpApp(tester, buildTestWidget());
      await tester.pumpAndSettle();

      // Assert - Dashboard content is visible
      expect(find.byType(PremiumSuperAdminStatsGrid), findsOneWidget);
      expect(find.byType(PremiumSuperAdminRevenueCard), findsOneWidget);
      expect(find.byType(PremiumSuperAdminQuickActions), findsOneWidget);
      expect(find.text('Quick Actions'), findsOneWidget);

      // Reset screen size
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    });
  });
}
