import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Haptic feedback types for interactive feedback.
///
/// Provides different intensity levels and interaction types for haptic feedback.
enum HapticFeedbackType { light, medium, heavy, selection }

/// Tap scale animation widget with haptic feedback.
///
/// Provides a scale-down effect when tapped, creating an interactive button-like
/// experience. Includes optional haptic feedback on tap and long press.
///
/// **Use Cases:**
/// - Interactive buttons and touchable elements
/// - Forms and input fields that need visual feedback
/// - Action buttons in modals and sheets
/// - Any element that needs tactile confirmation on interaction
///
/// **Parameters:**
/// - `child`: The widget to apply the scale animation to
/// - `onTap`: Callback when the widget is tapped
/// - `onLongPress`: Callback when the widget is long pressed
/// - `scaleDown`: Scale factor when pressed (default: 0.95, meaning 95% of original size)
/// - `duration`: Duration of the scale animation (default: 100ms)
/// - `enableHaptic`: Whether to trigger haptic feedback (default: true)
/// - `hapticType`: Type of haptic feedback to use (default: light)
///
/// **Example:**
/// ```dart
/// TapScaleAnimation(
///   child: MyButton(),
///   onTap: () => print('Tapped!'),
///   scaleDown: 0.92,
///   hapticType: HapticFeedbackType.medium,
/// )
/// ```
class TapScaleAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double scaleDown;
  final Duration duration;
  final bool enableHaptic;
  final HapticFeedbackType hapticType;

  const TapScaleAnimation({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.scaleDown = 0.95,
    this.duration = const Duration(milliseconds: 100),
    this.enableHaptic = true,
    this.hapticType = HapticFeedbackType.light,
  });

  @override
  State<TapScaleAnimation> createState() => _TapScaleAnimationState();
}

class _TapScaleAnimationState extends State<TapScaleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleDown,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _triggerHaptic() {
    if (!widget.enableHaptic) return;

    switch (widget.hapticType) {
      case HapticFeedbackType.light:
        HapticFeedback.lightImpact();
        break;
      case HapticFeedbackType.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticFeedbackType.heavy:
        HapticFeedback.heavyImpact();
        break;
      case HapticFeedbackType.selection:
        HapticFeedback.selectionClick();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () {
        _triggerHaptic();
        widget.onTap?.call();
      },
      onLongPress: widget.onLongPress != null
          ? () {
              _triggerHaptic();
              widget.onLongPress?.call();
            }
          : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: widget.child,
      ),
    );
  }
}
