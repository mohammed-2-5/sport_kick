import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Shake animation widget for error states and alerts.
///
/// Creates a horizontal shake effect that can be triggered by external state changes.
/// Typically used to indicate errors, validation failures, or warning states.
///
/// **Use Cases:**
/// - Form validation errors
/// - Invalid input notifications
/// - Attention-grabbing alerts and warnings
/// - Rejection or negative feedback states
/// - Danger/error confirmation dialogs
///
/// **Parameters:**
/// - `child`: The widget to apply the shake animation to
/// - `shake`: Boolean to trigger/control the shake animation
/// - `duration`: Duration of the entire shake sequence (default: 400ms)
/// - `shakeOffset`: Horizontal offset distance in pixels (default: 10.0)
/// - `onShakeComplete`: Callback when the shake animation completes
///
/// **Animation Behavior:**
/// The widget watches the `shake` parameter. When it transitions from false to true,
/// the shake animation is triggered. The shake follows a specific pattern with multiple
/// oscillations before settling back to the original position.
///
/// **Example:**
/// ```dart
/// ShakeAnimation(
///   shake: emailError,
///   shakeOffset: 8.0,
///   onShakeComplete: () => print('Shake done'),
///   child: TextField(
///     decoration: InputDecoration(
///       labelText: 'Email',
///       errorText: emailError ? 'Invalid email' : null,
///     ),
///   ),
/// )
/// ```
class ShakeAnimation extends StatefulWidget {
  final Widget child;
  final bool shake;
  final Duration duration;
  final double shakeOffset;
  final VoidCallback? onShakeComplete;

  const ShakeAnimation({
    super.key,
    required this.child,
    this.shake = false,
    this.duration = const Duration(milliseconds: 400),
    this.shakeOffset = 10.0,
    this.onShakeComplete,
  });

  @override
  State<ShakeAnimation> createState() => _ShakeAnimationState();
}

class _ShakeAnimationState extends State<ShakeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: -1), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: -1, end: 1), weight: 2),
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: -1), weight: 2),
      TweenSequenceItem(tween: Tween<double>(begin: -1, end: 1), weight: 2),
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: 0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onShakeComplete?.call();
      }
    });
  }

  @override
  void didUpdateWidget(ShakeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shake && !oldWidget.shake) {
      HapticFeedback.mediumImpact();
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_animation.value * widget.shakeOffset, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
