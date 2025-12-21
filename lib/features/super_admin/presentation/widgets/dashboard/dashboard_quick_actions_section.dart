import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/dashboard/dashboard_quick_action_card.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Quick actions section for dashboard.
class DashboardQuickActionsSection extends StatelessWidget {
  const DashboardQuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.quickActions,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.premiumTextPrimary,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.4,
          children: [
            DashboardQuickActionCard(
              title: context.l10n.createAdmin,
              subtitle: context.l10n.addNewFieldOwner,
              icon: Icons.person_add,
              color: Colors.purple,
              route: 'superAdminCreateAdmin',
            ),
            DashboardQuickActionCard(
              title: context.l10n.createField,
              subtitle: context.l10n.addNewSportsField,
              icon: Icons.add_business,
              color: Colors.deepOrange,
              route: 'superAdminCreateField',
            ),
            DashboardQuickActionCard(
              title: context.l10n.viewAdmins,
              subtitle: context.l10n.manageFieldOwners,
              icon: Icons.admin_panel_settings,
              color: Colors.blue,
              route: 'superAdminAdmins',
            ),
            DashboardQuickActionCard(
              title: context.l10n.viewUsers,
              subtitle: context.l10n.manageCustomers,
              icon: Icons.people,
              color: Colors.green,
              route: 'superAdminUsers',
            ),
            DashboardQuickActionCard(
              title: context.l10n.manageCities,
              subtitle: context.l10n.configureLocations,
              icon: Icons.location_city,
              color: Colors.orange,
              route: 'superAdminCities',
            ),
            DashboardQuickActionCard(
              title: context.l10n.allFields,
              subtitle: context.l10n.viewAllSportsFields,
              icon: Icons.sports_soccer,
              color: Colors.teal,
              route: 'superAdminFields',
            ),
            DashboardQuickActionCard(
              title: context.l10n.allBookings,
              subtitle: context.l10n.viewAllReservations,
              icon: Icons.event_note,
              color: Colors.indigo,
              route: 'superAdminBookings',
            ),
            DashboardQuickActionCard(
              title: context.l10n.analytics,
              subtitle: context.l10n.platformInsights,
              icon: Icons.analytics,
              color: Colors.deepPurple,
              route: 'superAdminAnalytics',
            ),
          ],
        ),
      ],
    );
  }
}
