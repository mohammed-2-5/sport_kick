import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/analytics/analytics_chart_card.dart';

/// Booking status distribution pie chart
class BookingStatusChart extends StatelessWidget {
  final List<BookingEntity> bookings;

  const BookingStatusChart({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    final pending = bookings
        .where((b) => b.status == BookingStatus.pending)
        .length;
    final confirmed = bookings
        .where((b) => b.status == BookingStatus.confirmed)
        .length;
    final canceled = bookings
        .where((b) => b.status == BookingStatus.canceled)
        .length;
    final completed = bookings
        .where((b) => b.status == BookingStatus.completed)
        .length;

    final total = pending + confirmed + canceled + completed;
    if (total == 0) return const SizedBox.shrink();

    return AnalyticsChartCard(
      title: 'Booking Distribution',
      subtitle: 'By status',
      icon: Icons.pie_chart,
      color: Colors.blue,
      child: SizedBox(
        height: 250,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: PieChart(
                PieChartData(
                  sections: [
                    if (pending > 0)
                      PieChartSectionData(
                        value: pending.toDouble(),
                        title:
                            '${((pending / total) * 100).toStringAsFixed(0)}%',
                        color: Colors.orange,
                        radius: 100,
                        titleStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    if (confirmed > 0)
                      PieChartSectionData(
                        value: confirmed.toDouble(),
                        title:
                            '${((confirmed / total) * 100).toStringAsFixed(0)}%',
                        color: Colors.green,
                        radius: 100,
                        titleStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    if (canceled > 0)
                      PieChartSectionData(
                        value: canceled.toDouble(),
                        title:
                            '${((canceled / total) * 100).toStringAsFixed(0)}%',
                        color: Colors.red,
                        radius: 100,
                        titleStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    if (completed > 0)
                      PieChartSectionData(
                        value: completed.toDouble(),
                        title:
                            '${((completed / total) * 100).toStringAsFixed(0)}%',
                        color: Colors.purple,
                        radius: 100,
                        titleStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (pending > 0)
                    ChartLegendItem(
                      color: Colors.orange,
                      label: 'Pending',
                      value: pending,
                    ),
                  if (confirmed > 0)
                    ChartLegendItem(
                      color: Colors.green,
                      label: 'Confirmed',
                      value: confirmed,
                    ),
                  if (canceled > 0)
                    ChartLegendItem(
                      color: Colors.red,
                      label: 'Canceled',
                      value: canceled,
                    ),
                  if (completed > 0)
                    ChartLegendItem(
                      color: Colors.purple,
                      label: 'Completed',
                      value: completed,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
