import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/premium/skeletons/shimmer_loading.dart';

/// Individual grid item skeleton.
class GridItemSkeleton extends StatelessWidget {
  const GridItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(14),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerContainer(width: 44, height: 44, borderRadius: 12),
          Spacer(),
          ShimmerTextLine(width: double.infinity, height: 16),
          SizedBox(height: 6),
          ShimmerTextLine(width: 80, height: 12),
        ],
      ),
    );
  }
}
