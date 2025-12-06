import 'package:flutter/animation.dart';

/// Animation constants for consistent timing and curves across the app.
///
/// Provides centralized animation configuration following Material Design
/// motion guidelines for a cohesive user experience.
///
/// Usage:
/// ```dart
/// AnimationController(
///   duration: AppAnimations.normal,
///   vsync: this,
/// )
/// ```
class AppAnimations {
  // Prevent instantiation
  AppAnimations._();

  // ==================== DURATIONS ====================

  /// Extra fast duration for instant feedback (100ms)
  static const Duration instant = Duration(milliseconds: 100);

  /// Fast duration for micro-interactions (200ms)
  static const Duration fast = Duration(milliseconds: 200);

  /// Normal duration for standard transitions (300ms)
  static const Duration normal = Duration(milliseconds: 300);

  /// Medium duration for card animations (400ms)
  static const Duration medium = Duration(milliseconds: 400);

  /// Slow duration for page transitions (500ms)
  static const Duration slow = Duration(milliseconds: 500);

  /// Extra slow duration for complex animations (800ms)
  static const Duration extraSlow = Duration(milliseconds: 800);

  // ==================== STAGGER DELAYS ====================

  /// Delay between staggered list items (50ms)
  static const Duration staggerDelay = Duration(milliseconds: 50);

  /// Short delay for quick sequences (30ms)
  static const Duration shortStagger = Duration(milliseconds: 30);

  /// Long delay for dramatic effect (100ms)
  static const Duration longStagger = Duration(milliseconds: 100);

  // ==================== CURVES ====================

  /// Standard ease in and out curve
  static const Curve easeInOut = Curves.easeInOut;

  /// Smooth ease out curve for entrances
  static const Curve easeOut = Curves.easeOut;

  /// Quick ease in curve for exits
  static const Curve easeIn = Curves.easeIn;

  /// Bouncy curve for playful interactions
  static const Curve bounceOut = Curves.bounceOut;

  /// Elastic curve for spring-like motion
  static const Curve elasticOut = Curves.elasticOut;

  /// Fast out, slow in for Material Design
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;

  /// Deceleration curve
  static const Curve decelerate = Curves.decelerate;

  // ==================== OFFSETS ====================

  /// Standard slide offset for bottom-to-top animations
  static const Offset slideUpOffset = Offset(0, 50);

  /// Standard slide offset for top-to-bottom animations
  static const Offset slideDownOffset = Offset(0, -50);

  /// Standard slide offset for right-to-left animations
  static const Offset slideLeftOffset = Offset(50, 0);

  /// Standard slide offset for left-to-right animations
  static const Offset slideRightOffset = Offset(-50, 0);

  // ==================== SCALE VALUES ====================

  /// Scale for button press effect
  static const double buttonPressScale = 0.96;

  /// Scale for card tap effect
  static const double cardTapScale = 0.98;

  /// Scale for icon bounce
  static const double iconBounceScale = 1.2;

  /// Initial scale for zoom in animations
  static const double scaleInStart = 0.8;

  /// Final scale for normal state
  static const double scaleNormal = 1.0;

  // ==================== FLOATING ANIMATION ====================

  /// Vertical offset for floating animations (up)
  static const double floatUp = -10.0;

  /// Vertical offset for floating animations (down)
  static const double floatDown = 10.0;

  /// Duration for floating animation cycle
  static const Duration floatDuration = Duration(milliseconds: 2000);

  // ==================== ROTATION ====================

  /// Quarter turn rotation (90 degrees)
  static const double quarterTurn = 0.25;

  /// Half turn rotation (180 degrees)
  static const double halfTurn = 0.5;

  /// Full turn rotation (360 degrees)
  static const double fullTurn = 1.0;

  // ==================== SHIMMER ====================

  /// Duration for shimmer loading animation
  static const Duration shimmerDuration = Duration(milliseconds: 1500);

  /// Begin value for shimmer gradient
  static const double shimmerBegin = -1.0;

  /// End value for shimmer gradient
  static const double shimmerEnd = 2.0;

  // ==================== PAGE TRANSITIONS ====================

  /// Duration for page route transitions
  static const Duration pageTransition = Duration(milliseconds: 350);

  /// Duration for modal bottom sheet
  static const Duration modalTransition = Duration(milliseconds: 400);

  /// Duration for dialog animations
  static const Duration dialogTransition = Duration(milliseconds: 250);
}
