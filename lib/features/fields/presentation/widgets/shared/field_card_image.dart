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
    return Container(
      height: FieldConstants.fieldCardImageHeight + 20,
      width: double.infinity,
      color: AppColors.surfaceVariant,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.sports_soccer,
            size: 48,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.noImage,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the popular/trending badge positioned at top-left
  Widget _buildPopularBadge(BuildContext context) {
    return Positioned(
      top: 12,
      left: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.local_fire_department_rounded,
              size: 14,
              color: Colors.white,
            ),
            const SizedBox(width: 4),
            Text(
              context.l10n.trending,
              style: AppTextStyles.labelSmall.copyWith(
                color: Colors.white,
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
