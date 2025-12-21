import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Premium Revenue Chart Widget
///
/// Displays revenue trends over time with a smooth line chart.
/// Uses the premium color palette for a sophisticated look.
class RevenueChart extends StatelessWidget {
  final List<double> revenueData;
  final List<String> labels;

  const RevenueChart({
    super.key,
    required this.revenueData,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.premiumSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.premiumSurfaceHighlight),
      ),
      child: LineChart(
        _buildChartData(),
        duration: const Duration(milliseconds: 250),
      ),
    );
  }

  LineChartData _buildChartData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: AppColors.premiumSurfaceHighlight,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= 0 && value.toInt() < labels.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    labels[value.toInt()],
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.premiumTextSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                '${value.toInt()}K',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.premiumTextSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (revenueData.length - 1).toDouble(),
      minY: 0,
      maxY: _getMaxY(),
      lineBarsData: [
        LineChartBarData(
          spots: _buildSpots(),
          isCurved: true,
          curveSmoothness: 0.35,
          color: AppColors.premiumGold,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: AppColors.premiumGold,
                strokeWidth: 2,
                strokeColor: AppColors.premiumBackground,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.premiumGold.withValues(alpha: 0.3),
                AppColors.premiumGold.withValues(alpha: 0.05),
              ],
            ),
          ),
          shadow: Shadow(
            color: AppColors.premiumGold.withValues(alpha: 0.5),
            blurRadius: 8,
          ),
        ),
      ],
    );
  }

  List<FlSpot> _buildSpots() {
    return List.generate(
      revenueData.length,
      (index) => FlSpot(index.toDouble(), revenueData[index]),
    );
  }

  double _getMaxY() {
    if (revenueData.isEmpty) return 5;
    final maxValue = revenueData.reduce((a, b) => a > b ? a : b);
    return (maxValue * 1.2).ceilToDouble();
  }
}
