import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Success dialog shown after field creation.
///
/// Displays a success message with checkmark icon and allows
/// user to navigate back to previous screen.
class FieldCreationSuccessDialog extends StatelessWidget {
  /// Message to display in dialog
  final String message;

  const FieldCreationSuccessDialog({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.success, size: 32),
          const SizedBox(width: 12),
          Text(context.l10n.success2),
        ],
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close dialog
            Navigator.pop(context); // Return to previous screen
          },
          child: Text(context.l10n.ok),
        ),
      ],
    );
  }
}
