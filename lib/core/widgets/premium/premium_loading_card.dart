import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Premium card with shimmer loading effect.
///
/// Shows animated shimmer effect for loading states.
class PremiumLoadingCard extends StatefulWidget {
  final double height;
  final BorderRadius? borderRadius;

  const PremiumLoadingCard({super.key, this.height = 120, this.borderRadius});

  @override
  State<PremiumLoadingCard> createState() => _PremiumLoadingCardState();
}

class _PremiumLoadingCardState extends State<PremiumLoadingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.shimmerDuration,
      vsync: this,
    )..repeat();

    _animation =
        Tween<double>(
          begin: AppAnimations.shimmerBegin,
          end: AppAnimations.shimmerEnd,
        ).animate(
          CurvedAnimation(parent: _controller, curve: AppAnimations.easeInOut),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(16);

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: borderRadius,
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Stack(
              children: [
                Container(color: AppColors.shimmerBase),
                Transform.translate(
                  offset: Offset(_animation.value * 300, 0),
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.shimmerBase.withValues(alpha: 0),
                          AppColors.shimmerHighlight,
                          AppColors.shimmerBase.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
