import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/core/constants/app_shadows.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/constants/field_constants.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Field information section widget.
///
/// Displays:
/// - Field name
/// - Category
/// - Rating and reviews
/// - Price per hour
/// - Capacity/field size
/// - Surface type and indoor/outdoor chips
class FieldInfoSection extends StatelessWidget {
  final FieldEntity field;
  final dynamic category;

  const FieldInfoSection({super.key, required this.field, this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          Text(
            field.name,
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // Category
          if (category != null)
            Text(
              category.name,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),

          const SizedBox(height: FieldConstants.itemSpacing),

          // Rating and Reviews
          if (field.hasReviews)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        FieldConstants.ratingGradientStart,
                        FieldConstants.ratingGradientEnd,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        field.ratingDisplay,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${field.totalReviews})',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: FieldConstants.itemSpacing),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.info.withValues(alpha: 0.2),
                        AppColors.info.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: AppColors.info.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.bookmark_rounded,
                        color: AppColors.info,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${LocaleFormatters.formatNumber(context, field.totalBookings)} ${context.l10n.bookings}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.info,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

          const SizedBox(height: FieldConstants.standardPadding),

          // Price and Field Size
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: AppGradients.primary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: AppShadows.medium,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.attach_money_rounded,
                            color: Colors.white.withValues(alpha: 0.9),
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            context.l10n.ratePerHour,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${LocaleFormatters.formatPrice(context, amount: field.pricePerHour, currency: field.currency, decimalDigits: 0)}/${context.l10n.perHour}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: FieldConstants.itemSpacing),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.info.withValues(alpha: 0.2),
                        AppColors.info.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.info.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.people_outline_rounded,
                            color: AppColors.info,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            context.l10n.fieldSize,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.info,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        field.fieldSize,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.info,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: FieldConstants.itemSpacing),

          // Surface Type and Indoor/Outdoor
          Row(
            children: [
              if (field.surfaceType != null) ...[
                _buildInfoChip(
                  Icons.grass,
                  _localizedSurface(context, field.surfaceType!),
                  rawValue: field.surfaceType!,
                ),
                const SizedBox(width: FieldConstants.chipSpacing),
              ],
              _buildInfoChip(
                field.isIndoor ? Icons.home : Icons.wb_sunny,
                field.isIndoor ? context.l10n.indoor : context.l10n.outdoor,
                rawValue: field.isIndoor ? 'indoor' : 'outdoor',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, {String? rawValue}) {
    // Determine gradient based on label type
    final compare = (rawValue ?? label).toLowerCase();
    LinearGradient chipGradient;
    if (compare.contains('grass') || compare.contains('natural')) {
      chipGradient = const LinearGradient(
        colors: [
          FieldConstants.grassGradientStart,
          FieldConstants.grassGradientEnd,
        ],
      );
    } else if (compare.contains('indoor')) {
      chipGradient = const LinearGradient(
        colors: [
          FieldConstants.indoorGradientStart,
          FieldConstants.indoorGradientEnd,
        ],
      );
    } else if (compare.contains('outdoor')) {
      chipGradient = const LinearGradient(
        colors: [
          FieldConstants.outdoorGradientStart,
          FieldConstants.outdoorGradientEnd,
        ],
      );
    } else {
      chipGradient = const LinearGradient(
        colors: [
          FieldConstants.defaultChipGradientStart,
          FieldConstants.defaultChipGradientEnd,
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: chipGradient,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: chipGradient.colors.first.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _localizedSurface(BuildContext context, String surface) {
    final lower = surface.toLowerCase();
    if (lower.contains('natural') || lower.contains('grass')) {
      return context.l10n.surfaceGrass;
    }
    if (lower.contains('turf') || lower.contains('artificial')) {
      return context.l10n.surfaceTurf;
    }
    return surface;
  }
}
