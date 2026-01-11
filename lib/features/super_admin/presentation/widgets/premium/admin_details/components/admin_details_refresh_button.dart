import 'package:flutter/material.dart';

/// Refresh button widget for admin details view.
class AdminDetailsRefreshButton extends StatelessWidget {
  final VoidCallback onTap;

  const AdminDetailsRefreshButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outline),
        ),
        child: Icon(Icons.refresh, color: colorScheme.onSurface, size: 20),
      ),
    );
  }
}
