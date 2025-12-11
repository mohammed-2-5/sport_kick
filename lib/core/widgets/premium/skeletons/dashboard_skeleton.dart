import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/skeletons/shimmer_loading.dart';

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
            if (showHeader) const _HeaderSkeleton(),
            if (showStats) ...[
              const SizedBox(height: 20),
              const _StatsRowSkeleton(),
            ],
            if (showQuickActions) ...[
              const SizedBox(height: 24),
              const _QuickActionsSkeleton(),
            ],
            if (showRecentItems) ...[
              const SizedBox(height: 24),
              const _RecentItemsSkeleton(),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

/// Header skeleton.
class _HeaderSkeleton extends StatelessWidget {
  const _HeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      decoration: BoxDecoration(
        color: AppColors.shimmerBase.withValues(alpha: 0.3),
      ),
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerContainer(width: 44, height: 44, borderRadius: 12),
              ShimmerContainer(width: 44, height: 44, borderRadius: 12),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              ShimmerAvatar(size: 64),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerTextLine(width: 100, height: 12),
                    SizedBox(height: 8),
                    ShimmerTextLine(width: 150, height: 20),
                    SizedBox(height: 8),
                    ShimmerTextLine(width: 120, height: 12),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Stats row skeleton.
class _StatsRowSkeleton extends StatelessWidget {
  const _StatsRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 4,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return const _StatCardSkeleton();
        },
      ),
    );
  }
}

/// Individual stat card skeleton.
class _StatCardSkeleton extends StatelessWidget {
  const _StatCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerContainer(width: 36, height: 36, borderRadius: 10),
          Spacer(),
          ShimmerTextLine(width: 60, height: 24),
          SizedBox(height: 4),
          ShimmerTextLine(width: 80, height: 12),
        ],
      ),
    );
  }
}

/// Quick actions skeleton.
class _QuickActionsSkeleton extends StatelessWidget {
  const _QuickActionsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              ShimmerContainer(width: 4, height: 20, borderRadius: 2),
              SizedBox(width: 10),
              ShimmerTextLine(width: 120, height: 18),
            ],
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.6,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return const _QuickActionCardSkeleton();
            },
          ),
        ],
      ),
    );
  }
}

/// Quick action card skeleton.
class _QuickActionCardSkeleton extends StatelessWidget {
  const _QuickActionCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerContainer(width: 40, height: 40, borderRadius: 10),
          Spacer(),
          ShimmerTextLine(width: 80, height: 13),
        ],
      ),
    );
  }
}

/// Recent items skeleton.
class _RecentItemsSkeleton extends StatelessWidget {
  const _RecentItemsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ShimmerContainer(width: 4, height: 20, borderRadius: 2),
                  SizedBox(width: 10),
                  ShimmerTextLine(width: 140, height: 18),
                ],
              ),
              ShimmerTextLine(width: 60, height: 13),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(3, (_) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: _RecentItemCardSkeleton(),
            );
          }),
        ],
      ),
    );
  }
}

/// Recent item card skeleton.
class _RecentItemCardSkeleton extends StatelessWidget {
  const _RecentItemCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          ShimmerContainer(width: 4, height: 50, borderRadius: 2),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerTextLine(width: 100, height: 14),
                    ShimmerContainer(width: 60, height: 20, borderRadius: 6),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    ShimmerContainer(width: 14, height: 14, borderRadius: 4),
                    SizedBox(width: 4),
                    ShimmerTextLine(width: 80, height: 12),
                    SizedBox(width: 12),
                    ShimmerContainer(width: 14, height: 14, borderRadius: 4),
                    SizedBox(width: 4),
                    ShimmerTextLine(width: 60, height: 12),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
