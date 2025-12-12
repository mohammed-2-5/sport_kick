import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/premium/skeletons/stat_card_skeleton.dart';

/// Stats row skeleton for dashboard loading state.
class StatsRowSkeleton extends StatelessWidget {
  const StatsRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 4,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return const StatCardSkeleton();
        },
      ),
    );
  }
}
