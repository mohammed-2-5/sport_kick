import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/premium/transitions/premium_page_transitions.dart';

/// Extension methods for NavigatorState with premium page transitions.
///
/// Provides convenient push methods with various premium transition animations.
/// Use these methods instead of [Navigator.push] to apply consistent transition
/// effects throughout the app.
///
/// Example:
/// ```dart
/// Navigator.of(context).pushFade(const DetailPage());
/// Navigator.of(context).pushSlideRight(const SettingsPage());
/// ```
extension PremiumNavigatorExtension on NavigatorState {
  /// Push a page with fade transition.
  ///
  /// The page fades in with [Curves.easeInOut] curve over 300ms.
  Future<T?> pushFade<T extends Object?>(Widget page) {
    return push(PremiumPageTransitions.fade<T>(child: page));
  }

  /// Push a page with slide from right transition.
  ///
  /// The page slides in from the right with combined fade and slide animations
  /// over 350ms.
  Future<T?> pushSlideRight<T extends Object?>(Widget page) {
    return push(PremiumPageTransitions.slideFromRight<T>(child: page));
  }

  /// Push a page with slide from bottom transition.
  ///
  /// The page slides up from the bottom with combined fade and slide animations
  /// over 350ms.
  Future<T?> pushSlideBottom<T extends Object?>(Widget page) {
    return push(PremiumPageTransitions.slideFromBottom<T>(child: page));
  }

  /// Push a page with scale transition.
  ///
  /// The page scales up from 0.9 to 1.0 with fade animation over 300ms.
  Future<T?> pushScale<T extends Object?>(Widget page) {
    return push(PremiumPageTransitions.scale<T>(child: page));
  }

  /// Push a page with fade through transition (Material 3 style).
  ///
  /// The outgoing page fades out and scales down while the incoming page
  /// fades in and scales up over 400ms, creating a smooth fade-through effect.
  Future<T?> pushFadeThrough<T extends Object?>(Widget page) {
    return push(PremiumPageTransitions.fadeThrough<T>(child: page));
  }
}
