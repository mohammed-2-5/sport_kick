import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/recurring_bookings/domain/repositories/recurring_booking_repository.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/approve_recurring_booking_usecase.dart';

class MockRecurringBookingRepository extends Mock
    implements RecurringBookingRepository {}

void main() {
  late ApproveRecurringBookingUseCase useCase;
  late MockRecurringBookingRepository mockRepository;

  setUp(() {
    mockRepository = MockRecurringBookingRepository();
    useCase = ApproveRecurringBookingUseCase(mockRepository);
  });

  group('ApproveRecurringBookingUseCase', () {
    const tRecurringBookingId = 'recurring-123';

    const tParams = ApproveRecurringBookingParams(
      recurringBookingId: tRecurringBookingId,
    );

    group('successful approval', () {
      test('should return true when approval succeeds', () async {
        // Arrange
        when(
          () => mockRepository.approveRecurringBooking(
            recurringBookingId: any(named: 'recurringBookingId'),
          ),
        ).thenAnswer((_) async => const Right(true));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Right(true)));
        verify(
          () => mockRepository.approveRecurringBooking(
            recurringBookingId: tRecurringBookingId,
          ),
        ).called(1);
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.approveRecurringBooking(
            recurringBookingId: any(named: 'recurringBookingId'),
          ),
        ).thenAnswer((_) async => const Right(true));

        // Act
        await useCase(tParams);

        // Assert
        verify(
          () => mockRepository.approveRecurringBooking(
            recurringBookingId: tRecurringBookingId,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle multiple approvals for different bookings', () async {
        // Arrange
        final bookingIds = ['booking-1', 'booking-2', 'booking-3'];

        for (final id in bookingIds) {
          when(
            () => mockRepository.approveRecurringBooking(
              recurringBookingId: any(named: 'recurringBookingId'),
            ),
          ).thenAnswer((_) async => const Right(true));

          // Act
          final result = await useCase(
            ApproveRecurringBookingParams(recurringBookingId: id),
          );

          // Assert
          expect(result.isRight(), true);
        }
      });

      test('should handle UUID format booking IDs', () async {
        // Arrange
        const uuidBookingId = '550e8400-e29b-41d4-a716-446655440000';
        const params = ApproveRecurringBookingParams(
          recurringBookingId: uuidBookingId,
        );

        when(
          () => mockRepository.approveRecurringBooking(
            recurringBookingId: any(named: 'recurringBookingId'),
          ),
        ).thenAnswer((_) async => const Right(true));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.approveRecurringBooking(
            recurringBookingId: uuidBookingId,
          ),
        ).called(1);
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to approve booking');

        when(
          () => mockRepository.approveRecurringBooking(
            recurringBookingId: any(named: 'recurringBookingId'),
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
          () => mockRepository.approveRecurringBooking(
            recurringBookingId: any(named: 'recurringBookingId'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test(
        'should return ValidationFailure when booking already approved',
        () async {
          // Arrange
          const tFailure = ValidationFailure('Booking is already approved');

          when(
            () => mockRepository.approveRecurringBooking(
              recurringBookingId: any(named: 'recurringBookingId'),
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
        const tFailure = AuthFailure('Not authorized to approve this booking');

        when(
          () => mockRepository.approveRecurringBooking(
            recurringBookingId: any(named: 'recurringBookingId'),
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
          () => mockRepository.approveRecurringBooking(
            recurringBookingId: any(named: 'recurringBookingId'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });

    group('ApproveRecurringBookingParams', () {
      test('should support equality', () {
        const params1 = ApproveRecurringBookingParams(
          recurringBookingId: tRecurringBookingId,
        );
        const params2 = ApproveRecurringBookingParams(
          recurringBookingId: tRecurringBookingId,
        );

        expect(params1, equals(params2));
      });

      test('should have correct props', () {
        expect(tParams.props, [tRecurringBookingId]);
      });

      test('should not be equal with different values', () {
        const params1 = ApproveRecurringBookingParams(
          recurringBookingId: tRecurringBookingId,
        );
        const params2 = ApproveRecurringBookingParams(
          recurringBookingId: 'different-id',
        );

        expect(params1, isNot(equals(params2)));
      });
    });
  });
}
