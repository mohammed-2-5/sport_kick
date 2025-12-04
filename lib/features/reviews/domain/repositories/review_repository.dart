import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/reviews/domain/entities/review_entity.dart';

/// Review repository interface.
///
/// Defines the contract for review data operations.
/// Implementations should handle all review-related data access.
abstract class ReviewRepository {
  /// Create a new review
  ///
  /// [fieldId] - ID of the field being reviewed
  /// [userId] - ID of the user creating the review
  /// [bookingId] - Optional booking ID associated with the review
  /// [rating] - Rating value (1-5)
  /// [comment] - Optional review comment
  ///
  /// Returns [Right(ReviewEntity)] on success
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, ReviewEntity>> createReview({
    required String fieldId,
    required String userId,
    String? bookingId,
    required int rating,
    String? comment,
  });

  /// Get all reviews for a specific field
  ///
  /// [fieldId] - ID of the field
  /// [limit] - Maximum number of reviews to fetch (default: 20)
  /// [offset] - Number of reviews to skip for pagination (default: 0)
  ///
  /// Returns [Right(List<ReviewEntity>)] on success
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, List<ReviewEntity>>> getFieldReviews({
    required String fieldId,
    int limit = 20,
    int offset = 0,
  });

  /// Get a specific review by ID
  ///
  /// [reviewId] - ID of the review
  ///
  /// Returns [Right(ReviewEntity)] on success
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, ReviewEntity>> getReviewById(String reviewId);

  /// Get user's review for a specific field
  ///
  /// [userId] - ID of the user
  /// [fieldId] - ID of the field
  ///
  /// Returns [Right(ReviewEntity)] if review exists
  /// Returns [Left(Failure)] on error or if no review found
  Future<Either<Failure, ReviewEntity?>> getUserFieldReview({
    required String userId,
    required String fieldId,
  });

  /// Update an existing review
  ///
  /// [reviewId] - ID of the review to update
  /// [rating] - Optional new rating
  /// [comment] - Optional new comment
  ///
  /// Returns [Right(ReviewEntity)] on success
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, ReviewEntity>> updateReview({
    required String reviewId,
    int? rating,
    String? comment,
  });

  /// Delete a review
  ///
  /// [reviewId] - ID of the review to delete
  ///
  /// Returns [Right(void)] on success
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, void>> deleteReview(String reviewId);

  /// Check if user can review a field
  ///
  /// [userId] - ID of the user
  /// [fieldId] - ID of the field
  /// [bookingId] - ID of the booking
  ///
  /// Returns [Right(bool)] indicating if user can review
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, bool>> canUserReviewField({
    required String userId,
    required String fieldId,
    required String bookingId,
  });

  /// Get all reviews by a specific user
  ///
  /// [userId] - ID of the user
  /// [limit] - Maximum number of reviews to fetch (default: 20)
  /// [offset] - Number of reviews to skip for pagination (default: 0)
  ///
  /// Returns [Right(List<ReviewEntity>)] on success
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, List<ReviewEntity>>> getUserReviews({
    required String userId,
    int limit = 20,
    int offset = 0,
  });
}
