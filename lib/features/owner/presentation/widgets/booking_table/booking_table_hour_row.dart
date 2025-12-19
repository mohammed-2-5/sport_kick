import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/owner/presentation/cubit/booking_table/booking_table_state.dart';
import 'package:spo_kick/features/owner/presentation/utils/booking_table_helpers.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking_table/booking_cell.dart';

/// Hour row for booking table showing time slots across the week.
///
/// Displays a row with the hour label and 7 booking cells (one for each day).
class BookingTableHourRow extends StatelessWidget {
  final String hour;
  final BookingTableLoaded state;
  final Function(int dayIndex, String hour) onCellTap;

  const BookingTableHourRow({
    required this.hour,
    required this.state,
    required this.onCellTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Time label
        Container(
          width: 65,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.navyDeep.withValues(alpha: 0.03),
            border: Border(
              right: BorderSide(color: AppColors.border.withValues(alpha: 0.3)),
              bottom: BorderSide(
                color: AppColors.border.withValues(alpha: 0.15),
              ),
            ),
          ),
          child: Text(
            hour,
            style: AppTextStyles.labelSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),

        // Day cells for this hour
        ...List.generate(7, (dayIndex) {
          final booking = state.getBookingAt(dayIndex, hour);
          final businessHours = state.getBusinessHoursForDay(dayIndex);
          final isOpen = BookingTableHelpers.isHourOpen(hour, businessHours);
          final slotDate = state.weekStartDate.add(Duration(days: dayIndex));
          final isToday = BookingTableHelpers.isToday(slotDate);
          final isPast = _isSlotInPast(slotDate, hour);

          return BookingCell(
            booking: booking,
            isOpen: isOpen,
            isToday: isToday,
            isPast: isPast,
            hour: hour,
            dayIndex: dayIndex,
            onTap: () => onCellTap(dayIndex, hour),
          );
        }),
      ],
    );
  }

  /// Check if a time slot is in the past.
  bool _isSlotInPast(DateTime date, String hour) {
    final hourInt = int.parse(hour.split(':')[0]);
    final minuteInt = int.parse(hour.split(':')[1]);

    final slotDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      hourInt,
      minuteInt,
    );

    return slotDateTime.isBefore(DateTime.now());
  }
}
