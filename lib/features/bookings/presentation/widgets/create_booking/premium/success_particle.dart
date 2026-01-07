import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Animated particle for confetti effect in success overlay.
class SuccessParticle extends StatelessWidget {
  final AnimationController controller;
  final int index;

  const SuccessParticle({
    super.key,
    required this.controller,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final random = math.Random(index);
    final startX = random.nextDouble() * MediaQuery.of(context).size.width;
    final size = 6.0 + random.nextDouble() * 6;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final color = [
      colorScheme.primary,
      isDark ? AppColors.darkSuccess : AppColors.success,
      isDark ? AppColors.darkWarning : AppColors.warning,
      colorScheme.tertiary,
    ][index % 4];

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final progress = (controller.value + index / 20) % 1.0;
        final y = -50 + progress * (MediaQuery.of(context).size.height + 100);
        final x = startX + math.sin(progress * math.pi * 4) * 30;
        final opacity = progress < 0.8 ? 1.0 : (1.0 - progress) * 5;
        final rotation = progress * math.pi * 4;

        return Positioned(
          left: x,
          top: y,
          child: Transform.rotate(
            angle: rotation,
            child: Opacity(
              opacity: opacity.clamp(0.0, 1.0),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
