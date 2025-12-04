import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/reviews/domain/repositories/review_repository.dart';

/// Use case for deleting a review.
///
/// Handles the business logic for removing a review from the system.
class DeleteReviewUseCase {
  final ReviewRepository repository;

  DeleteReviewUseCase(this.repository);

  /// Execute the use case
  ///
  /// [reviewId] - ID of the review to delete
  ///
  /// Returns [Right(void)] on success
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, void>> call(String reviewId) async {
    if (reviewId.isEmpty) {
      return Left(ValidationFailure('Review ID cannot be empty'));
    }

    return await repository.deleteReview(reviewId);
  }
}
