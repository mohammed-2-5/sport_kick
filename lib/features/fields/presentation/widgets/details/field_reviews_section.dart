import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_cubit.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_state.dart';
import 'package:spo_kick/features/reviews/presentation/widgets/rating/rating_stars.dart';
import 'package:spo_kick/features/reviews/presentation/widgets/list/review_card.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';

/// Reviews section widget for field details.
///
/// Displays recent reviews and allows users to write reviews.
class FieldReviewsSection extends StatelessWidget {
  final FieldEntity field;

  const FieldReviewsSection({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.reviews,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (field.hasReviews)
                TextButton(
                  onPressed: () {
                    context.pushNamed(
                      'allReviews',
                      extra: {
                        'fieldId': field.id,
                        'fieldName': field.name,
                        'averageRating': field.averageRating,
                        'totalReviews': field.totalReviews,
                      },
                    );
                  },
                  child: Text(context.l10n.seeAll),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Rating summary
          if (field.hasReviews)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        LocaleFormatters.formatNumber(
                          context,
                          field.averageRating ?? 0,
                          decimalDigits: 1,
                        ),
                        style: AppTextStyles.displaySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      RatingStars(rating: field.averageRating ?? 0, size: 16),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n
                              .reviewsSummary(field.totalReviews)
                              .replaceFirst(
                                field.totalReviews.toString(),
                                LocaleFormatters.formatNumber(
                                  context,
                                  field.totalReviews,
                                ),
                              ),
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.rate_review_outlined, color: Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      context.l10n.noReviews,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // Write review button
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              if (authState is Authenticated) {
                return SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final result = await context.pushNamed(
                        'createReview',
                        extra: {'fieldId': field.id, 'fieldName': field.name},
                      );
                      // Reload field details if review was created
                      if (result == true) {
                        // Trigger field reload here if needed
                      }
                    },
                    icon: const Icon(Icons.edit),
                    label: Text(context.l10n.writeReview),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: AppColors.primary),
                      foregroundColor: AppColors.primary,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          const SizedBox(height: 16),

          // Recent reviews
          if (field.hasReviews)
            BlocProvider(
              create: (_) =>
                  sl<ReviewsCubit>()
                    ..loadFieldReviews(fieldId: field.id, limit: 3),
              child: BlocBuilder<ReviewsCubit, ReviewsState>(
                builder: (context, state) {
                  if (state is ReviewsLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  }

                  if (state is ReviewsError) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.errorLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppColors.error,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              context.l10n.failedToLoadReviews,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is ReviewsLoaded && state.reviews.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.recentReviews,
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...state.reviews
                            .take(3)
                            .map((review) => ReviewCard(review: review)),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
        ],
      ),
    );
  }
}
