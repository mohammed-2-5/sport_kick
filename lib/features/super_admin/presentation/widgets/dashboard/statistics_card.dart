import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

class StatisticsCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final double? trend;

  const StatisticsCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.trend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.premiumSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: AppTextStyles.labelMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.premiumTextSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 8),

          // Value
          Text(
            value,
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
              shadows: [
                Shadow(color: color.withValues(alpha: 0.5), blurRadius: 10),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          if (trend != null) ...[
            const SizedBox(height: 8),
            _buildTrendIndicator(),
          ],
        ],
      ),
    );
  }

  Widget _buildTrendIndicator() {
    final isPositive = trend! >= 0;
    final trendColor = isPositive ? AppColors.success : AppColors.error;
    final trendIcon = isPositive ? Icons.trending_up : Icons.trending_down;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(trendIcon, color: trendColor, size: 14),
        const SizedBox(width: 4),
        Text(
          '${trend!.abs().toStringAsFixed(1)}%',
          style: AppTextStyles.labelMedium.copyWith(
            color: trendColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
