import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/analytics/analytics_chart_card.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Monthly bookings bar chart
class MonthlyBookingsChart extends StatelessWidget {
  final List<BookingEntity> bookings;

  const MonthlyBookingsChart({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    // Group bookings by month
    final Map<int, int> monthlyBookings = {};
    final now = DateTime.now();

    for (var booking in bookings) {
      final monthKey = booking.date.month;
      monthlyBookings[monthKey] = (monthlyBookings[monthKey] ?? 0) + 1;
    }

    // Create bar groups for last 6 months (oldest to newest: left to right)
    final barGroups = <BarChartGroupData>[];
    for (int i = 5; i >= 0; i--) {
      final month = now.month - i;
      final normalizedMonth = month <= 0 ? month + 12 : month;
      final count = monthlyBookings[normalizedMonth] ?? 0;
      barGroups.add(
        BarChartGroupData(
          x: 5 - i, // 0 for oldest, 5 for current month
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
      title: context.l10n.monthlyBookings,
      subtitle: context.l10n.last6Months,
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
                        style: AppTextStyles.badge,
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      // value 0 = oldest month, 5 = current month
                      final monthOffset = 5 - value.toInt();
                      final monthNum = now.month - monthOffset;
                      final normalizedMonth = monthNum <= 0
                          ? monthNum + 12
                          : monthNum;
                      const months = [
                        '', // index 0 unused
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
                        'Dec',
                      ];
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          months[normalizedMonth],
                          style: AppTextStyles.badge,
                        ),
                      );
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
              gridData: const FlGridData(show: true, drawVerticalLine: false),
            ),
          ),
        ),
      ),
    );
  }
}
