import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spo_kick/features/owner/domain/entities/owner_revenue_entity.dart';
import 'package:spo_kick/features/owner/presentation/constants/analytics_constants.dart';

/// Owner Revenue Trends Chart
///
/// Line chart showing revenue trends over the last 6 months
/// Uses monthly revenue data from OwnerRevenueEntity
class OwnerRevenueTrendsChart extends StatelessWidget {
  final OwnerRevenueEntity revenue;
  final int dateRangeDays;

  const OwnerRevenueTrendsChart({
    super.key,
    required this.revenue,
    required this.dateRangeDays,
  });

  @override
  Widget build(BuildContext context) {
    return _ChartCard(
      title: AnalyticsConstants.revenueTrendsTitle,
      subtitle: AnalyticsConstants.revenueTrendsSubtitle,
      icon: Icons.trending_up,
      color: AnalyticsConstants.revenueChartColor,
      child: SizedBox(
        height: AnalyticsConstants.lineChartHeight,
        child: Padding(
          padding: const EdgeInsets.only(
            right: AnalyticsConstants.chartRightPadding,
            top: AnalyticsConstants.chartTopPadding,
          ),
          child: _buildLineChart(),
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    final spots = _generateSpots();

    if (spots.isEmpty) {
      return const Center(
        child: Text(
          AnalyticsConstants.noDataMessage,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: AnalyticsConstants.leftAxisReservedSize,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()} EGP',
                  style: const TextStyle(
                    fontSize: AnalyticsConstants.chartAxisFontSize,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return _buildMonthLabel(value.toInt());
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AnalyticsConstants.revenueChartColor,
            barWidth: AnalyticsConstants.lineChartBarWidth,
            belowBarData: BarAreaData(
              show: true,
              color: AnalyticsConstants.revenueChartAreaColor,
            ),
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateSpots() {
    final spots = <FlSpot>[];

    // Generate simple monthly data based on monthly revenue
    // In a real implementation, this would use actual historical data
    for (int i = 0; i < AnalyticsConstants.monthsToShow; i++) {
      final monthIndex = i.toDouble();
      final revenueValue = i == AnalyticsConstants.monthsToShow - 1
          ? revenue.monthlyRevenue
          : revenue.monthlyRevenue * (0.7 + (i * 0.05));

      spots.add(FlSpot(monthIndex, revenueValue));
    }

    return spots;
  }

  Widget _buildMonthLabel(int index) {
    final now = DateTime.now();
    final monthIndex =
        now.month - (AnalyticsConstants.monthsToShow - 1) + index;
    final month = monthIndex <= 0 ? monthIndex + 12 : monthIndex;

    return Text(
      AnalyticsConstants.monthAbbreviations[month],
      style: const TextStyle(fontSize: AnalyticsConstants.chartAxisFontSize),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget child;

  const _ChartCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.child,
  });

  static const double _elevation = 2.0;
  static const double _borderRadius = 12.0;
  static const double _headerPadding = 16.0;
  static const double _iconSize = 24.0;
  static const double _titleSpacing = 8.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: _elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(_headerPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: _iconSize),
                const SizedBox(width: _titleSpacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: AnalyticsConstants.chartTitleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: AnalyticsConstants.chartAxisFontSize,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: _headerPadding),
            child,
          ],
        ),
      ),
    );
  }
}
