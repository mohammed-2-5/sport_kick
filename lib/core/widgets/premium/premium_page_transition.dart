import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_animations.dart';

/// Premium page route builder for smooth navigation animations.
///
/// Provides consistent page transitions across the app.
/// Use with Navigator for custom transitions.
///
/// Usage:
/// ```dart
/// Navigator.of(context).push(
///   PremiumPageRoute(
///     builder: (context) => DetailsPage(),
///     type: PageTransitionType.slideFromRight,
///   ),
/// )
/// ```
class PremiumPageRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;
  final PageTransitionType type;

  PremiumPageRoute({
    required this.builder,
    this.type = PageTransitionType.slideFromRight,
    super.settings,
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) =>
             builder(context),
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return _buildTransition(
             type: type,
             animation: animation,
             child: child,
           );
         },
         transitionDuration: _getDuration(type),
       );

  static Widget _buildTransition({
    required PageTransitionType type,
    required Animation<double> animation,
    required Widget child,
  }) {
    switch (type) {
      case PageTransitionType.slideFromRight:
        return SlideTransition(
          position:
              Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: AppAnimations.fastOutSlowIn,
                ),
              ),
          child: child,
        );

      case PageTransitionType.slideFromBottom:
        return SlideTransition(
          position:
              Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: AppAnimations.easeOut,
                ),
              ),
          child: child,
        );

      case PageTransitionType.fade:
        return FadeTransition(opacity: animation, child: child);

      case PageTransitionType.scale:
        return ScaleTransition(
          scale:
              Tween<double>(
                begin: AppAnimations.scaleInStart,
                end: AppAnimations.scaleNormal,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: AppAnimations.easeOut,
                ),
              ),
          child: child,
        );

      case PageTransitionType.fadeAndSlide:
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0.0, 0.05),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: AppAnimations.easeOut,
                  ),
                ),
            child: child,
          ),
        );
    }
  }

  static Duration _getDuration(PageTransitionType type) {
    switch (type) {
      case PageTransitionType.slideFromRight:
      case PageTransitionType.fadeAndSlide:
        return AppAnimations.pageTransition;
      case PageTransitionType.slideFromBottom:
        return AppAnimations.modalTransition;
      case PageTransitionType.fade:
        return AppAnimations.normal;
      case PageTransitionType.scale:
        return AppAnimations.dialogTransition;
    }
  }
}

/// Page transition types for different navigation scenarios.
enum PageTransitionType {
  /// Slide from right - Default navigation (push)
  slideFromRight,

  /// Slide from bottom - Modals and sheets
  slideFromBottom,

  /// Fade - Settings and info pages
  fade,

  /// Scale - Dialogs and pop-ups
  scale,

  /// Fade and slide combined - Premium effect
  fadeAndSlide,
}

/// Convenience methods for common navigation patterns.
extension PremiumNavigation on BuildContext {
  /// Push with slide from right transition.
  Future<T?> pushWithSlide<T>(Widget page) {
    return Navigator.of(this).push<T>(
      PremiumPageRoute(
        builder: (_) => page,
        type: PageTransitionType.slideFromRight,
      ),
    );
  }

  /// Push modal with slide from bottom transition.
  Future<T?> pushModal<T>(Widget page) {
    return Navigator.of(this).push<T>(
      PremiumPageRoute(
        builder: (_) => page,
        type: PageTransitionType.slideFromBottom,
      ),
    );
  }

  /// Push with fade transition.
  Future<T?> pushWithFade<T>(Widget page) {
    return Navigator.of(this).push<T>(
      PremiumPageRoute(builder: (_) => page, type: PageTransitionType.fade),
    );
  }

  /// Push with scale transition.
  Future<T?> pushWithScale<T>(Widget page) {
    return Navigator.of(this).push<T>(
      PremiumPageRoute(builder: (_) => page, type: PageTransitionType.scale),
    );
  }

  /// Push with fade and slide transition.
  Future<T?> pushWithFadeAndSlide<T>(Widget page) {
    return Navigator.of(this).push<T>(
      PremiumPageRoute(
        builder: (_) => page,
        type: PageTransitionType.fadeAndSlide,
      ),
    );
  }
}
