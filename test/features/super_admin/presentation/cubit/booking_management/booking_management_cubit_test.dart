import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/usecases/cancel_booking_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/update_booking_status_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_bookings_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/booking_management/booking_management_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/booking_management/booking_management_state.dart';

// Mock Use Cases
class MockGetAllBookingsUseCase extends Mock implements GetAllBookingsUseCase {}

class MockUpdateBookingStatusUseCase extends Mock
    implements UpdateBookingStatusUseCase {}

class MockCancelBookingUseCase extends Mock implements CancelBookingUseCase {}

void main() {
  late BookingManagementCubit cubit;
  late MockGetAllBookingsUseCase mockGetAllBookings;
  late MockUpdateBookingStatusUseCase mockUpdateStatus;
  late MockCancelBookingUseCase mockCancelBooking;

  // Test data
  final now = DateTime.now();
  final pendingBooking = BookingEntity(
    id: 'booking-1',
    userId: 'user-1',
    fieldId: 'field-1',
    date: now,
    startTime: '10:00',
    endTime: '11:00',
    totalPrice: 100,
    currency: 'EGP',
    status: BookingStatus.pending,
    userName: 'John Doe',
    fieldName: 'Field A',
    createdAt: now,
  );

  final confirmedBooking = BookingEntity(
    id: 'booking-2',
    userId: 'user-2',
    fieldId: 'field-1',
    date: now,
    startTime: '11:00',
    endTime: '12:00',
    totalPrice: 100,
    currency: 'EGP',
    status: BookingStatus.confirmed,
    userName: 'Jane Smith',
    fieldName: 'Field A',
    createdAt: now,
  );

  final allBookings = [pendingBooking, confirmedBooking];

  setUpAll(() {
    registerFallbackValue(BookingStatus.confirmed);
  });

  setUp(() {
    mockGetAllBookings = MockGetAllBookingsUseCase();
    mockUpdateStatus = MockUpdateBookingStatusUseCase();
    mockCancelBooking = MockCancelBookingUseCase();

    cubit = BookingManagementCubit(
      getAllBookingsUseCase: mockGetAllBookings,
      updateBookingStatusUseCase: mockUpdateStatus,
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

  group('loadAllBookings', () {
    blocTest<BookingManagementCubit, BookingManagementState>(
      'emits [Loading, AllBookingsLoaded] when loading succeeds',
      build: () {
        when(
          () => mockGetAllBookings(),
        ).thenAnswer((_) async => Right(allBookings));
        return cubit;
      },
      act: (cubit) => cubit.loadAllBookings(),
      expect: () => [
        isA<BookingManagementLoading>().having(
          (s) => s.message,
          'message',
          'Loading bookings...',
        ),
        isA<AllBookingsLoaded>().having((s) => s.bookings.length, 'count', 2),
      ],
    );

    blocTest<BookingManagementCubit, BookingManagementState>(
      'emits [Loading, Error] when loading fails',
      build: () {
        when(
          () => mockGetAllBookings(),
        ).thenAnswer((_) async => const Left(ServerFailure('Network error')));
        return cubit;
      },
      act: (cubit) => cubit.loadAllBookings(),
      expect: () => [
        isA<BookingManagementLoading>(),
        isA<BookingManagementError>().having(
          (s) => s.message,
          'message',
          'Network error',
        ),
      ],
    );
  });

  group('updateBookingStatus', () {
    blocTest<BookingManagementCubit, BookingManagementState>(
      'emits [Loading, StatusUpdated] and reloads on success',
      build: () {
        when(
          () => mockUpdateStatus(
            bookingId: 'booking-1',
            status: BookingStatus.confirmed,
          ),
        ).thenAnswer((_) async => Right(confirmedBooking));
        when(
          () => mockGetAllBookings(),
        ).thenAnswer((_) async => Right(allBookings));
        return cubit;
      },
      act: (cubit) => cubit.updateBookingStatus(
        bookingId: 'booking-1',
        status: BookingStatus.confirmed,
      ),
      expect: () => [
        isA<BookingManagementLoading>().having(
          (s) => s.message,
          'message',
          'Updating booking status...',
        ),
        isA<BookingStatusUpdated>()
            .having((s) => s.bookingId, 'bookingId', 'booking-1')
            .having((s) => s.newStatus, 'newStatus', 'Confirmed'),
        isA<BookingManagementLoading>(),
        isA<AllBookingsLoaded>(),
      ],
    );

    blocTest<BookingManagementCubit, BookingManagementState>(
      'emits Error when update fails',
      build: () {
        when(
          () => mockUpdateStatus(
            bookingId: 'booking-1',
            status: BookingStatus.confirmed,
          ),
        ).thenAnswer((_) async => const Left(ServerFailure('Update failed')));
        return cubit;
      },
      act: (cubit) => cubit.updateBookingStatus(
        bookingId: 'booking-1',
        status: BookingStatus.confirmed,
      ),
      expect: () => [
        isA<BookingManagementLoading>(),
        isA<BookingManagementError>().having(
          (s) => s.message,
          'message',
          'Update failed',
        ),
      ],
    );
  });

  group('cancelBooking', () {
    blocTest<BookingManagementCubit, BookingManagementState>(
      'emits [Loading, BookingCancelled] and reloads on success',
      build: () {
        when(
          () =>
              mockCancelBooking(bookingId: 'booking-1', reason: 'Test reason'),
        ).thenAnswer((_) async => Right(pendingBooking));
        when(
          () => mockGetAllBookings(),
        ).thenAnswer((_) async => Right(allBookings));
        return cubit;
      },
      act: (cubit) =>
          cubit.cancelBooking(bookingId: 'booking-1', reason: 'Test reason'),
      expect: () => [
        isA<BookingManagementLoading>().having(
          (s) => s.message,
          'message',
          'Cancelling booking...',
        ),
        isA<BookingCancelled>().having(
          (s) => s.bookingId,
          'bookingId',
          'booking-1',
        ),
        isA<BookingManagementLoading>(),
        isA<AllBookingsLoaded>(),
      ],
    );

    blocTest<BookingManagementCubit, BookingManagementState>(
      'emits Error when cancellation fails',
      build: () {
        when(
          () =>
              mockCancelBooking(bookingId: 'booking-1', reason: 'Test reason'),
        ).thenAnswer((_) async => const Left(ServerFailure('Cancel failed')));
        return cubit;
      },
      act: (cubit) =>
          cubit.cancelBooking(bookingId: 'booking-1', reason: 'Test reason'),
      expect: () => [
        isA<BookingManagementLoading>(),
        isA<BookingManagementError>().having(
          (s) => s.message,
          'message',
          'Cancel failed',
        ),
      ],
    );
  });

  group('reset', () {
    blocTest<BookingManagementCubit, BookingManagementState>(
      'resets to initial state',
      build: () => cubit,
      seed: () => AllBookingsLoaded(allBookings),
      act: (cubit) => cubit.reset(),
      expect: () => [const BookingManagementInitial()],
    );
  });
}
