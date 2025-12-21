import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';

/// Glassmorphism floating header that appears on scroll.
///
/// Features:
/// - Backdrop blur effect
/// - Fade-in animation based on scroll
/// - Field name and rating display
/// - Back and share buttons
class PremiumFieldFloatingHeader extends StatelessWidget {
  final String fieldName;
  final double rating;
  final int reviewCount;
  final double opacity;
  final VoidCallback onBackPressed;
  final VoidCallback onSharePressed;
  final VoidCallback onFavoritePressed;
  final bool isFavorite;

  const PremiumFieldFloatingHeader({
    super.key,
    required this.fieldName,
    required this.rating,
    required this.reviewCount,
    required this.opacity,
    required this.onBackPressed,
    required this.onSharePressed,
    required this.onFavoritePressed,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: opacity,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.only(
              top: 40,
              left: 8,
              right: 8,
              bottom: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Back Button
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: onBackPressed,
                  color: AppColors.textPrimary,
                ),

                // Field Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        fieldName,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${LocaleFormatters.formatNumber(context, rating, decimalDigits: 1)} (${context.l10n.reviewsSummary(reviewCount)})',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Favorite Button
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : AppColors.textPrimary,
                  ),
                  onPressed: onFavoritePressed,
                ),

                // Share Button
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: onSharePressed,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
