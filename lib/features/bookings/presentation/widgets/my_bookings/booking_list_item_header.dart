import 'package:flutter/material.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/utils/booking_status_utils.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Status header widget with colored gradient background.
///
/// Displays booking status with icon and booking ID badge.
class BookingListItemHeader extends StatelessWidget {
  final BookingStatus status;
  final String bookingId;

  const BookingListItemHeader({
    super.key,
    required this.status,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = BookingStatusUtils.getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: BookingConstants.standardPadding,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        gradient: BookingStatusUtils.getStatusGradient(status),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              BookingStatusUtils.getStatusIcon(status),
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            BookingStatusUtils.getStatusLabel(context, status).toUpperCase(),
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 1.0,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '#${bookingId.substring(0, 6).toUpperCase()}',
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: statusColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
