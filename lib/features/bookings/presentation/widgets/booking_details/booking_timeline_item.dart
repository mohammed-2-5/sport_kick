import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// A single timeline item for booking history.
///
/// Displays an event in the booking timeline with:
/// - Status icon
/// - Title
/// - Timestamp
/// - Optional connector line
class BookingTimelineItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String time;
  final bool isCompleted;
  final bool isError;
  final bool showConnector;

  const BookingTimelineItem({
    super.key,
    required this.icon,
    required this.title,
    required this.time,
    this.isCompleted = true,
    this.isError = false,
    this.showConnector = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final color = isError
        ? (isDark ? AppColors.darkError : AppColors.error)
        : isCompleted
        ? (isDark ? AppColors.darkSuccess : AppColors.success)
        : colorScheme.onSurfaceVariant;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              if (showConnector)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: color.withValues(alpha: 0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: BookingConstants.itemSpacing),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
