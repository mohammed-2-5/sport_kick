import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/owner/domain/entities/owner_revenue_entity.dart';
import 'package:spo_kick/features/owner/presentation/constants/analytics_constants.dart';

/// Owner Booking Status Chart
///
/// Pie chart showing distribution of booking statuses
/// - Confirmed bookings
/// - Pending bookings
/// - Completed bookings
class OwnerBookingStatusChart extends StatelessWidget {
  final OwnerRevenueEntity revenue;

  const OwnerBookingStatusChart({super.key, required this.revenue});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _ChartCard(
      title: l10n.bookingStatusTitle,
      subtitle: l10n.bookingStatusSubtitle,
      icon: Icons.pie_chart,
      color: AppColors.info,
      child: SizedBox(
        height: AnalyticsConstants.pieChartHeight,
        child: Row(
          children: [
            Expanded(flex: 3, child: _buildPieChart(context)),
            Expanded(flex: 2, child: _buildLegend(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(BuildContext context) {
    final sections = _createPieSections();

    if (sections.isEmpty) {
      return Center(
        child: Text(
          context.l10n.noDataAvailablePeriod,
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    return PieChart(
      PieChartData(
        sections: sections,
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        borderData: FlBorderData(show: false),
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {},
        ),
      ),
    );
  }

  List<PieChartSectionData> _createPieSections() {
    final totalBookings = revenue.totalBookings;
    if (totalBookings == 0) return [];

    final confirmedBookings = revenue.monthlyBookings;
    final pendingBookings = revenue.pendingBookings;

    // Estimate completed bookings (total - monthly - pending)
    final completedBookings =
        totalBookings - confirmedBookings - pendingBookings;

    final sections = <PieChartSectionData>[];

    if (confirmedBookings > 0) {
      sections.add(
        _createSection(
          value: confirmedBookings.toDouble(),
          color: AnalyticsConstants.statusPieColors[0],
          title:
              '${((confirmedBookings / totalBookings) * 100).toStringAsFixed(0)}%',
        ),
      );
    }

    if (pendingBookings > 0) {
      sections.add(
        _createSection(
          value: pendingBookings.toDouble(),
          color: AnalyticsConstants.statusPieColors[1],
          title:
              '${((pendingBookings / totalBookings) * 100).toStringAsFixed(0)}%',
        ),
      );
    }

    if (completedBookings > 0) {
      sections.add(
        _createSection(
          value: completedBookings.toDouble(),
          color: AnalyticsConstants.statusPieColors[2],
          title:
              '${((completedBookings / totalBookings) * 100).toStringAsFixed(0)}%',
        ),
      );
    }

    return sections;
  }

  PieChartSectionData _createSection({
    required double value,
    required Color color,
    required String title,
  }) {
    const fontSize = 12.0;
    const radius = 50.0;
    const titlePositionPercentageOffset = 0.55;

    return PieChartSectionData(
      value: value,
      color: color,
      title: title,
      radius: radius,
      titleStyle: const TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titlePositionPercentageOffset: titlePositionPercentageOffset,
    );
  }

  Widget _buildLegend(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LegendItem(
          color: AnalyticsConstants.statusPieColors[0],
          label: l10n.statusConfirmed,
          value: revenue.monthlyBookings.toString(),
        ),
        const SizedBox(height: 8),
        _LegendItem(
          color: AnalyticsConstants.statusPieColors[1],
          label: l10n.statusPending,
          value: revenue.pendingBookings.toString(),
        ),
        const SizedBox(height: 8),
        _LegendItem(
          color: AnalyticsConstants.statusPieColors[2],
          label: l10n.statusCompleted,
          value:
              (revenue.totalBookings -
                      revenue.monthlyBookings -
                      revenue.pendingBookings)
                  .toString(),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.value,
  });

  static const double _indicatorSize = 16.0;
  static const double _spacing = 8.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: _indicatorSize,
          height: _indicatorSize,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: _spacing),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: AnalyticsConstants.chartAxisFontSize,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: AnalyticsConstants.chartAxisFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
