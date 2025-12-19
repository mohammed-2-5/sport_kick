import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/owner/presentation/cubit/booking_table/booking_table_state.dart';
import 'package:spo_kick/features/owner/presentation/utils/booking_table_helpers.dart';

/// Header row for booking table showing day names and dates.
///
/// Displays 7 columns (Sat-Fri) with day names and dates.
/// Highlights today's column with gold accent color.
class BookingTableHeaderRow extends StatelessWidget {
  final BookingTableLoaded state;

  const BookingTableHeaderRow({required this.state, super.key});

  /// Day names for header (Sat-Fri).
  static const _dayNames = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Time column header
        Container(
          width: 65,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.navyDeep.withValues(alpha: 0.05),
            border: Border(
              right: BorderSide(color: AppColors.border.withValues(alpha: 0.3)),
            ),
          ),
          child: Text(
            'Time',
            style: AppTextStyles.labelSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),

        // Day columns
        ...List.generate(7, (dayIndex) {
          final date = state.weekStartDate.add(Duration(days: dayIndex));
          final isToday = BookingTableHelpers.isToday(date);
          final businessHours = state.getBusinessHoursForDay(dayIndex);
          final isClosed = businessHours == null || !businessHours.isOpen;

          return _DayColumnHeader(
            dayName: _dayNames[dayIndex],
            date: date,
            isToday: isToday,
            isClosed: isClosed,
          );
        }),
      ],
    );
  }
}

/// Individual day column header.
class _DayColumnHeader extends StatelessWidget {
  final String dayName;
  final DateTime date;
  final bool isToday;
  final bool isClosed;

  const _DayColumnHeader({
    required this.dayName,
    required this.date,
    required this.isToday,
    required this.isClosed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 56,
      decoration: BoxDecoration(
        color: isToday
            ? AppColors.goldAccent.withValues(alpha: 0.1)
            : isClosed
            ? AppColors.textSecondary.withValues(alpha: 0.05)
            : Colors.transparent,
        border: Border(
          right: BorderSide(color: AppColors.border.withValues(alpha: 0.3)),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dayName,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w700,
              color: isToday ? AppColors.goldAccent : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: isToday
                ? BoxDecoration(
                    color: AppColors.goldAccent,
                    borderRadius: BorderRadius.circular(10),
                  )
                : null,
            child: Text(
              '${date.day}',
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: isToday ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
