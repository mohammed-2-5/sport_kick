import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/usecases/get_user_bookings_usecase.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late GetUserBookingsUseCase useCase;
  late MockBookingRepository mockRepository;

  setUp(() {
    mockRepository = MockBookingRepository();
    useCase = GetUserBookingsUseCase(mockRepository);
  });

  group('GetUserBookingsUseCase', () {
    final tBookings = [
      BookingEntity(
        id: 'booking-1',
        userId: 'user-1',
        fieldId: 'field-1',
        date: DateTime(2026, 1, 15),
        startTime: '09:00',
        endTime: '10:00',
        status: BookingStatus.pending,
        totalPrice: 200.0,
        currency: 'EGP',
        createdAt: DateTime.now(),
        fieldName: 'Field 1',
      ),
      BookingEntity(
        id: 'booking-2',
        userId: 'user-1',
        fieldId: 'field-2',
        date: DateTime(2026, 1, 16),
        startTime: '14:00',
        endTime: '15:00',
        status: BookingStatus.confirmed,
        totalPrice: 300.0,
        currency: 'EGP',
        createdAt: DateTime.now(),
        fieldName: 'Field 2',
      ),
      BookingEntity(
        id: 'booking-3',
        userId: 'user-1',
        fieldId: 'field-3',
        date: DateTime(2026, 1, 17),
        startTime: '18:00',
        endTime: '19:00',
        status: BookingStatus.completed,
        totalPrice: 250.0,
        currency: 'EGP',
        createdAt: DateTime.now(),
        fieldName: 'Field 3',
      ),
    ];

    group('successful retrieval', () {
      test(
        'should return List<BookingEntity> when repository call succeeds',
        () async {
          // Arrange
          when(
            () => mockRepository.getUserBookings(),
          ).thenAnswer((_) async => Right(tBookings));

          // Act
          final result = await useCase();

          // Assert
          expect(result.isRight(), true);
          expect(result.getOrElse(() => []), equals(tBookings));
          verify(() => mockRepository.getUserBookings()).called(1);
        },
      );

      test('should return empty list when user has no bookings', () async {
        // Arrange
        when(
          () => mockRepository.getUserBookings(),
        ).thenAnswer((_) async => const Right([]));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        expect(result.getOrElse(() => []), isEmpty);
      });

      test('should return bookings with different statuses', () async {
        // Arrange
        when(
          () => mockRepository.getUserBookings(),
        ).thenAnswer((_) async => Right(tBookings));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        final bookings = result.getOrElse(() => []);
        expect(bookings[0].status, BookingStatus.pending);
        expect(bookings[1].status, BookingStatus.confirmed);
        expect(bookings[2].status, BookingStatus.completed);
      });

      test('should return bookings from different fields', () async {
        // Arrange
        when(
          () => mockRepository.getUserBookings(),
        ).thenAnswer((_) async => Right(tBookings));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        final bookings = result.getOrElse(() => []);
        expect(bookings[0].fieldId, 'field-1');
        expect(bookings[1].fieldId, 'field-2');
        expect(bookings[2].fieldId, 'field-3');
      });

      test('should return bookings including canceled ones', () async {
        // Arrange
        final bookingsWithCanceled = [
          ...tBookings,
          BookingEntity(
            id: 'booking-4',
            userId: 'user-1',
            fieldId: 'field-1',
            date: DateTime(2026, 1, 18),
            startTime: '10:00',
            endTime: '11:00',
            status: BookingStatus.canceled,
            totalPrice: 200.0,
            currency: 'EGP',
            createdAt: DateTime.now(),
            cancellationReason: 'Changed plans',
            canceledAt: DateTime.now(),
          ),
        ];

        when(
          () => mockRepository.getUserBookings(),
        ).thenAnswer((_) async => Right(bookingsWithCanceled));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        final bookings = result.getOrElse(() => []);
        expect(bookings.length, 4);
        expect(bookings[3].status, BookingStatus.canceled);
      });

      test('should return bookings with notes', () async {
        // Arrange
        final bookingsWithNotes = [
          BookingEntity(
            id: 'booking-1',
            userId: 'user-1',
            fieldId: 'field-1',
            date: DateTime(2026, 1, 15),
            startTime: '09:00',
            endTime: '10:00',
            status: BookingStatus.confirmed,
            totalPrice: 200.0,
            currency: 'EGP',
            createdAt: DateTime.now(),
            notes: 'Please prepare the field',
          ),
        ];

        when(
          () => mockRepository.getUserBookings(),
        ).thenAnswer((_) async => Right(bookingsWithNotes));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        final bookings = result.getOrElse(() => []);
        expect(bookings[0].notes, 'Please prepare the field');
      });
    });

    group('repository failures', () {
      test('should return ServerFailure when repository call fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to get user bookings');
        when(
          () => mockRepository.getUserBookings(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure when network error occurs', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.getUserBookings(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure when user not authenticated', () async {
        // Arrange
        const tFailure = ServerFailure('User not authenticated');
        when(
          () => mockRepository.getUserBookings(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure when database error occurs', () async {
        // Arrange
        const tFailure = ServerFailure('Database error');
        when(
          () => mockRepository.getUserBookings(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure when session expired', () async {
        // Arrange
        const tFailure = ServerFailure('Session expired');
        when(
          () => mockRepository.getUserBookings(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });

    group('edge cases', () {
      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.getUserBookings(),
        ).thenAnswer((_) async => Right(tBookings));

        // Act
        await useCase();

        // Assert
        verify(() => mockRepository.getUserBookings()).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle large number of bookings', () async {
        // Arrange
        final largeBookingList = List.generate(
          1000,
          (index) => BookingEntity(
            id: 'booking-$index',
            userId: 'user-1',
            fieldId: 'field-${index % 10}',
            date: DateTime(2026, 1, 15 + (index % 30)),
            startTime: '${(9 + (index % 14)).toString().padLeft(2, '0')}:00',
            endTime: '${(10 + (index % 14)).toString().padLeft(2, '0')}:00',
            status: BookingStatus.values[index % 4],
            totalPrice: 200.0 + (index % 10) * 10,
            currency: 'EGP',
            createdAt: DateTime.now(),
          ),
        );

        when(
          () => mockRepository.getUserBookings(),
        ).thenAnswer((_) async => Right(largeBookingList));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        expect(result.getOrElse(() => []).length, 1000);
      });

      test('should handle single booking', () async {
        // Arrange
        final singleBooking = [tBookings[0]];

        when(
          () => mockRepository.getUserBookings(),
        ).thenAnswer((_) async => Right(singleBooking));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        expect(result.getOrElse(() => []).length, 1);
      });

      test('should preserve booking order from repository', () async {
        // Arrange
        when(
          () => mockRepository.getUserBookings(),
        ).thenAnswer((_) async => Right(tBookings));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        final bookings = result.getOrElse(() => []);
        expect(bookings[0].id, 'booking-1');
        expect(bookings[1].id, 'booking-2');
        expect(bookings[2].id, 'booking-3');
      });

      test('should handle bookings from different dates', () async {
        // Arrange
        when(
          () => mockRepository.getUserBookings(),
        ).thenAnswer((_) async => Right(tBookings));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        final bookings = result.getOrElse(() => []);
        expect(bookings[0].date.day, 15);
        expect(bookings[1].date.day, 16);
        expect(bookings[2].date.day, 17);
      });

      test('should handle bookings with different time slots', () async {
        // Arrange
        when(
          () => mockRepository.getUserBookings(),
        ).thenAnswer((_) async => Right(tBookings));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        final bookings = result.getOrElse(() => []);
        expect(bookings[0].startTime, '09:00');
        expect(bookings[1].startTime, '14:00');
        expect(bookings[2].startTime, '18:00');
      });

      test('should handle bookings with different prices', () async {
        // Arrange
        when(
          () => mockRepository.getUserBookings(),
        ).thenAnswer((_) async => Right(tBookings));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        final bookings = result.getOrElse(() => []);
        expect(bookings[0].totalPrice, 200.0);
        expect(bookings[1].totalPrice, 300.0);
        expect(bookings[2].totalPrice, 250.0);
      });

      test('should handle bookings with past and future dates', () async {
        // Arrange
        final mixedDateBookings = [
          BookingEntity(
            id: 'booking-1',
            userId: 'user-1',
            fieldId: 'field-1',
            date: DateTime(2025, 12, 1), // Past
            startTime: '09:00',
            endTime: '10:00',
            status: BookingStatus.completed,
            totalPrice: 200.0,
            currency: 'EGP',
            createdAt: DateTime.now(),
          ),
          BookingEntity(
            id: 'booking-2',
            userId: 'user-1',
            fieldId: 'field-2',
            date: DateTime(2027, 1, 1), // Future
            startTime: '14:00',
            endTime: '15:00',
            status: BookingStatus.confirmed,
            totalPrice: 300.0,
            currency: 'EGP',
            createdAt: DateTime.now(),
          ),
        ];

        when(
          () => mockRepository.getUserBookings(),
        ).thenAnswer((_) async => Right(mixedDateBookings));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        expect(result.getOrElse(() => []).length, 2);
      });

      test('should handle bookings with 1 hour and 2 hour durations', () async {
        // Arrange
        final mixedDurationBookings = [
          BookingEntity(
            id: 'booking-1',
            userId: 'user-1',
            fieldId: 'field-1',
            date: DateTime(2026, 1, 15),
            startTime: '09:00',
            endTime: '10:00',
            status: BookingStatus.confirmed,
            totalPrice: 200.0,
            currency: 'EGP',
            createdAt: DateTime.now(),
            durationHours: 1,
          ),
          BookingEntity(
            id: 'booking-2',
            userId: 'user-1',
            fieldId: 'field-1',
            date: DateTime(2026, 1, 16),
            startTime: '14:00',
            endTime: '16:00',
            status: BookingStatus.confirmed,
            totalPrice: 400.0,
            currency: 'EGP',
            createdAt: DateTime.now(),
            durationHours: 2,
          ),
        ];

        when(
          () => mockRepository.getUserBookings(),
        ).thenAnswer((_) async => Right(mixedDurationBookings));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        final bookings = result.getOrElse(() => []);
        expect(bookings[0].durationHours, 1);
        expect(bookings[1].durationHours, 2);
      });
    });
  });
}
