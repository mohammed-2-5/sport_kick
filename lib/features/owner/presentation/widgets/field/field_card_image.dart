import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/core/constants/app_shadows.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Image header for the field card.
class FieldCardImage extends StatelessWidget {
  final FieldEntity field;

  const FieldCardImage({required this.field, super.key});

  @override
  Widget build(BuildContext context) {
    if (!field.hasImages) {
      return _buildImagePlaceholder(context);
    }

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(18),
        topRight: Radius.circular(18),
      ),
      child: Stack(
        children: [
          Image.network(
            field.mainImage!,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (ctx, error, stackTrace) {
              return _buildImagePlaceholder(ctx);
            },
          ),
          Container(
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.3),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          if (field.isVerified)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: AppGradients.success,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppShadows.small,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.verified_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      context.l10n.verifiedBadge,
                      style: AppTextStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
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

  Widget _buildImagePlaceholder(BuildContext context) {
    return Container(
      height: 150,
      decoration: const BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: Center(
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
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
