import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Dialog for confirming recurring booking cancellation.
class RecurringCancelDialog extends StatelessWidget {
  const RecurringCancelDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final errorColor = isDark ? AppColors.darkError : AppColors.error;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(Icons.cancel_outlined, color: errorColor, size: 24),
          const SizedBox(width: 12),
          Text(context.l10n.cancelSubscriptionTitle),
        ],
      ),
      content: Text(context.l10n.cancelSubscriptionBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(context.l10n.keepBooking),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: errorColor,
            foregroundColor: colorScheme.onPrimary,
          ),
          child: Text(context.l10n.cancel),
        ),
      ],
    );
  }

  /// Show the cancel confirmation dialog.
  static Future<bool> show(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => const RecurringCancelDialog(),
        ) ??
        false;
  }
}
