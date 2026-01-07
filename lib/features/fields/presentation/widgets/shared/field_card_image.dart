import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/features/fields/presentation/constants/field_constants.dart';
import 'package:spo_kick/features/fields/presentation/widgets/shared/field_card_image_placeholder.dart';
import 'package:spo_kick/features/fields/presentation/widgets/shared/field_card_popular_badge.dart';

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
          Hero(
            tag: 'field_$fieldId',
            child: hasImages
                ? Image.network(
                    mainImageUrl!,
                    height: FieldConstants.fieldCardImageHeight + 20,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const FieldCardImagePlaceholder(),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const FieldCardImagePlaceholder();
                    },
                  )
                : const FieldCardImagePlaceholder(),
          ),
          Container(
            height: FieldConstants.fieldCardImageHeight + 20,
            decoration: const BoxDecoration(gradient: AppGradients.overlay),
          ),
          if (isPopular) const FieldCardPopularBadge(),
        ],
      ),
    );
  }
}
