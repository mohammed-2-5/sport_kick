import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Displays the field image for booking details.
///
/// Shows a hero-style image with gradient overlay and fallback icon.
class BookingFieldImage extends StatelessWidget {
  final String imageUrl;
  final double height;

  const BookingFieldImage({
    super.key,
    required this.imageUrl,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppColors.navyDeep,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.accentCyan,
                  strokeWidth: 2,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: AppColors.navyDeep,
              child: const Center(
                child: Icon(
                  Icons.sports_soccer,
                  color: AppColors.accentCyan,
                  size: 64,
                ),
              ),
            ),
          ),
          // Bottom gradient for better text contrast
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 80,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
