import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings/booking_list_item_info_badge.dart';

/// Date and time row widget displaying formatted date and time slot.
class BookingListItemDateTime extends StatelessWidget {
  final String formattedDate;
  final String formattedTimeSlot;
  final DateTime? date;
  final String? startTime;
  final String? endTime;

  const BookingListItemDateTime({
    super.key,
    required this.formattedDate,
    required this.formattedTimeSlot,
    this.date,
    this.startTime,
    this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    final dateText = date != null
        ? LocaleFormatters.formatDate(context, date!)
        : formattedDate;
    final timeText = startTime != null && endTime != null
        ? LocaleFormatters.formatTimeRange(
            context,
            startTime: startTime!,
            endTime: endTime!,
            baseDate: date,
          )
        : formattedTimeSlot;

    return Row(
      children: [
        Expanded(
          child: BookingListItemInfoBadge(
            icon: Icons.calendar_today,
            text: dateText,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: BookingListItemInfoBadge(
            icon: Icons.access_time,
            text: timeText,
            color: AppColors.success,
          ),
        ),
      ],
    );
  }
}
