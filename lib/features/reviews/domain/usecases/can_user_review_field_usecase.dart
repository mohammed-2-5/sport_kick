import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/reviews/domain/repositories/review_repository.dart';

/// Use case for checking if a user can review a field.
///
/// Verifies that the user has a completed booking and hasn't already reviewed.
class CanUserReviewFieldUseCase {
  final ReviewRepository repository;

  CanUserReviewFieldUseCase(this.repository);

  /// Execute the use case
  ///
  /// [params] - Parameters for checking review eligibility
  ///
  /// Returns [Right(bool)] indicating if user can review
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, bool>> call(CanUserReviewFieldParams params) async {
    return await repository.canUserReviewField(
      userId: params.userId,
      fieldId: params.fieldId,
      bookingId: params.bookingId,
    );
  }
}

/// Parameters for checking if user can review a field
class CanUserReviewFieldParams {
  final String userId;
  final String fieldId;
  final String bookingId;

  const CanUserReviewFieldParams({
    required this.userId,
    required this.fieldId,
    required this.bookingId,
  });
}
