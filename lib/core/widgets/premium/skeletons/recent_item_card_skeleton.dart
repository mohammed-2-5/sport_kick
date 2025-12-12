import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/premium/skeletons/shimmer_loading.dart';

/// Recent item card skeleton for dashboard loading state.
class RecentItemCardSkeleton extends StatelessWidget {
  const RecentItemCardSkeleton({super.key});

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
