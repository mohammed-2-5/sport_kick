import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Premium field information card.
///
/// Features:
/// - Field name with premium typography
/// - Rating badge with gradient
/// - Price and capacity cards
/// - Surface type and indoor/outdoor chips
/// - Booking count badge
class PremiumFieldInfoCard extends StatelessWidget {
  final FieldEntity field;
  final dynamic category;

  const PremiumFieldInfoCard({super.key, required this.field, this.category});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Field Name
          Text(
            field.name,
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 8),

          // Category
          if (category != null)
            Text(
              category.name,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.accentCyan,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),

          const SizedBox(height: 20),

          // Rating and Bookings
          if (field.hasReviews)
            Row(
              children: [
                // Rating Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.orange, Colors.deepOrange],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        field.ratingDisplay,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${LocaleFormatters.formatNumber(context, field.totalReviews)})',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Bookings Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentCyan.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: AppColors.accentCyan.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.bookmark_rounded,
                        color: AppColors.accentCyan,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${LocaleFormatters.formatNumber(context, field.totalBookings)} ${context.l10n.bookings}',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.accentCyan,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

          const SizedBox(height: 24),

          // Price and Capacity Cards
          Row(
            children: [
              // Price Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.accentCyan, AppColors.accentCyanDark],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentCyan.withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
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
                            style: AppTextStyles.labelSmall.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${LocaleFormatters.formatPrice(context, amount: field.pricePerHour, currency: field.currency, decimalDigits: 0)}/${context.l10n.perHour}',
                        style: AppTextStyles.headlineSmall.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Capacity Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.accentCyan.withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.people_outline_rounded,
                            color: AppColors.accentCyan,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            context.l10n.fieldSize,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.accentCyan,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        field.fieldSize,
                        style: AppTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppColors.accentCyan,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Surface Type and Indoor/Outdoor Chips
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              if (field.surfaceType != null)
                _buildInfoChip(
                  Icons.grass,
                  field.surfaceType!,
                  AppColors.success,
                ),
              _buildInfoChip(
                field.isIndoor ? Icons.home : Icons.wb_sunny,
                field.isIndoor ? 'Indoor' : 'Outdoor',
                field.isIndoor ? AppColors.navyDeep : Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
