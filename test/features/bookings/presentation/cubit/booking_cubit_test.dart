import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_state.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late BookingCubit cubit;
  late MockGetAvailableTimeSlotsUseCase mockGetAvailableTimeSlotsUseCase;
  late MockCreateBookingUseCase mockCreateBookingUseCase;
  late MockCreateManualBookingUseCase mockCreateManualBookingUseCase;
  late MockGetUserBookingsUseCase mockGetUserBookingsUseCase;
  late MockGetBookingByIdUseCase mockGetBookingByIdUseCase;
  late MockCancelBookingUseCase mockCancelBookingUseCase;
  late MockBookingGetOwnerBookingsUseCase mockGetOwnerBookingsUseCase;
  late MockUpdateBookingStatusUseCase mockUpdateBookingStatusUseCase;

  // Test data
  late List<TimeSlotEntity> tTimeSlots;
  late BookingEntity tBooking;
  late List<BookingEntity> tBookings;
  final now = DateTime.now();

  setUp(() {
    // Initialize mocks
    mockGetAvailableTimeSlotsUseCase = MockGetAvailableTimeSlotsUseCase();
    mockCreateBookingUseCase = MockCreateBookingUseCase();
    mockCreateManualBookingUseCase = MockCreateManualBookingUseCase();
    mockGetUserBookingsUseCase = MockGetUserBookingsUseCase();
    mockGetBookingByIdUseCase = MockGetBookingByIdUseCase();
    mockCancelBookingUseCase = MockCancelBookingUseCase();
    mockGetOwnerBookingsUseCase = MockBookingGetOwnerBookingsUseCase();
    mockUpdateBookingStatusUseCase = MockUpdateBookingStatusUseCase();

    // Initialize test data
    tTimeSlots = [
      const TimeSlotEntity(
        startTime: '10:00',
        endTime: '11:00',
        isAvailable: true,
        price: 150.0,
        currency: 'EGP',
      ),
    ];

    tBooking = BookingEntity(
      id: 'booking-1',
      fieldId: 'field-1',
      userId: 'user-1',
      date: now,
      startTime: '10:00',
      endTime: '11:00',
      totalPrice: 150.0,
      currency: 'EGP',
      status: BookingStatus.pending,
      createdAt: now,
    );

    tBookings = [tBooking];

    // Create cubit
    cubit = BookingCubit(
      getAvailableTimeSlotsUseCase: mockGetAvailableTimeSlotsUseCase,
      createBookingUseCase: mockCreateBookingUseCase,
      createManualBookingUseCase: mockCreateManualBookingUseCase,
      getUserBookingsUseCase: mockGetUserBookingsUseCase,
      getBookingByIdUseCase: mockGetBookingByIdUseCase,
      cancelBookingUseCase: mockCancelBookingUseCase,
      getOwnerBookingsUseCase: mockGetOwnerBookingsUseCase,
      updateBookingStatusUseCase: mockUpdateBookingStatusUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('BookingCubit -', () {
    test('initial state should be BookingInitial', () {
      expect(cubit.state, equals(const BookingInitial()));
    });

    group('loadAvailableTimeSlots -', () {
      const tFieldId = 'field-1';
      final tDate = now;

      blocTest<BookingCubit, BookingState>(
        'should emit [Loading, TimeSlotsLoaded] when successful',
        build: () {
          when(
            () => mockGetAvailableTimeSlotsUseCase(
              fieldId: tFieldId,
              date: tDate,
            ),
          ).thenAnswer((_) async => Right(tTimeSlots));
          return cubit;
        },
        act: (cubit) =>
            cubit.loadAvailableTimeSlots(fieldId: tFieldId, date: tDate),
        expect: () => [
          const BookingLoading(message: 'Loading available time slots...'),
          TimeSlotsLoaded(
            timeSlots: tTimeSlots,
            selectedDate: tDate,
            fieldId: tFieldId,
          ),
        ],
      );

      blocTest<BookingCubit, BookingState>(
        'should emit [Loading, Empty] when no slots available',
        build: () {
          when(
            () => mockGetAvailableTimeSlotsUseCase(
              fieldId: tFieldId,
              date: tDate,
            ),
          ).thenAnswer((_) async => const Right([]));
          return cubit;
        },
        act: (cubit) =>
            cubit.loadAvailableTimeSlots(fieldId: tFieldId, date: tDate),
        expect: () => [
          const BookingLoading(message: 'Loading available time slots...'),
          const BookingsEmpty(
            message: 'No time slots available for this date.',
          ),
        ],
      );
    });

    group('createBooking -', () {
      const tFieldId = 'field-1';
      final tDate = now;
      const tStartTime = '10:00';
      const tEndTime = '11:00';
      const tPrice = 150.0;

      blocTest<BookingCubit, BookingState>(
        'should emit [Loading, Created] when successful',
        build: () {
          when(
            () => mockCreateBookingUseCase(
              fieldId: tFieldId,
              date: tDate,
              startTime: tStartTime,
              endTime: tEndTime,
              totalPrice: tPrice,
              notes: null,
            ),
          ).thenAnswer((_) async => Right(tBooking));
          return cubit;
        },
        act: (cubit) => cubit.createBooking(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tPrice,
        ),
        expect: () => [
          const BookingLoading(message: 'Creating booking...'),
          BookingCreated(tBooking),
        ],
      );
    });

    group('loadUserBookings -', () {
      blocTest<BookingCubit, BookingState>(
        'should emit [Loading, Loaded] when successful',
        build: () {
          when(
            () => mockGetUserBookingsUseCase(),
          ).thenAnswer((_) async => Right(tBookings));
          return cubit;
        },
        act: (cubit) => cubit.loadUserBookings(),
        expect: () => [
          const BookingLoading(message: 'Loading your bookings...'),
          BookingsLoaded(tBookings),
        ],
      );
    });

    group('cancelBooking -', () {
      const tBookingId = 'booking-1';
      const tReason = 'Changed mind';

      blocTest<BookingCubit, BookingState>(
        'should emit [Loading, Canceled] when successful',
        build: () {
          when(
            () => mockCancelBookingUseCase(
              bookingId: tBookingId,
              reason: tReason,
            ),
          ).thenAnswer((_) async => Right(tBooking));
          return cubit;
        },
        act: (cubit) =>
            cubit.cancelBooking(bookingId: tBookingId, reason: tReason),
        expect: () => [
          const BookingLoading(message: 'Canceling booking...'),
          BookingCanceled(tBooking),
        ],
      );
    });

    group('updateBookingStatus -', () {
      const tBookingId = 'booking-1';
      const tStatus = BookingStatus.confirmed;

      blocTest<BookingCubit, BookingState>(
        'should emit [Loading, Loaded] (reload) when successful',
        build: () {
          when(
            () => mockUpdateBookingStatusUseCase(
              bookingId: tBookingId,
              status: tStatus,
            ),
          ).thenAnswer((_) async => Right(tBooking));
          when(
            () => mockGetOwnerBookingsUseCase(),
          ).thenAnswer((_) async => Right(tBookings));
          return cubit;
        },
        act: (cubit) => cubit.updateBookingStatus(tBookingId, tStatus),
        expect: () => [
          const BookingLoading(message: 'Updating booking...'),
          const BookingLoading(message: 'Loading bookings...'),
          BookingsLoaded(tBookings),
        ],
      );
    });
  });
}
