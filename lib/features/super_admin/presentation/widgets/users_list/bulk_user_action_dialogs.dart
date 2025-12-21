import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Bulk activate users confirmation dialog.
class BulkActivateUsersDialog extends StatelessWidget {
  final int count;

  const BulkActivateUsersDialog({required this.count, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.activateSelectedUsers),
      content: Text(context.l10n.areYouSureYouWantToActivateCountUsers(count)),
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

/// Bulk deactivate users confirmation dialog.
class BulkDeactivateUsersDialog extends StatelessWidget {
  final int count;

  const BulkDeactivateUsersDialog({required this.count, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.deactivateSelectedUsers),
      content: Text(
        context.l10n.areYouSureYouWantToDeactivateCountUsers(count),
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
