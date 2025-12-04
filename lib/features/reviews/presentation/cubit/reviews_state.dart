import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/reviews/domain/entities/review_entity.dart';

/// Base class for all review states
abstract class ReviewsState extends Equatable {
  const ReviewsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ReviewsInitial extends ReviewsState {
  const ReviewsInitial();
}

/// Loading state
class ReviewsLoading extends ReviewsState {
  const ReviewsLoading();
}

/// State when reviews are successfully loaded
class ReviewsLoaded extends ReviewsState {
  final List<ReviewEntity> reviews;
  final bool hasMore;
  final int totalCount;

  const ReviewsLoaded({
    required this.reviews,
    this.hasMore = false,
    this.totalCount = 0,
  });

  @override
  List<Object?> get props => [reviews, hasMore, totalCount];

  ReviewsLoaded copyWith({
    List<ReviewEntity>? reviews,
    bool? hasMore,
    int? totalCount,
  }) {
    return ReviewsLoaded(
      reviews: reviews ?? this.reviews,
      hasMore: hasMore ?? this.hasMore,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}

/// State when creating a review
class ReviewCreating extends ReviewsState {
  const ReviewCreating();
}

/// State when review is successfully created
class ReviewCreated extends ReviewsState {
  final ReviewEntity review;

  const ReviewCreated(this.review);

  @override
  List<Object?> get props => [review];
}

/// State when updating a review
class ReviewUpdating extends ReviewsState {
  const ReviewUpdating();
}

/// State when review is successfully updated
class ReviewUpdated extends ReviewsState {
  final ReviewEntity review;

  const ReviewUpdated(this.review);

  @override
  List<Object?> get props => [review];
}

/// State when deleting a review
class ReviewDeleting extends ReviewsState {
  const ReviewDeleting();
}

/// State when review is successfully deleted
class ReviewDeleted extends ReviewsState {
  const ReviewDeleted();
}

/// State for checking if user can review
class ReviewEligibilityChecking extends ReviewsState {
  const ReviewEligibilityChecking();
}

/// State when user review eligibility is determined
class ReviewEligibilityChecked extends ReviewsState {
  final bool canReview;
  final String message;

  const ReviewEligibilityChecked({required this.canReview, this.message = ''});

  @override
  List<Object?> get props => [canReview, message];
}

/// Error state
class ReviewsError extends ReviewsState {
  final String message;

  const ReviewsError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State when loading more reviews (pagination)
class ReviewsLoadingMore extends ReviewsLoaded {
  const ReviewsLoadingMore({
    required super.reviews,
    super.hasMore,
    super.totalCount,
  });
}
