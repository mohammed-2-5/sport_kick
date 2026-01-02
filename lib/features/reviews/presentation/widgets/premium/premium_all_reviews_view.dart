import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/core/widgets/premium/empty_states.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_cubit.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_state.dart';
import 'package:spo_kick/features/reviews/presentation/widgets/premium/premium_filter_chips.dart';
import 'package:spo_kick/features/reviews/presentation/widgets/premium/premium_review_card.dart';
import 'package:spo_kick/features/reviews/presentation/widgets/premium/premium_star_rating_display.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium all reviews view with enhanced UI.
///
/// Features:
/// - Rating overview card
/// - Rating filter chips
/// - Staggered review list
/// - Pull to refresh
/// - Empty states
class PremiumAllReviewsView extends StatefulWidget {
  final String fieldId;
  final String fieldName;
  final double? averageRating;
  final String? currentUserId;

  const PremiumAllReviewsView({
    super.key,
    required this.fieldId,
    required this.fieldName,
    this.averageRating,
    this.currentUserId,
  });

  @override
  State<PremiumAllReviewsView> createState() => _PremiumAllReviewsViewState();
}

class _PremiumAllReviewsViewState extends State<PremiumAllReviewsView> {
  int? _selectedRating;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewsCubit, ReviewsState>(
      builder: (context, state) {
        if (state is ReviewsLoading) {
          return LoadingIndicator.inline(message: context.l10n.loadingReviews);
        }

        if (state is ReviewsError) {
          return EmptyStates.error(
            context,
            message: state.message,
            onRetry: () => context.read<ReviewsCubit>().loadFieldReviews(
              fieldId: widget.fieldId,
            ),
          );
        }

        if (state is ReviewsLoaded) {
          if (state.reviews.isEmpty) {
            return EmptyStates.noReviews(
              context,
              onWrite: () => _navigateToCreateReview(context),
            );
          }

          // Calculate rating breakdown
          final ratingCounts = <int, int>{};
          for (final review in state.reviews) {
            ratingCounts[review.rating] =
                (ratingCounts[review.rating] ?? 0) + 1;
          }

          // Filter reviews
          final filteredReviews = _selectedRating == null
              ? state.reviews
              : state.reviews
                    .where((r) => r.rating == _selectedRating)
                    .toList();

          // Calculate average
          final avgRating =
              widget.averageRating ??
              (state.reviews.isNotEmpty
                  ? state.reviews.map((r) => r.rating).reduce((a, b) => a + b) /
                        state.reviews.length
                  : 0.0);

          final colorScheme = Theme.of(context).colorScheme;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ReviewsCubit>().loadFieldReviews(
                fieldId: widget.fieldId,
              );
            },
            color: colorScheme.primary,
            child: CustomScrollView(
              slivers: [
                // Rating overview
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: PremiumRatingOverview(
                      averageRating: avgRating,
                      totalReviews: state.reviews.length,
                      ratingBreakdown: ratingCounts,
                    ),
                  ),
                ),

                // Filter chips
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          context.l10n.filterByRating,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      PremiumRatingFilterChips(
                        selectedRating: _selectedRating,
                        ratingCounts: ratingCounts,
                        onRatingSelected: (rating) {
                          setState(() => _selectedRating = rating);
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                // Reviews list header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedRating == null
                              ? context.l10n.allReviewsWithCount(
                                  state.reviews.length,
                                )
                              : context.l10n.starReviewsWithCount(
                                  filteredReviews.length,
                                  _selectedRating!,
                                ),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        if (_selectedRating != null)
                          GestureDetector(
                            onTap: () => setState(() => _selectedRating = null),
                            child: Text(
                              context.l10n.clear,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Reviews list
                if (filteredReviews.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star_outline,
                            size: 64,
                            color: colorScheme.onSurfaceVariant.withValues(
                              alpha: 0.3,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            context.l10n.noStarReviewsYet(_selectedRating!),
                            style: TextStyle(
                              fontSize: 16,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverAnimationLimiter(
                      child: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final review = filteredReviews[index];
                          final isCurrentUser =
                              widget.currentUserId != null &&
                              review.userId == widget.currentUserId;

                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: PremiumReviewCard(
                                  review: review,
                                  showActions: isCurrentUser,
                                  onEdit: isCurrentUser
                                      ? () => _navigateToEditReview(
                                          context,
                                          review.id,
                                          review.rating,
                                          review.comment,
                                        )
                                      : null,
                                  onDelete: isCurrentUser
                                      ? () => _showDeleteConfirmation(
                                          context,
                                          review.id,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          );
                        }, childCount: filteredReviews.length),
                      ),
                    ),
                  ),

                // Bottom padding
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _navigateToCreateReview(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/create-review',
      arguments: {'fieldId': widget.fieldId, 'fieldName': widget.fieldName},
    );
  }

  void _navigateToEditReview(
    BuildContext context,
    String reviewId,
    int rating,
    String? comment,
  ) {
    Navigator.pushNamed(
      context,
      '/create-review',
      arguments: {
        'fieldId': widget.fieldId,
        'fieldName': widget.fieldName,
        'reviewId': reviewId,
        'existingRating': rating,
        'existingComment': comment,
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, String reviewId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(context.l10n.deleteReview),
        content: Text(context.l10n.thisActionCannotBeUndoneAre),
        actions: [
          Builder(
            builder: (context) {
              final colorScheme = Theme.of(context).colorScheme;
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      context.l10n.cancel,
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<ReviewsCubit>().deleteReview(reviewId);
                    },
                    child: Text(
                      context.l10n.delete,
                      style: TextStyle(
                        color: isDark ? AppColors.darkError : AppColors.error,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Sliver animation limiter wrapper.
class SliverAnimationLimiter extends StatelessWidget {
  final Widget child;

  const SliverAnimationLimiter({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(child: child);
  }
}
