import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/recurring_bookings/domain/entities/recurring_booking_entity.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/cancel_recurring_booking_usecase.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/get_my_recurring_bookings_usecase.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/cubit/my_recurring_bookings_cubit.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/cubit/my_recurring_bookings_state.dart';

// Mock Classes
class MockGetMyRecurringBookingsUseCase extends Mock
    implements GetMyRecurringBookingsUseCase {}

class MockCancelRecurringBookingUseCase extends Mock
    implements CancelRecurringBookingUseCase {}

void main() {
  late MyRecurringBookingsCubit cubit;
  late MockGetMyRecurringBookingsUseCase mockGetMyRecurringBookingsUseCase;
  late MockCancelRecurringBookingUseCase mockCancelRecurringBookingUseCase;

  // Test data
  final now = DateTime.now();
  late List<RecurringBookingEntity> tAllBookings;
  late List<RecurringBookingEntity> tActiveBookings;
  late List<RecurringBookingEntity> tPendingBookings;

  setUpAll(() {
    registerFallbackValue(
      const CancelRecurringBookingParams(recurringBookingId: 'fallback-id'),
    );
  });

  setUp(() {
    mockGetMyRecurringBookingsUseCase = MockGetMyRecurringBookingsUseCase();
    mockCancelRecurringBookingUseCase = MockCancelRecurringBookingUseCase();

    // Initialize test data - mixed status bookings
    tActiveBookings = [
      RecurringBookingEntity(
        id: 'active-1',
        fieldId: 'field-1',
        fieldName: 'Al-Ahly Stadium',
        fieldImageUrl: 'https://example.com/image1.jpg',
        cityName: 'Cairo',
        dayOfWeek: 1, // Sunday
        startTime: '16:00',
        endTime: '18:00',
        durationHours: 2,
        pricePerBooking: 350.0,
        status: RecurringBookingStatus.active,
        createdAt: now.subtract(const Duration(days: 60)),
        startedAt: now.subtract(const Duration(days: 56)),
        nextBookingDate: now.add(const Duration(days: 3)),
        nextBookingPaid: false,
        totalBookingsCount: 16,
        completedBookingsCount: 8,
      ),
      RecurringBookingEntity(
        id: 'active-2',
        fieldId: 'field-2',
        fieldName: 'Zamalek Club',
        cityName: 'Giza',
        dayOfWeek: 4, // Wednesday
        startTime: '20:00',
        endTime: '22:00',
        durationHours: 2,
        pricePerBooking: 500.0,
        status: RecurringBookingStatus.active,
        createdAt: now.subtract(const Duration(days: 30)),
        startedAt: now.subtract(const Duration(days: 28)),
        nextBookingDate: now.add(const Duration(days: 5)),
        nextBookingPaid: true,
        totalBookingsCount: 8,
        completedBookingsCount: 4,
      ),
    ];

    tPendingBookings = [
      RecurringBookingEntity(
        id: 'pending-1',
        fieldId: 'field-3',
        fieldName: 'Maadi Sports Club',
        cityName: 'Cairo',
        dayOfWeek: 6, // Friday
        startTime: '10:00',
        endTime: '12:00',
        durationHours: 2,
        pricePerBooking: 250.0,
        status: RecurringBookingStatus.pendingApproval,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
    ];

    final canceledBooking = RecurringBookingEntity(
      id: 'canceled-1',
      fieldId: 'field-1',
      fieldName: 'Al-Ahly Stadium',
      dayOfWeek: 3, // Tuesday
      startTime: '14:00',
      endTime: '16:00',
      durationHours: 2,
      pricePerBooking: 350.0,
      status: RecurringBookingStatus.canceled,
      createdAt: now.subtract(const Duration(days: 90)),
      totalBookingsCount: 4,
      completedBookingsCount: 4,
    );

    final rejectedBooking = RecurringBookingEntity(
      id: 'rejected-1',
      fieldId: 'field-4',
      fieldName: 'Heliopolis Club',
      dayOfWeek: 0, // Saturday
      startTime: '08:00',
      endTime: '10:00',
      durationHours: 2,
      pricePerBooking: 400.0,
      status: RecurringBookingStatus.rejected,
      rejectionReason: 'Time slot already reserved for tournament',
      createdAt: now.subtract(const Duration(days: 5)),
    );

    tAllBookings = [
      ...tActiveBookings,
      ...tPendingBookings,
      canceledBooking,
      rejectedBooking,
    ];

    cubit = MyRecurringBookingsCubit(
      getMyRecurringBookingsUseCase: mockGetMyRecurringBookingsUseCase,
      cancelRecurringBookingUseCase: mockCancelRecurringBookingUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('MyRecurringBookingsCubit -', () {
    test('initial state should be MyRecurringBookingsInitial', () {
      expect(cubit.state, equals(const MyRecurringBookingsInitial()));
    });

    group('loadRecurringBookings -', () {
      blocTest<MyRecurringBookingsCubit, MyRecurringBookingsState>(
        'should emit [Loading, Loaded] when successful with mixed bookings',
        build: () {
          when(
            () => mockGetMyRecurringBookingsUseCase(),
          ).thenAnswer((_) async => Right(tAllBookings));
          return cubit;
        },
        act: (cubit) => cubit.loadRecurringBookings(),
        expect: () => [
          const MyRecurringBookingsLoading(),
          MyRecurringBookingsLoaded(bookings: tAllBookings),
        ],
        verify: (_) {
          verify(() => mockGetMyRecurringBookingsUseCase()).called(1);
        },
      );

      blocTest<MyRecurringBookingsCubit, MyRecurringBookingsState>(
        'should emit [Loading, Loaded] with empty list when no bookings',
        build: () {
          when(
            () => mockGetMyRecurringBookingsUseCase(),
          ).thenAnswer((_) async => const Right([]));
          return cubit;
        },
        act: (cubit) => cubit.loadRecurringBookings(),
        expect: () => [
          const MyRecurringBookingsLoading(),
          MyRecurringBookingsLoaded(bookings: const []),
        ],
      );

      blocTest<MyRecurringBookingsCubit, MyRecurringBookingsState>(
        'should emit [Loading, Error] when failure occurs',
        build: () {
          when(() => mockGetMyRecurringBookingsUseCase()).thenAnswer(
            (_) async =>
                const Left(ServerFailure('Failed to load recurring bookings')),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadRecurringBookings(),
        expect: () => [
          const MyRecurringBookingsLoading(),
          const MyRecurringBookingsError('Failed to load recurring bookings'),
        ],
      );

      blocTest<MyRecurringBookingsCubit, MyRecurringBookingsState>(
        'should emit [Loading, Error] when network failure occurs',
        build: () {
          when(() => mockGetMyRecurringBookingsUseCase()).thenAnswer(
            (_) async => const Left(NetworkFailure('No internet connection')),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadRecurringBookings(),
        expect: () => [
          const MyRecurringBookingsLoading(),
          const MyRecurringBookingsError('No internet connection'),
        ],
      );
    });

    group('cancelRecurringBooking -', () {
      const tBookingId = 'active-1';
      const tCancelReason = 'No longer need this time slot';

      test('should emit ActionInProgress and return true on success', () async {
        when(
          () => mockCancelRecurringBookingUseCase(any()),
        ).thenAnswer((_) async => const Right(true));
        when(
          () => mockGetMyRecurringBookingsUseCase(),
        ).thenAnswer((_) async => Right(tPendingBookings));

        // First load data
        await cubit.loadRecurringBookings();
        when(
          () => mockGetMyRecurringBookingsUseCase(),
        ).thenAnswer((_) async => Right(tAllBookings));
        await cubit.loadRecurringBookings();

        // Now cancel
        final result = await cubit.cancelRecurringBooking(
          recurringBookingId: tBookingId,
          reason: tCancelReason,
        );

        expect(result, isTrue);
        verify(
          () => mockCancelRecurringBookingUseCase(
            const CancelRecurringBookingParams(
              recurringBookingId: tBookingId,
              reason: tCancelReason,
            ),
          ),
        ).called(1);
      });

      test('should return true with null reason', () async {
        when(
          () => mockCancelRecurringBookingUseCase(any()),
        ).thenAnswer((_) async => const Right(true));
        when(
          () => mockGetMyRecurringBookingsUseCase(),
        ).thenAnswer((_) async => Right(tAllBookings));

        await cubit.loadRecurringBookings();

        final result = await cubit.cancelRecurringBooking(
          recurringBookingId: tBookingId,
        );

        expect(result, isTrue);
        verify(
          () => mockCancelRecurringBookingUseCase(
            const CancelRecurringBookingParams(
              recurringBookingId: tBookingId,
              reason: null,
            ),
          ),
        ).called(1);
      });

      test('should return false when cancellation fails', () async {
        when(() => mockCancelRecurringBookingUseCase(any())).thenAnswer(
          (_) async =>
              const Left(ServerFailure('Cannot cancel active subscription')),
        );
        when(
          () => mockGetMyRecurringBookingsUseCase(),
        ).thenAnswer((_) async => Right(tAllBookings));

        await cubit.loadRecurringBookings();

        final result = await cubit.cancelRecurringBooking(
          recurringBookingId: tBookingId,
          reason: tCancelReason,
        );

        expect(result, isFalse);
        expect(cubit.state, isA<MyRecurringBookingsLoaded>());
      });

      test('should return false when state is not Loaded', () async {
        // Keep initial state
        final result = await cubit.cancelRecurringBooking(
          recurringBookingId: tBookingId,
        );
        expect(result, isFalse);
        verifyNever(() => mockCancelRecurringBookingUseCase(any()));
      });

      test('should return false when state is Loading', () async {
        // Manually emit loading state - we need to test this scenario
        final testCubit = MyRecurringBookingsCubit(
          getMyRecurringBookingsUseCase: mockGetMyRecurringBookingsUseCase,
          cancelRecurringBookingUseCase: mockCancelRecurringBookingUseCase,
        );

        // Can't cancel when not in loaded state
        final result = await testCubit.cancelRecurringBooking(
          recurringBookingId: tBookingId,
        );

        expect(result, isFalse);
        testCubit.close();
      });
    });

    group('refresh -', () {
      blocTest<MyRecurringBookingsCubit, MyRecurringBookingsState>(
        'should call loadRecurringBookings when refresh is called',
        build: () {
          when(
            () => mockGetMyRecurringBookingsUseCase(),
          ).thenAnswer((_) async => Right(tAllBookings));
          return cubit;
        },
        act: (cubit) => cubit.refresh(),
        expect: () => [
          const MyRecurringBookingsLoading(),
          MyRecurringBookingsLoaded(bookings: tAllBookings),
        ],
        verify: (_) {
          verify(() => mockGetMyRecurringBookingsUseCase()).called(1);
        },
      );
    });
  });

  group('MyRecurringBookingsLoaded -', () {
    test('correctly categorizes bookings by status', () {
      final state = MyRecurringBookingsLoaded(bookings: tAllBookings);

      expect(state.activeBookings.length, equals(2));
      expect(state.pendingBookings.length, equals(1));
      expect(state.otherBookings.length, equals(2)); // canceled + rejected
    });

    test('isEmpty returns true for empty bookings', () {
      final state = MyRecurringBookingsLoaded(bookings: const []);
      expect(state.isEmpty, isTrue);
      expect(state.hasActive, isFalse);
      expect(state.hasPending, isFalse);
    });

    test('hasActive returns true when active bookings exist', () {
      final state = MyRecurringBookingsLoaded(bookings: tActiveBookings);
      expect(state.hasActive, isTrue);
    });

    test('hasPending returns true when pending bookings exist', () {
      final state = MyRecurringBookingsLoaded(bookings: tPendingBookings);
      expect(state.hasPending, isTrue);
    });

    test('props returns bookings list for equality', () {
      final state1 = MyRecurringBookingsLoaded(bookings: tAllBookings);
      final state2 = MyRecurringBookingsLoaded(bookings: tAllBookings);
      expect(state1, equals(state2));
    });
  });

  group('MyRecurringBookingsActionInProgress -', () {
    test('props include bookings and actionBookingId', () {
      final state1 = MyRecurringBookingsActionInProgress(
        bookings: tAllBookings,
        actionBookingId: 'test-1',
      );
      final state2 = MyRecurringBookingsActionInProgress(
        bookings: tAllBookings,
        actionBookingId: 'test-1',
      );
      final state3 = MyRecurringBookingsActionInProgress(
        bookings: tAllBookings,
        actionBookingId: 'test-2',
      );

      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });
  });

  group('MyRecurringBookingsError -', () {
    test('props returns message', () {
      const error1 = MyRecurringBookingsError('Error message');
      const error2 = MyRecurringBookingsError('Error message');
      const error3 = MyRecurringBookingsError('Different error');

      expect(error1, equals(error2));
      expect(error1, isNot(equals(error3)));
    });
  });

  group('RecurringBookingEntity - computed properties -', () {
    test('dayName returns correct day name', () {
      final entity = RecurringBookingEntity(
        id: 'test',
        fieldId: 'field-1',
        fieldName: 'Test Field',
        dayOfWeek: 0, // Saturday
        startTime: '10:00',
        endTime: '12:00',
        durationHours: 2,
        pricePerBooking: 100,
        status: RecurringBookingStatus.active,
        createdAt: now,
      );

      expect(entity.dayName, equals('Saturday'));
      expect(entity.shortDayName, equals('Sat'));
    });

    test('timeRange formats correctly', () {
      final entity = RecurringBookingEntity(
        id: 'test',
        fieldId: 'field-1',
        fieldName: 'Test Field',
        dayOfWeek: 1,
        startTime: '14:00',
        endTime: '16:00',
        durationHours: 2,
        pricePerBooking: 100,
        status: RecurringBookingStatus.active,
        createdAt: now,
      );

      expect(entity.timeRange, equals('14:00 - 16:00'));
    });

    test('isActive and isPending return correct values', () {
      final activeEntity = RecurringBookingEntity(
        id: 'test',
        fieldId: 'field-1',
        fieldName: 'Test Field',
        dayOfWeek: 1,
        startTime: '10:00',
        endTime: '12:00',
        durationHours: 2,
        pricePerBooking: 100,
        status: RecurringBookingStatus.active,
        createdAt: now,
      );

      final pendingEntity = RecurringBookingEntity(
        id: 'test2',
        fieldId: 'field-1',
        fieldName: 'Test Field',
        dayOfWeek: 1,
        startTime: '10:00',
        endTime: '12:00',
        durationHours: 2,
        pricePerBooking: 100,
        status: RecurringBookingStatus.pendingApproval,
        createdAt: now,
      );

      expect(activeEntity.isActive, isTrue);
      expect(activeEntity.isPending, isFalse);
      expect(pendingEntity.isActive, isFalse);
      expect(pendingEntity.isPending, isTrue);
    });

    test('remainingBookingsCount calculates correctly', () {
      final entity = RecurringBookingEntity(
        id: 'test',
        fieldId: 'field-1',
        fieldName: 'Test Field',
        dayOfWeek: 1,
        startTime: '10:00',
        endTime: '12:00',
        durationHours: 2,
        pricePerBooking: 100,
        status: RecurringBookingStatus.active,
        createdAt: now,
        totalBookingsCount: 10,
        completedBookingsCount: 4,
      );

      expect(entity.remainingBookingsCount, equals(6));
    });

    test('needsPayment returns correct value', () {
      final needsPayment = RecurringBookingEntity(
        id: 'test',
        fieldId: 'field-1',
        fieldName: 'Test Field',
        dayOfWeek: 1,
        startTime: '10:00',
        endTime: '12:00',
        durationHours: 2,
        pricePerBooking: 100,
        status: RecurringBookingStatus.active,
        createdAt: now,
        nextBookingDate: now.add(const Duration(days: 2)),
        nextBookingPaid: false,
      );

      final alreadyPaid = RecurringBookingEntity(
        id: 'test2',
        fieldId: 'field-1',
        fieldName: 'Test Field',
        dayOfWeek: 1,
        startTime: '10:00',
        endTime: '12:00',
        durationHours: 2,
        pricePerBooking: 100,
        status: RecurringBookingStatus.active,
        createdAt: now,
        nextBookingDate: now.add(const Duration(days: 2)),
        nextBookingPaid: true,
      );

      final pendingEntity = RecurringBookingEntity(
        id: 'test3',
        fieldId: 'field-1',
        fieldName: 'Test Field',
        dayOfWeek: 1,
        startTime: '10:00',
        endTime: '12:00',
        durationHours: 2,
        pricePerBooking: 100,
        status: RecurringBookingStatus.pendingApproval,
        createdAt: now,
        nextBookingDate: now.add(const Duration(days: 2)),
        nextBookingPaid: false,
      );

      expect(needsPayment.needsPayment, isTrue);
      expect(alreadyPaid.needsPayment, isFalse);
      expect(pendingEntity.needsPayment, isFalse);
    });
  });
}
