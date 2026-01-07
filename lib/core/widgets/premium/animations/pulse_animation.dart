import 'package:flutter/material.dart';

/// Pulse animation widget for attention-grabbing effects.
///
/// Creates a continuous pulsing scale effect that repeats indefinitely when enabled.
/// Perfect for drawing attention to important elements or indicating active/live status.
///
/// **Use Cases:**
/// - Live status indicators (online, recording)
/// - New notification badges
/// - Featured or promotion sections
/// - Call-to-action elements requiring attention
/// - Loading states with visual feedback
/// - "New" or "Hot" badges
///
/// **Parameters:**
/// - `child`: The widget to apply the pulse animation to
/// - `pulse`: Boolean to enable/disable the pulsing animation (default: true)
/// - `duration`: Duration of one complete pulse cycle (default: 1000ms)
/// - `minScale`: Minimum scale factor (default: 0.95, meaning 95% of original size)
/// - `maxScale`: Maximum scale factor (default: 1.05, meaning 105% of original size)
///
/// **Animation Behavior:**
/// When `pulse` is true:
/// - The widget continuously scales between minScale and maxScale
/// - Animation repeats indefinitely with a smooth ease-in-out curve
/// - Each complete cycle takes `duration` milliseconds
///
/// When `pulse` is false:
/// - The animation stops and the widget returns to its normal scale (1.0)
/// - Useful for conditional pulsing based on app state
///
/// **Example:**
/// ```dart
/// PulseAnimation(
///   pulse: isLive,
///   duration: Duration(milliseconds: 800),
///   minScale: 0.9,
///   maxScale: 1.1,
///   child: Container(
///     width: 16,
///     height: 16,
///     decoration: BoxDecoration(
///       color: Colors.red,
///       shape: BoxShape.circle,
///     ),
///   ),
/// )
/// ```
class PulseAnimation extends StatefulWidget {
  final Widget child;
  final bool pulse;
  final Duration duration;
  final double minScale;
  final double maxScale;

  const PulseAnimation({
    super.key,
    required this.child,
    this.pulse = true,
    this.duration = const Duration(milliseconds: 1000),
    this.minScale = 0.95,
    this.maxScale = 1.05,
  });

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.pulse) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PulseAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pulse && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.pulse && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 0.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.pulse) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(scale: _animation.value, child: child);
      },
      child: widget.child,
    );
  }
}
