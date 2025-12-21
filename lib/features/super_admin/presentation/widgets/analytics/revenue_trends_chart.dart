import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/analytics/analytics_chart_card.dart';

/// Revenue trends line chart
class RevenueTrendsChart extends StatelessWidget {
  final List<BookingEntity> bookings;

  const RevenueTrendsChart({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
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
      title: context.l10n.revenueTrendsTitle,
      subtitle: context.l10n.last6MonthsRevenue,
      icon: Icons.trending_up,
      color: Colors.green,
      child: SizedBox(
        height: 250,
        child: Padding(
          padding: const EdgeInsets.only(right: 16, top: 16),
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: true, drawVerticalLine: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 60,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${LocaleFormatters.formatNumber(context, value.toInt())} ${context.l10n.currencyEgp}',
                        style: AppTextStyles.labelSmall.copyWith(fontSize: 10),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final monthIndex = now.month - 5 + value.toInt();
                      final month = monthIndex <= 0
                          ? monthIndex + 12
                          : monthIndex;
                      return Text(
                        DateFormat(
                          'MMM',
                          locale,
                        ).format(DateTime(now.year, month, 1)),
                        style: AppTextStyles.labelSmall.copyWith(fontSize: 10),
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
                  dotData: const FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
