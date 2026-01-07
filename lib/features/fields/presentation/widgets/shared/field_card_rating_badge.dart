import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Rating badge with gradient background when reviews exist.
class FieldCardRatingBadge extends StatelessWidget {
  /// The formatted rating value (e.g., "4.5")
  final String ratingDisplay;

  /// The total number of reviews
  final int totalReviews;

  const FieldCardRatingBadge({
    super.key,
    required this.ratingDisplay,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final warningColor = isDark ? AppColors.darkWarning : AppColors.warning;
    final contentColor = colorScheme.onPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [warningColor, warningColor.withValues(alpha: 0.8)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: warningColor.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 16, color: contentColor),
          const SizedBox(width: 4),
          Text(
            ratingDisplay,
            style: AppTextStyles.labelMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: contentColor,
            ),
          ),
          const SizedBox(width: 3),
          Text(
            '(${LocaleFormatters.formatNumber(context, totalReviews)})',
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 11,
              color: contentColor.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}
