import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/premium/skeletons/shimmer_loading.dart';
import 'package:spo_kick/core/widgets/premium/skeletons/header_skeleton.dart';
import 'package:spo_kick/core/widgets/premium/skeletons/stats_row_skeleton.dart';
import 'package:spo_kick/core/widgets/premium/skeletons/quick_actions_skeleton.dart';
import 'package:spo_kick/core/widgets/premium/skeletons/recent_items_skeleton.dart';

/// Dashboard loading skeleton.
///
/// Displays a shimmer skeleton while dashboard data loads.
class DashboardSkeleton extends StatelessWidget {
  final bool showHeader;
  final bool showStats;
  final bool showQuickActions;
  final bool showRecentItems;

  const DashboardSkeleton({
    super.key,
    this.showHeader = true,
    this.showStats = true,
    this.showQuickActions = true,
    this.showRecentItems = true,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            if (showHeader) const HeaderSkeleton(),
            if (showStats) ...[
              const SizedBox(height: 20),
              const StatsRowSkeleton(),
            ],
            if (showQuickActions) ...[
              const SizedBox(height: 24),
              const QuickActionsSkeleton(),
            ],
            if (showRecentItems) ...[
              const SizedBox(height: 24),
              const RecentItemsSkeleton(),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
