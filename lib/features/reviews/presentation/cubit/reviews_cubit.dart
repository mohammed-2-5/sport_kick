import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/reviews/domain/usecases/can_user_review_field_usecase.dart';
import 'package:spo_kick/features/reviews/domain/usecases/create_review_usecase.dart';
import 'package:spo_kick/features/reviews/domain/usecases/delete_review_usecase.dart';
import 'package:spo_kick/features/reviews/domain/usecases/get_field_reviews_usecase.dart';
import 'package:spo_kick/features/reviews/domain/usecases/update_review_usecase.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_state.dart';

import '../../domain/entities/review_entity.dart';

/// Cubit for managing reviews state.
///
/// Handles all review-related operations including create, read, update, delete.
class ReviewsCubit extends Cubit<ReviewsState> {
  final CreateReviewUseCase createReviewUseCase;
  final GetFieldReviewsUseCase getFieldReviewsUseCase;
  final UpdateReviewUseCase updateReviewUseCase;
  final DeleteReviewUseCase deleteReviewUseCase;
  final CanUserReviewFieldUseCase canUserReviewFieldUseCase;

  ReviewsCubit({
    required this.createReviewUseCase,
    required this.getFieldReviewsUseCase,
    required this.updateReviewUseCase,
    required this.deleteReviewUseCase,
    required this.canUserReviewFieldUseCase,
  }) : super(const ReviewsInitial());

  /// Load reviews for a specific field
  Future<void> loadFieldReviews({
    required String fieldId,
    int limit = 20,
    int offset = 0,
  }) async {
    if (offset == 0) {
      emit(const ReviewsLoading());
    } else {
      // If loading more, preserve current state
      if (state is ReviewsLoaded) {
        emit(
          ReviewsLoadingMore(
            reviews: (state as ReviewsLoaded).reviews,
            hasMore: (state as ReviewsLoaded).hasMore,
            totalCount: (state as ReviewsLoaded).totalCount,
          ),
        );
      }
    }

    final result = await getFieldReviewsUseCase(
      GetFieldReviewsParams(fieldId: fieldId, limit: limit, offset: offset),
    );

    result.fold((failure) => emit(ReviewsError(failure.message)), (newReviews) {
      final List<ReviewEntity> allReviews = offset == 0
          ? newReviews
          : [
              ...(state is ReviewsLoaded
                  ? (state as ReviewsLoaded).reviews
                  : <ReviewEntity>[]),
              ...newReviews,
            ];

      emit(
        ReviewsLoaded(
          reviews: allReviews,
          hasMore: newReviews.length >= limit,
          totalCount: allReviews.length,
        ),
      );
    });
  }

  /// Create a new review
  Future<void> createReview({
    required String fieldId,
    required String userId,
    String? bookingId,
    required int rating,
    String? comment,
  }) async {
    emit(const ReviewCreating());

    final result = await createReviewUseCase(
      CreateReviewParams(
        fieldId: fieldId,
        userId: userId,
        bookingId: bookingId,
        rating: rating,
        comment: comment,
      ),
    );

    result.fold(
      (failure) => emit(ReviewsError(failure.message)),
      (review) => emit(ReviewCreated(review)),
    );
  }

  /// Update an existing review
  Future<void> updateReview({
    required String reviewId,
    int? rating,
    String? comment,
  }) async {
    emit(const ReviewUpdating());

    final result = await updateReviewUseCase(
      UpdateReviewParams(reviewId: reviewId, rating: rating, comment: comment),
    );

    result.fold(
      (failure) => emit(ReviewsError(failure.message)),
      (review) => emit(ReviewUpdated(review)),
    );
  }

  /// Delete a review
  Future<void> deleteReview(String reviewId) async {
    emit(const ReviewDeleting());

    final result = await deleteReviewUseCase(reviewId);

    result.fold(
      (failure) => emit(ReviewsError(failure.message)),
      (_) => emit(const ReviewDeleted()),
    );
  }

  /// Check if user can review a field
  Future<void> checkReviewEligibility({
    required String userId,
    required String fieldId,
    required String bookingId,
  }) async {
    emit(const ReviewEligibilityChecking());

    final result = await canUserReviewFieldUseCase(
      CanUserReviewFieldParams(
        userId: userId,
        fieldId: fieldId,
        bookingId: bookingId,
      ),
    );

    result.fold((failure) => emit(ReviewsError(failure.message)), (canReview) {
      final message = canReview
          ? 'You can review this field'
          : 'You cannot review this field yet. Complete your booking first.';
      emit(ReviewEligibilityChecked(canReview: canReview, message: message));
    });
  }

  /// Reset to initial state
  void reset() {
    emit(const ReviewsInitial());
  }
}
