import 'package:flutter/material.dart';

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

  // ==================== SEMANTIC COLORS ====================

  /// Success color
  Color get success => brightness == Brightness.dark
      ? const Color(0xFF81C784)
      : const Color(0xFF4CAF50);

  /// Warning color
  Color get warning => brightness == Brightness.dark
      ? const Color(0xFFFFB74D)
      : const Color(0xFFFFA726);

  /// Info color
  Color get info => brightness == Brightness.dark
      ? const Color(0xFF64B5F6)
      : const Color(0xFF2196F3);

  // ==================== BORDER COLORS ====================

  /// Border/outline color (replaces AppColors.border)
  Color get border => outline;

  /// Divider color (replaces AppColors.divider)
  Color get divider => outlineVariant;
}
