import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Card showing selected date with change option.
class DateSummaryCard extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onChangePressed;

  const DateSummaryCard({
    super.key,
    required this.selectedDate,
    required this.onChangePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accentCyan.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today,
            color: AppColors.accentCyan,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            'Selected: ${DateFormat('EEE, MMM d').format(selectedDate)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.accentCyan,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onChangePressed,
            child: const Text(
              'Change',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.accentCyan,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
