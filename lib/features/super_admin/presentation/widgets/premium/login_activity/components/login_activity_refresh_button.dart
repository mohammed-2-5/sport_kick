import 'package:flutter/material.dart';

/// Refresh button for login activity header.
class LoginActivityRefreshButton extends StatelessWidget {
  final VoidCallback onTap;

  const LoginActivityRefreshButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(
          Icons.refresh_rounded,
          color: Theme.of(context).colorScheme.onPrimary,
          size: 22,
        ),
        onPressed: onTap,
      ),
    );
  }
}
