import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/analytics/analytics_chart_card.dart';

/// Revenue trends line chart
class RevenueTrendsChart extends StatelessWidget {
  final List<BookingEntity> bookings;

  const RevenueTrendsChart({
    super.key,
    required this.bookings,
  });

  @override
  Widget build(BuildContext context) {
    // Group bookings by month and calculate revenue
    final Map<int, double> monthlyRevenue = {};
    final now = DateTime.now();

    for (var booking in bookings) {
      if (booking.status == BookingStatus.confirmed ||
          booking.status == BookingStatus.completed) {
        final monthKey = booking.date.month;
        monthlyRevenue[monthKey] =
            (monthlyRevenue[monthKey] ?? 0) + booking.totalPrice;
      }
    }

    // Create spots for the last 6 months
    final spots = <FlSpot>[];
    for (int i = 0; i < 6; i++) {
      final month = (now.month - i);
      final normalizedMonth = month <= 0 ? month + 12 : month;
      final revenue = monthlyRevenue[normalizedMonth] ?? 0;
      spots.insert(0, FlSpot(i.toDouble(), revenue));
    }

    return AnalyticsChartCard(
      title: 'Revenue Trends',
      subtitle: 'Last 6 months revenue',
      icon: Icons.trending_up,
      color: Colors.green,
      child: SizedBox(
        height: 250,
        child: Padding(
          padding: const EdgeInsets.only(right: 16, top: 16),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true, drawVerticalLine: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 60,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${value.toInt()} EGP',
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final monthIndex = now.month - 5 + value.toInt();
                      final month =
                          monthIndex <= 0 ? monthIndex + 12 : monthIndex;
                      const months = [
                        '',
                        'Jan',
                        'Feb',
                        'Mar',
                        'Apr',
                        'May',
                        'Jun',
                        'Jul',
                        'Aug',
                        'Sep',
                        'Oct',
                        'Nov',
                        'Dec'
                      ];
                      return Text(
                        months[month],
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: Colors.green,
                  barWidth: 3,
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.green.withValues(alpha: 0.2),
                  ),
                  dotData: FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
