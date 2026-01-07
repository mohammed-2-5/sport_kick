import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/usecases/get_owner_bookings_usecase.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late GetOwnerBookingsUseCase useCase;
  late MockBookingRepository mockRepository;

  setUp(() {
    mockRepository = MockBookingRepository();
    useCase = GetOwnerBookingsUseCase(mockRepository);
  });

  group('GetOwnerBookingsUseCase', () {
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
        userName: 'User 1',
      ),
      BookingEntity(
        id: 'booking-2',
        userId: 'user-2',
        fieldId: 'field-2',
        date: DateTime(2026, 1, 16),
        startTime: '14:00',
        endTime: '15:00',
        status: BookingStatus.confirmed,
        totalPrice: 300.0,
        currency: 'EGP',
        createdAt: DateTime.now(),
        fieldName: 'Field 2',
        userName: 'User 2',
      ),
      BookingEntity(
        id: 'booking-3',
        userId: 'user-3',
        fieldId: 'field-1',
        date: DateTime(2026, 1, 17),
        startTime: '18:00',
        endTime: '19:00',
        status: BookingStatus.completed,
        totalPrice: 250.0,
        currency: 'EGP',
        createdAt: DateTime.now(),
        fieldName: 'Field 1',
        userName: 'User 3',
      ),
    ];

    group('successful retrieval', () {
      test(
        'should return List<BookingEntity> when repository call succeeds',
        () async {
          // Arrange
          when(
            () => mockRepository.getOwnerBookings(),
          ).thenAnswer((_) async => Right(tBookings));

          // Act
          final result = await useCase();

          // Assert
          expect(result.isRight(), true);
          expect(result.getOrElse(() => []), equals(tBookings));
          verify(() => mockRepository.getOwnerBookings()).called(1);
        },
      );

      test('should return empty list when owner has no bookings', () async {
        // Arrange
        when(
          () => mockRepository.getOwnerBookings(),
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
          () => mockRepository.getOwnerBookings(),
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

      test('should return bookings from multiple fields', () async {
        // Arrange
        when(
          () => mockRepository.getOwnerBookings(),
        ).thenAnswer((_) async => Right(tBookings));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        final bookings = result.getOrElse(() => []);
        expect(bookings[0].fieldId, 'field-1');
        expect(bookings[1].fieldId, 'field-2');
        expect(bookings[2].fieldId, 'field-1');
      });

      test('should return bookings with different users', () async {
        // Arrange
        when(
          () => mockRepository.getOwnerBookings(),
        ).thenAnswer((_) async => Right(tBookings));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        final bookings = result.getOrElse(() => []);
        expect(bookings[0].userId, 'user-1');
        expect(bookings[1].userId, 'user-2');
        expect(bookings[2].userId, 'user-3');
      });

      test('should return bookings including manual bookings', () async {
        // Arrange
        final bookingsWithManual = [
          ...tBookings,
          BookingEntity(
            id: 'booking-4',
            userId: 'user-4',
            fieldId: 'field-1',
            date: DateTime(2026, 1, 18),
            startTime: '10:00',
            endTime: '11:00',
            status: BookingStatus.confirmed,
            totalPrice: 200.0,
            currency: 'EGP',
            createdAt: DateTime.now(),
            isManual: true,
            customerName: 'Walk-in Customer',
            customerPhone: '01012345678',
          ),
        ];

        when(
          () => mockRepository.getOwnerBookings(),
        ).thenAnswer((_) async => Right(bookingsWithManual));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        final bookings = result.getOrElse(() => []);
        expect(bookings.length, 4);
        expect(bookings[3].isManual, true);
      });

      test('should return bookings including canceled ones', () async {
        // Arrange
        final bookingsWithCanceled = [
          ...tBookings,
          BookingEntity(
            id: 'booking-4',
            userId: 'user-4',
            fieldId: 'field-1',
            date: DateTime(2026, 1, 18),
            startTime: '10:00',
            endTime: '11:00',
            status: BookingStatus.canceled,
            totalPrice: 200.0,
            currency: 'EGP',
            createdAt: DateTime.now(),
            cancellationReason: 'User canceled',
            canceledAt: DateTime.now(),
          ),
        ];

        when(
          () => mockRepository.getOwnerBookings(),
        ).thenAnswer((_) async => Right(bookingsWithCanceled));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        final bookings = result.getOrElse(() => []);
        expect(bookings.length, 4);
        expect(bookings[3].status, BookingStatus.canceled);
      });
    });

    group('repository failures', () {
      test('should return ServerFailure when repository call fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to get owner bookings');
        when(
          () => mockRepository.getOwnerBookings(),
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
          () => mockRepository.getOwnerBookings(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure when user is not an owner', () async {
        // Arrange
        const tFailure = ServerFailure('User is not a field owner');
        when(
          () => mockRepository.getOwnerBookings(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure when user unauthorized', () async {
        // Arrange
        const tFailure = ServerFailure('Unauthorized access');
        when(
          () => mockRepository.getOwnerBookings(),
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
          () => mockRepository.getOwnerBookings(),
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
          () => mockRepository.getOwnerBookings(),
        ).thenAnswer((_) async => Right(tBookings));

        // Act
        await useCase();

        // Assert
        verify(() => mockRepository.getOwnerBookings()).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle large number of bookings', () async {
        // Arrange
        final largeBookingList = List.generate(
          1000,
          (index) => BookingEntity(
            id: 'booking-$index',
            userId: 'user-$index',
            fieldId: 'field-${index % 5}',
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
          () => mockRepository.getOwnerBookings(),
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
          () => mockRepository.getOwnerBookings(),
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
          () => mockRepository.getOwnerBookings(),
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
          () => mockRepository.getOwnerBookings(),
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
          () => mockRepository.getOwnerBookings(),
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
          () => mockRepository.getOwnerBookings(),
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
            userId: 'user-2',
            fieldId: 'field-1',
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
          () => mockRepository.getOwnerBookings(),
        ).thenAnswer((_) async => Right(mixedDateBookings));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        expect(result.getOrElse(() => []).length, 2);
      });
    });
  });
}
