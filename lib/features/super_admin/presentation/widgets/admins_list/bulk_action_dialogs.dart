import 'package:flutter/material.dart';

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
      title: const Text('Activate Selected Admins'),
      content: Text('Are you sure you want to activate $count admins?'),
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
      title: const Text('Deactivate Selected Admins'),
      content: Text('Are you sure you want to deactivate $count admins?'),
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
