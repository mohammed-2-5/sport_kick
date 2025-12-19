import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_shadows.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Card displaying performance metrics (Average Booking Value, Occupancy Rate, etc.).
class PerformanceMetricsCard extends StatelessWidget {
  const PerformanceMetricsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Performance Metrics',
          style: AppTextStyles.appBarTitle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildMetricRow(
          'Average Booking Value',
          '\$85.50',
          Icons.trending_up_rounded,
          AppColors.success,
          '+5.2%',
        ),
        const SizedBox(height: 12),
        _buildMetricRow(
          'Occupancy Rate',
          '78%',
          Icons.people_rounded,
          const Color(0xFF42A5F5),
          '+8.1%',
        ),
        const SizedBox(height: 12),
        _buildMetricRow(
          'Customer Satisfaction',
          '4.8/5.0',
          Icons.star_rounded,
          const Color(0xFFFFA726),
          '+0.3',
        ),
      ],
    );
  }

  Widget _buildMetricRow(
    String title,
    String value,
    IconData icon,
    Color color,
    String change,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
        boxShadow: AppShadows.small,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.arrow_upward_rounded,
                  size: 12,
                  color: AppColors.success,
                ),
                const SizedBox(width: 4),
                Text(
                  change,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
