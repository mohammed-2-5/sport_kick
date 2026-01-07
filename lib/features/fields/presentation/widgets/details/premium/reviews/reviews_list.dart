import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/premium/reviews/reviews_empty_state.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/premium/reviews/reviews_error_state.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_cubit.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_state.dart';
import 'package:spo_kick/features/reviews/presentation/widgets/list/review_card.dart';

/// Reviews list section with state handling.
///
/// Handles all states from ReviewsCubit:
/// - Loading: Shows centered progress indicator
/// - Error: Shows error message with retry button
/// - Empty: Shows empty state with icon and text
/// - Loaded: Shows up to 3 recent reviews
class ReviewsList extends StatelessWidget {
  final FieldEntity field;
  final ColorScheme colorScheme;
  final bool isDark;

  const ReviewsList({
    super.key,
    required this.field,
    required this.colorScheme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewsCubit, ReviewsState>(
      builder: (context, state) {
        if (state is ReviewsLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is ReviewsError) {
          return ReviewsErrorState(
            message: state.message,
            onRetry: () => context.read<ReviewsCubit>().loadFieldReviews(
              fieldId: field.id,
              limit: 3,
            ),
            colorScheme: colorScheme,
            isDark: isDark,
          );
        }

        if (state is ReviewsLoaded) {
          if (state.reviews.isEmpty) {
            return ReviewsEmptyState(colorScheme: colorScheme);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.recentReviewsFromCustomers,
                style: AppTextStyles.labelLarge.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ...state.reviews
                  .take(3)
                  .map(
                    (review) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ReviewCard(review: review),
                    ),
                  ),
            ],
          );
        }

        return ReviewsEmptyState(colorScheme: colorScheme);
      },
    );
  }
}
