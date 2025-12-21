import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/dashboard/statistics_card.dart';

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
          title: context.l10n.totalUsers,
          value: statistics.totalUsers.toString(),
          subtitle: context.l10n.newUsersThisMonth(
            statistics.newUsersThisMonth,
          ),
          icon: Icons.people,
          color: Colors.blue,
          trend: statistics.userGrowthRate,
        ),
        StatisticsCard(
          title: context.l10n.totalAdmins,
          value: statistics.totalAdmins.toString(),
          subtitle: context.l10n.fieldOwners,
          icon: Icons.admin_panel_settings,
          color: Colors.purple,
        ),
        StatisticsCard(
          title: context.l10n.activeFields,
          value: statistics.activeFields.toString(),
          subtitle: context.l10n.inactiveCount(statistics.inactiveFields),
          icon: Icons.sports_soccer,
          color: Colors.green,
        ),
        StatisticsCard(
          title: context.l10n.totalBookings,
          value: statistics.totalBookings.toString(),
          subtitle: context.l10n.pendingCount(statistics.pendingBookings),
          icon: Icons.event,
          color: Colors.orange,
        ),
      ],
    );
  }
}
