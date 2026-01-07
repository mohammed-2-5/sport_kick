import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Stat Item Card Widget
///
/// Displays a single statistic with:
/// - Icon in a colored circle
/// - Formatted numeric value
/// - Label text
///
/// Used in the stats overview section to show key metrics
class StatItemCard extends StatelessWidget {
  /// Label text for the statistic
  final String label;

  /// Formatted numeric value to display
  final String value;

  /// Icon to display in the circular container
  final IconData icon;

  /// Color for the icon and background
  final Color color;

  const StatItemCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.bold(AppTextStyles.titleMedium)),
          Text(label, style: AppTextStyles.labelSmall),
        ],
      ),
    );
  }
}
