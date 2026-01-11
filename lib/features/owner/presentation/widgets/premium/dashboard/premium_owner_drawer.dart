import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/dashboard/components/premium_owner_drawer_header.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/dashboard/components/premium_owner_drawer_item.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/dashboard/components/premium_owner_logout_button.dart';

/// Premium owner navigation drawer.
///
/// Features:
/// - Glass header with user info
/// - Animated menu items
/// - Icon badges for notifications
/// - Logout with confirmation
class PremiumOwnerDrawer extends StatelessWidget {
  final String ownerName;
  final String email;
  final String? avatarUrl;
  final int selectedIndex;
  final Function(int) onItemTap;
  final VoidCallback onLogout;
  final int pendingRecurringCount;

  const PremiumOwnerDrawer({
    super.key,
    required this.ownerName,
    required this.email,
    this.avatarUrl,
    required this.selectedIndex,
    required this.onItemTap,
    required this.onLogout,
    this.pendingRecurringCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Drawer(
      backgroundColor: colorScheme.surface,
      child: Column(
        children: [
          // Header
          PremiumOwnerDrawerHeader(
            name: ownerName,
            email: email,
            avatarUrl: avatarUrl,
          ),

          // Menu items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                PremiumOwnerDrawerItem(
                  icon: Icons.dashboard_rounded,
                  label: context.l10n.dashboard,
                  isSelected: selectedIndex == 0,
                  onTap: () => onItemTap(0),
                ),
                PremiumOwnerDrawerItem(
                  icon: Icons.calendar_month_rounded,
                  label: context.l10n.bookings,
                  isSelected: selectedIndex == 1,
                  onTap: () => onItemTap(1),
                ),
                PremiumOwnerDrawerItem(
                  icon: Icons.sports_soccer_rounded,
                  label: context.l10n.myFields,
                  isSelected: selectedIndex == 2,
                  onTap: () => onItemTap(2),
                ),
                PremiumOwnerDrawerItem(
                  icon: Icons.analytics_rounded,
                  label: context.l10n.analytics,
                  isSelected: selectedIndex == 3,
                  onTap: () => onItemTap(3),
                ),
                PremiumOwnerDrawerItem(
                  icon: Icons.event_repeat_rounded,
                  label: context.l10n.subscriptions,
                  isSelected: selectedIndex == 4,
                  onTap: () => onItemTap(4),
                  badgeCount: pendingRecurringCount,
                ),
                const Divider(height: 32),
                PremiumOwnerDrawerItem(
                  icon: Icons.person_rounded,
                  label: context.l10n.profile,
                  isSelected: selectedIndex == 5,
                  onTap: () => onItemTap(5),
                ),
                PremiumOwnerDrawerItem(
                  icon: Icons.settings_rounded,
                  label: context.l10n.settings,
                  isSelected: selectedIndex == 6,
                  onTap: () => onItemTap(6),
                ),
              ],
            ),
          ),

          // Logout
          PremiumOwnerLogoutButton(onTap: onLogout),

          // Version info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              context.l10n.sportKickV100,
              style: AppTextStyles.labelSmall.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
