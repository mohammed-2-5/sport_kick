import 'package:flutter/material.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Period header widget for time slot sections.
class TimeSlotPeriodHeader extends StatelessWidget {
  final String period;
  final IconData icon;

  const TimeSlotPeriodHeader({
    super.key,
    required this.period,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: BookingConstants.smallPadding),
        Text(
          period,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
