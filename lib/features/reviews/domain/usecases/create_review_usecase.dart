import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/reviews/domain/entities/review_entity.dart';
import 'package:spo_kick/features/reviews/domain/repositories/review_repository.dart';

/// Use case for creating a new review.
///
/// Handles the business logic for creating a review for a field.
class CreateReviewUseCase {
  final ReviewRepository repository;

  CreateReviewUseCase(this.repository);

  /// Execute the use case
  ///
  /// [params] - Parameters for creating the review
  ///
  /// Returns [Right(ReviewEntity)] on success
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, ReviewEntity>> call(CreateReviewParams params) async {
    // Validate rating
    if (params.rating < 1 || params.rating > 5) {
      return const Left(ValidationFailure('Rating must be between 1 and 5'));
    }

    // Validate comment length if provided
    if (params.comment != null && params.comment!.length > 1000) {
      return const Left(
        ValidationFailure('Comment must not exceed 1000 characters'),
      );
    }

    return await repository.createReview(
      fieldId: params.fieldId,
      userId: params.userId,
      bookingId: params.bookingId,
      rating: params.rating,
      comment: params.comment,
    );
  }
}

/// Parameters for creating a review
class CreateReviewParams {
  final String fieldId;
  final String userId;
  final String? bookingId;
  final int rating;
  final String? comment;

  const CreateReviewParams({
    required this.fieldId,
    required this.userId,
    this.bookingId,
    required this.rating,
    this.comment,
  });
}
