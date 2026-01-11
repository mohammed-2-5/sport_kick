import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/dashboard/components/activity_grid.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/dashboard/components/premium_section_header.dart';

/// Premium activity summary card for super admin dashboard.
///
/// Features:
/// - Today's activity overview
/// - Pending items counter
/// - Progress indicators
/// - Animated elements
class PremiumSuperAdminActivityCard extends StatelessWidget {
  final int todayBookings;
  final int pendingBookings;
  final int pendingFields;
  final int activeUsers;
  final VoidCallback onTap;

  const PremiumSuperAdminActivityCard({
    super.key,
    required this.todayBookings,
    required this.pendingBookings,
    required this.pendingFields,
    required this.activeUsers,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PremiumSectionHeader(title: context.l10n.todaySActivity),
          const SizedBox(height: 14),
          ActivityGrid(
            todayBookings: todayBookings,
            pendingBookings: pendingBookings,
            pendingFields: pendingFields,
            activeUsers: activeUsers,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
