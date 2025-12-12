import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/premium/skeletons/shimmer_loading.dart';
import 'package:spo_kick/core/widgets/premium/skeletons/quick_action_card_skeleton.dart';

/// Quick actions skeleton for dashboard loading state.
class QuickActionsSkeleton extends StatelessWidget {
  const QuickActionsSkeleton({super.key});

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
              return const QuickActionCardSkeleton();
            },
          ),
        ],
      ),
    );
  }
}
