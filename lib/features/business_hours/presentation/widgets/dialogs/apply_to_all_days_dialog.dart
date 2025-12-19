import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

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
      title: Text(context.l10n.businessHoursApplyToAllDays),
      content: Text(context.l10n.businessHoursApplyToAllDescription),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(context.l10n.apply),
        ),
      ],
    );
  }
}
