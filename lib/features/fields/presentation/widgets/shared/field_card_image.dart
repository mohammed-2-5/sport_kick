import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/features/fields/presentation/constants/field_constants.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Image section of the field card with hero animation, gradient overlay,
/// and optional popular badge.
///
/// Displays the main field image with loading/error states, applies a gradient
/// overlay for better text visibility, and shows a "TRENDING" badge if the
/// field is marked as popular.
class FieldCardImage extends StatelessWidget {
  /// The unique identifier for the field (used for Hero animation)
  final String fieldId;

  /// The URL of the main field image (nullable)
  final String? mainImageUrl;

  /// Whether the field has images available
  final bool hasImages;

  /// Whether to show the popular/trending badge
  final bool isPopular;

  const FieldCardImage({
    super.key,
    required this.fieldId,
    required this.mainImageUrl,
    required this.hasImages,
    required this.isPopular,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(FieldConstants.cardBorderRadius + 8),
      ),
      child: Stack(
        children: [
          // Image with Hero Animation
          Hero(
            tag: 'field_$fieldId',
            child: hasImages
                ? Image.network(
                    mainImageUrl!,
                    height: FieldConstants.fieldCardImageHeight + 20,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholder(context);
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildPlaceholder(context);
                    },
                  )
                : _buildPlaceholder(context),
          ),

          // Gradient Overlay
          Container(
            height: FieldConstants.fieldCardImageHeight + 20,
            decoration: const BoxDecoration(gradient: AppGradients.overlay),
          ),

          // Popular Badge
          if (isPopular) _buildPopularBadge(context),
        ],
      ),
    );
  }

  /// Builds the placeholder widget shown when no image is available
  /// or when image is loading/failed
  Widget _buildPlaceholder(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: FieldConstants.fieldCardImageHeight + 20,
      width: double.infinity,
      color: colorScheme.surfaceContainerHighest,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports_soccer,
            size: 48,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.noImage,
            style: AppTextStyles.bodySmall.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the popular/trending badge positioned at top-left
  Widget _buildPopularBadge(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final errorColor = isDark ? AppColors.darkError : AppColors.error;
    // Use onPrimary for content on colored gradients (white in both themes)
    final contentColor = colorScheme.onPrimary;

    return Positioned(
      top: 12,
      left: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              errorColor,
              isDark ? AppColors.darkWarning : const Color(0xFFFF8E53),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: errorColor.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.local_fire_department_rounded,
              size: 14,
              color: contentColor,
            ),
            const SizedBox(width: 4),
            Text(
              context.l10n.trending,
              style: AppTextStyles.labelSmall.copyWith(
                color: contentColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
