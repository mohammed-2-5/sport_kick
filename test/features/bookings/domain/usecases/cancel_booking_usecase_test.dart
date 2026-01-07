import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/entities/payment_status.dart';
import 'package:spo_kick/features/bookings/domain/usecases/cancel_booking_usecase.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late CancelBookingUseCase useCase;
  late MockBookingRepository mockRepository;

  setUp(() {
    mockRepository = MockBookingRepository();
    useCase = CancelBookingUseCase(mockRepository);
  });

  group('CancelBookingUseCase', () {
    const tBookingId = 'booking-123';
    const tReason = 'Changed plans';

    final tBookingEntity = BookingEntity(
      id: tBookingId,
      userId: 'user-1',
      fieldId: 'field-1',
      date: DateTime(2026, 1, 15),
      startTime: '09:00',
      endTime: '10:00',
      status: BookingStatus.canceled,
      totalPrice: 200.0,
      currency: 'EGP',
      createdAt: DateTime.now(),
      cancellationReason: tReason,
      canceledAt: DateTime.now(),
    );

    group('successful cancellation', () {
      test('should return BookingEntity when cancellation succeeds', () async {
        // Arrange
        when(
          () => mockRepository.cancelBooking(
            bookingId: any(named: 'bookingId'),
            reason: any(named: 'reason'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(bookingId: tBookingId, reason: tReason);

        // Assert
        expect(result.isRight(), true);
        expect(result.getOrElse(() => tBookingEntity), equals(tBookingEntity));
        verify(
          () => mockRepository.cancelBooking(
            bookingId: tBookingId,
            reason: tReason,
          ),
        ).called(1);
      });

      test('should call repository with correct parameters', () async {
        // Arrange
        when(
          () => mockRepository.cancelBooking(
            bookingId: any(named: 'bookingId'),
            reason: any(named: 'reason'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        await useCase(bookingId: tBookingId, reason: tReason);

        // Assert
        verify(
          () => mockRepository.cancelBooking(
            bookingId: tBookingId,
            reason: tReason,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle booking with pending status', () async {
        // Arrange
        final pendingBooking = tBookingEntity.copyWith(
          status: BookingStatus.pending,
        );

        when(
          () => mockRepository.cancelBooking(
            bookingId: any(named: 'bookingId'),
            reason: any(named: 'reason'),
          ),
        ).thenAnswer((_) async => Right(pendingBooking));

        // Act
        final result = await useCase(bookingId: tBookingId, reason: tReason);

        // Assert
        expect(result.isRight(), true);
        final booking = result.getOrElse(() => tBookingEntity);
        expect(booking, equals(pendingBooking));
      });

      test('should handle booking with confirmed status', () async {
        // Arrange
        final confirmedBooking = tBookingEntity.copyWith(
          status: BookingStatus.confirmed,
        );

        when(
          () => mockRepository.cancelBooking(
            bookingId: any(named: 'bookingId'),
            reason: any(named: 'reason'),
          ),
        ).thenAnswer((_) async => Right(confirmedBooking));

        // Act
        final result = await useCase(bookingId: tBookingId, reason: tReason);

        // Assert
        expect(result.isRight(), true);
        final booking = result.getOrElse(() => tBookingEntity);
        expect(booking, equals(confirmedBooking));
      });
    });

    group('validation failures', () {
      test(
        'should return ValidationFailure when reason is empty string',
        () async {
          // Act
          final result = await useCase(bookingId: tBookingId, reason: '');

          // Assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure, isA<ValidationFailure>());
            expect(
              (failure as ValidationFailure).message,
              'Cancellation reason is required',
            );
          }, (_) => fail('Should return failure'));
          verifyNever(
            () => mockRepository.cancelBooking(
              bookingId: any(named: 'bookingId'),
              reason: any(named: 'reason'),
            ),
          );
        },
      );

      test(
        'should return ValidationFailure when reason is only whitespace',
        () async {
          // Act
          final result = await useCase(bookingId: tBookingId, reason: '   ');

          // Assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure, isA<ValidationFailure>());
            expect(
              (failure as ValidationFailure).message,
              'Cancellation reason is required',
            );
          }, (_) => fail('Should return failure'));
          verifyNever(
            () => mockRepository.cancelBooking(
              bookingId: any(named: 'bookingId'),
              reason: any(named: 'reason'),
            ),
          );
        },
      );

      test(
        'should return ValidationFailure when reason is tabs and spaces',
        () async {
          // Act
          final result = await useCase(
            bookingId: tBookingId,
            reason: '  \t  \n  ',
          );

          // Assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure, isA<ValidationFailure>());
            expect(
              (failure as ValidationFailure).message,
              'Cancellation reason is required',
            );
          }, (_) => fail('Should return failure'));
        },
      );
    });

    group('valid reasons', () {
      test('should accept reason with leading/trailing whitespace', () async {
        // Arrange
        const reasonWithWhitespace = '  Changed plans  ';

        when(
          () => mockRepository.cancelBooking(
            bookingId: any(named: 'bookingId'),
            reason: any(named: 'reason'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          reason: reasonWithWhitespace,
        );

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.cancelBooking(
            bookingId: tBookingId,
            reason: reasonWithWhitespace,
          ),
        ).called(1);
      });

      test('should accept short reason', () async {
        // Arrange
        const shortReason = 'No';

        when(
          () => mockRepository.cancelBooking(
            bookingId: any(named: 'bookingId'),
            reason: any(named: 'reason'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          reason: shortReason,
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept long reason', () async {
        // Arrange
        const longReason =
            'I need to cancel because I have an unexpected meeting that came up '
            'and I will not be able to make it to the field at the scheduled time. '
            'I apologize for the inconvenience.';

        when(
          () => mockRepository.cancelBooking(
            bookingId: any(named: 'bookingId'),
            reason: any(named: 'reason'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(bookingId: tBookingId, reason: longReason);

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept reason with special characters', () async {
        // Arrange
        const specialReason = "Can't make it! Bad weather @ field #1 :(";

        when(
          () => mockRepository.cancelBooking(
            bookingId: any(named: 'bookingId'),
            reason: any(named: 'reason'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          reason: specialReason,
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept reason with Arabic text', () async {
        // Arrange
        const arabicReason = 'تغيرت خططي';

        when(
          () => mockRepository.cancelBooking(
            bookingId: any(named: 'bookingId'),
            reason: any(named: 'reason'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          reason: arabicReason,
        );

        // Assert
        expect(result.isRight(), true);
      });
    });

    group('repository failures', () {
      test('should return ServerFailure when repository call fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to cancel booking');
        when(
          () => mockRepository.cancelBooking(
            bookingId: any(named: 'bookingId'),
            reason: any(named: 'reason'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(bookingId: tBookingId, reason: tReason);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure when network error occurs', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.cancelBooking(
            bookingId: any(named: 'bookingId'),
            reason: any(named: 'reason'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(bookingId: tBookingId, reason: tReason);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure when booking not found', () async {
        // Arrange
        const tFailure = ServerFailure('Booking not found');
        when(
          () => mockRepository.cancelBooking(
            bookingId: any(named: 'bookingId'),
            reason: any(named: 'reason'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(
          bookingId: 'non-existent-id',
          reason: tReason,
        );

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test(
        'should return ServerFailure when booking already canceled',
        () async {
          // Arrange
          const tFailure = ServerFailure('Booking is already canceled');
          when(
            () => mockRepository.cancelBooking(
              bookingId: any(named: 'bookingId'),
              reason: any(named: 'reason'),
            ),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(bookingId: tBookingId, reason: tReason);

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );

      test('should return ServerFailure when user unauthorized', () async {
        // Arrange
        const tFailure = ServerFailure(
          'You are not authorized to cancel this booking',
        );
        when(
          () => mockRepository.cancelBooking(
            bookingId: any(named: 'bookingId'),
            reason: any(named: 'reason'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(bookingId: tBookingId, reason: tReason);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });

    group('edge cases', () {
      test('should handle booking ID with special characters', () async {
        // Arrange
        const specialBookingId = 'booking-123-456_xyz';

        when(
          () => mockRepository.cancelBooking(
            bookingId: any(named: 'bookingId'),
            reason: any(named: 'reason'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          bookingId: specialBookingId,
          reason: tReason,
        );

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.cancelBooking(
            bookingId: specialBookingId,
            reason: tReason,
          ),
        ).called(1);
      });

      test('should handle very long booking ID', () async {
        // Arrange
        final longBookingId = 'booking-${'1234567890' * 10}';

        when(
          () => mockRepository.cancelBooking(
            bookingId: any(named: 'bookingId'),
            reason: any(named: 'reason'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(bookingId: longBookingId, reason: tReason);

        // Assert
        expect(result.isRight(), true);
      });

      test(
        'should preserve reason exactly as provided after validation',
        () async {
          // Arrange
          const exactReason = '  Test Reason  ';

          when(
            () => mockRepository.cancelBooking(
              bookingId: any(named: 'bookingId'),
              reason: any(named: 'reason'),
            ),
          ).thenAnswer((_) async => Right(tBookingEntity));

          // Act
          await useCase(bookingId: tBookingId, reason: exactReason);

          // Assert
          verify(
            () => mockRepository.cancelBooking(
              bookingId: tBookingId,
              reason: exactReason,
            ),
          ).called(1);
        },
      );
    });
  });
}
