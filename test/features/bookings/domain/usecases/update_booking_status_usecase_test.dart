import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/usecases/update_booking_status_usecase.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late UpdateBookingStatusUseCase useCase;
  late MockBookingRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(BookingStatus.confirmed);
  });

  setUp(() {
    mockRepository = MockBookingRepository();
    useCase = UpdateBookingStatusUseCase(mockRepository);
  });

  group('UpdateBookingStatusUseCase', () {
    const tBookingId = 'booking-123';

    final tBookingEntity = BookingEntity(
      id: tBookingId,
      userId: 'user-1',
      fieldId: 'field-1',
      date: DateTime(2026, 1, 15),
      startTime: '09:00',
      endTime: '10:00',
      status: BookingStatus.confirmed,
      totalPrice: 200.0,
      currency: 'EGP',
      createdAt: DateTime.now(),
      confirmedAt: DateTime.now(),
    );

    group('successful status update', () {
      test(
        'should return BookingEntity when status update to confirmed succeeds',
        () async {
          // Arrange
          when(
            () => mockRepository.updateBookingStatus(
              bookingId: any(named: 'bookingId'),
              status: any(named: 'status'),
            ),
          ).thenAnswer((_) async => Right(tBookingEntity));

          // Act
          final result = await useCase(
            bookingId: tBookingId,
            status: BookingStatus.confirmed,
          );

          // Assert
          expect(result.isRight(), true);
          expect(
            result.getOrElse(() => tBookingEntity),
            equals(tBookingEntity),
          );
          verify(
            () => mockRepository.updateBookingStatus(
              bookingId: tBookingId,
              status: BookingStatus.confirmed,
            ),
          ).called(1);
        },
      );

      test(
        'should return BookingEntity when status update to canceled succeeds',
        () async {
          // Arrange
          final canceledBooking = tBookingEntity.copyWith(
            status: BookingStatus.canceled,
            canceledAt: DateTime.now(),
          );

          when(
            () => mockRepository.updateBookingStatus(
              bookingId: any(named: 'bookingId'),
              status: any(named: 'status'),
            ),
          ).thenAnswer((_) async => Right(canceledBooking));

          // Act
          final result = await useCase(
            bookingId: tBookingId,
            status: BookingStatus.canceled,
          );

          // Assert
          expect(result.isRight(), true);
          final booking = result.getOrElse(() => tBookingEntity);
          expect(booking.status, BookingStatus.canceled);
        },
      );

      test(
        'should return BookingEntity when status update to completed succeeds',
        () async {
          // Arrange
          final completedBooking = tBookingEntity.copyWith(
            status: BookingStatus.completed,
          );

          when(
            () => mockRepository.updateBookingStatus(
              bookingId: any(named: 'bookingId'),
              status: any(named: 'status'),
            ),
          ).thenAnswer((_) async => Right(completedBooking));

          // Act
          final result = await useCase(
            bookingId: tBookingId,
            status: BookingStatus.completed,
          );

          // Assert
          expect(result.isRight(), true);
          final booking = result.getOrElse(() => tBookingEntity);
          expect(booking.status, BookingStatus.completed);
        },
      );

      test(
        'should return BookingEntity when status update to pending succeeds',
        () async {
          // Arrange
          final pendingBooking = tBookingEntity.copyWith(
            status: BookingStatus.pending,
          );

          when(
            () => mockRepository.updateBookingStatus(
              bookingId: any(named: 'bookingId'),
              status: any(named: 'status'),
            ),
          ).thenAnswer((_) async => Right(pendingBooking));

          // Act
          final result = await useCase(
            bookingId: tBookingId,
            status: BookingStatus.pending,
          );

          // Assert
          expect(result.isRight(), true);
          final booking = result.getOrElse(() => tBookingEntity);
          expect(booking.status, BookingStatus.pending);
        },
      );

      test('should call repository with correct parameters', () async {
        // Arrange
        when(
          () => mockRepository.updateBookingStatus(
            bookingId: any(named: 'bookingId'),
            status: any(named: 'status'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        await useCase(bookingId: tBookingId, status: BookingStatus.confirmed);

        // Assert
        verify(
          () => mockRepository.updateBookingStatus(
            bookingId: tBookingId,
            status: BookingStatus.confirmed,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('status transitions', () {
      test('should handle pending to confirmed transition', () async {
        // Arrange
        final confirmedBooking = tBookingEntity.copyWith(
          status: BookingStatus.confirmed,
          confirmedAt: DateTime.now(),
        );

        when(
          () => mockRepository.updateBookingStatus(
            bookingId: any(named: 'bookingId'),
            status: any(named: 'status'),
          ),
        ).thenAnswer((_) async => Right(confirmedBooking));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          status: BookingStatus.confirmed,
        );

        // Assert
        expect(result.isRight(), true);
        final booking = result.getOrElse(() => tBookingEntity);
        expect(booking.status, BookingStatus.confirmed);
        expect(booking.confirmedAt, isNotNull);
      });

      test('should handle pending to canceled transition', () async {
        // Arrange
        final canceledBooking = tBookingEntity.copyWith(
          status: BookingStatus.canceled,
          canceledAt: DateTime.now(),
        );

        when(
          () => mockRepository.updateBookingStatus(
            bookingId: any(named: 'bookingId'),
            status: any(named: 'status'),
          ),
        ).thenAnswer((_) async => Right(canceledBooking));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          status: BookingStatus.canceled,
        );

        // Assert
        expect(result.isRight(), true);
        final booking = result.getOrElse(() => tBookingEntity);
        expect(booking.status, BookingStatus.canceled);
      });

      test('should handle confirmed to completed transition', () async {
        // Arrange
        final completedBooking = tBookingEntity.copyWith(
          status: BookingStatus.completed,
        );

        when(
          () => mockRepository.updateBookingStatus(
            bookingId: any(named: 'bookingId'),
            status: any(named: 'status'),
          ),
        ).thenAnswer((_) async => Right(completedBooking));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          status: BookingStatus.completed,
        );

        // Assert
        expect(result.isRight(), true);
        final booking = result.getOrElse(() => tBookingEntity);
        expect(booking.status, BookingStatus.completed);
      });

      test('should handle confirmed to canceled transition', () async {
        // Arrange
        final canceledBooking = tBookingEntity.copyWith(
          status: BookingStatus.canceled,
          canceledAt: DateTime.now(),
        );

        when(
          () => mockRepository.updateBookingStatus(
            bookingId: any(named: 'bookingId'),
            status: any(named: 'status'),
          ),
        ).thenAnswer((_) async => Right(canceledBooking));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          status: BookingStatus.canceled,
        );

        // Assert
        expect(result.isRight(), true);
        final booking = result.getOrElse(() => tBookingEntity);
        expect(booking.status, BookingStatus.canceled);
      });
    });

    group('repository failures', () {
      test('should return ServerFailure when repository call fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to update booking status');
        when(
          () => mockRepository.updateBookingStatus(
            bookingId: any(named: 'bookingId'),
            status: any(named: 'status'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          status: BookingStatus.confirmed,
        );

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure when network error occurs', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.updateBookingStatus(
            bookingId: any(named: 'bookingId'),
            status: any(named: 'status'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          status: BookingStatus.confirmed,
        );

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure when booking not found', () async {
        // Arrange
        const tFailure = ServerFailure('Booking not found');
        when(
          () => mockRepository.updateBookingStatus(
            bookingId: any(named: 'bookingId'),
            status: any(named: 'status'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(
          bookingId: 'non-existent-id',
          status: BookingStatus.confirmed,
        );

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure when user unauthorized', () async {
        // Arrange
        const tFailure = ServerFailure(
          'You are not authorized to update this booking',
        );
        when(
          () => mockRepository.updateBookingStatus(
            bookingId: any(named: 'bookingId'),
            status: any(named: 'status'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          status: BookingStatus.confirmed,
        );

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test(
        'should return ServerFailure when invalid status transition',
        () async {
          // Arrange
          const tFailure = ServerFailure('Invalid status transition');
          when(
            () => mockRepository.updateBookingStatus(
              bookingId: any(named: 'bookingId'),
              status: any(named: 'status'),
            ),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(
            bookingId: tBookingId,
            status: BookingStatus.completed,
          );

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );

      test(
        'should return ServerFailure when booking already in that status',
        () async {
          // Arrange
          const tFailure = ServerFailure('Booking is already confirmed');
          when(
            () => mockRepository.updateBookingStatus(
              bookingId: any(named: 'bookingId'),
              status: any(named: 'status'),
            ),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(
            bookingId: tBookingId,
            status: BookingStatus.confirmed,
          );

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );

      test('should return ServerFailure when booking is in the past', () async {
        // Arrange
        const tFailure = ServerFailure(
          'Cannot update status for past bookings',
        );
        when(
          () => mockRepository.updateBookingStatus(
            bookingId: any(named: 'bookingId'),
            status: any(named: 'status'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          status: BookingStatus.confirmed,
        );

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });

    group('edge cases', () {
      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.updateBookingStatus(
            bookingId: any(named: 'bookingId'),
            status: any(named: 'status'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        await useCase(bookingId: tBookingId, status: BookingStatus.confirmed);

        // Assert
        verify(
          () => mockRepository.updateBookingStatus(
            bookingId: tBookingId,
            status: BookingStatus.confirmed,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle booking ID with special characters', () async {
        // Arrange
        const specialBookingId = 'booking-123_456-xyz';

        when(
          () => mockRepository.updateBookingStatus(
            bookingId: any(named: 'bookingId'),
            status: any(named: 'status'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          bookingId: specialBookingId,
          status: BookingStatus.confirmed,
        );

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.updateBookingStatus(
            bookingId: specialBookingId,
            status: BookingStatus.confirmed,
          ),
        ).called(1);
      });

      test('should handle very long booking ID', () async {
        // Arrange
        final longBookingId = 'booking-${'1234567890' * 10}';

        when(
          () => mockRepository.updateBookingStatus(
            bookingId: any(named: 'bookingId'),
            status: any(named: 'status'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          bookingId: longBookingId,
          status: BookingStatus.confirmed,
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle all booking status enum values', () async {
        // Arrange
        when(
          () => mockRepository.updateBookingStatus(
            bookingId: any(named: 'bookingId'),
            status: any(named: 'status'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act & Assert for each status
        for (final status in BookingStatus.values) {
          final result = await useCase(bookingId: tBookingId, status: status);
          expect(result.isRight(), true);
        }
      });

      test('should preserve booking data except status', () async {
        // Arrange
        final updatedBooking = BookingEntity(
          id: tBookingId,
          userId: 'user-1',
          fieldId: 'field-1',
          date: DateTime(2026, 1, 15),
          startTime: '09:00',
          endTime: '10:00',
          status: BookingStatus.confirmed,
          totalPrice: 200.0,
          currency: 'EGP',
          createdAt: DateTime.now(),
          fieldName: 'Test Field',
          userName: 'John Doe',
          notes: 'Test notes',
        );

        when(
          () => mockRepository.updateBookingStatus(
            bookingId: any(named: 'bookingId'),
            status: any(named: 'status'),
          ),
        ).thenAnswer((_) async => Right(updatedBooking));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          status: BookingStatus.confirmed,
        );

        // Assert
        expect(result.isRight(), true);
        final booking = result.getOrElse(() => tBookingEntity);
        expect(booking.id, tBookingId);
        expect(booking.userId, 'user-1');
        expect(booking.fieldId, 'field-1');
        expect(booking.totalPrice, 200.0);
        expect(booking.fieldName, 'Test Field');
        expect(booking.userName, 'John Doe');
        expect(booking.notes, 'Test notes');
      });
    });
  });
}
