import 'package:flutter/material.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/presentation/utils/booking_status_utils.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Premium status banner for booking details.
///
/// Displays a gradient banner with status icon and text.
class BookingStatusBanner extends StatelessWidget {
  final BookingStatus status;

  const BookingStatusBanner({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        gradient: BookingStatusUtils.getStatusGradient(status, isDark: isDark),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: isDark ? 0.15 : 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              BookingStatusUtils.getStatusIcon(status),
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            BookingStatusUtils.getStatusLabel(context, status).toUpperCase(),
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
