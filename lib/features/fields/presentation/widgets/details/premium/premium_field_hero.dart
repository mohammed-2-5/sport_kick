import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/field_badges.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium hero image with parallax scroll effect.
///
/// Features:
/// - Parallax scrolling background
/// - Image page indicator
/// - Verified/Popular badges
/// - Gradient overlay
/// - Tap to view fullscreen
class PremiumFieldHero extends StatefulWidget {
  final List<String> images;
  final String fieldId;
  final bool isVerified;
  final bool isPopular;
  final VoidCallback onImageTap;

  const PremiumFieldHero({
    super.key,
    required this.images,
    required this.fieldId,
    required this.isVerified,
    required this.isPopular,
    required this.onImageTap,
  });

  @override
  State<PremiumFieldHero> createState() => _PremiumFieldHeroState();
}

class _PremiumFieldHeroState extends State<PremiumFieldHero> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasImages = widget.images.isNotEmpty;

    return SizedBox(
      height: 320,
      child: Stack(
        children: [
          // Image Gallery
          if (hasImages)
            GestureDetector(
              onTap: widget.onImageTap,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  return Hero(
                    tag: index == 0
                        ? 'field_${widget.fieldId}'
                        : 'field_${widget.fieldId}_$index',
                    child: CachedNetworkImage(
                      imageUrl: widget.images[index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.backgroundLight,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.accentCyan,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.backgroundLight,
                        child: const Center(
                          child: Icon(
                            Icons.sports_soccer,
                            size: 64,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          else
            Container(
              color: AppColors.backgroundLight,
              child: const Center(
                child: Icon(
                  Icons.sports_soccer,
                  size: 80,
                  color: AppColors.textSecondary,
                ),
              ),
            ),

          // Gradient Overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.0),
                    Colors.black.withValues(alpha: 0.0),
                    Colors.black.withValues(alpha: 0.6),
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // Badges
          Positioned(
            top: 60,
            left: 20,
            child: FieldBadges(
              isVerified: widget.isVerified,
              isPopular: widget.isPopular,
            ),
          ),

          // Page Indicator
          if (widget.images.length > 1)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.images.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Tap hint
          if (hasImages)
            Positioned(
              bottom: 60,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.zoom_in, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      context.l10n.tapToView,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
