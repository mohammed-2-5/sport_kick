import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';

class OwnerBookingDateTimeRow extends StatelessWidget {
  final BookingEntity booking;

  const OwnerBookingDateTimeRow({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: 16,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 8),
        Text(booking.formattedDate, style: AppTextStyles.bodyMedium),
        const SizedBox(width: 16),
        Icon(
          Icons.access_time,
          size: 16,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 8),
        Text(
          LocaleFormatters.formatTimeRange(
            context,
            startTime: booking.startTime,
            endTime: booking.endTime,
            baseDate: booking.date,
          ),
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }
}
