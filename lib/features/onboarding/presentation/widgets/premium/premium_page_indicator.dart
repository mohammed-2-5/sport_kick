import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Premium page indicator dots.
///
/// Features:
/// - Animated dot expansion
/// - Gradient active dot
/// - Smooth transitions
class PremiumPageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const PremiumPageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => _IndicatorDot(
          isActive: index == currentIndex,
          isPassed: index < currentIndex,
        ),
      ),
    );
  }
}

/// Individual indicator dot.
class _IndicatorDot extends StatelessWidget {
  final bool isActive;
  final bool isPassed;

  const _IndicatorDot({required this.isActive, required this.isPassed});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: isActive ? 32 : 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: isActive || isPassed
            ? const LinearGradient(
                colors: [AppColors.accentCyan, AppColors.accentCyanDark],
              )
            : null,
        color: isActive || isPassed
            ? null
            : Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.accentCyan.withValues(alpha: 0.4),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
    );
  }
}
