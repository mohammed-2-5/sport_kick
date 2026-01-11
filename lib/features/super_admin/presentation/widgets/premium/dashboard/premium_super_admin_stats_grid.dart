import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'components/stats/stat_item.dart';
import 'components/stats/stat_card.dart';

/// Premium stats grid for super admin dashboard.
///
/// Features:
/// - 2x2 grid layout with large stat cards
/// - Gradient backgrounds with glow effects
/// - Growth indicators
/// - Animated entrance
class PremiumSuperAdminStatsGrid extends StatelessWidget {
  final int totalUsers;
  final int totalAdmins;
  final int totalFields;
  final int totalBookings;
  final double userGrowth;
  final double bookingGrowth;
  final VoidCallback onUsersTap;
  final VoidCallback onAdminsTap;
  final VoidCallback onFieldsTap;
  final VoidCallback onBookingsTap;

  const PremiumSuperAdminStatsGrid({
    super.key,
    required this.totalUsers,
    required this.totalAdmins,
    required this.totalFields,
    required this.totalBookings,
    required this.userGrowth,
    required this.bookingGrowth,
    required this.onUsersTap,
    required this.onAdminsTap,
    required this.onFieldsTap,
    required this.onBookingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final stats = [
      StatItem(
        label: context.l10n.totalUsers,
        value: _formatNumber(totalUsers),
        icon: Icons.people_rounded,
        gradient: const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        growth: userGrowth,
        onTap: onUsersTap,
      ),
      StatItem(
        label: context.l10n.fieldOwners2,
        value: _formatNumber(totalAdmins),
        icon: Icons.admin_panel_settings_rounded,
        gradient: const [AppColors.goldAccent, Color(0xFFD4A574)],
        onTap: onAdminsTap,
      ),
      StatItem(
        label: context.l10n.totalFields,
        value: _formatNumber(totalFields),
        icon: Icons.sports_soccer_rounded,
        gradient: const [Color(0xFF10B981), Color(0xFF059669)],
        onTap: onFieldsTap,
      ),
      StatItem(
        label: context.l10n.totalBookings,
        value: _formatNumber(totalBookings),
        icon: Icons.calendar_month_rounded,
        gradient: const [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
        growth: bookingGrowth,
        onTap: onBookingsTap,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AnimationLimiter(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.1,
          ),
          itemCount: stats.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              columnCount: 2,
              duration: const Duration(milliseconds: 400),
              child: ScaleAnimation(
                child: FadeInAnimation(child: StatCard(stat: stats[index])),
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatNumber(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }
}
