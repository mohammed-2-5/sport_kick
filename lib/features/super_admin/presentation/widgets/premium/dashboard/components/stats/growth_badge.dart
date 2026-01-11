import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Growth indicator badge.
class GrowthBadge extends StatelessWidget {
  final double growth;

  const GrowthBadge({super.key, required this.growth});

  @override
  Widget build(BuildContext context) {
    final isPositive = growth >= 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: isPositive
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
            size: 12,
            color: isPositive ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 2),
          Text(
            '${growth.abs().toStringAsFixed(1)}%',
            style: AppTextStyles.withColor(
              AppTextStyles.labelSmallBold,
              isPositive ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
