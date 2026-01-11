import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Badge displayed when a time slot is already booked.
///
/// Shows "Booked" label with error-colored styling.
class TimeSlotBookedBadge extends StatelessWidget {
  const TimeSlotBookedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final errorColor = isDark ? AppColors.darkError : AppColors.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: errorColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.block, size: 12, color: errorColor),
            const SizedBox(width: 4),
            Text(
              context.l10n.bookedLabel,
              style: AppTextStyles.labelSmall.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: errorColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
