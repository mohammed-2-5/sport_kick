import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/super_admin/presentation/constants/dashboard_colors.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/dashboard/components/activity_item.dart';

/// Activity grid displaying four activity metrics.
///
/// Shows today's bookings, pending items, new fields, and active users
/// in a horizontal grid layout.
class ActivityGrid extends StatelessWidget {
  final int todayBookings;
  final int pendingBookings;
  final int pendingFields;
  final int activeUsers;
  final VoidCallback onTap;

  const ActivityGrid({
    super.key,
    required this.todayBookings,
    required this.pendingBookings,
    required this.pendingFields,
    required this.activeUsers,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ActivityItem(
            label: context.l10n.todayBookings2,
            value: todayBookings.toString(),
            icon: Icons.event_available_rounded,
            color: DashboardColors.bookingsPrimary,
            onTap: onTap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ActivityItem(
            label: context.l10n.pending,
            value: pendingBookings.toString(),
            icon: Icons.pending_actions_rounded,
            color: DashboardColors.pendingWarning,
            showBadge: pendingBookings > 0,
            onTap: onTap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ActivityItem(
            label: context.l10n.newFields,
            value: pendingFields.toString(),
            icon: Icons.add_business_rounded,
            color: DashboardColors.fieldsSuccess,
            showBadge: pendingFields > 0,
            onTap: onTap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ActivityItem(
            label: context.l10n.activeNow,
            value: activeUsers.toString(),
            icon: Icons.person_rounded,
            color: DashboardColors.activeUsersPurple,
            isLive: true,
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}
