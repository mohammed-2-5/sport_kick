import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_statistics_entity.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_platform_statistics_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_dashboard/super_admin_dashboard_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_dashboard/super_admin_dashboard_state.dart';

// Mock Use Cases
class MockGetPlatformStatisticsUseCase extends Mock
    implements GetPlatformStatisticsUseCase {}

class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

void main() {
  late SuperAdminDashboardCubit cubit;
  late MockGetPlatformStatisticsUseCase mockGetStats;
  late MockGetCurrentUserUseCase mockGetCurrentUser;

  // Test data
  final now = DateTime.now();
  final testUser = UserEntity(
    id: 'admin-1',
    email: 'admin@test.com',
    fullName: 'Super Admin',
    role: 'super_admin',
    isActive: true,
    createdAt: now,
    updatedAt: now,
  );

  final testStats = PlatformStatisticsEntity(
    totalUsers: 100,
    newUsersThisMonth: 20,
    totalAdmins: 10,
    activeFields: 40,
    totalFields: 50,
    citiesWithFields: 8,
    activeCities: 10,
    totalBookings: 500,
    pendingBookings: 50,
    confirmedBookings: 200,
    completedBookings: 200,
    canceledBookings: 50,
    manualBookings: 100,
    bookingsThisMonth: 100,
    totalRevenue: 50000.0,
    revenueThisMonth: 5000.0,
  );

  setUp(() {
    mockGetStats = MockGetPlatformStatisticsUseCase();
    mockGetCurrentUser = MockGetCurrentUserUseCase();

    cubit = SuperAdminDashboardCubit(
      getPlatformStatisticsUseCase: mockGetStats,
      getCurrentUserUseCase: mockGetCurrentUser,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('SuperAdminDashboardCubit', () {
    test('initial state is SuperAdminDashboardLoading', () {
      expect(cubit.state, const SuperAdminDashboardLoading());
    });
  });

  group('loadDashboard', () {
    blocTest<SuperAdminDashboardCubit, SuperAdminDashboardState>(
      'emits [Loading, Loaded] when dashboard loads successfully',
      build: () {
        when(
          () => mockGetCurrentUser(),
        ).thenAnswer((_) async => Right(testUser));
        when(() => mockGetStats()).thenAnswer((_) async => Right(testStats));
        return cubit;
      },
      act: (cubit) => cubit.loadDashboard(),
      expect: () => [
        const SuperAdminDashboardLoading(),
        isA<SuperAdminDashboardLoaded>()
            .having((s) => s.adminName, 'adminName', 'Super Admin')
            .having((s) => s.stats.totalUsers, 'totalUsers', 100),
      ],
    );

    blocTest<SuperAdminDashboardCubit, SuperAdminDashboardState>(
      'uses fallback name when user name is null',
      build: () {
        when(() => mockGetCurrentUser()).thenAnswer(
          (_) async => Right(
            UserEntity(
              id: 'admin-1',
              email: 'admin@test.com',
              fullName: null,
              role: 'super_admin',
              createdAt: now,
              updatedAt: now,
            ),
          ),
        );
        when(() => mockGetStats()).thenAnswer((_) async => Right(testStats));
        return cubit;
      },
      act: (cubit) => cubit.loadDashboard(),
      expect: () => [
        const SuperAdminDashboardLoading(),
        isA<SuperAdminDashboardLoaded>().having(
          (s) => s.adminName,
          'adminName',
          'admin@test.com',
        ),
      ],
    );

    blocTest<SuperAdminDashboardCubit, SuperAdminDashboardState>(
      'uses Admin fallback when user fetch fails',
      build: () {
        when(
          () => mockGetCurrentUser(),
        ).thenAnswer((_) async => const Left(ServerFailure('User error')));
        when(() => mockGetStats()).thenAnswer((_) async => Right(testStats));
        return cubit;
      },
      act: (cubit) => cubit.loadDashboard(),
      expect: () => [
        const SuperAdminDashboardLoading(),
        isA<SuperAdminDashboardLoaded>().having(
          (s) => s.adminName,
          'adminName',
          'Admin',
        ),
      ],
    );

    blocTest<SuperAdminDashboardCubit, SuperAdminDashboardState>(
      'emits Error when statistics fail to load',
      build: () {
        when(
          () => mockGetCurrentUser(),
        ).thenAnswer((_) async => Right(testUser));
        when(
          () => mockGetStats(),
        ).thenAnswer((_) async => const Left(ServerFailure('Stats error')));
        return cubit;
      },
      act: (cubit) => cubit.loadDashboard(),
      expect: () => [
        const SuperAdminDashboardLoading(),
        isA<SuperAdminDashboardError>().having(
          (s) => s.message,
          'message',
          'Stats error',
        ),
      ],
    );

    blocTest<SuperAdminDashboardCubit, SuperAdminDashboardState>(
      'emits Error when exception is thrown',
      build: () {
        when(
          () => mockGetCurrentUser(),
        ).thenThrow(Exception('Unexpected error'));
        return cubit;
      },
      act: (cubit) => cubit.loadDashboard(),
      expect: () => [
        const SuperAdminDashboardLoading(),
        isA<SuperAdminDashboardError>().having(
          (s) => s.message,
          'message',
          contains('Exception'),
        ),
      ],
    );
  });

  group('refresh', () {
    final loadedState = SuperAdminDashboardLoaded(
      adminName: 'Super Admin',
      stats: testStats,
    );

    blocTest<SuperAdminDashboardCubit, SuperAdminDashboardState>(
      'sets isRefreshing and updates stats on success',
      build: () {
        when(() => mockGetStats()).thenAnswer((_) async => Right(testStats));
        return SuperAdminDashboardCubit(
          getPlatformStatisticsUseCase: mockGetStats,
          getCurrentUserUseCase: mockGetCurrentUser,
        );
      },
      seed: () => loadedState,
      act: (cubit) => cubit.refresh(),
      expect: () => [
        isA<SuperAdminDashboardLoaded>().having(
          (s) => s.isRefreshing,
          'isRefreshing',
          true,
        ),
        isA<SuperAdminDashboardLoaded>().having(
          (s) => s.isRefreshing,
          'isRefreshing',
          false,
        ),
      ],
    );

    blocTest<SuperAdminDashboardCubit, SuperAdminDashboardState>(
      'does nothing when not in loaded state',
      build: () => cubit,
      act: (cubit) => cubit.refresh(),
      expect: () => [],
    );
  });

  group('changeNavIndex', () {
    final loadedState = SuperAdminDashboardLoaded(
      adminName: 'Super Admin',
      stats: testStats,
    );

    blocTest<SuperAdminDashboardCubit, SuperAdminDashboardState>(
      'updates selectedNavIndex',
      build: () => SuperAdminDashboardCubit(
        getPlatformStatisticsUseCase: mockGetStats,
        getCurrentUserUseCase: mockGetCurrentUser,
      ),
      seed: () => loadedState,
      act: (cubit) => cubit.changeNavIndex(2),
      expect: () => [
        isA<SuperAdminDashboardLoaded>().having(
          (s) => s.selectedNavIndex,
          'selectedNavIndex',
          2,
        ),
      ],
    );
  });

  group('toggleDrawer', () {
    final loadedState = SuperAdminDashboardLoaded(
      adminName: 'Super Admin',
      stats: testStats,
    );

    blocTest<SuperAdminDashboardCubit, SuperAdminDashboardState>(
      'toggles drawer state to open',
      build: () => SuperAdminDashboardCubit(
        getPlatformStatisticsUseCase: mockGetStats,
        getCurrentUserUseCase: mockGetCurrentUser,
      ),
      seed: () => loadedState,
      act: (cubit) => cubit.toggleDrawer(true),
      expect: () => [
        isA<SuperAdminDashboardLoaded>().having(
          (s) => s.isDrawerOpen,
          'isDrawerOpen',
          true,
        ),
      ],
    );

    blocTest<SuperAdminDashboardCubit, SuperAdminDashboardState>(
      'toggles drawer state to closed',
      build: () => SuperAdminDashboardCubit(
        getPlatformStatisticsUseCase: mockGetStats,
        getCurrentUserUseCase: mockGetCurrentUser,
      ),
      seed: () => loadedState.copyWith(isDrawerOpen: true),
      act: (cubit) => cubit.toggleDrawer(false),
      expect: () => [
        isA<SuperAdminDashboardLoaded>().having(
          (s) => s.isDrawerOpen,
          'isDrawerOpen',
          false,
        ),
      ],
    );
  });

  group('helper methods', () {
    test('getGreeting returns correct greeting based on time', () {
      // This is time-dependent, so we just verify it returns a string
      final greeting = cubit.getGreeting();
      expect(greeting, anyOf('Good Morning', 'Good Afternoon', 'Good Evening'));
    });

    test('getFormattedDate returns properly formatted date', () {
      final formatted = cubit.getFormattedDate();
      expect(formatted, isNotEmpty);
      // Should match pattern like "Monday, Jan 1"
      expect(formatted, matches(RegExp(r'\w+, \w+ \d+')));
    });

    test('formatCurrency formats millions correctly', () {
      expect(cubit.formatCurrency(1500000), '1.5M EGP');
    });

    test('formatCurrency formats thousands correctly', () {
      expect(cubit.formatCurrency(1500), '1.5K EGP');
    });

    test('formatCurrency formats small values correctly', () {
      expect(cubit.formatCurrency(500), '500 EGP');
    });

    test('formatNumber formats millions correctly', () {
      expect(cubit.formatNumber(1500000), '1.5M');
    });

    test('formatNumber formats thousands correctly', () {
      expect(cubit.formatNumber(1500), '1.5K');
    });

    test('formatNumber formats small values correctly', () {
      expect(cubit.formatNumber(500), '500');
    });
  });
}
