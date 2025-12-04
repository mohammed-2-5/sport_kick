import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/features/fields/presentation/constants/field_constants.dart';

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
                      return _buildPlaceholder();
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildPlaceholder();
                    },
                  )
                : _buildPlaceholder(),
          ),

          // Gradient Overlay
          Container(
            height: FieldConstants.fieldCardImageHeight + 20,
            decoration: const BoxDecoration(gradient: AppGradients.overlay),
          ),

          // Popular Badge
          if (isPopular) _buildPopularBadge(),
        ],
      ),
    );
  }

  /// Builds the placeholder widget shown when no image is available
  /// or when image is loading/failed
  Widget _buildPlaceholder() {
    return Container(
      height: FieldConstants.fieldCardImageHeight + 20,
      width: double.infinity,
      color: AppColors.surfaceVariant,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports_soccer,
            size: 48,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 8),
          Text(
            'No Image',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  /// Builds the popular/trending badge positioned at top-left
  Widget _buildPopularBadge() {
    return Positioned(
      top: 12,
      left: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
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
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.local_fire_department_rounded,
              size: 14,
              color: Colors.white,
            ),
            SizedBox(width: 4),
            Text(
              'TRENDING',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
