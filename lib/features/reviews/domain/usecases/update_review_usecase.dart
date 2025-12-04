import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/reviews/domain/entities/review_entity.dart';
import 'package:spo_kick/features/reviews/domain/repositories/review_repository.dart';

/// Use case for updating an existing review.
///
/// Handles the business logic for updating a review's rating and/or comment.
class UpdateReviewUseCase {
  final ReviewRepository repository;

  UpdateReviewUseCase(this.repository);

  /// Execute the use case
  ///
  /// [params] - Parameters for updating the review
  ///
  /// Returns [Right(ReviewEntity)] on success
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, ReviewEntity>> call(UpdateReviewParams params) async {
    // Validate rating if provided
    if (params.rating != null && (params.rating! < 1 || params.rating! > 5)) {
      return Left(ValidationFailure('Rating must be between 1 and 5'));
    }

    // Validate comment length if provided
    if (params.comment != null && params.comment!.length > 1000) {
      return Left(ValidationFailure('Comment must not exceed 1000 characters'));
    }

    // At least one field must be provided
    if (params.rating == null && params.comment == null) {
      return Left(
        ValidationFailure('At least rating or comment must be provided'),
      );
    }

    return await repository.updateReview(
      reviewId: params.reviewId,
      rating: params.rating,
      comment: params.comment,
    );
  }
}

/// Parameters for updating a review
class UpdateReviewParams {
  final String reviewId;
  final int? rating;
  final String? comment;

  const UpdateReviewParams({required this.reviewId, this.rating, this.comment});
}
