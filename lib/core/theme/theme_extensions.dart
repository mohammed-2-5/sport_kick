import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Theme Extensions for easy access to theme-aware colors
///
/// Usage:
/// ```dart
/// // Instead of AppColors.textPrimary
/// context.colors.onSurface
///
/// // Instead of AppColors.primary
/// context.colors.primary
///
/// // Instead of AppColors.cardBackground
/// context.colors.surface
///
/// // For semantic colors (success/error/warning)
/// context.colors.success
/// context.colors.successContainer
///
/// // For shadows that adapt to theme
/// context.cardShadow
/// context.subtleShadow
/// ```
extension ThemeExtension on BuildContext {
  /// Get the current theme data
  ThemeData get theme => Theme.of(this);

  /// Get the current color scheme
  ColorScheme get colors => Theme.of(this).colorScheme;

  /// Get the current text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Check if current theme is dark mode
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Check if current theme is light mode
  bool get isLightMode => Theme.of(this).brightness == Brightness.light;

  // ==================== SHADOW HELPERS ====================

  /// Card shadow - subtle elevation shadow that adapts to theme
  /// Use instead of hardcoded BoxShadow with Colors.black
  List<BoxShadow> get cardShadow => isDarkMode
      ? [] // Dark mode: no shadow, use borders instead
      : [
          BoxShadow(
            color: Colors.black.withAlpha(13), // ~5% opacity
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ];

  /// Subtle shadow for hover/pressed states
  List<BoxShadow> get subtleShadow => isDarkMode
      ? []
      : [
          BoxShadow(
            color: Colors.black.withAlpha(8), // ~3% opacity
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ];

  /// Elevated shadow for dialogs/modals
  List<BoxShadow> get elevatedShadow => isDarkMode
      ? []
      : [
          BoxShadow(
            color: Colors.black.withAlpha(26), // ~10% opacity
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ];

  // ==================== GRADIENT HELPERS ====================

  /// Navy gradient for headers - adapts to dark theme
  LinearGradient get navyGradient =>
      isDarkMode ? AppColors.darkNavyGradient : AppColors.navyGradient;

  /// Primary gradient - adapts to dark theme
  LinearGradient get primaryGradient =>
      isDarkMode ? AppColors.darkPrimaryGradient : AppColors.primaryGradient;

  /// Shimmer gradient - adapts to dark theme
  LinearGradient get shimmerGradient =>
      isDarkMode ? AppColors.darkShimmerGradient : AppColors.shimmerGradient;

  // ==================== OVERLAY HELPERS ====================

  /// Overlay color for modals/dialogs
  Color get overlayColor =>
      isDarkMode ? AppColors.darkOverlay : AppColors.overlay;

  /// Scrim color for bottom sheets
  Color get scrimColor => isDarkMode
      ? Colors.black.withAlpha(179) // ~70% opacity
      : Colors.black.withAlpha(128); // ~50% opacity
}

/// Color mapping helpers for migration from AppColors to theme-aware colors
///
/// This extension provides semantic color access that automatically
/// adapts to light/dark theme.
extension SemanticColors on ColorScheme {
  // ==================== TEXT COLORS ====================

  /// Primary text color (replaces AppColors.textPrimary)
  Color get textPrimary => onSurface;

  /// Secondary text color (replaces AppColors.textSecondary)
  Color get textSecondary => onSurfaceVariant;

  /// Disabled text color (replaces AppColors.textDisabled)
  Color get textDisabled => onSurface.withAlpha(97); // ~38% opacity

  /// Text on primary color background
  Color get textOnPrimary => onPrimary;

  // ==================== BACKGROUND COLORS ====================

  /// Card background (replaces AppColors.cardBackground)
  Color get cardBackground => surface;

  /// Page background (replaces AppColors.scaffoldBackground)
  Color get pageBackground => surface;

  /// Elevated surface (replaces AppColors.backgroundLight in elevated contexts)
  Color get elevatedSurface => surfaceContainerHighest;

  // ==================== SEMANTIC COLORS ====================

  /// Success color (adapts to dark theme)
  Color get success =>
      brightness == Brightness.dark ? AppColors.darkSuccess : AppColors.success;

  /// Success container/background color
  Color get successContainer => brightness == Brightness.dark
      ? AppColors.darkSuccessContainer
      : AppColors.successContainer;

  /// On success (text/icon on success background)
  Color get onSuccess => brightness == Brightness.dark
      ? AppColors.darkOnSuccess
      : AppColors.onSuccess;

  /// Warning color (adapts to dark theme)
  Color get warning =>
      brightness == Brightness.dark ? AppColors.darkWarning : AppColors.warning;

  /// Warning container/background color
  Color get warningContainer => brightness == Brightness.dark
      ? AppColors.darkWarningContainer
      : AppColors.warningContainer;

  /// On warning (text/icon on warning background)
  Color get onWarning => brightness == Brightness.dark
      ? AppColors.darkOnWarning
      : AppColors.onWarning;

  /// Info color (adapts to dark theme)
  Color get info =>
      brightness == Brightness.dark ? AppColors.darkInfo : AppColors.info;

  /// Info container/background color
  Color get infoContainer => brightness == Brightness.dark
      ? AppColors.darkInfoContainer
      : AppColors.infoContainer;

  /// On info (text/icon on info background)
  Color get onInfo =>
      brightness == Brightness.dark ? AppColors.darkOnInfo : AppColors.onInfo;

  // ==================== STATUS BADGE HELPERS ====================

  /// Get background color with opacity for status badges
  /// Usage: colorScheme.statusBadgeBackground(colorScheme.success)
  Color statusBadgeBackground(Color statusColor) =>
      statusColor.withAlpha(26); // ~10% opacity

  // ==================== BORDER COLORS ====================

  /// Border/outline color (replaces AppColors.border)
  Color get border => outline;

  /// Divider color (replaces AppColors.divider)
  Color get divider => outlineVariant;

  // ==================== SHIMMER COLORS ====================

  /// Shimmer base color
  Color get shimmerBase => brightness == Brightness.dark
      ? AppColors.darkShimmerBase
      : AppColors.shimmerBase;

  /// Shimmer highlight color
  Color get shimmerHighlight => brightness == Brightness.dark
      ? AppColors.darkShimmerHighlight
      : AppColors.shimmerHighlight;

  // ==================== INACTIVE/DISABLED STATES ====================

  /// Inactive toggle/switch track color
  Color get inactiveTrack => brightness == Brightness.dark
      ? onSurfaceVariant.withAlpha(77) // ~30% opacity
      : onSurfaceVariant.withAlpha(51); // ~20% opacity

  /// Inactive toggle/switch thumb color
  Color get inactiveThumb => brightness == Brightness.dark
      ? onSurfaceVariant.withAlpha(153) // ~60% opacity
      : onSurfaceVariant;
}
