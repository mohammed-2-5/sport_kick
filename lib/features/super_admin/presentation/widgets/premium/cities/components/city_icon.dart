import 'package:flutter/material.dart';

/// City icon with status glow.
class CityIcon extends StatelessWidget {
  final bool isActive;
  final Color accentColor;

  const CityIcon({
    super.key,
    required this.isActive,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentColor.withValues(alpha: 0.15),
            accentColor.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(Icons.location_city_rounded, color: accentColor, size: 24),
    );
  }
}
