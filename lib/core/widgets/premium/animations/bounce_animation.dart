import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Bounce animation widget with spring-like effect.
///
/// Creates a bouncy scale animation that plays on tap, ideal for elements that
/// need to draw attention or provide playful feedback. The animation combines
/// ease-out and elastic curves to create a natural bouncing effect.
///
/// **Use Cases:**
/// - Playful interactive elements (badges, icons)
/// - Fun confirmation or success indicators
/// - Call-to-action buttons that need visual emphasis
/// - Animated badges and notification counters
/// - Interactive game-like UI elements
///
/// **Parameters:**
/// - `child`: The widget to apply the bounce animation to
/// - `onTap`: Callback when the animation completes and tap happens
/// - `duration`: Duration of the entire bounce animation (default: 200ms)
/// - `bounceScale`: Maximum scale factor when bouncing (default: 1.1, meaning 110% of original size)
///
/// **Animation Sequence:**
/// The animation plays in two phases:
/// 1. Scale up to `bounceScale` with ease-out curve (50% of duration)
/// 2. Scale back to 1.0 with elastic-out curve (50% of duration)
///
/// **Example:**
/// ```dart
/// BounceAnimation(
///   bounceScale: 1.15,
///   onTap: () => print('Bounced!'),
///   child: Icon(Icons.favorite),
/// )
/// ```
class BounceAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Duration duration;
  final double bounceScale;

  const BounceAnimation({
    super.key,
    required this.child,
    this.onTap,
    this.duration = const Duration(milliseconds: 200),
    this.bounceScale = 1.1,
  });

  @override
  State<BounceAnimation> createState() => _BounceAnimationState();
}

class _BounceAnimationState extends State<BounceAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: widget.bounceScale,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: widget.bounceScale,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playAnimation() {
    _controller.forward(from: 0.0);
    HapticFeedback.lightImpact();
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _playAnimation,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(scale: _animation.value, child: child);
        },
        child: widget.child,
      ),
    );
  }
}
