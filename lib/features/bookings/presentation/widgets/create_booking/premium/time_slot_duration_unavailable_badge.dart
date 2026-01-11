import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Badge displayed when a slot cannot fit the selected duration.
///
/// Shows warning-colored badge indicating duration unavailability.
class TimeSlotDurationUnavailableBadge extends StatelessWidget {
  const TimeSlotDurationUnavailableBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final warningColor = isDark ? AppColors.darkWarning : AppColors.warning;
    return Container(
      constraints: const BoxConstraints(maxWidth: 90),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: warningColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.timer_off_outlined, size: 12, color: warningColor),
            const SizedBox(width: 2),
            Flexible(
              child: Text(
                context.l10n.durationUnavailable,
                style: AppTextStyles.labelSmall.copyWith(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: warningColor,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
