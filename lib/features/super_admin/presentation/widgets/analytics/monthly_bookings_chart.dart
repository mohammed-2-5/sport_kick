import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/analytics/analytics_chart_card.dart';

/// Monthly bookings bar chart
class MonthlyBookingsChart extends StatelessWidget {
  final List<BookingEntity> bookings;

  const MonthlyBookingsChart({
    super.key,
    required this.bookings,
  });

  @override
  Widget build(BuildContext context) {
    // Group bookings by month
    final Map<int, int> monthlyBookings = {};
    final now = DateTime.now();

    for (var booking in bookings) {
      final monthKey = booking.date.month;
      monthlyBookings[monthKey] = (monthlyBookings[monthKey] ?? 0) + 1;
    }

    // Create bar groups for last 6 months
    final barGroups = <BarChartGroupData>[];
    for (int i = 0; i < 6; i++) {
      final month = now.month - i;
      final normalizedMonth = month <= 0 ? month + 12 : month;
      final count = monthlyBookings[normalizedMonth] ?? 0;
      barGroups.insert(
        0,
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: count.toDouble(),
              color: Colors.blue,
              width: 16,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
          ],
        ),
      );
    }

    return AnalyticsChartCard(
      title: 'Monthly Bookings',
      subtitle: 'Last 6 months',
      icon: Icons.bar_chart,
      color: Colors.blue,
      child: SizedBox(
        height: 250,
        child: Padding(
          padding: const EdgeInsets.only(right: 16, top: 16),
          child: BarChart(
            BarChartData(
              barGroups: barGroups,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
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
              gridData: FlGridData(show: true, drawVerticalLine: false),
            ),
          ),
        ),
      ),
    );
  }
}
