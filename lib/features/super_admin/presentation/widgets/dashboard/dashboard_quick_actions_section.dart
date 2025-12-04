import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/dashboard/dashboard_quick_action_card.dart';

/// Quick actions section for dashboard.
class DashboardQuickActionsSection extends StatelessWidget {
  const DashboardQuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
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
          children: const [
            DashboardQuickActionCard(
              title: 'Create Admin',
              subtitle: 'Add new field owner',
              icon: Icons.person_add,
              color: Colors.purple,
              route: 'superAdminCreateAdmin',
            ),
            DashboardQuickActionCard(
              title: 'Create Field',
              subtitle: 'Add new sports field',
              icon: Icons.add_business,
              color: Colors.deepOrange,
              route: 'superAdminCreateField',
            ),
            DashboardQuickActionCard(
              title: 'View Admins',
              subtitle: 'Manage field owners',
              icon: Icons.admin_panel_settings,
              color: Colors.blue,
              route: 'superAdminAdmins',
            ),
            DashboardQuickActionCard(
              title: 'View Users',
              subtitle: 'Manage customers',
              icon: Icons.people,
              color: Colors.green,
              route: 'superAdminUsers',
            ),
            DashboardQuickActionCard(
              title: 'Manage Cities',
              subtitle: 'Configure locations',
              icon: Icons.location_city,
              color: Colors.orange,
              route: 'superAdminCities',
            ),
            DashboardQuickActionCard(
              title: 'All Fields',
              subtitle: 'View all sports fields',
              icon: Icons.sports_soccer,
              color: Colors.teal,
              route: 'superAdminFields',
            ),
            DashboardQuickActionCard(
              title: 'All Bookings',
              subtitle: 'View all reservations',
              icon: Icons.event_note,
              color: Colors.indigo,
              route: 'superAdminBookings',
            ),
            DashboardQuickActionCard(
              title: 'Analytics',
              subtitle: 'Platform insights',
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
