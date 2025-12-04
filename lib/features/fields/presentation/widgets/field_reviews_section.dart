import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/constants/field_constants.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_cubit.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_state.dart';
import 'package:spo_kick/features/reviews/presentation/widgets/rating_stars.dart';
import 'package:spo_kick/features/reviews/presentation/widgets/review_card.dart';

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
              const Text(
                FieldConstants.reviewsTitle,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  child: const Text('See all'),
                ),
            ],
          ),
          const SizedBox(height: FieldConstants.itemSpacing),

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
                        field.averageRating?.toStringAsFixed(1) ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 36,
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
                          '${field.totalReviews} ${field.totalReviews == 1 ? 'Review' : 'Reviews'}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Based on customer experiences',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
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
              child: const Row(
                children: [
                  Icon(Icons.rate_review_outlined, color: Colors.grey),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'No reviews yet. Be the first to review!',
                      style: TextStyle(color: Colors.grey),
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
                        extra: {
                          'fieldId': field.id,
                          'fieldName': field.name,
                        },
                      );
                      // Reload field details if review was created
                      if (result == true) {
                        // Trigger field reload here if needed
                      }
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Write a Review'),
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
                              'Failed to load reviews',
                              style: const TextStyle(color: AppColors.error),
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
                        const Text(
                          'Recent Reviews',
                          style: TextStyle(
                            fontSize: 16,
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
