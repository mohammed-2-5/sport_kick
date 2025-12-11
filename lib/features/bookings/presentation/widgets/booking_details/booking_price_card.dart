import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details/booking_price_row.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details/booking_total_row.dart';

/// Premium card displaying price breakdown.
///
/// Shows:
/// - Hourly rate calculation
/// - Duration
/// - Total price with accent styling
class BookingPriceCard extends StatelessWidget {
  final BookingEntity booking;

  const BookingPriceCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final hourlyRate = booking.totalPrice / booking.durationInHours;

    return PremiumCard(
      accentColor: AppColors.accentCyan,
      showAccentBorder: true,
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
                  Icons.receipt_long,
                  color: AppColors.accentCyan,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                BookingConstants.priceBreakdownLabel,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: BookingConstants.standardPadding),
          BookingPriceRow(
            label:
                '${booking.durationInHours} ${booking.durationInHours > 1 ? BookingConstants.hoursSuffix : BookingConstants.hourSuffix}',
            value: '${hourlyRate.toStringAsFixed(0)} ${booking.currency}/hr',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: AppColors.border),
          ),
          BookingTotalRow(formattedPrice: booking.formattedPrice),
        ],
      ),
    );
  }
}
