import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/premium/skeletons/shimmer_loading.dart';

/// Individual stat card skeleton for dashboard loading state.
class StatCardSkeleton extends StatelessWidget {
  const StatCardSkeleton({super.key});

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
