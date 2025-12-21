import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Confirmation dialog for bulk admin activation.
///
/// Shows a confirmation dialog before activating multiple admins.
class BulkActivateAdminsDialog extends StatelessWidget {
  /// Number of admins to activate
  final int count;

  const BulkActivateAdminsDialog({required this.count, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.activateSelectedAdmins),
      content: Text(context.l10n.areYouSureYouWantToActivateCountAdmins(count)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(context.l10n.activate),
        ),
      ],
    );
  }
}

/// Confirmation dialog for bulk admin deactivation.
///
/// Shows a confirmation dialog before deactivating multiple admins.
class BulkDeactivateAdminsDialog extends StatelessWidget {
  /// Number of admins to deactivate
  final int count;

  const BulkDeactivateAdminsDialog({required this.count, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.deactivateSelectedAdmins),
      content: Text(
        context.l10n.areYouSureYouWantToDeactivateCountAdmins(count),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: Text(context.l10n.deactivate),
        ),
      ],
    );
  }
}
