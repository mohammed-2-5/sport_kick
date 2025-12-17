import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Badge indicating a slot is on the next day (after midnight).
class NextDayBadge extends StatelessWidget {
  const NextDayBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.accentCyan.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.3)),
      ),
      child: const Text(
        '+1',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.accentCyan,
        ),
      ),
    );
  }
}
