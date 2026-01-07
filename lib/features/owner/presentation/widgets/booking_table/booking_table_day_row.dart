import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/owner/presentation/cubit/booking_table/booking_table_state.dart';
import 'package:spo_kick/features/owner/presentation/utils/booking_table_helpers.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking_table/booking_cell.dart';

/// Day row for booking table showing time slots across for a specific day.
///
/// Displays a row with the day label and time slot cells for that day.
class BookingTableDayRow extends StatelessWidget {
  final int dayIndex;
  final BookingTableLoaded state;
  final Function(int dayIndex, String hour) onCellTap;

  /// Day names for display.
  static const _dayNames = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

  const BookingTableDayRow({
    required this.dayIndex,
    required this.state,
    required this.onCellTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final hours = BookingTableHelpers.generateWorkingHours(state.businessHours);
    final date = state.weekStartDate.add(Duration(days: dayIndex));
    final isToday = BookingTableHelpers.isToday(date);
    final businessHours = state.getBusinessHoursForDay(dayIndex);
    final isClosed = businessHours == null || !businessHours.isOpen;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        // Day label (first column)
        Container(
          width: 75,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isToday
                ? colorScheme.tertiary.withValues(alpha: 0.1)
                : isClosed
                ? colorScheme.onSurfaceVariant.withValues(alpha: 0.05)
                : colorScheme.primary.withValues(alpha: 0.03),
            border: Border(
              right: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
              bottom: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.15),
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _dayNames[dayIndex],
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isToday ? colorScheme.tertiary : colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: isToday
                    ? BoxDecoration(
                        color: colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(10),
                      )
                    : null,
                child: Text(
                  '${date.day}',
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isToday
                        ? Colors.white
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Time cells for this day
        ...hours.map((hour) {
          final booking = state.getBookingAt(dayIndex, hour);
          final isOpen = BookingTableHelpers.isHourOpen(hour, businessHours);
          final slotDate = state.weekStartDate.add(Duration(days: dayIndex));
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
