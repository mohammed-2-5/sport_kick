import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Status badge widget.
class StatusBadge extends StatelessWidget {
  final String status;
  final Color color;
  final IconData icon;

  const StatusBadge({
    super.key,
    required this.status,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            status,
            style: AppTextStyles.withColor(
              AppTextStyles.bold(AppTextStyles.badge),
              color,
            ),
          ),
        ],
      ),
    );
  }
}
