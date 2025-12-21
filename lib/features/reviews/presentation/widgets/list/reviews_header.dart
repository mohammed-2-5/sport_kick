import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/reviews/presentation/widgets/rating/rating_stars.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

class ReviewsHeader extends StatelessWidget {
  final String fieldName;
  final double? averageRating;
  final int? totalReviews;

  const ReviewsHeader({
    super.key,
    required this.fieldName,
    this.averageRating,
    this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fieldName,
            style: AppTextStyles.appBarTitle.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          if (averageRating != null && totalReviews != null) ...[
            Row(
              children: [
                RatingStars(rating: averageRating!, size: 24),
                const SizedBox(width: 12),
                Text(
                  LocaleFormatters.formatNumber(
                    context,
                    averageRating!,
                    decimalDigits: 1,
                  ),
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${context.l10n.reviewsSummary(totalReviews!)})',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ] else ...[
            Text(
              context.l10n.noRatingsYet,
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[600]),
            ),
          ],
        ],
      ),
    );
  }
}
