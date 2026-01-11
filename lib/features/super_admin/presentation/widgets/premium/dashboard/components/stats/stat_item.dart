import 'package:flutter/material.dart';

/// Stat item data class.
class StatItem {
  final String label;
  final String value;
  final IconData icon;
  final List<Color> gradient;
  final double? growth;
  final VoidCallback onTap;

  const StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.gradient,
    this.growth,
    required this.onTap,
  });
}
