import 'package:flutter/material.dart';

/// Shows a "Coming Soon" dialog for features not yet implemented.
void showComingSoonDialog(BuildContext context, String feature) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Coming Soon'),
      content: Text('$feature will be available in a future update.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

/// Shows a maintenance mode confirmation dialog.
void showMaintenanceModeDialog(BuildContext context, VoidCallback onConfirm) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Maintenance Mode'),
      content: const Text(
        'Are you sure you want to enable maintenance mode? '
        'This will prevent users from accessing the platform.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Enable'),
        ),
      ],
    ),
  );
}
