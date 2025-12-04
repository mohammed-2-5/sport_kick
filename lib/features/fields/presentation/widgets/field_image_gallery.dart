import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/features/fields/presentation/constants/field_constants.dart';

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
      child: hasImages ? _buildImageGallery() : _buildImagePlaceholder(),
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
                return _buildImagePlaceholder();
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
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

        // Badges
        Positioned(
          top: 60,
          left: FieldConstants.standardPadding,
          child: _buildBadges(),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports_soccer, size: 64, color: AppColors.textSecondary),
            SizedBox(height: FieldConstants.standardPadding),
            Text(
              'No Images Available',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadges() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isVerified)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: AppColors.success.withValues(alpha: 0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_rounded, size: 18, color: Colors.white),
                SizedBox(width: 6),
                Text(
                  'Verified Field',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        if (widget.isPopular) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.local_fire_department_rounded,
                  size: 18,
                  color: Colors.white,
                ),
                SizedBox(width: 6),
                Text(
                  'TRENDING',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
