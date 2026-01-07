import 'package:flutter/material.dart';

/// Slide in animation widget with fade effect.
///
/// Animates a child widget sliding in from a specified direction with a fade-in
/// transition. Supports delays and various slide directions via factory constructors.
/// Ideal for entrance animations in list items, dialogs, and page transitions.
///
/// **Use Cases:**
/// - List item entrance animations
/// - Dialog and bottom sheet animations
/// - Page transition effects
/// - Staggered animations (using delay)
/// - Card and content entrance effects
/// - Animated navigation transitions
///
/// **Parameters:**
/// - `child`: The widget to animate
/// - `duration`: Duration of the slide and fade animation (default: 400ms)
/// - `delay`: Delay before animation starts (default: zero)
/// - `beginOffset`: Starting position offset (default: Offset(0, 0.3) - from bottom)
/// - `curve`: Animation curve for slide transition (default: Curves.easeOutCubic)
///
/// **Factory Constructors:**
/// - `SlideInAnimation()`: Default slide from bottom with fade
/// - `SlideInAnimation.fromLeft()`: Slide from left edge
/// - `SlideInAnimation.fromRight()`: Slide from right edge
/// - `SlideInAnimation.fromBottom()`: Slide from bottom edge
/// - `SlideInAnimation.fromTop()`: Slide from top edge
///
/// **Animation Behavior:**
/// The animation combines two effects:
/// 1. **Slide Transition**: Moves from `beginOffset` to Offset.zero
/// 2. **Fade Transition**: Fades in from 0.0 to 1.0 (first half of animation duration)
///
/// **Example - Basic Usage:**
/// ```dart
/// SlideInAnimation.fromBottom(
///   duration: Duration(milliseconds: 500),
///   child: MyCard(),
/// )
/// ```
///
/// **Example - Staggered List Animation:**
/// ```dart
/// ListView.builder(
///   itemCount: items.length,
///   itemBuilder: (context, index) {
///     return SlideInAnimation.fromBottom(
///       delay: Duration(milliseconds: index * 100),
///       child: ListTile(title: Text(items[index])),
///     );
///   },
/// )
/// ```
///
/// **Example - Custom Direction and Curve:**
/// ```dart
/// SlideInAnimation(
///   beginOffset: Offset(-0.5, 0),
///   duration: Duration(milliseconds: 600),
///   curve: Curves.easeOut,
///   child: MyWidget(),
/// )
/// ```
class SlideInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Offset beginOffset;
  final Curve curve;

  const SlideInAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.delay = Duration.zero,
    this.beginOffset = const Offset(0, 0.3),
    this.curve = Curves.easeOutCubic,
  });

  /// Factory constructor for slide animation from left.
  ///
  /// Animates the child sliding in from the left edge with fade.
  ///
  /// **Example:**
  /// ```dart
  /// SlideInAnimation.fromLeft(
  ///   child: MyWidget(),
  ///   delay: Duration(milliseconds: 200),
  /// )
  /// ```
  factory SlideInAnimation.fromLeft({
    Key? key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 400),
    Duration delay = Duration.zero,
  }) {
    return SlideInAnimation(
      key: key,
      duration: duration,
      delay: delay,
      beginOffset: const Offset(-0.3, 0),
      child: child,
    );
  }

  /// Factory constructor for slide animation from right.
  ///
  /// Animates the child sliding in from the right edge with fade.
  ///
  /// **Example:**
  /// ```dart
  /// SlideInAnimation.fromRight(
  ///   child: MyWidget(),
  ///   duration: Duration(milliseconds: 500),
  /// )
  /// ```
  factory SlideInAnimation.fromRight({
    Key? key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 400),
    Duration delay = Duration.zero,
  }) {
    return SlideInAnimation(
      key: key,
      duration: duration,
      delay: delay,
      beginOffset: const Offset(0.3, 0),
      child: child,
    );
  }

  /// Factory constructor for slide animation from bottom.
  ///
  /// Animates the child sliding in from the bottom edge with fade.
  /// This is the default animation direction.
  ///
  /// **Example:**
  /// ```dart
  /// SlideInAnimation.fromBottom(
  ///   child: MyWidget(),
  /// )
  /// ```
  factory SlideInAnimation.fromBottom({
    Key? key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 400),
    Duration delay = Duration.zero,
  }) {
    return SlideInAnimation(
      key: key,
      duration: duration,
      delay: delay,
      beginOffset: const Offset(0, 0.3),
      child: child,
    );
  }

  /// Factory constructor for slide animation from top.
  ///
  /// Animates the child sliding in from the top edge with fade.
  ///
  /// **Example:**
  /// ```dart
  /// SlideInAnimation.fromTop(
  ///   child: MyWidget(),
  ///   delay: Duration(milliseconds: 150),
  /// )
  /// ```
  factory SlideInAnimation.fromTop({
    Key? key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 400),
    Duration delay = Duration.zero,
  }) {
    return SlideInAnimation(
      key: key,
      duration: duration,
      delay: delay,
      beginOffset: const Offset(0, -0.3),
      child: child,
    );
  }

  @override
  State<SlideInAnimation> createState() => _SlideInAnimationState();
}

class _SlideInAnimationState extends State<SlideInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _offsetAnimation = Tween<Offset>(
      begin: widget.beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5)),
    );

    if (widget.delay > Duration.zero) {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.forward();
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
      opacity: _fadeAnimation,
      child: SlideTransition(position: _offsetAnimation, child: widget.child),
    );
  }
}
