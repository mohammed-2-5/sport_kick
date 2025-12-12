import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/premium/skeletons/shimmer_loading.dart';

/// Quick action card skeleton for dashboard loading state.
class QuickActionCardSkeleton extends StatelessWidget {
  const QuickActionCardSkeleton({super.key});

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
