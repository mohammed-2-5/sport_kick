import 'package:equatable/equatable.dart';

/// State for review form.
sealed class ReviewFormState extends Equatable {
  const ReviewFormState();

  @override
  List<Object?> get props => [];
}

/// Initial form state.
class ReviewFormInitial extends ReviewFormState {
  final int rating;
  final String comment;
  final bool isEditing;

  const ReviewFormInitial({
    this.rating = 0,
    this.comment = '',
    this.isEditing = false,
  });

  @override
  List<Object?> get props => [rating, comment, isEditing];
}

/// Form is valid and ready for submission.
class ReviewFormValid extends ReviewFormState {
  final int rating;
  final String comment;

  const ReviewFormValid({required this.rating, required this.comment});

  @override
  List<Object?> get props => [rating, comment];
}

/// Form is being submitted.
class ReviewFormSubmitting extends ReviewFormState {
  const ReviewFormSubmitting();
}

/// Form submission succeeded.
class ReviewFormSuccess extends ReviewFormState {
  final bool isEdit;

  const ReviewFormSuccess({this.isEdit = false});

  @override
  List<Object?> get props => [isEdit];
}

/// Form submission failed.
class ReviewFormError extends ReviewFormState {
  final String message;

  const ReviewFormError({required this.message});

  @override
  List<Object?> get props => [message];
}
