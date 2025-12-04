import 'package:flutter/material.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/statistics_card.dart';

/// Main statistics grid for dashboard.
///
/// Displays 2x2 grid of primary statistics.
class DashboardMainStatsGrid extends StatelessWidget {
  final dynamic statistics;

  const DashboardMainStatsGrid({required this.statistics, super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        StatisticsCard(
          title: 'Total Users',
          value: statistics.totalUsers.toString(),
          subtitle: '+${statistics.newUsersThisMonth} this month',
          icon: Icons.people,
          color: Colors.blue,
          trend: statistics.userGrowthRate,
        ),
        StatisticsCard(
          title: 'Total Admins',
          value: statistics.totalAdmins.toString(),
          subtitle: 'Field owners',
          icon: Icons.admin_panel_settings,
          color: Colors.purple,
        ),
        StatisticsCard(
          title: 'Active Fields',
          value: statistics.activeFields.toString(),
          subtitle: '${statistics.inactiveFields} inactive',
          icon: Icons.sports_soccer,
          color: Colors.green,
        ),
        StatisticsCard(
          title: 'Total Bookings',
          value: statistics.totalBookings.toString(),
          subtitle: '${statistics.pendingBookings} pending',
          icon: Icons.event,
          color: Colors.orange,
        ),
      ],
    );
  }
}
