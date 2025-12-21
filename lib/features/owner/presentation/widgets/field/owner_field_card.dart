import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/core/constants/app_shadows.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/presentation/widgets/field/field_action_buttons.dart';
import 'package:spo_kick/features/owner/presentation/widgets/field/field_card_image.dart';
import 'package:spo_kick/features/owner/presentation/widgets/field/field_stat_chip.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Owner Field Card widget for managing fields
///
/// Displays field information with edit and delete actions
class OwnerFieldCard extends StatelessWidget {
  final FieldEntity field;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const OwnerFieldCard({
    super.key,
    required this.field,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, AppColors.primary],
          stops: [0.99, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 2,
        ),
        boxShadow: AppShadows.medium,
      ),
      child: Column(
        children: [
          // Image Header
          FieldCardImage(field: field),

          // Field Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  field.name,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Location & Size
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      field.city,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.straighten_rounded,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      field.fieldSize,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Stats Row
                Row(
                  children: [
                    FieldStatChip(
                      icon: Icons.star_rounded,
                      text: field.hasReviews
                          ? field.ratingDisplay
                          : context.l10n.newLabel,
                      color: const Color(0xFFFFA726),
                    ),
                    const SizedBox(width: 8),
                    FieldStatChip(
                      icon: Icons.bookmark_rounded,
                      text: context.l10n.bookingsCount(
                        field.totalBookings,
                        LocaleFormatters.formatNumber(
                          context,
                          field.totalBookings,
                        ),
                      ),
                      color: const Color(0xFF42A5F5),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppGradients.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        field.formattedPrice,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Action Buttons
                FieldActionButtons(onEdit: onEdit, onDelete: onDelete),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
