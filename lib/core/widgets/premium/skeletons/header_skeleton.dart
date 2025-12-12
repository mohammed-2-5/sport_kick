import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/skeletons/shimmer_loading.dart';

/// Header skeleton for dashboard loading state.
class HeaderSkeleton extends StatelessWidget {
  const HeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      decoration: BoxDecoration(
        color: AppColors.shimmerBase.withValues(alpha: 0.3),
      ),
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerContainer(width: 44, height: 44, borderRadius: 12),
              ShimmerContainer(width: 44, height: 44, borderRadius: 12),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              ShimmerAvatar(size: 64),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerTextLine(width: 100, height: 12),
                    SizedBox(height: 8),
                    ShimmerTextLine(width: 150, height: 20),
                    SizedBox(height: 8),
                    ShimmerTextLine(width: 120, height: 12),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
