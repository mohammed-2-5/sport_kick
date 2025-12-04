import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/owner/domain/entities/owner_revenue_entity.dart';
import 'package:spo_kick/features/owner/presentation/constants/analytics_constants.dart';

/// Owner Revenue Metrics Widget
///
/// Displays key revenue metrics in a grid of cards:
/// - Total revenue
/// - Monthly revenue
/// - Average booking value
/// - Total bookings
/// - Pending bookings
class OwnerRevenueMetrics extends StatelessWidget {
  final OwnerRevenueEntity revenue;

  const OwnerRevenueMetrics({
    super.key,
    required this.revenue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Metrics',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AnalyticsConstants.sectionSpacing / 2),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: AnalyticsConstants.metricCardSpacing,
              crossAxisSpacing: AnalyticsConstants.metricCardSpacing,
              childAspectRatio: 1.5,
              children: [
                _MetricCard(
                  title: AnalyticsConstants.totalRevenueLabel,
                  value: '${revenue.totalRevenue.toStringAsFixed(0)} EGP',
                  icon: Icons.attach_money,
                  color: AppColors.success,
                ),
                _MetricCard(
                  title: AnalyticsConstants.monthlyRevenueLabel,
                  value: '${revenue.monthlyRevenue.toStringAsFixed(0)} EGP',
                  icon: Icons.calendar_today,
                  color: AppColors.info,
                ),
                _MetricCard(
                  title: AnalyticsConstants.averageBookingLabel,
                  value:
                      '${revenue.averageRevenuePerBooking.toStringAsFixed(0)} EGP',
                  icon: Icons.trending_up,
                  color: AppColors.warning,
                ),
                _MetricCard(
                  title: AnalyticsConstants.totalBookingsLabel,
                  value: revenue.totalBookings.toString(),
                  icon: Icons.event_available,
                  color: AppColors.primary,
                ),
                _MetricCard(
                  title: AnalyticsConstants.pendingBookingsLabel,
                  value: revenue.pendingBookings.toString(),
                  icon: Icons.pending_actions,
                  color: AppColors.bookingPending,
                ),
                if (crossAxisCount == 3)
                  _MetricCard(
                    title: AnalyticsConstants.revenueGrowthLabel,
                    value: '${revenue.revenueGrowthRate.toStringAsFixed(1)}%',
                    icon: Icons.show_chart,
                    color: AppColors.secondary,
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  static const double _iconSize = 32.0;
  static const double _cardElevation = 2.0;
  static const double _borderRadius = 12.0;
  static const double _padding = 16.0;
  static const double _iconValueSpacing = 12.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: _cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(_padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: _iconSize,
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: _iconValueSpacing),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
