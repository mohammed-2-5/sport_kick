import 'package:flutter/material.dart';

/// Custom page route with fade transition for Hero animations support.
///
/// Extends [PageRouteBuilder] to provide a custom page route with fade
/// transition animation. Useful for pages that contain Hero-animated widgets
/// or when a fade transition is desired.
///
/// The route applies a fade transition with [Curves.easeOutCubic] curve and
/// 400ms duration for both forward and reverse animations.
///
/// Example:
/// ```dart
/// Navigator.push(
///   context,
///   PremiumHeroPageRoute(
///     child: const DetailPage(),
///   ),
/// )
/// ```
class PremiumHeroPageRoute<T> extends PageRouteBuilder<T> {
  /// The widget to display on this route.
  final Widget child;

  /// Creates a premium hero page route.
  ///
  /// The [child] is required and cannot be null.
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
