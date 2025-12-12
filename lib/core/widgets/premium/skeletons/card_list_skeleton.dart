import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/premium/skeletons/shimmer_loading.dart';
import 'package:spo_kick/core/widgets/premium/skeletons/card_skeleton.dart';

/// Card list skeleton with larger items.
class CardListSkeleton extends StatelessWidget {
  final int itemCount;
  final EdgeInsets padding;

  const CardListSkeleton({
    super.key,
    this.itemCount = 3,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Padding(
        padding: padding,
        child: Column(
          children: List.generate(itemCount, (index) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: CardSkeleton(),
            );
          }),
        ),
      ),
    );
  }
}
