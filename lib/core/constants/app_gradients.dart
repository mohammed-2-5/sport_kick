import 'package:flutter/material.dart';

/// Premium gradient definitions for the app.
///
/// Provides consistent gradient styles across the application.
class AppGradients {
  // Prevent instantiation
  AppGradients._();

  /// Primary gradient (Green shades)
  static const LinearGradient primary = LinearGradient(
    colors: [Color(0xFF43A047), Color(0xFF66BB6A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Primary gradient (Vertical)
  static const LinearGradient primaryVertical = LinearGradient(
    colors: [Color(0xFF43A047), Color(0xFF66BB6A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Success gradient
  static const LinearGradient success = LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Warning gradient
  static const LinearGradient warning = LinearGradient(
    colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Error gradient
  static const LinearGradient error = LinearGradient(
    colors: [Color(0xFFF44336), Color(0xFFEF5350)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Info gradient
  static const LinearGradient info = LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Dark gradient (for premium cards)
  static const LinearGradient dark = LinearGradient(
    colors: [Color(0xFF212121), Color(0xFF424242)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Light gradient (for backgrounds)
  static const LinearGradient light = LinearGradient(
    colors: [Color(0xFFFAFAFA), Color(0xFFF5F5F5)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Shimmer gradient (for loading states)
  static const LinearGradient shimmer = LinearGradient(
    colors: [Color(0xFFE0E0E0), Color(0xFFF5F5F5), Color(0xFFE0E0E0)],
    stops: [0.1, 0.5, 0.9],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Glass effect gradient (semi-transparent)
  static LinearGradient glass({double opacity = 0.2}) {
    return LinearGradient(
      colors: [
        Colors.white.withValues(alpha: opacity),
        Colors.white.withValues(alpha: opacity * 0.5),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Overlay gradient (for image overlays)
  static const LinearGradient overlay = LinearGradient(
    colors: [Colors.transparent, Color(0x99000000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.3, 1.0],
  );

  /// Status gradient based on booking status
  static LinearGradient statusGradient(Color statusColor) {
    return LinearGradient(
      colors: [
        statusColor.withValues(alpha: 0.15),
        statusColor.withValues(alpha: 0.05),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
