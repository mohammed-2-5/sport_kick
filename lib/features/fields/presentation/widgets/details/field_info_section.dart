import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/core/constants/app_shadows.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/sport_category_entity.dart';
import 'package:spo_kick/features/fields/presentation/constants/field_constants.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/sport_category_localizer.dart';

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
  final SportCategoryEntity? category;

  const FieldInfoSection({super.key, required this.field, this.category});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final infoColor = isDark ? AppColors.darkInfo : AppColors.info;

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
              category!.getLocalizedName(context),
              style: AppTextStyles.titleMedium.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),

          const SizedBox(height: FieldConstants.itemSpacing),

          // Rating and Reviews
          if (field.hasReviews)
            Row(
              children: [
                Builder(
                  builder: (context) {
                    final warningColor = isDark
                        ? AppColors.darkWarning
                        : AppColors.warning;
                    // Use onPrimary for content on colored gradients (white in both themes)
                    final contentColor = colorScheme.onPrimary;

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            warningColor,
                            warningColor.withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: warningColor.withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: contentColor,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            field.ratingDisplay,
                            style: AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: contentColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${field.totalReviews})',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: contentColor.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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
                        infoColor.withValues(alpha: 0.2),
                        infoColor.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: infoColor.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bookmark_rounded, color: infoColor, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        '${LocaleFormatters.formatNumber(context, field.totalBookings)} ${context.l10n.bookings}',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: infoColor,
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
                child: Builder(
                  builder: (context) {
                    // Use onPrimary for content on primary gradient (white in both themes)
                    final contentColor = colorScheme.onPrimary;
                    return Container(
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
                                color: contentColor.withValues(alpha: 0.9),
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                context.l10n.ratePerHour,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: contentColor.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${LocaleFormatters.formatPrice(context, amount: field.pricePerHour, currency: field.currency, decimalDigits: 0)}/${context.l10n.perHour}',
                            style: AppTextStyles.headlineSmall.copyWith(
                              fontWeight: FontWeight.bold,
                              color: contentColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: FieldConstants.itemSpacing),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        infoColor.withValues(alpha: 0.2),
                        infoColor.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: infoColor.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.people_outline_rounded,
                            color: infoColor,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            context.l10n.fieldSize,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: infoColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        field.fieldSize,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: infoColor,
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
                  context,
                  Icons.grass,
                  _localizedSurface(context, field.surfaceType!),
                  rawValue: field.surfaceType!,
                ),
                const SizedBox(width: FieldConstants.chipSpacing),
              ],
              _buildInfoChip(
                context,
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

  Widget _buildInfoChip(
    BuildContext context,
    IconData icon,
    String label, {
    String? rawValue,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    // Use onPrimary for content on colored gradients (white in both themes)
    final contentColor = colorScheme.onPrimary;

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
          Icon(icon, size: 16, color: contentColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.labelLarge.copyWith(
              color: contentColor,
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
