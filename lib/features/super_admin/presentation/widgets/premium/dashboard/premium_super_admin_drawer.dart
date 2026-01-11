import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/dashboard/components/drawer/drawer_header.dart'
    as custom;
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/dashboard/components/drawer/drawer_logout_button.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/dashboard/components/drawer/drawer_menu_item.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/dashboard/components/drawer/drawer_section_divider.dart';

/// Premium super admin navigation drawer with gold accent.
///
/// Features:
/// - Gold gradient header
/// - Animated menu items
/// - Section dividers
/// - Logout with confirmation
class PremiumSuperAdminDrawer extends StatelessWidget {
  final String adminName;
  final String email;
  final int selectedIndex;
  final Function(int) onItemTap;
  final VoidCallback onLogout;

  const PremiumSuperAdminDrawer({
    super.key,
    required this.adminName,
    required this.email,
    required this.selectedIndex,
    required this.onItemTap,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // Header
          custom.AdminDrawerHeader(name: adminName, email: email),

          // Menu items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                DrawerMenuItem(
                  icon: Icons.dashboard_rounded,
                  label: context.l10n.dashboard,
                  isSelected: selectedIndex == 0,
                  onTap: () => onItemTap(0),
                ),
                DrawerSectionDivider(title: context.l10n.management),
                DrawerMenuItem(
                  icon: Icons.people_rounded,
                  label: context.l10n.users,
                  isSelected: selectedIndex == 1,
                  onTap: () => onItemTap(1),
                ),
                DrawerMenuItem(
                  icon: Icons.admin_panel_settings_rounded,
                  label: context.l10n.fieldOwners2,
                  isSelected: selectedIndex == 2,
                  onTap: () => onItemTap(2),
                ),
                DrawerMenuItem(
                  icon: Icons.sports_soccer_rounded,
                  label: context.l10n.fields,
                  isSelected: selectedIndex == 3,
                  onTap: () => onItemTap(3),
                ),
                DrawerMenuItem(
                  icon: Icons.calendar_month_rounded,
                  label: context.l10n.bookings,
                  isSelected: selectedIndex == 4,
                  onTap: () => onItemTap(4),
                ),
                DrawerMenuItem(
                  icon: Icons.location_city_rounded,
                  label: context.l10n.cities,
                  isSelected: selectedIndex == 5,
                  onTap: () => onItemTap(5),
                ),
                DrawerMenuItem(
                  icon: Icons.sports_rounded,
                  label: context.l10n.sports,
                  isSelected: selectedIndex == 6,
                  onTap: () => onItemTap(6),
                ),
                DrawerMenuItem(
                  icon: Icons.rate_review_rounded,
                  label: context.l10n.reviews,
                  isSelected: selectedIndex == 7,
                  onTap: () => onItemTap(7),
                ),
                DrawerMenuItem(
                  icon: Icons.notifications_active_rounded,
                  label: context.l10n.notifications,
                  isSelected: selectedIndex == 8,
                  onTap: () => onItemTap(8),
                ),
                DrawerSectionDivider(title: context.l10n.analytics),
                DrawerMenuItem(
                  icon: Icons.analytics_rounded,
                  label: context.l10n.statistics,
                  isSelected: selectedIndex == 9,
                  onTap: () => onItemTap(9),
                ),
                DrawerMenuItem(
                  icon: Icons.assessment_rounded,
                  label: context.l10n.reports,
                  isSelected: selectedIndex == 10,
                  onTap: () => onItemTap(10),
                ),
                DrawerMenuItem(
                  icon: Icons.security_rounded,
                  label: context.l10n.loginActivity,
                  isSelected: selectedIndex == 11,
                  onTap: () => onItemTap(11),
                ),
                DrawerSectionDivider(title: context.l10n.system),
                DrawerMenuItem(
                  icon: Icons.settings_rounded,
                  label: context.l10n.settings,
                  isSelected: selectedIndex == 12,
                  onTap: () => onItemTap(12),
                ),
              ],
            ),
          ),

          // Logout
          DrawerLogoutButton(onTap: onLogout),

          // Version info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              context.l10n.sportKickAdminV100,
              style: AppTextStyles.withColor(
                AppTextStyles.labelSmall,
                AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
