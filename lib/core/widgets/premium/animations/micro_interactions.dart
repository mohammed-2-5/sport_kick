// Micro-interactions animation widgets library.
//
// This library provides a collection of reusable animation widgets for creating
// smooth, polished user interactions. Each animation is designed for specific
// UI patterns and can be easily integrated into any Flutter application.
//
// Available Animations:
// - TapScaleAnimation: Scale-down effect on tap with haptic feedback
// - BounceAnimation: Spring-like bounce effect on interaction
// - ShakeAnimation: Horizontal shake for error states
// - PulseAnimation: Continuous pulsing effect for attention
// - SlideInAnimation: Slide and fade entrance animation
//
// Quick Start:
// import 'package:spo_kick/core/widgets/premium/animations/micro_interactions.dart';
//
// Use any animation like:
// TapScaleAnimation(
//   child: MyButton(),
//   onTap: () => print('Tapped!'),
// )
//
// Design Principles:
// - Each animation is self-contained in its own file
// - Animations are composable and can be nested
// - All animations use efficient Flutter primitives
// - Haptic feedback is integrated where appropriate
// - Customizable timing and intensity parameters

export 'tap_scale_animation.dart';
export 'bounce_animation.dart';
export 'shake_animation.dart';
export 'pulse_animation.dart';
export 'slide_in_animation.dart';
