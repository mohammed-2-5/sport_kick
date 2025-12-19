import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

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
    final locale = Localizations.localeOf(context).toString();
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
            context.l10n.selectedDateLabel(
              DateFormat('EEE, MMM d', locale).format(selectedDate),
            ),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.accentCyan,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onChangePressed,
            child: Text(
              context.l10n.change,
              style: const TextStyle(
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
