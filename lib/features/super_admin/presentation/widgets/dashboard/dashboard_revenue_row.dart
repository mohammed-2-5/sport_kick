import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/statistics_card.dart';

/// Revenue statistics row for dashboard.
class DashboardRevenueRow extends StatelessWidget {
  final dynamic statistics;

  const DashboardRevenueRow({required this.statistics, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatisticsCard(
            title: 'Total Revenue',
            value: 'EGP ${statistics.formattedRevenue}',
            subtitle: 'All time earnings',
            icon: Icons.monetization_on,
            color: AppColors.premiumGold,
            trend: statistics.revenueGrowthRate,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatisticsCard(
            title: 'Avg. Revenue',
            value:
                'EGP ${statistics.averageRevenuePerBooking.toStringAsFixed(0)}',
            subtitle: 'Per booking',
            icon: Icons.analytics,
            color: Colors.indigo,
          ),
        ),
      ],
    );
  }
}
