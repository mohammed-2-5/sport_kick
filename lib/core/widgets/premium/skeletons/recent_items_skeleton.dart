import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/premium/skeletons/shimmer_loading.dart';
import 'package:spo_kick/core/widgets/premium/skeletons/recent_item_card_skeleton.dart';

/// Recent items skeleton for dashboard loading state.
class RecentItemsSkeleton extends StatelessWidget {
  const RecentItemsSkeleton({super.key});

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
              child: RecentItemCardSkeleton(),
            );
          }),
        ],
      ),
    );
  }
}
