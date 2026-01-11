import 'package:flutter/material.dart';

/// Success icon widget for password reset dialog.
class PasswordSuccessIcon extends StatelessWidget {
  final Color actionColor;

  const PasswordSuccessIcon({required this.actionColor, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: actionColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: actionColor.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Icon(Icons.check, color: Colors.white, size: 40),
    );
  }
}
