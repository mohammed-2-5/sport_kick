import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details/booking_timeline_events.dart';

/// Premium card displaying the booking timeline.
///
/// Shows chronological events:
/// - Booking created
/// - Booking confirmed (if applicable)
/// - Booking canceled (if applicable)
class BookingTimelineCard extends StatelessWidget {
  final BookingEntity booking;

  const BookingTimelineCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accentCyan.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.timeline,
                  color: AppColors.accentCyan,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Booking Timeline',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: BookingConstants.standardPadding),
          BookingTimelineEvents(booking: booking),
        ],
      ),
    );
  }
}
