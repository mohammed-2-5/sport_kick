import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Growth indicator badge for revenue.
class RevenueGrowthBadge extends StatelessWidget {
  final double growth;

  const RevenueGrowthBadge({super.key, required this.growth});

  @override
  Widget build(BuildContext context) {
    final isPositive = growth >= 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isPositive
            ? Colors.green.withValues(alpha: 0.2)
            : Colors.red.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPositive
              ? Colors.green.withValues(alpha: 0.3)
              : Colors.red.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
            size: 14,
            color: isPositive ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 4),
          Text(
            '${isPositive ? '+' : ''}${growth.toStringAsFixed(1)}%',
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
