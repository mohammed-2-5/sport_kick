import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/analytics/analytics_chart_card.dart';

/// City performance comparison bar chart
class CityPerformanceChart extends StatelessWidget {
  final List<BookingEntity> bookings;

  const CityPerformanceChart({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    // Group bookings by field (using field names as proxy)
    final Map<String, int> fieldBookings = {};

    for (var booking in bookings) {
      if (booking.fieldName != null) {
        fieldBookings[booking.fieldName!] =
            (fieldBookings[booking.fieldName!] ?? 0) + 1;
      }
    }

    // Get top 5 fields
    final topFields = fieldBookings.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top5 = topFields.take(5).toList();

    if (top5.isEmpty) return const SizedBox.shrink();

    return AnalyticsChartCard(
      title: context.l10n.topFieldsByBookings,
      subtitle: context.l10n.mostBookedFields,
      icon: Icons.location_city,
      color: Colors.teal,
      child: SizedBox(
        height: 250,
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: BarChart(
            BarChartData(
              barGroups: top5
                  .asMap()
                  .entries
                  .map(
                    (entry) => BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.value.toDouble(),
                          color: Colors.teal,
                          width: 20,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: AppTextStyles.labelSmall.copyWith(fontSize: 10),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= top5.length) {
                        return const SizedBox.shrink();
                      }
                      final name = top5[value.toInt()].key;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          name.length > 8 ? '${name.substring(0, 8)}...' : name,
                          style: AppTextStyles.labelSmall.copyWith(fontSize: 9),
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
