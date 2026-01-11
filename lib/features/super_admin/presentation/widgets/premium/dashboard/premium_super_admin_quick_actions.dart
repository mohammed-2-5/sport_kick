import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'components/actions/section_header.dart';
import 'components/actions/quick_action.dart';
import 'components/actions/quick_action_card.dart';

/// Premium quick actions for super admin dashboard.
///
/// Features:
/// - 2-column grid with 8 management actions
/// - Gradient icons with glow
/// - Animated entrance
/// - Tap feedback
class PremiumSuperAdminQuickActions extends StatelessWidget {
  final VoidCallback onManageUsers;
  final VoidCallback onManageAdmins;
  final VoidCallback onManageFields;
  final VoidCallback onManageBookings;
  final VoidCallback onManageCities;
  final VoidCallback onViewAnalytics;
  final VoidCallback onViewReports;

  final VoidCallback onSettings;

  const PremiumSuperAdminQuickActions({
    super.key,
    required this.onManageUsers,
    required this.onManageAdmins,
    required this.onManageFields,
    required this.onManageBookings,
    required this.onManageCities,
    required this.onViewAnalytics,
    required this.onViewReports,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    final actions = [
      QuickAction(
        label: context.l10n.manageUsers,
        icon: Icons.people_rounded,
        gradient: const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        onTap: onManageUsers,
      ),
      QuickAction(
        label: context.l10n.fieldOwners2,
        icon: Icons.admin_panel_settings_rounded,
        gradient: const [AppColors.goldAccent, Color(0xFFD4A574)],
        onTap: onManageAdmins,
      ),
      QuickAction(
        label: context.l10n.allFields,
        icon: Icons.sports_soccer_rounded,
        gradient: const [Color(0xFF10B981), Color(0xFF059669)],
        onTap: onManageFields,
      ),
      QuickAction(
        label: context.l10n.allBookings,
        icon: Icons.calendar_month_rounded,
        gradient: const [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
        onTap: onManageBookings,
      ),
      QuickAction(
        label: context.l10n.cities,
        icon: Icons.location_city_rounded,
        gradient: const [Color(0xFFF59E0B), Color(0xFFEF4444)],
        onTap: onManageCities,
      ),
      QuickAction(
        label: context.l10n.analytics,
        icon: Icons.analytics_rounded,
        gradient: const [Color(0xFFEC4899), Color(0xFFBE185D)],
        onTap: onViewAnalytics,
      ),
      QuickAction(
        label: context.l10n.reports,
        icon: Icons.assessment_rounded,
        gradient: const [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
        onTap: onViewReports,
      ),
      QuickAction(
        label: context.l10n.settings,
        icon: Icons.settings_rounded,
        gradient: const [Color(0xFF64748B), Color(0xFF475569)],
        onTap: onSettings,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: context.l10n.quickActions),
          const SizedBox(height: 14),
          AnimationLimiter(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: actions.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  columnCount: 4,
                  duration: const Duration(milliseconds: 375),
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: QuickActionCard(action: actions[index]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
