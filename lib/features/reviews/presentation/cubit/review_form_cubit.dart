import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/reviews/domain/usecases/create_review_usecase.dart';
import 'package:spo_kick/features/reviews/domain/usecases/update_review_usecase.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/review_form_state.dart';

/// Cubit for managing review form state.
///
/// Handles rating changes, comment updates, and form submission.
class ReviewFormCubit extends Cubit<ReviewFormState> {
  final CreateReviewUseCase createReviewUseCase;
  final UpdateReviewUseCase updateReviewUseCase;
  final String fieldId;
  final String? bookingId;
  final String? reviewId;
  final String? userId;

  int _rating = 0;
  String _comment = '';

  ReviewFormCubit({
    required this.createReviewUseCase,
    required this.updateReviewUseCase,
    required this.fieldId,
    this.bookingId,
    this.reviewId,
    this.userId,
    int? initialRating,
    String? initialComment,
  }) : super(
         ReviewFormInitial(
           rating: initialRating ?? 0,
           comment: initialComment ?? '',
           isEditing: reviewId != null,
         ),
       ) {
    _rating = initialRating ?? 0;
    _comment = initialComment ?? '';
  }

  /// Whether this is an edit operation.
  bool get isEditing => reviewId != null;

  /// Current rating value.
  int get rating => _rating;

  /// Current comment value.
  String get comment => _comment;

  /// Update rating.
  void updateRating(int rating) {
    _rating = rating;
    _validateForm();
  }

  /// Update comment.
  void updateComment(String comment) {
    _comment = comment;
  }

  void _validateForm() {
    if (_rating > 0) {
      emit(ReviewFormValid(rating: _rating, comment: _comment));
    } else {
      emit(
        ReviewFormInitial(
          rating: _rating,
          comment: _comment,
          isEditing: isEditing,
        ),
      );
    }
  }

  /// Submit the review.
  Future<void> submit({
    required String errorRating,
    required String errorLogin,
  }) async {
    if (_rating == 0) {
      emit(ReviewFormError(message: errorRating));
      return;
    }

    if (userId == null && !isEditing) {
      emit(ReviewFormError(message: errorLogin));
      return;
    }

    emit(const ReviewFormSubmitting());

    final commentToSubmit = _comment.trim().isEmpty ? null : _comment.trim();

    if (isEditing) {
      // Update existing review
      final result = await updateReviewUseCase(
        UpdateReviewParams(
          reviewId: reviewId!,
          rating: _rating,
          comment: commentToSubmit,
        ),
      );

      result.fold(
        (failure) => emit(ReviewFormError(message: failure.message)),
        (_) => emit(const ReviewFormSuccess(isEdit: true)),
      );
    } else {
      // Create new review
      final result = await createReviewUseCase(
        CreateReviewParams(
          fieldId: fieldId,
          userId: userId!,
          bookingId: bookingId,
          rating: _rating,
          comment: commentToSubmit,
        ),
      );

      result.fold(
        (failure) => emit(ReviewFormError(message: failure.message)),
        (_) => emit(const ReviewFormSuccess(isEdit: false)),
      );
    }
  }
}
