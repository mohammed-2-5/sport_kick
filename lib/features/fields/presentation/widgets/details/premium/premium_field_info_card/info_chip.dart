import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// A reusable chip widget for displaying field attributes with icon and label.
///
/// This widget displays information about field characteristics (e.g., surface type,
/// indoor/outdoor status) with a customizable icon, label, and color. The chip has
/// a subtle background color with a matching border, creating a cohesive design.
///
/// Example:
/// ```dart
/// InfoChip(
///   icon: Icons.grass,
///   label: 'Artificial Turf',
///   color: Colors.green,
/// )
/// ```
class InfoChip extends StatelessWidget {
  /// The icon to display in the chip.
  final IconData icon;

  /// The text label to display next to the icon.
  final String label;

  /// The color used for the icon, text, and border of the chip.
  /// The background will be a light version of this color (10% opacity).
  final Color color;

  /// Creates an [InfoChip] widget.
  ///
  /// All parameters are required:
  /// - [icon]: The icon data to display
  /// - [label]: The text label for the chip
  /// - [color]: The primary color for the chip styling
  const InfoChip({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
