import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spo_kick/features/owner/presentation/constants/analytics_constants.dart';

/// Owner Revenue by Field Chart
///
/// Bar chart showing revenue breakdown by field
/// Displays top performing fields based on revenue
class OwnerRevenueByFieldChart extends StatelessWidget {
  final Map<String, double> revenueByField;

  const OwnerRevenueByFieldChart({super.key, required this.revenueByField});

  @override
  Widget build(BuildContext context) {
    return _ChartCard(
      title: AnalyticsConstants.revenueByFieldTitle,
      subtitle: AnalyticsConstants.revenueByFieldSubtitle,
      icon: Icons.bar_chart,
      color: Theme.of(context).colorScheme.primary,
      child: SizedBox(
        height: AnalyticsConstants.barChartHeight,
        child: Padding(
          padding: const EdgeInsets.only(
            right: AnalyticsConstants.chartRightPadding,
            top: AnalyticsConstants.chartTopPadding,
          ),
          child: _buildBarChart(context),
        ),
      ),
    );
  }

  Widget _buildBarChart(BuildContext context) {
    if (revenueByField.isEmpty) {
      return const Center(
        child: Text(
          AnalyticsConstants.noDataMessage,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final sortedEntries = revenueByField.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topFields = sortedEntries
        .take(AnalyticsConstants.maxFieldsInChart)
        .toList();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _calculateMaxY(topFields),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.toInt()} EGP',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return _buildFieldLabel(value.toInt(), topFields);
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: AnalyticsConstants.leftAxisReservedSize,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}',
                  style: const TextStyle(
                    fontSize: AnalyticsConstants.chartAxisFontSize,
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        barGroups: _buildBarGroups(topFields),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups(
    List<MapEntry<String, double>> topFields,
  ) {
    return List.generate(topFields.length, (index) {
      final entry = topFields[index];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: AnalyticsConstants.getFieldBarColor(index),
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildFieldLabel(int index, List<MapEntry<String, double>> topFields) {
    if (index >= topFields.length) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        'F${index + 1}',
        style: const TextStyle(
          fontSize: AnalyticsConstants.chartAxisFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  double _calculateMaxY(List<MapEntry<String, double>> topFields) {
    if (topFields.isEmpty) return 100;
    final maxRevenue = topFields.first.value;
    return (maxRevenue * 1.2).ceilToDouble();
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
