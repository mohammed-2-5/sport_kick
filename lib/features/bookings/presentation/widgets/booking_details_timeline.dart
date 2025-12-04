import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';

/// Timeline card widget for booking details page.
///
/// Displays:
/// - Booking creation timestamp
/// - Confirmation timestamp (if applicable)
/// - Cancellation timestamp (if applicable)
class BookingDetailsTimeline extends StatelessWidget {
  final BookingEntity booking;

  const BookingDetailsTimeline({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(BookingConstants.standardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(BookingConstants.borderRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking Timeline',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: BookingConstants.standardPadding),

          // Created
          _buildTimelineItem(
            icon: Icons.add_circle_outline,
            title: 'Booking Created',
            time: _formatDateTime(booking.createdAt),
            isCompleted: true,
          ),

          // Confirmed (if applicable)
          if (booking.confirmedAt != null) ...[
            const SizedBox(height: BookingConstants.itemSpacing),
            _buildTimelineItem(
              icon: Icons.check_circle_outline,
              title: BookingConstants.confirmedLabel,
              time: _formatDateTime(booking.confirmedAt!),
              isCompleted: true,
            ),
          ],

          // Canceled (if applicable)
          if (booking.canceledAt != null) ...[
            const SizedBox(height: BookingConstants.itemSpacing),
            _buildTimelineItem(
              icon: Icons.cancel_outlined,
              title: BookingConstants.cancelledLabel,
              time: _formatDateTime(booking.canceledAt!),
              isCompleted: true,
              isError: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required String title,
    required String time,
    required bool isCompleted,
    bool isError = false,
  }) {
    final color = isError
        ? AppColors.error
        : isCompleted
        ? AppColors.success
        : AppColors.textSecondary;

    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: BookingConstants.itemSpacing),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final month = months[dateTime.month - 1];
    final day = dateTime.day;
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$month $day, $year at $hour:$minute';
  }
}
