import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/reviews/domain/entities/review_entity.dart';
import 'package:spo_kick/features/reviews/domain/repositories/review_repository.dart';

/// Use case for getting reviews for a specific field.
///
/// Handles the business logic for fetching field reviews with pagination.
class GetFieldReviewsUseCase {
  final ReviewRepository repository;

  GetFieldReviewsUseCase(this.repository);

  /// Execute the use case
  ///
  /// [params] - Parameters for fetching reviews
  ///
  /// Returns [Right(List<ReviewEntity>)] on success
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, List<ReviewEntity>>> call(
    GetFieldReviewsParams params,
  ) async {
    // Validate limit
    if (params.limit < 1 || params.limit > 100) {
      return Left(ValidationFailure('Limit must be between 1 and 100'));
    }

    // Validate offset
    if (params.offset < 0) {
      return Left(ValidationFailure('Offset must be non-negative'));
    }

    return await repository.getFieldReviews(
      fieldId: params.fieldId,
      limit: params.limit,
      offset: params.offset,
    );
  }
}

/// Parameters for getting field reviews
class GetFieldReviewsParams {
  final String fieldId;
  final int limit;
  final int offset;

  const GetFieldReviewsParams({
    required this.fieldId,
    this.limit = 20,
    this.offset = 0,
  });
}
