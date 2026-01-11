import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Info chip (date, time, user).
class InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const InfoChip({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color.withValues(alpha: 0.7)),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTextStyles.withColor(AppTextStyles.labelSmall, color),
        ),
      ],
    );
  }
}
