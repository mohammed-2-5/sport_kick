import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_cubit.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_state.dart';
import 'package:spo_kick/features/reviews/presentation/widgets/list/review_card.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

class ReviewsListContent extends StatefulWidget {
  final String fieldId;
  final String fieldName;

  const ReviewsListContent({
    super.key,
    required this.fieldId,
    required this.fieldName,
  });

  @override
  State<ReviewsListContent> createState() => _ReviewsListContentState();
}

class _ReviewsListContentState extends State<ReviewsListContent> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isLoadingMore) return;

    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final threshold = maxScroll * 0.8;

    if (currentScroll >= threshold) {
      final state = context.read<ReviewsCubit>().state;
      if (state is ReviewsLoaded && state.hasMore) {
        setState(() {
          _isLoadingMore = true;
        });
        context.read<ReviewsCubit>().loadFieldReviews(
          fieldId: widget.fieldId,
          offset: state.reviews.length,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<ReviewsCubit, ReviewsState>(
      listener: (context, state) {
        if (state is ReviewsLoaded || state is ReviewsError) {
          if (mounted) {
            setState(() {
              _isLoadingMore = false;
            });
          }
        }
      },
      builder: (context, state) {
        if (state is ReviewsLoading) {
          return Center(
            child: CircularProgressIndicator(color: colorScheme.primary),
          );
        }

        if (state is ReviewsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: isDark ? AppColors.darkError : AppColors.error,
                ),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: AppTextStyles.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<ReviewsCubit>().loadFieldReviews(
                      fieldId: widget.fieldId,
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: Text(context.l10n.retry),
                ),
              ],
            ),
          );
        }

        if (state is ReviewsLoaded) {
          if (state.reviews.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.rate_review_outlined,
                    size: 64,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.noReviews,
                    style: AppTextStyles.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.beFirstToReviewField(widget.fieldName),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: state.reviews.length + (state.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= state.reviews.length) {
                // Loading indicator for pagination
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: CircularProgressIndicator(
                      color: colorScheme.primary,
                    ),
                  ),
                );
              }

              final review = state.reviews[index];
              return ReviewCard(review: review);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
