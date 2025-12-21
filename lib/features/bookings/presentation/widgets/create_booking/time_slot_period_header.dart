import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
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
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: BookingConstants.smallPadding),
        Text(
          period,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
