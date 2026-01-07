import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/reviews/domain/entities/review_entity.dart';
import 'package:spo_kick/features/reviews/domain/repositories/review_repository.dart';
import 'package:spo_kick/features/reviews/domain/usecases/update_review_usecase.dart';

class MockReviewRepository extends Mock implements ReviewRepository {}

void main() {
  late UpdateReviewUseCase useCase;
  late MockReviewRepository mockRepository;

  setUp(() {
    mockRepository = MockReviewRepository();
    useCase = UpdateReviewUseCase(mockRepository);
  });

  group('UpdateReviewUseCase', () {
    final tNow = DateTime(2026, 1, 7);
    final tUpdatedReview = ReviewEntity(
      id: 'review-123',
      fieldId: 'field-123',
      userId: 'user-123',
      rating: 4,
      comment: 'Updated comment',
      createdAt: tNow,
      updatedAt: tNow,
    );

    group('successful update', () {
      test('should return updated review when update succeeds', () async {
        // Arrange
        const params = UpdateReviewParams(
          reviewId: 'review-123',
          rating: 4,
          comment: 'Updated comment',
        );

        when(
          () => mockRepository.updateReview(
            reviewId: any(named: 'reviewId'),
            rating: any(named: 'rating'),
            comment: any(named: 'comment'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedReview));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, equals(Right(tUpdatedReview)));
      });

      test('should update only rating', () async {
        // Arrange
        const params = UpdateReviewParams(reviewId: 'review-123', rating: 3);

        when(
          () => mockRepository.updateReview(
            reviewId: any(named: 'reviewId'),
            rating: any(named: 'rating'),
            comment: any(named: 'comment'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedReview));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });

      test('should update only comment', () async {
        // Arrange
        const params = UpdateReviewParams(
          reviewId: 'review-123',
          comment: 'New comment',
        );

        when(
          () => mockRepository.updateReview(
            reviewId: any(named: 'reviewId'),
            rating: any(named: 'rating'),
            comment: any(named: 'comment'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedReview));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });
    });

    group('validation failures', () {
      test('should return ValidationFailure when no fields provided', () async {
        // Arrange
        const params = UpdateReviewParams(reviewId: 'review-123');

        // Act
        final result = await useCase(params);

        // Assert
        expect(
          result,
          equals(
            const Left(
              ValidationFailure('At least rating or comment must be provided'),
            ),
          ),
        );
      });

      test('should return ValidationFailure for rating below 1', () async {
        // Arrange
        const params = UpdateReviewParams(reviewId: 'review-123', rating: 0);

        // Act
        final result = await useCase(params);

        // Assert
        expect(
          result,
          equals(
            const Left(ValidationFailure('Rating must be between 1 and 5')),
          ),
        );
      });

      test('should return ValidationFailure for rating above 5', () async {
        // Arrange
        const params = UpdateReviewParams(reviewId: 'review-123', rating: 6);

        // Act
        final result = await useCase(params);

        // Assert
        expect(
          result,
          equals(
            const Left(ValidationFailure('Rating must be between 1 and 5')),
          ),
        );
      });

      test(
        'should return ValidationFailure for comment exceeding 1000 chars',
        () async {
          // Arrange
          final longComment = 'a' * 1001;
          final params = UpdateReviewParams(
            reviewId: 'review-123',
            comment: longComment,
          );

          // Act
          final result = await useCase(params);

          // Assert
          expect(
            result,
            equals(
              const Left(
                ValidationFailure('Comment must not exceed 1000 characters'),
              ),
            ),
          );
        },
      );
    });

    group('repository failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const params = UpdateReviewParams(reviewId: 'review-123', rating: 4);
        const tFailure = ServerFailure('Failed to update review');

        when(
          () => mockRepository.updateReview(
            reviewId: any(named: 'reviewId'),
            rating: any(named: 'rating'),
            comment: any(named: 'comment'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ValidationFailure when review not found', () async {
        // Arrange
        const params = UpdateReviewParams(
          reviewId: 'invalid-review',
          rating: 4,
        );
        const tFailure = ValidationFailure('Review not found');

        when(
          () => mockRepository.updateReview(
            reviewId: any(named: 'reviewId'),
            rating: any(named: 'rating'),
            comment: any(named: 'comment'),
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
