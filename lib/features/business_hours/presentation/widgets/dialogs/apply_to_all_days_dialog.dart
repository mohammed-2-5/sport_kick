import 'package:flutter/material.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_strings.dart';

/// Dialog for confirming "Apply to All Days" action.
///
/// Shows a confirmation dialog before applying business hours to all days.
class ApplyToAllDaysDialog extends StatelessWidget {
  const ApplyToAllDaysDialog({super.key});

  /// Shows the dialog and returns true if confirmed, false otherwise.
  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => const ApplyToAllDaysDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(BusinessHoursStrings.applyToAllDays),
      content: const Text(BusinessHoursStrings.helpApplyToAll),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text(BusinessHoursStrings.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text(BusinessHoursStrings.apply),
        ),
      ],
    );
  }
}
