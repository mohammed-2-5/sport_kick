import 'package:flutter/material.dart';

/// Animated page view with smooth transitions.
///
/// Features:
/// - Fade transition between pages
/// - Slide animation based on direction
/// - Keeps pages in memory with IndexedStack
class AnimatedPageView extends StatelessWidget {
  final int currentIndex;
  final int previousIndex;
  final List<Widget> children;
  final Duration duration;
  final Curve curve;

  const AnimatedPageView({
    super.key,
    required this.currentIndex,
    required this.previousIndex,
    required this.children,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    final isForward = currentIndex > previousIndex;

    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: curve,
      switchOutCurve: curve,
      transitionBuilder: (child, animation) {
        final slideAnimation = Tween<Offset>(
          begin: Offset(isForward ? 0.1 : -0.1, 0),
          end: Offset.zero,
        ).animate(animation);

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: slideAnimation, child: child),
        );
      },
      child: IndexedStack(
        key: ValueKey<int>(currentIndex),
        index: currentIndex,
        children: children,
      ),
    );
  }
}

/// Page transition wrapper for individual pages.
class PageTransitionWrapper extends StatelessWidget {
  final Widget child;
  final bool isActive;

  const PageTransitionWrapper({
    super.key,
    required this.child,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isActive ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: AnimatedScale(
        scale: isActive ? 1.0 : 0.95,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: child,
      ),
    );
  }
}
