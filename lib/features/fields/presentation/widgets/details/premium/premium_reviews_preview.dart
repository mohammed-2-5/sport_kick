import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_cubit.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_state.dart';
import 'package:spo_kick/features/reviews/presentation/widgets/list/review_card.dart';

/// Premium reviews preview section.
///
/// Features:
/// - Overall rating display
/// - Recent reviews preview (max 3)
/// - View All Reviews button
/// - Premium card styling
/// - Star rating display
class PremiumReviewsPreview extends StatelessWidget {
  final FieldEntity field;

  const PremiumReviewsPreview({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<ReviewsCubit>()..loadFieldReviews(fieldId: field.id, limit: 3),
      child: _ReviewsContent(field: field),
    );
  }
}

/// Internal widget to handle reviews content with BlocBuilder
class _ReviewsContent extends StatelessWidget {
  final FieldEntity field;

  const _ReviewsContent({required this.field});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    context.l10n.reviews,
                    style: AppTextStyles.titleLarge.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              if (field.hasReviews)
                TextButton(
                  onPressed: () {
                    context.pushNamed(
                      'allReviews',
                      extra: {'fieldId': field.id, 'fieldName': field.name},
                    );
                  },
                  child: Text(
                    context.l10n.viewAll,
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.accentCyan,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 20),

          // Overall Rating (if reviews exist)
          if (field.hasReviews) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.orange, Colors.deepOrange],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    field.averageRating!.toStringAsFixed(1),
                    style: AppTextStyles.displayMedium.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.star, color: Colors.white, size: 18),
                            Icon(Icons.star, color: Colors.white, size: 18),
                            Icon(Icons.star, color: Colors.white, size: 18),
                            Icon(Icons.star, color: Colors.white, size: 18),
                            Icon(Icons.star, color: Colors.white, size: 18),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          context.l10n.basedOnReviews(field.totalReviews),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Reviews List or Empty State
          BlocBuilder<ReviewsCubit, ReviewsState>(
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
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        state.message,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          context.read<ReviewsCubit>().loadFieldReviews(
                            fieldId: field.id,
                            limit: 3,
                          );
                        },
                        child: Text(context.l10n.retry),
                      ),
                    ],
                  ),
                );
              }

              if (state is ReviewsLoaded) {
                if (state.reviews.isEmpty) {
                  return _buildEmptyState(context);
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.recentReviewsFromCustomers,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.textSecondary,
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

              return _buildEmptyState(context);
            },
          ),

          const SizedBox(height: 16),

          // Write Review Button
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              if (authState is Authenticated) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result = await context.pushNamed(
                        'createReview',
                        extra: {'fieldId': field.id, 'fieldName': field.name},
                      );

                      // Refresh reviews if a new review was created
                      if (result == true && context.mounted) {
                        context.read<ReviewsCubit>().loadFieldReviews(
                          fieldId: field.id,
                          limit: 3,
                        );
                      }
                    },
                    icon: const Icon(Icons.rate_review),
                    label: Text(context.l10n.writeAReview),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentCyan,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: AppColors.backgroundLight,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.rate_review_outlined,
            size: 48,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          context.l10n.noReviews,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.beFirstReview,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
