import 'package:flutter/material.dart';

/// Animated switcher wrapper for smooth content transitions.
///
/// Features:
/// - Configurable animation types
/// - Smooth content switching
/// - Customizable duration and curves
class AnimatedSwitcherWrapper extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve switchInCurve;
  final Curve switchOutCurve;
  final AnimatedSwitcherTransitionBuilder? transitionBuilder;
  final AnimatedSwitcherLayoutBuilder? layoutBuilder;

  const AnimatedSwitcherWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.switchInCurve = Curves.easeOut,
    this.switchOutCurve = Curves.easeIn,
    this.transitionBuilder,
    this.layoutBuilder,
  });

  /// Factory constructor for fade transition.
  factory AnimatedSwitcherWrapper.fade({
    Key? key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return AnimatedSwitcherWrapper(
      key: key,
      duration: duration,
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: child,
    );
  }

  /// Factory constructor for scale transition.
  factory AnimatedSwitcherWrapper.scale({
    Key? key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return AnimatedSwitcherWrapper(
      key: key,
      duration: duration,
      transitionBuilder: (child, animation) => ScaleTransition(
        scale: animation,
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: child,
    );
  }

  /// Factory constructor for slide vertical transition.
  factory AnimatedSwitcherWrapper.slideVertical({
    Key? key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
    bool slideUp = true,
  }) {
    return AnimatedSwitcherWrapper(
      key: key,
      duration: duration,
      transitionBuilder: (child, animation) {
        final offsetAnimation =
            Tween<Offset>(
              begin: Offset(0, slideUp ? 0.2 : -0.2),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: offsetAnimation, child: child),
        );
      },
      child: child,
    );
  }

  /// Factory constructor for slide horizontal transition.
  factory AnimatedSwitcherWrapper.slideHorizontal({
    Key? key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
    bool slideRight = true,
  }) {
    return AnimatedSwitcherWrapper(
      key: key,
      duration: duration,
      transitionBuilder: (child, animation) {
        final offsetAnimation =
            Tween<Offset>(
              begin: Offset(slideRight ? 0.2 : -0.2, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: offsetAnimation, child: child),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: switchInCurve,
      switchOutCurve: switchOutCurve,
      transitionBuilder:
          transitionBuilder ??
          (child, animation) =>
              FadeTransition(opacity: animation, child: child),
      layoutBuilder:
          layoutBuilder ??
          (currentChild, previousChildren) {
            return Stack(
              alignment: Alignment.center,
              children: [
                ...previousChildren,
                if (currentChild != null) currentChild,
              ],
            );
          },
      child: child,
    );
  }
}

/// Animated indexed stack with smooth transitions.
class AnimatedIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  final Duration duration;
  final Curve curve;

  const AnimatedIndexedStack({
    super.key,
    required this.index,
    required this.children,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<AnimatedIndexedStack> createState() => _AnimatedIndexedStackState();
}

class _AnimatedIndexedStackState extends State<AnimatedIndexedStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(AnimatedIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index != oldWidget.index) {
      _controller.reverse().then((_) {
        setState(() => _currentIndex = widget.index);
        _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: IndexedStack(index: _currentIndex, children: widget.children),
    );
  }
}
