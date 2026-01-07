import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).toString();
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, color: colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Text(
            context.l10n.selectedDateLabel(
              DateFormat('EEE, MMM d', locale).format(selectedDate),
            ),
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onChangePressed,
            child: Text(
              context.l10n.change,
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
