import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details/booking_duration_badge.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/shared/booking_info_row.dart';

/// Premium card displaying booking date and time information.
///
/// Shows:
/// - Date with calendar icon
/// - Time slot with clock icon
/// - Duration badge
class BookingDateTimeInfoCard extends StatelessWidget {
  final BookingEntity booking;

  const BookingDateTimeInfoCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Date & Time',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: BookingConstants.standardPadding),
          BookingInfoRow(
            icon: Icons.calendar_today,
            title: BookingConstants.dateLabel,
            value: booking.formattedDate,
            iconColor: AppColors.primary,
          ),
          const SizedBox(height: BookingConstants.standardPadding),
          BookingInfoRow(
            icon: Icons.access_time,
            title: 'Time Slot',
            value: booking.formattedTimeSlot,
            iconColor: AppColors.accentCyan,
            trailing: BookingDurationBadge(
              durationInHours: booking.durationInHours,
            ),
          ),
        ],
      ),
    );
  }
}
