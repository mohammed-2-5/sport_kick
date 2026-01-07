import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/recurring_bookings/domain/repositories/recurring_booking_repository.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/reject_recurring_booking_usecase.dart';

class MockRecurringBookingRepository extends Mock
    implements RecurringBookingRepository {}

void main() {
  late RejectRecurringBookingUseCase useCase;
  late MockRecurringBookingRepository mockRepository;

  setUp(() {
    mockRepository = MockRecurringBookingRepository();
    useCase = RejectRecurringBookingUseCase(mockRepository);
  });

  group('RejectRecurringBookingUseCase', () {
    const tRecurringBookingId = 'recurring-123';
    const tReason = 'Slot is not available for recurring bookings';

    const tParams = RejectRecurringBookingParams(
      recurringBookingId: tRecurringBookingId,
      reason: tReason,
    );

    group('successful rejection', () {
      test('should return true when rejection succeeds', () async {
        // Arrange
        when(
          () => mockRepository.rejectRecurringBooking(
            recurringBookingId: any(named: 'recurringBookingId'),
            reason: any(named: 'reason'),
          ),
        ).thenAnswer((_) async => const Right(true));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Right(true)));
        verify(
          () => mockRepository.rejectRecurringBooking(
            recurringBookingId: tRecurringBookingId,
            reason: tReason,
          ),
        ).called(1);
      });

      test('should handle various rejection reasons', () async {
        final reasons = [
          'Slot is not available',
          'Field is under maintenance',
          'User has unpaid bookings',
          'Too many recurring bookings for this time',
          'Conflict with existing recurring booking',
        ];

        for (final reason in reasons) {
          // Arrange
          final params = RejectRecurringBookingParams(
            recurringBookingId: tRecurringBookingId,
            reason: reason,
          );

          when(
            () => mockRepository.rejectRecurringBooking(
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

      test('should handle Arabic rejection reasons', () async {
        // Arrange
        const arabicReason = 'الموعد غير متاح للحجوزات المتكررة';
        const params = RejectRecurringBookingParams(
          recurringBookingId: tRecurringBookingId,
          reason: arabicReason,
        );

        when(
          () => mockRepository.rejectRecurringBooking(
            recurringBookingId: any(named: 'recurringBookingId'),
            reason: any(named: 'reason'),
          ),
        ).thenAnswer((_) async => const Right(true));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.rejectRecurringBooking(
            recurringBookingId: any(named: 'recurringBookingId'),
            reason: any(named: 'reason'),
          ),
        ).thenAnswer((_) async => const Right(true));

        // Act
        await useCase(tParams);

        // Assert
        verify(
          () => mockRepository.rejectRecurringBooking(
            recurringBookingId: tRecurringBookingId,
            reason: tReason,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle long rejection reasons', () async {
        // Arrange
        final longReason = 'A' * 500;
        final params = RejectRecurringBookingParams(
          recurringBookingId: tRecurringBookingId,
          reason: longReason,
        );

        when(
          () => mockRepository.rejectRecurringBooking(
            recurringBookingId: any(named: 'recurringBookingId'),
            reason: any(named: 'reason'),
          ),
        ).thenAnswer((_) async => const Right(true));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to reject booking');

        when(
          () => mockRepository.rejectRecurringBooking(
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
        const tFailure = ValidationFailure('Recurring booking not found');

        when(
          () => mockRepository.rejectRecurringBooking(
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
        'should return ValidationFailure when booking already processed',
        () async {
          // Arrange
          const tFailure = ValidationFailure('Booking is already processed');

          when(
            () => mockRepository.rejectRecurringBooking(
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

      test('should return AuthFailure when not authorized', () async {
        // Arrange
        const tFailure = AuthFailure('Not authorized to reject this booking');

        when(
          () => mockRepository.rejectRecurringBooking(
            recurringBookingId: any(named: 'recurringBookingId'),
            reason: any(named: 'reason'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure on network error', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');

        when(
          () => mockRepository.rejectRecurringBooking(
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

    group('RejectRecurringBookingParams', () {
      test('should support equality', () {
        const params1 = RejectRecurringBookingParams(
          recurringBookingId: tRecurringBookingId,
          reason: tReason,
        );
        const params2 = RejectRecurringBookingParams(
          recurringBookingId: tRecurringBookingId,
          reason: tReason,
        );

        expect(params1, equals(params2));
      });

      test('should have correct props', () {
        expect(tParams.props, [tRecurringBookingId, tReason]);
      });

      test('should not be equal with different booking ID', () {
        const params1 = RejectRecurringBookingParams(
          recurringBookingId: tRecurringBookingId,
          reason: tReason,
        );
        const params2 = RejectRecurringBookingParams(
          recurringBookingId: 'different-id',
          reason: tReason,
        );

        expect(params1, isNot(equals(params2)));
      });

      test('should not be equal with different reason', () {
        const params1 = RejectRecurringBookingParams(
          recurringBookingId: tRecurringBookingId,
          reason: tReason,
        );
        const params2 = RejectRecurringBookingParams(
          recurringBookingId: tRecurringBookingId,
          reason: 'Different reason',
        );

        expect(params1, isNot(equals(params2)));
      });
    });
  });
}
