import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/recurring_bookings/domain/repositories/recurring_booking_repository.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/cancel_recurring_booking_usecase.dart';

class MockRecurringBookingRepository extends Mock
    implements RecurringBookingRepository {}

void main() {
  late CancelRecurringBookingUseCase useCase;
  late MockRecurringBookingRepository mockRepository;

  setUp(() {
    mockRepository = MockRecurringBookingRepository();
    useCase = CancelRecurringBookingUseCase(mockRepository);
  });

  group('CancelRecurringBookingUseCase', () {
    const tRecurringBookingId = 'recurring-123';
    const tReason = 'No longer need the booking';

    group('successful cancellation', () {
      test(
        'should return true when cancellation succeeds with reason',
        () async {
          // Arrange
          const tParams = CancelRecurringBookingParams(
            recurringBookingId: tRecurringBookingId,
            reason: tReason,
          );

          when(
            () => mockRepository.cancelRecurringBooking(
              recurringBookingId: any(named: 'recurringBookingId'),
              reason: any(named: 'reason'),
            ),
          ).thenAnswer((_) async => const Right(true));

          // Act
          final result = await useCase(tParams);

          // Assert
          expect(result, equals(const Right(true)));
          verify(
            () => mockRepository.cancelRecurringBooking(
              recurringBookingId: tRecurringBookingId,
              reason: tReason,
            ),
          ).called(1);
        },
      );

      test(
        'should return true when cancellation succeeds without reason',
        () async {
          // Arrange
          const tParams = CancelRecurringBookingParams(
            recurringBookingId: tRecurringBookingId,
          );

          when(
            () => mockRepository.cancelRecurringBooking(
              recurringBookingId: any(named: 'recurringBookingId'),
              reason: any(named: 'reason'),
            ),
          ).thenAnswer((_) async => const Right(true));

          // Act
          final result = await useCase(tParams);

          // Assert
          expect(result, equals(const Right(true)));
          verify(
            () => mockRepository.cancelRecurringBooking(
              recurringBookingId: tRecurringBookingId,
              reason: null,
            ),
          ).called(1);
        },
      );

      test('should handle various cancellation reasons', () async {
        final reasons = [
          'Moving to a different city',
          'Schedule conflict',
          'Financial reasons',
          'Found a better option',
          '', // empty reason
        ];

        for (final reason in reasons) {
          // Arrange
          final params = CancelRecurringBookingParams(
            recurringBookingId: tRecurringBookingId,
            reason: reason,
          );

          when(
            () => mockRepository.cancelRecurringBooking(
              recurringBookingId: any(named: 'recurringBookingId'),
              reason: any(named: 'reason'),
            ),
          ).thenAnswer((_) async => const Right(true));

          // Act
          final result = await useCase(params);

          // Assert
          expect(result.isRight(), true);
        }
      });

      test('should handle Arabic cancellation reasons', () async {
        // Arrange
        const arabicReason = 'لم أعد بحاجة للحجز';
        const tParams = CancelRecurringBookingParams(
          recurringBookingId: tRecurringBookingId,
          reason: arabicReason,
        );

        when(
          () => mockRepository.cancelRecurringBooking(
            recurringBookingId: any(named: 'recurringBookingId'),
            reason: any(named: 'reason'),
          ),
        ).thenAnswer((_) async => const Right(true));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result.isRight(), true);
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tParams = CancelRecurringBookingParams(
          recurringBookingId: tRecurringBookingId,
        );
        const tFailure = ServerFailure('Failed to cancel recurring booking');

        when(
          () => mockRepository.cancelRecurringBooking(
            recurringBookingId: any(named: 'recurringBookingId'),
            reason: any(named: 'reason'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ValidationFailure when booking not found', () async {
        // Arrange
        const tParams = CancelRecurringBookingParams(
          recurringBookingId: 'non-existent-id',
        );
        const tFailure = ValidationFailure('Booking not found');

        when(
          () => mockRepository.cancelRecurringBooking(
            recurringBookingId: any(named: 'recurringBookingId'),
            reason: any(named: 'reason'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test(
        'should return ValidationFailure when cancellation within notice period',
        () async {
          // Arrange
          const tParams = CancelRecurringBookingParams(
            recurringBookingId: tRecurringBookingId,
          );
          const tFailure = ValidationFailure(
            'Cannot cancel within 1 week notice period',
          );

          when(
            () => mockRepository.cancelRecurringBooking(
              recurringBookingId: any(named: 'recurringBookingId'),
              reason: any(named: 'reason'),
            ),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(tParams);

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );

      test('should return NetworkFailure on network error', () async {
        // Arrange
        const tParams = CancelRecurringBookingParams(
          recurringBookingId: tRecurringBookingId,
        );
        const tFailure = NetworkFailure('No internet connection');

        when(
          () => mockRepository.cancelRecurringBooking(
            recurringBookingId: any(named: 'recurringBookingId'),
            reason: any(named: 'reason'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });

    group('CancelRecurringBookingParams', () {
      test('should support equality with reason', () {
        const params1 = CancelRecurringBookingParams(
          recurringBookingId: tRecurringBookingId,
          reason: tReason,
        );
        const params2 = CancelRecurringBookingParams(
          recurringBookingId: tRecurringBookingId,
          reason: tReason,
        );

        expect(params1, equals(params2));
      });

      test('should support equality without reason', () {
        const params1 = CancelRecurringBookingParams(
          recurringBookingId: tRecurringBookingId,
        );
        const params2 = CancelRecurringBookingParams(
          recurringBookingId: tRecurringBookingId,
        );

        expect(params1, equals(params2));
      });

      test('should have correct props', () {
        const params = CancelRecurringBookingParams(
          recurringBookingId: tRecurringBookingId,
          reason: tReason,
        );

        expect(params.props, [tRecurringBookingId, tReason]);
      });

      test('should not be equal with different values', () {
        const params1 = CancelRecurringBookingParams(
          recurringBookingId: tRecurringBookingId,
          reason: tReason,
        );
        const params2 = CancelRecurringBookingParams(
          recurringBookingId: 'different-id',
          reason: tReason,
        );

        expect(params1, isNot(equals(params2)));
      });
    });
  });
}
