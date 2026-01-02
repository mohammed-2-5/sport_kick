import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Field information section displaying name, location, and verified badge.
///
/// Shows the field name with optional verified badge, and location details
/// including city and field size.
class FieldCardInfo extends StatelessWidget {
  /// The name of the field
  final String fieldName;

  /// The city where the field is located
  final String city;

  /// The size of the field (e.g., "5v5", "7v7", "11v11")
  final String fieldSize;

  /// Whether the field is verified
  final bool isVerified;

  const FieldCardInfo({
    super.key,
    required this.fieldName,
    required this.city,
    required this.fieldSize,
    required this.isVerified,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name and Verified Badge
        Row(
          children: [
            Expanded(
              child: Text(
                fieldName,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isVerified) ...[
              const SizedBox(width: 8),
              _buildVerifiedBadge(context),
            ],
          ],
        ),

        const SizedBox(height: 4),

        // Location
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 14,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                '$city - $fieldSize',
                style: AppTextStyles.bodySmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds the verified badge with gradient background
  Widget _buildVerifiedBadge(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successColor = isDark ? AppColors.darkSuccess : AppColors.success;
    // Use onPrimary for content on colored gradients (white in both themes)
    final contentColor = colorScheme.onPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [successColor, successColor.withValues(alpha: 0.7)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: successColor.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified, size: 14, color: contentColor),
          const SizedBox(width: 4),
          Text(
            context.l10n.verified,
            style: AppTextStyles.labelSmall.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: contentColor,
            ),
          ),
        ],
      ),
    );
  }
}
