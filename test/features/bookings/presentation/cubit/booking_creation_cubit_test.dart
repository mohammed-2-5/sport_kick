import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/usecases/create_booking_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/create_manual_booking_usecase.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/creation/booking_creation_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/creation/booking_creation_state.dart';

// Mock Use Cases
class MockCreateBookingUseCase extends Mock implements CreateBookingUseCase {}

class MockCreateManualBookingUseCase extends Mock
    implements CreateManualBookingUseCase {}

void main() {
  late BookingCreationCubit cubit;
  late MockCreateBookingUseCase mockCreateBooking;
  late MockCreateManualBookingUseCase mockCreateManualBooking;

  // Test data
  final now = DateTime.now();
  final testDate = DateTime(now.year, now.month, now.day + 1);
  const startTime = '10:00';
  const endTime = '11:00';
  const fieldId = 'field-1';
  const totalPrice = 100.0;
  const loadingMessage = 'Creating booking...';

  final testBooking = BookingEntity(
    id: 'booking-1',
    userId: 'user-1',
    fieldId: fieldId,
    date: testDate,
    startTime: startTime,
    endTime: endTime,
    status: BookingStatus.pending,
    totalPrice: totalPrice,
    currency: 'EGP',
    createdAt: now,
  );

  setUp(() {
    mockCreateBooking = MockCreateBookingUseCase();
    mockCreateManualBooking = MockCreateManualBookingUseCase();

    cubit = BookingCreationCubit(
      createBookingUseCase: mockCreateBooking,
      createManualBookingUseCase: mockCreateManualBooking,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('BookingCreationCubit', () {
    test('initial state is BookingCreationInitial', () {
      expect(cubit.state, const BookingCreationInitial());
    });
  });

  group('createBooking', () {
    blocTest<BookingCreationCubit, BookingCreationState>(
      'emits [Loading, Created] when booking creation succeeds',
      build: () {
        when(
          () => mockCreateBooking(
            fieldId: fieldId,
            date: testDate,
            startTime: startTime,
            endTime: endTime,
            totalPrice: totalPrice,
            notes: null,
          ),
        ).thenAnswer((_) async => Right(testBooking));
        return cubit;
      },
      act: (cubit) => cubit.createBooking(
        fieldId: fieldId,
        date: testDate,
        startTime: startTime,
        endTime: endTime,
        totalPrice: totalPrice,
        loadingMessage: loadingMessage,
      ),
      expect: () => [
        const BookingCreationLoading(message: loadingMessage),
        isA<BookingCreated>().having(
          (s) => s.booking.id,
          'bookingId',
          'booking-1',
        ),
      ],
    );

    blocTest<BookingCreationCubit, BookingCreationState>(
      'emits [Loading, Error] when booking creation fails',
      build: () {
        when(
          () => mockCreateBooking(
            fieldId: fieldId,
            date: testDate,
            startTime: startTime,
            endTime: endTime,
            totalPrice: totalPrice,
            notes: null,
          ),
        ).thenAnswer(
          (_) async => const Left(ServerFailure('Booking conflict')),
        );
        return cubit;
      },
      act: (cubit) => cubit.createBooking(
        fieldId: fieldId,
        date: testDate,
        startTime: startTime,
        endTime: endTime,
        totalPrice: totalPrice,
        loadingMessage: loadingMessage,
      ),
      expect: () => [
        const BookingCreationLoading(message: loadingMessage),
        const BookingCreationError('Booking conflict'),
      ],
    );
  });

  group('createBookingFromSelection', () {
    blocTest<BookingCreationCubit, BookingCreationState>(
      'calls createBooking correctly',
      build: () {
        when(
          () => mockCreateBooking(
            fieldId: fieldId,
            date: testDate,
            startTime: startTime,
            endTime: endTime,
            totalPrice: totalPrice,
            notes: null,
          ),
        ).thenAnswer((_) async => Right(testBooking));
        return cubit;
      },
      act: (cubit) => cubit.createBookingFromSelection(
        fieldId: fieldId,
        selectedDate: testDate,
        startTime: startTime,
        endTime: endTime,
        totalPrice: totalPrice,
        loadingMessage: loadingMessage,
      ),
      expect: () => [
        const BookingCreationLoading(message: loadingMessage),
        isA<BookingCreated>(),
      ],
    );
  });

  group('createManualBooking', () {
    const customerName = 'John Doe';
    const customerPhone = '0123456789';

    blocTest<BookingCreationCubit, BookingCreationState>(
      'emits [Loading, Created] when manual booking succeeds',
      build: () {
        when(
          () => mockCreateManualBooking(
            fieldId: fieldId,
            date: testDate,
            startTime: startTime,
            endTime: endTime,
            totalPrice: totalPrice,
            customerName: customerName,
            customerPhone: customerPhone,
            customerEmail: null,
            notes: null,
          ),
        ).thenAnswer((_) async => Right(testBooking));
        return cubit;
      },
      act: (cubit) => cubit.createManualBooking(
        fieldId: fieldId,
        date: testDate,
        startTime: startTime,
        endTime: endTime,
        totalPrice: totalPrice,
        loadingMessage: loadingMessage,
        customerName: customerName,
        customerPhone: customerPhone,
      ),
      expect: () => [
        const BookingCreationLoading(message: loadingMessage),
        isA<BookingCreated>(),
      ],
    );

    blocTest<BookingCreationCubit, BookingCreationState>(
      'emits [Loading, Error] when manual booking fails',
      build: () {
        when(
          () => mockCreateManualBooking(
            fieldId: fieldId,
            date: testDate,
            startTime: startTime,
            endTime: endTime,
            totalPrice: totalPrice,
            customerName: customerName,
            customerPhone: customerPhone,
            customerEmail: null,
            notes: null,
          ),
        ).thenAnswer(
          (_) async => const Left(ServerFailure('Manual booking failed')),
        );
        return cubit;
      },
      act: (cubit) => cubit.createManualBooking(
        fieldId: fieldId,
        date: testDate,
        startTime: startTime,
        endTime: endTime,
        totalPrice: totalPrice,
        loadingMessage: loadingMessage,
        customerName: customerName,
        customerPhone: customerPhone,
      ),
      expect: () => [
        const BookingCreationLoading(message: loadingMessage),
        const BookingCreationError('Manual booking failed'),
      ],
    );
  });

  group('reset', () {
    blocTest<BookingCreationCubit, BookingCreationState>(
      'resets to initial state',
      build: () => cubit,
      seed: () => const BookingCreationError('Error'),
      act: (cubit) => cubit.reset(),
      expect: () => [const BookingCreationInitial()],
    );
  });
}
