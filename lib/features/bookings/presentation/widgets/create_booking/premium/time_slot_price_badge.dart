import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';

/// Displays the price for an available time slot.
///
/// Shows price with success-colored badge when available.
class TimeSlotPriceBadge extends StatelessWidget {
  final TimeSlotEntity slot;
  final bool isSelected;

  const TimeSlotPriceBadge({
    super.key,
    required this.slot,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final successColor = isDark ? AppColors.darkSuccess : AppColors.success;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? colorScheme.onPrimary.withValues(alpha: 0.2)
            : successColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        LocaleFormatters.formatPrice(
          context,
          amount: slot.price,
          currency: slot.currency,
          decimalDigits: 0,
        ),
        style: AppTextStyles.labelSmall.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isSelected ? colorScheme.onPrimary : successColor,
        ),
      ),
    );
  }
}
