import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/premium/skeletons/shimmer_loading.dart';

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
                child: _ListItemSkeleton(height: itemHeight),
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// Individual list item skeleton.
class _ListItemSkeleton extends StatelessWidget {
  final double height;

  const _ListItemSkeleton({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const ShimmerAvatar(size: 48),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ShimmerTextLine(width: 120, height: 16),
                const SizedBox(height: 8),
                const ShimmerTextLine(width: 180, height: 12),
              ],
            ),
          ),
          const ShimmerContainer(width: 24, height: 24, borderRadius: 6),
        ],
      ),
    );
  }
}

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
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: const _CardSkeleton(),
            );
          }),
        ),
      ),
    );
  }
}

/// Individual card skeleton.
class _CardSkeleton extends StatelessWidget {
  const _CardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          const ShimmerContainer(
            width: double.infinity,
            height: 160,
            borderRadius: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerTextLine(width: 180, height: 18),
                const SizedBox(height: 8),
                const ShimmerTextLine(width: 140, height: 14),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const ShimmerTextLine(width: 80, height: 14),
                    const ShimmerContainer(
                      width: 80,
                      height: 32,
                      borderRadius: 8,
                    ),
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

/// Grid skeleton for grid views.
class GridSkeleton extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  final double childAspectRatio;
  final EdgeInsets padding;

  const GridSkeleton({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.0,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Padding(
        padding: padding,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return const _GridItemSkeleton();
          },
        ),
      ),
    );
  }
}

/// Individual grid item skeleton.
class _GridItemSkeleton extends StatelessWidget {
  const _GridItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerContainer(width: 44, height: 44, borderRadius: 12),
          const Spacer(),
          const ShimmerTextLine(width: double.infinity, height: 16),
          const SizedBox(height: 6),
          const ShimmerTextLine(width: 80, height: 12),
        ],
      ),
    );
  }
}
