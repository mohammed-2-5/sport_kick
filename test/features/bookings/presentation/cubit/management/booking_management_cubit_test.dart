import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/usecases/cancel_booking_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/get_booking_by_id_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/get_user_bookings_usecase.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/management/booking_management_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/management/booking_management_state.dart';

// Mock Use Cases
class MockGetUserBookingsUseCase extends Mock
    implements GetUserBookingsUseCase {}

class MockGetBookingByIdUseCase extends Mock implements GetBookingByIdUseCase {}

class MockCancelBookingUseCase extends Mock implements CancelBookingUseCase {}

void main() {
  late BookingManagementCubit cubit;
  late MockGetUserBookingsUseCase mockGetUserBookings;
  late MockGetBookingByIdUseCase mockGetBookingById;
  late MockCancelBookingUseCase mockCancelBooking;

  // Test data
  final now = DateTime.now();
  final testBooking = BookingEntity(
    id: 'booking-1',
    userId: 'user-1',
    fieldId: 'field-1',
    date: DateTime(now.year, now.month, now.day + 1),
    startTime: '10:00',
    endTime: '11:00',
    status: BookingStatus.pending,
    totalPrice: 100.0,
    currency: 'EGP',
    createdAt: now,
  );

  setUp(() {
    mockGetUserBookings = MockGetUserBookingsUseCase();
    mockGetBookingById = MockGetBookingByIdUseCase();
    mockCancelBooking = MockCancelBookingUseCase();

    cubit = BookingManagementCubit(
      getUserBookingsUseCase: mockGetUserBookings,
      getBookingByIdUseCase: mockGetBookingById,
      cancelBookingUseCase: mockCancelBooking,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('BookingManagementCubit', () {
    test('initial state is BookingManagementInitial', () {
      expect(cubit.state, const BookingManagementInitial());
    });
  });

  group('loadUserBookings', () {
    const loadingMessage = 'Loading bookings...';

    blocTest<BookingManagementCubit, BookingManagementState>(
      'emits [Loading, BookingsLoaded] when bookings exist',
      build: () {
        when(
          () => mockGetUserBookings(),
        ).thenAnswer((_) async => Right([testBooking]));
        return cubit;
      },
      act: (cubit) => cubit.loadUserBookings(loadingMessage: loadingMessage),
      expect: () => [
        const BookingManagementLoading(message: loadingMessage),
        isA<BookingsLoaded>().having((s) => s.bookings.length, 'count', 1),
      ],
    );

    blocTest<BookingManagementCubit, BookingManagementState>(
      'emits [Loading, BookingsEmpty] when no bookings exist',
      build: () {
        when(
          () => mockGetUserBookings(),
        ).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (cubit) => cubit.loadUserBookings(loadingMessage: loadingMessage),
      expect: () => [
        const BookingManagementLoading(message: loadingMessage),
        const BookingsEmpty(),
      ],
    );

    blocTest<BookingManagementCubit, BookingManagementState>(
      'emits [Loading, Error] when loading fails',
      build: () {
        when(
          () => mockGetUserBookings(),
        ).thenAnswer((_) async => const Left(ServerFailure('Network error')));
        return cubit;
      },
      act: (cubit) => cubit.loadUserBookings(loadingMessage: loadingMessage),
      expect: () => [
        const BookingManagementLoading(message: loadingMessage),
        const BookingManagementError('Network error'),
      ],
    );
  });

  group('loadBookingById', () {
    const loadingMessage = 'Loading details...';
    const bookingId = 'booking-1';

    blocTest<BookingManagementCubit, BookingManagementState>(
      'emits [Loading, BookingDetailsLoaded] when found',
      build: () {
        when(
          () => mockGetBookingById(bookingId),
        ).thenAnswer((_) async => Right(testBooking));
        return cubit;
      },
      act: (cubit) =>
          cubit.loadBookingById(bookingId, loadingMessage: loadingMessage),
      expect: () => [
        const BookingManagementLoading(message: loadingMessage),
        isA<BookingDetailsLoaded>().having(
          (s) => s.booking.id,
          'bookingId',
          bookingId,
        ),
      ],
    );

    blocTest<BookingManagementCubit, BookingManagementState>(
      'emits [Loading, Error] when not found',
      build: () {
        when(
          () => mockGetBookingById(bookingId),
        ).thenAnswer((_) async => const Left(ServerFailure('Not found')));
        return cubit;
      },
      act: (cubit) =>
          cubit.loadBookingById(bookingId, loadingMessage: loadingMessage),
      expect: () => [
        const BookingManagementLoading(message: loadingMessage),
        const BookingManagementError('Not found'),
      ],
    );
  });

  group('cancelBooking', () {
    const loadingMessage = 'Canceling...';
    const bookingId = 'booking-1';
    const reason = 'Changed mind';

    final canceledBooking = testBooking.copyWith(
      status: BookingStatus.canceled,
      cancellationReason: reason,
    );

    blocTest<BookingManagementCubit, BookingManagementState>(
      'emits [Loading, BookingCanceled] when cancellation succeeds',
      build: () {
        when(
          () => mockCancelBooking(bookingId: bookingId, reason: reason),
        ).thenAnswer((_) async => Right(canceledBooking));
        return cubit;
      },
      act: (cubit) => cubit.cancelBooking(
        bookingId: bookingId,
        reason: reason,
        loadingMessage: loadingMessage,
      ),
      expect: () => [
        const BookingManagementLoading(message: loadingMessage),
        isA<BookingCanceled>()
            .having((s) => s.booking.status, 'status', BookingStatus.canceled)
            .having((s) => s.booking.cancellationReason, 'reason', reason),
      ],
    );

    blocTest<BookingManagementCubit, BookingManagementState>(
      'emits [Loading, Error] when cancellation fails',
      build: () {
        when(
          () => mockCancelBooking(bookingId: bookingId, reason: reason),
        ).thenAnswer((_) async => const Left(ServerFailure('Cannot cancel')));
        return cubit;
      },
      act: (cubit) => cubit.cancelBooking(
        bookingId: bookingId,
        reason: reason,
        loadingMessage: loadingMessage,
      ),
      expect: () => [
        const BookingManagementLoading(message: loadingMessage),
        const BookingManagementError('Cannot cancel'),
      ],
    );
  });

  group('refreshBookings', () {
    blocTest<BookingManagementCubit, BookingManagementState>(
      'reloads user bookings',
      build: () {
        when(
          () => mockGetUserBookings(),
        ).thenAnswer((_) async => Right([testBooking]));
        return cubit;
      },
      act: (cubit) => cubit.refreshBookings(),
      expect: () => [isA<BookingManagementLoading>(), isA<BookingsLoaded>()],
    );
  });

  group('reset', () {
    blocTest<BookingManagementCubit, BookingManagementState>(
      'resets to initial state',
      build: () => cubit,
      seed: () => const BookingManagementError('Error'),
      act: (cubit) => cubit.reset(),
      expect: () => [const BookingManagementInitial()],
    );
  });
}
