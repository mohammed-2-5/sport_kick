import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';

/// Premium chart card container.
///
/// Features:
/// - PremiumCard wrapper
/// - Title and subtitle
/// - Chart content area
/// - Legend support
class PremiumChartCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget chart;
  final Widget? legend;
  final double? height;

  const PremiumChartCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.chart,
    this.legend,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Chart
          SizedBox(height: height ?? 200, child: chart),
          // Legend
          if (legend != null) ...[const SizedBox(height: 16), legend!],
        ],
      ),
    );
  }
}

/// Simple legend item for charts.
class ChartLegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String? value;

  const ChartLegendItem({
    super.key,
    required this.color,
    required this.label,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (value != null)
          Text(
            value!,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
      ],
    );
  }
}

/// Chart legend row.
class ChartLegendRow extends StatelessWidget {
  final List<Widget> children;

  const ChartLegendRow({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 20, runSpacing: 12, children: children);
  }
}
