import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/next_day_badge.dart';

/// Displays the time range for a time slot.
///
/// Shows start to end time with optional next day badge.
class TimeSlotTimeDisplay extends StatelessWidget {
  final TimeSlotEntity slot;
  final bool isSelected;
  final bool isAvailable;

  const TimeSlotTimeDisplay({
    super.key,
    required this.slot,
    required this.isSelected,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LocaleFormatters.formatTimeRange(
              context,
              startTime: slot.startTime,
              endTime: slot.endTime,
              isEndNextDay: slot.isNextDay,
            ),
            style: AppTextStyles.labelLarge.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isSelected
                  ? colorScheme.onPrimary
                  : isAvailable
                  ? colorScheme.onSurface
                  : colorScheme.onSurfaceVariant,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          if (slot.isNextDay) ...[
            const SizedBox(width: 4),
            const NextDayBadge(),
          ],
        ],
      ),
    );
  }
}
