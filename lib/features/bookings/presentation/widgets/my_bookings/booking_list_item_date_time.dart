import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings/booking_list_item_info_badge.dart';

/// Date and time row widget displaying formatted date and time slot.
class BookingListItemDateTime extends StatelessWidget {
  final String formattedDate;
  final String formattedTimeSlot;

  const BookingListItemDateTime({
    super.key,
    required this.formattedDate,
    required this.formattedTimeSlot,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BookingListItemInfoBadge(
            icon: Icons.calendar_today,
            text: formattedDate,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: BookingListItemInfoBadge(
            icon: Icons.access_time,
            text: formattedTimeSlot,
            color: AppColors.success,
          ),
        ),
      ],
    );
  }
}
