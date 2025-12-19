import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/reviews/domain/entities/review_entity.dart';
import 'package:spo_kick/features/reviews/presentation/widgets/rating/rating_stars.dart';

/// Widget for displaying a single review.
///
/// Shows user info, rating, comment, and timestamp.
class ReviewCard extends StatelessWidget {
  final ReviewEntity review;
  final bool showActions;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ReviewCard({
    required this.review,
    this.showActions = false,
    this.onEdit,
    this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with user info and rating
            Row(
              children: [
                // User avatar
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  backgroundImage: review.userAvatar != null
                      ? NetworkImage(review.userAvatar!)
                      : null,
                  child: review.userAvatar == null
                      ? Text(
                          review.userInitials,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),

                // User name and date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            review.userName ?? 'Anonymous',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (review.wasEdited) ...[
                            const SizedBox(width: 6),
                            Text(
                              '(edited)',
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        review.formattedDate,
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                // Rating and actions
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RatingStars(rating: review.ratingAsDouble, size: 16),
                    if (showActions) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (onEdit != null)
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18),
                              onPressed: onEdit,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              color: AppColors.primary,
                            ),
                          if (onDelete != null) ...[
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 18),
                              onPressed: onDelete,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              color: AppColors.error,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),

            // Review comment
            if (review.hasComment) ...[
              const SizedBox(height: 12),
              Text(
                review.comment!,
                style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
              ),
            ],

            // Recent badge
            if (review.isRecent) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Recent Review',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
