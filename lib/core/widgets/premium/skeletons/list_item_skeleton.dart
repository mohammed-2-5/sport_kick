import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/premium/skeletons/shimmer_loading.dart';

/// Individual list item skeleton.
class ListItemSkeleton extends StatelessWidget {
  final double height;

  const ListItemSkeleton({super.key, this.height = 80});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          ShimmerAvatar(size: 48),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShimmerTextLine(width: 120, height: 16),
                SizedBox(height: 8),
                ShimmerTextLine(width: 180, height: 12),
              ],
            ),
          ),
          ShimmerContainer(width: 24, height: 24, borderRadius: 6),
        ],
      ),
    );
  }
}
