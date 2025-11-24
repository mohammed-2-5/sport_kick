import 'package:flutter/material.dart';

/// Premium shadow definitions for the app.
///
/// Provides multi-layer shadows for depth and premium feel.
class AppShadows {
  // Prevent instantiation
  AppShadows._();

  /// Small shadow for subtle elevation
  static const List<BoxShadow> small = [
    BoxShadow(
      color: Color(0x0A000000), // 4% opacity
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  /// Medium shadow for cards
  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x14000000), // 8% opacity
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color(0x0A000000), // 4% opacity
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  /// Large shadow for elevated elements
  static const List<BoxShadow> large = [
    BoxShadow(
      color: Color(0x1A000000), // 10% opacity
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x0F000000), // 6% opacity
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  /// Extra large shadow for floating elements
  static const List<BoxShadow> extraLarge = [
    BoxShadow(
      color: Color(0x1F000000), // 12% opacity
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
    BoxShadow(
      color: Color(0x14000000), // 8% opacity
      blurRadius: 32,
      offset: Offset(0, 12),
    ),
  ];

  /// Colored shadow for status indicators
  static List<BoxShadow> colored(Color color, {double opacity = 0.3}) {
    return [
      BoxShadow(
        color: color.withValues(alpha: opacity * 0.4),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
      BoxShadow(
        color: color.withValues(alpha: opacity * 0.2),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ];
  }

  /// Inner shadow effect (using negative spread)
  static const List<BoxShadow> inner = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 6,
      offset: Offset(0, 1),
      spreadRadius: -2,
    ),
  ];

  /// Soft glow effect
  static List<BoxShadow> glow(Color color, {double intensity = 0.5}) {
    return [
      BoxShadow(
        color: color.withValues(alpha: intensity * 0.3),
        blurRadius: 20,
        offset: Offset.zero,
      ),
      BoxShadow(
        color: color.withValues(alpha: intensity * 0.2),
        blurRadius: 40,
        offset: Offset.zero,
      ),
    ];
  }
}
