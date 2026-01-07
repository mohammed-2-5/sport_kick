import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/reviews/domain/repositories/review_repository.dart';
import 'package:spo_kick/features/reviews/domain/usecases/can_user_review_field_usecase.dart';

class MockReviewRepository extends Mock implements ReviewRepository {}

void main() {
  late CanUserReviewFieldUseCase useCase;
  late MockReviewRepository mockRepository;

  setUp(() {
    mockRepository = MockReviewRepository();
    useCase = CanUserReviewFieldUseCase(mockRepository);
  });

  group('CanUserReviewFieldUseCase', () {
    group('successful check', () {
      test('should return true when user can review', () async {
        // Arrange
        const params = CanUserReviewFieldParams(
          userId: 'user-123',
          fieldId: 'field-123',
          bookingId: 'booking-123',
        );

        when(
          () => mockRepository.canUserReviewField(
            userId: any(named: 'userId'),
            fieldId: any(named: 'fieldId'),
            bookingId: any(named: 'bookingId'),
          ),
        ).thenAnswer((_) async => const Right(true));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, equals(const Right(true)));
      });

      test('should return false when user cannot review', () async {
        // Arrange
        const params = CanUserReviewFieldParams(
          userId: 'user-123',
          fieldId: 'field-123',
          bookingId: 'booking-123',
        );

        when(
          () => mockRepository.canUserReviewField(
            userId: any(named: 'userId'),
            fieldId: any(named: 'fieldId'),
            bookingId: any(named: 'bookingId'),
          ),
        ).thenAnswer((_) async => const Right(false));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, equals(const Right(false)));
      });

      test('should call repository with correct parameters', () async {
        // Arrange
        const params = CanUserReviewFieldParams(
          userId: 'user-123',
          fieldId: 'field-123',
          bookingId: 'booking-123',
        );

        when(
          () => mockRepository.canUserReviewField(
            userId: any(named: 'userId'),
            fieldId: any(named: 'fieldId'),
            bookingId: any(named: 'bookingId'),
          ),
        ).thenAnswer((_) async => const Right(true));

        // Act
        await useCase(params);

        // Assert
        verify(
          () => mockRepository.canUserReviewField(
            userId: 'user-123',
            fieldId: 'field-123',
            bookingId: 'booking-123',
          ),
        ).called(1);
      });
    });

    group('repository failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const params = CanUserReviewFieldParams(
          userId: 'user-123',
          fieldId: 'field-123',
          bookingId: 'booking-123',
        );
        const tFailure = ServerFailure('Failed to check review eligibility');

        when(
          () => mockRepository.canUserReviewField(
            userId: any(named: 'userId'),
            fieldId: any(named: 'fieldId'),
            bookingId: any(named: 'bookingId'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ValidationFailure when booking not found', () async {
        // Arrange
        const params = CanUserReviewFieldParams(
          userId: 'user-123',
          fieldId: 'field-123',
          bookingId: 'invalid-booking',
        );
        const tFailure = ValidationFailure('Booking not found');

        when(
          () => mockRepository.canUserReviewField(
            userId: any(named: 'userId'),
            fieldId: any(named: 'fieldId'),
            bookingId: any(named: 'bookingId'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
