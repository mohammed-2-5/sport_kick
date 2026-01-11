import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_all_fields_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_statistics_entity.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_bookings_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_platform_statistics_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/statistics/statistics_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/statistics/statistics_state.dart';

// Mock Use Cases
class MockGetPlatformStatisticsUseCase extends Mock
    implements GetPlatformStatisticsUseCase {}

class MockGetAllBookingsUseCase extends Mock implements GetAllBookingsUseCase {}

class MockGetAllFieldsUseCase extends Mock implements GetAllFieldsUseCase {}

void main() {
  late StatisticsCubit cubit;
  late MockGetPlatformStatisticsUseCase mockGetStats;
  late MockGetAllBookingsUseCase mockGetBookings;
  late MockGetAllFieldsUseCase mockGetFields;

  // Test data
  final now = DateTime.now();
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

  final testBooking = BookingEntity(
    id: 'booking-1',
    userId: 'user-1',
    fieldId: 'field-1',
    date: now,
    startTime: '10:00',
    endTime: '11:00',
    totalPrice: 100,
    currency: 'EGP',
    status: BookingStatus.confirmed,
    userName: 'John Doe',
    fieldName: 'Field A',
    createdAt: now,
  );

  final testField = FieldEntity(
    id: 'field-1',
    name: 'Test Field',
    sportCategoryId: 'cat-1',
    ownerId: 'admin-1',
    city: 'Cairo',
    address: 'Test Address',
    pricePerHour: 100.0,
    currency: 'EGP',
    isActive: true,
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    mockGetStats = MockGetPlatformStatisticsUseCase();
    mockGetBookings = MockGetAllBookingsUseCase();
    mockGetFields = MockGetAllFieldsUseCase();

    cubit = StatisticsCubit(
      getPlatformStatisticsUseCase: mockGetStats,
      getAllBookingsUseCase: mockGetBookings,
      getAllFieldsUseCase: mockGetFields,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('StatisticsCubit', () {
    test('initial state is StatisticsInitial', () {
      expect(cubit.state, const StatisticsInitial());
    });
  });

  group('loadPlatformStatistics', () {
    blocTest<StatisticsCubit, StatisticsState>(
      'emits [Loading, PlatformStatisticsLoaded] when loading succeeds',
      build: () {
        when(() => mockGetStats()).thenAnswer((_) async => Right(testStats));
        return cubit;
      },
      act: (cubit) => cubit.loadPlatformStatistics(),
      expect: () => [
        isA<StatisticsLoading>().having(
          (s) => s.message,
          'message',
          'Loading statistics...',
        ),
        isA<PlatformStatisticsLoaded>().having(
          (s) => s.statistics.totalUsers,
          'totalUsers',
          100,
        ),
      ],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'emits [Loading, Error] when loading fails',
      build: () {
        when(
          () => mockGetStats(),
        ).thenAnswer((_) async => const Left(ServerFailure('Network error')));
        return cubit;
      },
      act: (cubit) => cubit.loadPlatformStatistics(),
      expect: () => [
        isA<StatisticsLoading>(),
        isA<StatisticsError>().having(
          (s) => s.message,
          'message',
          'Network error',
        ),
      ],
    );
  });

  group('loadAnalyticsData', () {
    blocTest<StatisticsCubit, StatisticsState>(
      'emits [Loading, AnalyticsDataLoaded] when all data loads successfully',
      build: () {
        when(
          () => mockGetBookings(),
        ).thenAnswer((_) async => Right([testBooking]));
        when(() => mockGetFields()).thenAnswer((_) async => Right([testField]));
        when(() => mockGetStats()).thenAnswer((_) async => Right(testStats));
        return cubit;
      },
      act: (cubit) => cubit.loadAnalyticsData(),
      expect: () => [
        isA<StatisticsLoading>().having(
          (s) => s.message,
          'message',
          'Loading analytics...',
        ),
        isA<AnalyticsDataLoaded>()
            .having((s) => s.bookings.length, 'bookings', 1)
            .having((s) => s.fields.length, 'fields', 1)
            .having((s) => s.statistics, 'statistics', isNotNull),
      ],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'emits Error when bookings fail to load',
      build: () {
        when(
          () => mockGetBookings(),
        ).thenAnswer((_) async => const Left(ServerFailure('Bookings error')));
        return cubit;
      },
      act: (cubit) => cubit.loadAnalyticsData(),
      expect: () => [
        isA<StatisticsLoading>(),
        isA<StatisticsError>().having(
          (s) => s.message,
          'message',
          'Bookings error',
        ),
      ],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'emits Error when fields fail to load',
      build: () {
        when(
          () => mockGetBookings(),
        ).thenAnswer((_) async => Right([testBooking]));
        when(
          () => mockGetFields(),
        ).thenAnswer((_) async => const Left(ServerFailure('Fields error')));
        return cubit;
      },
      act: (cubit) => cubit.loadAnalyticsData(),
      expect: () => [
        isA<StatisticsLoading>(),
        isA<StatisticsError>().having(
          (s) => s.message,
          'message',
          'Fields error',
        ),
      ],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'loads analytics even if statistics fail (partial success)',
      build: () {
        when(
          () => mockGetBookings(),
        ).thenAnswer((_) async => Right([testBooking]));
        when(() => mockGetFields()).thenAnswer((_) async => Right([testField]));
        when(
          () => mockGetStats(),
        ).thenAnswer((_) async => const Left(ServerFailure('Stats error')));
        return cubit;
      },
      act: (cubit) => cubit.loadAnalyticsData(),
      expect: () => [
        isA<StatisticsLoading>(),
        isA<AnalyticsDataLoaded>().having(
          (s) => s.statistics,
          'statistics',
          isNull,
        ),
      ],
    );
  });

  group('reset', () {
    blocTest<StatisticsCubit, StatisticsState>(
      'resets to initial state',
      build: () => cubit,
      seed: () => PlatformStatisticsLoaded(testStats),
      act: (cubit) => cubit.reset(),
      expect: () => [const StatisticsInitial()],
    );
  });
}
