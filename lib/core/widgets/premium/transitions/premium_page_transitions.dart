import 'package:flutter/material.dart';

// Re-export extracted classes
export 'package:spo_kick/core/widgets/premium/transitions/premium_hero_page_route.dart';
export 'package:spo_kick/core/widgets/premium/transitions/premium_navigator_extension.dart';

/// Premium page transition factory methods.
///
/// Provides static factory methods for creating custom page routes with
/// various transition animations. Use these to create PageRouteBuilder
/// instances with consistent, polished transitions.
///
/// Available transitions:
/// - fade: Simple opacity fade transition
/// - slideFromRight: Slide in from right with fade
/// - slideFromBottom: Slide up from bottom with fade
/// - scale: Scale up with fade effect
/// - sharedAxisHorizontal: Material 3 shared axis horizontal
/// - fadeThrough: Material 3 fade through transition
class PremiumPageTransitions {
  /// Private constructor to prevent instantiation.
  PremiumPageTransitions._();

  /// Fade transition duration (300ms)
  static const Duration fadeDuration = Duration(milliseconds: 300);

  /// Slide transition duration (350ms)
  static const Duration slideDuration = Duration(milliseconds: 350);

  /// Scale transition duration (300ms)
  static const Duration scaleDuration = Duration(milliseconds: 300);

  /// Creates a fade page route.
  ///
  /// The page fades in over the specified [duration] (default: 300ms)
  /// using an [Curves.easeInOut] curve.
  static PageRouteBuilder<T> fade<T>({
    required Widget child,
    RouteSettings? settings,
    Duration? duration,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: duration ?? fadeDuration,
      reverseTransitionDuration: duration ?? fadeDuration,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: child,
        );
      },
    );
  }

  /// Creates a slide from right page route.
  ///
  /// The page slides in from the right with a combined fade and slide
  /// animation over the specified [duration] (default: 350ms).
  static PageRouteBuilder<T> slideFromRight<T>({
    required Widget child,
    RouteSettings? settings,
    Duration? duration,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: duration ?? slideDuration,
      reverseTransitionDuration: duration ?? slideDuration,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation =
            Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );

        final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: const Interval(0.0, 0.5)),
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(position: offsetAnimation, child: child),
        );
      },
    );
  }

  /// Creates a slide from bottom page route.
  ///
  /// The page slides up from the bottom with a combined fade and slide
  /// animation over the specified [duration] (default: 350ms).
  static PageRouteBuilder<T> slideFromBottom<T>({
    required Widget child,
    RouteSettings? settings,
    Duration? duration,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: duration ?? slideDuration,
      reverseTransitionDuration: duration ?? slideDuration,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation =
            Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );

        final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: const Interval(0.0, 0.5)),
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(position: offsetAnimation, child: child),
        );
      },
    );
  }

  /// Creates a scale page route.
  ///
  /// The page scales up from 0.9 to 1.0 with a fade effect over the specified
  /// [duration] (default: 300ms). The [alignment] parameter controls the
  /// scale origin point (default: center).
  static PageRouteBuilder<T> scale<T>({
    required Widget child,
    RouteSettings? settings,
    Duration? duration,
    Alignment alignment = Alignment.center,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: duration ?? scaleDuration,
      reverseTransitionDuration: duration ?? scaleDuration,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );

        final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: const Interval(0.0, 0.5)),
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            alignment: alignment,
            child: child,
          ),
        );
      },
    );
  }

  /// Creates a shared axis horizontal page route (Material 3 style).
  ///
  /// Implements the Material Design 3 shared axis transition with
  /// horizontal direction. The outgoing page exits to the left while
  /// the incoming page enters from the right.
  static PageRouteBuilder<T> sharedAxisHorizontal<T>({
    required Widget child,
    RouteSettings? settings,
    Duration? duration,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: duration ?? slideDuration,
      reverseTransitionDuration: duration ?? slideDuration,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation =
            Tween<Offset>(
              begin: const Offset(0.3, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );

        final fadeAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        );

        // Exit animation for outgoing page
        final secondaryOffsetAnimation =
            Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(-0.3, 0.0),
            ).animate(
              CurvedAnimation(
                parent: secondaryAnimation,
                curve: Curves.easeOutCubic,
              ),
            );

        final secondaryFadeAnimation = Tween<double>(begin: 1.0, end: 0.0)
            .animate(
              CurvedAnimation(
                parent: secondaryAnimation,
                curve: Curves.easeOut,
              ),
            );

        return FadeTransition(
          opacity: secondaryFadeAnimation,
          child: SlideTransition(
            position: secondaryOffsetAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(position: offsetAnimation, child: child),
            ),
          ),
        );
      },
    );
  }

  /// Creates a fade through page route (Material 3 style).
  ///
  /// Implements the Material Design 3 fade through transition. The outgoing
  /// page fades out quickly while the incoming page fades and scales in,
  /// creating a smooth transition effect.
  static PageRouteBuilder<T> fadeThrough<T>({
    required Widget child,
    RouteSettings? settings,
    Duration? duration,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: duration ?? const Duration(milliseconds: 400),
      reverseTransitionDuration: duration ?? const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Fade out + scale down for outgoing
        final secondaryFadeAnimation = Tween<double>(begin: 1.0, end: 0.0)
            .animate(
              CurvedAnimation(
                parent: secondaryAnimation,
                curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
              ),
            );

        // Fade in + scale up for incoming
        final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
          ),
        );

        final scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
          ),
        );

        return FadeTransition(
          opacity: secondaryFadeAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(scale: scaleAnimation, child: child),
          ),
        );
      },
    );
  }
}
