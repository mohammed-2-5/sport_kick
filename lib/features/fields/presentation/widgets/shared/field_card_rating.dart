import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';

/// Rating display widget for field card.
///
/// Shows the field's rating with star icon and review count if reviews exist,
/// or displays a "New" badge if the field has no reviews yet.
class FieldCardRating extends StatelessWidget {
  /// Whether the field has any reviews
  final bool hasReviews;

  /// The formatted rating value (e.g., "4.5")
  final String ratingDisplay;

  /// The total number of reviews
  final int totalReviews;

  const FieldCardRating({
    super.key,
    required this.hasReviews,
    required this.ratingDisplay,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    if (hasReviews) {
      return _buildRatingBadge(context);
    } else {
      return _buildNewBadge(context);
    }
  }

  /// Builds the rating badge with gradient background when reviews exist
  Widget _buildRatingBadge(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final warningColor = isDark ? AppColors.darkWarning : AppColors.warning;
    // Use onPrimary for content on colored gradients (white in both themes)
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

  /// Builds the "New" badge when no reviews exist
  Widget _buildNewBadge(BuildContext context) {
    final colorScheme = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_outline_rounded,
            size: 14,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          const _NewLabel(),
        ],
      ),
    );
  }
}

class _NewLabel extends StatelessWidget {
  const _NewLabel();

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;

    return Text(
      context.l10n.newLabel,
      style: AppTextStyles.labelSmall.copyWith(
        color: colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
