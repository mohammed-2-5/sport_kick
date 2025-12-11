import 'package:flutter/material.dart';

/// Premium page transition definitions.
///
/// Provides custom page route transitions:
/// - Fade transition
/// - Slide transition
/// - Scale transition
/// - Combined transitions
class PremiumPageTransitions {
  PremiumPageTransitions._();

  /// Fade transition duration
  static const Duration fadeDuration = Duration(milliseconds: 300);

  /// Slide transition duration
  static const Duration slideDuration = Duration(milliseconds: 350);

  /// Scale transition duration
  static const Duration scaleDuration = Duration(milliseconds: 300);

  /// Creates a fade page route.
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

  /// Creates a shared axis horizontal page route.
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

/// Custom page route with Hero animations support.
class PremiumHeroPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  PremiumHeroPageRoute({required this.child, super.settings})
    : super(
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );

          return FadeTransition(opacity: curvedAnimation, child: child);
        },
      );
}

/// Extension for Navigator with premium transitions.
extension PremiumNavigatorExtension on NavigatorState {
  /// Push with fade transition.
  Future<T?> pushFade<T extends Object?>(Widget page) {
    return push(PremiumPageTransitions.fade<T>(child: page));
  }

  /// Push with slide from right transition.
  Future<T?> pushSlideRight<T extends Object?>(Widget page) {
    return push(PremiumPageTransitions.slideFromRight<T>(child: page));
  }

  /// Push with slide from bottom transition.
  Future<T?> pushSlideBottom<T extends Object?>(Widget page) {
    return push(PremiumPageTransitions.slideFromBottom<T>(child: page));
  }

  /// Push with scale transition.
  Future<T?> pushScale<T extends Object?>(Widget page) {
    return push(PremiumPageTransitions.scale<T>(child: page));
  }

  /// Push with fade through transition.
  Future<T?> pushFadeThrough<T extends Object?>(Widget page) {
    return push(PremiumPageTransitions.fadeThrough<T>(child: page));
  }
}
