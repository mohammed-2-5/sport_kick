import 'package:flutter/material.dart';

/// Bulk activate users confirmation dialog.
class BulkActivateUsersDialog extends StatelessWidget {
  final int count;

  const BulkActivateUsersDialog({required this.count, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Activate Selected Users'),
      content: Text('Are you sure you want to activate $count users?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Activate'),
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
      title: const Text('Deactivate Selected Users'),
      content: Text('Are you sure you want to deactivate $count users?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Deactivate'),
        ),
      ],
    );
  }
}
