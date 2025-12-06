import 'package:flutter/material.dart';
import 'package:spo_kick/features/owner/domain/entities/owner_revenue_entity.dart';
import 'package:spo_kick/features/owner/presentation/constants/analytics_constants.dart';
import 'package:spo_kick/features/owner/presentation/widgets/analytics/owner_booking_status_chart.dart';
import 'package:spo_kick/features/owner/presentation/widgets/analytics/owner_revenue_by_field_chart.dart';
import 'package:spo_kick/features/owner/presentation/widgets/analytics/owner_revenue_metrics.dart';
import 'package:spo_kick/features/owner/presentation/widgets/analytics/owner_revenue_trends_chart.dart';
import 'package:spo_kick/features/owner/presentation/widgets/analytics/revenue_analytics_header.dart';

/// Main content widget for revenue analytics.
/// Displays metrics, charts, and revenue breakdown.
class RevenueAnalyticsContent extends StatelessWidget {
  final OwnerRevenueEntity revenue;
  final int selectedDateRange;
  final VoidCallback onRefresh;

  const RevenueAnalyticsContent({
    super.key,
    required this.revenue,
    required this.selectedDateRange,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AnalyticsConstants.pageContentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            RevenueAnalyticsHeader(selectedDateRange: selectedDateRange),
            const SizedBox(height: AnalyticsConstants.sectionSpacing),

            // Key Metrics
            OwnerRevenueMetrics(revenue: revenue),
            const SizedBox(height: AnalyticsConstants.chartSpacing),

            // Revenue Trends Chart
            OwnerRevenueTrendsChart(
              revenue: revenue,
              dateRangeDays: selectedDateRange,
            ),
            const SizedBox(height: AnalyticsConstants.chartSpacing),

            // Revenue by Field Chart
            if (revenue.revenueByField.isNotEmpty) ...[
              OwnerRevenueByFieldChart(revenueByField: revenue.revenueByField),
              const SizedBox(height: AnalyticsConstants.chartSpacing),
            ],

            // Booking Status Chart
            OwnerBookingStatusChart(revenue: revenue),
            const SizedBox(height: AnalyticsConstants.sectionSpacing),
          ],
        ),
      ),
    );
  }
}
