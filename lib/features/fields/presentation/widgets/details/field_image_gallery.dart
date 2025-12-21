import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/features/fields/presentation/constants/field_constants.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/field_badges.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/image_placeholder.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Image gallery widget for field details page.
///
/// Displays a PageView of field images with:
/// - Hero animation for the first image
/// - Image counter badge
/// - Premium gradient overlay
/// - Verified and trending badges
class FieldImageGallery extends StatefulWidget {
  final List<String> images;
  final String fieldId;
  final bool isVerified;
  final bool isPopular;

  const FieldImageGallery({
    super.key,
    required this.images,
    required this.fieldId,
    required this.isVerified,
    required this.isPopular,
  });

  @override
  State<FieldImageGallery> createState() => _FieldImageGalleryState();
}

class _FieldImageGalleryState extends State<FieldImageGallery> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasImages = widget.images.isNotEmpty;

    return SizedBox(
      height: FieldConstants.imageGalleryHeight,
      child: hasImages ? _buildImageGallery() : const ImagePlaceholder(),
    );
  }

  Widget _buildImageGallery() {
    return Stack(
      children: [
        // Image Gallery with Hero Animation
        PageView.builder(
          controller: _pageController,
          itemCount: widget.images.length,
          onPageChanged: (index) {
            setState(() {
              _currentImageIndex = index;
            });
          },
          itemBuilder: (context, index) {
            final imageWidget = Image.network(
              widget.images[index],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const ImagePlaceholder();
              },
            );

            // Wrap first image with Hero for transition from list
            if (index == 0) {
              return Hero(tag: 'field_${widget.fieldId}', child: imageWidget);
            }
            return imageWidget;
          },
        ),

        // Premium Gradient Overlay
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(gradient: AppGradients.overlay),
          ),
        ),

        // Image Counter
        if (widget.images.length > 1)
          Positioned(
            bottom: FieldConstants.standardPadding,
            right: FieldConstants.standardPadding,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_currentImageIndex + 1}/${widget.images.length}',
                style: AppTextStyles.labelLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

        // Badges
        Positioned(
          top: 60,
          left: FieldConstants.standardPadding,
          child: FieldBadges(
            isVerified: widget.isVerified,
            isPopular: widget.isPopular,
          ),
        ),
      ],
    );
  }
}
