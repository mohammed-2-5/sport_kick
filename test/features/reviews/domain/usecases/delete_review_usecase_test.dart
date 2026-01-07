import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/reviews/domain/repositories/review_repository.dart';
import 'package:spo_kick/features/reviews/domain/usecases/delete_review_usecase.dart';

class MockReviewRepository extends Mock implements ReviewRepository {}

void main() {
  late DeleteReviewUseCase useCase;
  late MockReviewRepository mockRepository;

  setUp(() {
    mockRepository = MockReviewRepository();
    useCase = DeleteReviewUseCase(mockRepository);
  });

  group('DeleteReviewUseCase', () {
    const tReviewId = 'review-123';

    group('successful deletion', () {
      test('should return Right(void) when deletion succeeds', () async {
        // Arrange
        when(
          () => mockRepository.deleteReview(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(tReviewId);

        // Assert
        expect(result.isRight(), true);
        verify(() => mockRepository.deleteReview(tReviewId)).called(1);
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.deleteReview(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await useCase(tReviewId);

        // Assert
        verify(() => mockRepository.deleteReview(tReviewId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle UUID format review IDs', () async {
        // Arrange
        const uuidReviewId = '550e8400-e29b-41d4-a716-446655440000';
        when(
          () => mockRepository.deleteReview(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(uuidReviewId);

        // Assert
        expect(result.isRight(), true);
        verify(() => mockRepository.deleteReview(uuidReviewId)).called(1);
      });
    });

    group('validation failures', () {
      test('should return ValidationFailure when review ID is empty', () async {
        // Act
        final result = await useCase('');

        // Assert
        expect(
          result,
          equals(const Left(ValidationFailure('Review ID cannot be empty'))),
        );
        verifyNever(() => mockRepository.deleteReview(any()));
      });
    });

    group('repository failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to delete review');
        when(
          () => mockRepository.deleteReview(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tReviewId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ValidationFailure when review not found', () async {
        // Arrange
        const tFailure = ValidationFailure('Review not found');
        when(
          () => mockRepository.deleteReview(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase('non-existent-review');

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when not authorized', () async {
        // Arrange
        const tFailure = AuthFailure('Not authorized to delete this review');
        when(
          () => mockRepository.deleteReview(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tReviewId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
