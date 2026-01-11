import 'package:flutter/material.dart';

/// Quick action data class.
class QuickAction {
  final String label;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;

  const QuickAction({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });
}
