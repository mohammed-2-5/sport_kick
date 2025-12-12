import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/premium/skeletons/shimmer_loading.dart';
import 'package:spo_kick/core/widgets/premium/skeletons/list_item_skeleton.dart';

/// List loading skeleton.
///
/// Displays shimmer placeholders for list items.
class ListSkeleton extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsets padding;
  final bool showHeader;

  const ListSkeleton({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
    this.padding = const EdgeInsets.all(16),
    this.showHeader = false,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeader) ...[
              const ShimmerTextLine(width: 150, height: 20),
              const SizedBox(height: 16),
            ],
            ...List.generate(itemCount, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ListItemSkeleton(height: itemHeight),
              );
            }),
          ],
        ),
      ),
    );
  }
}
