import 'package:flutter/material.dart';

/// Utility class for facility-related data.
class FacilityData {
  FacilityData._();

  /// Returns gradient colors for each facility type.
  static List<Color> getGradient(String facility, ColorScheme colorScheme) {
    final gradients = {
      'Parking': [const Color(0xFF5C6BC0), const Color(0xFF7986CB)],
      'Changing Room': [const Color(0xFF26A69A), const Color(0xFF4DB6AC)],
      'Shower': [const Color(0xFF42A5F5), const Color(0xFF64B5F6)],
      'Cafeteria': [const Color(0xFFFF7043), const Color(0xFFFF8A65)],
      'WiFi': [const Color(0xFFAB47BC), const Color(0xFFBA68C8)],
      'Lighting': [const Color(0xFFFFA726), const Color(0xFFFFB74D)],
    };
    return gradients[facility] ??
        [colorScheme.primary, colorScheme.primaryContainer];
  }

  /// Returns the appropriate icon for each facility type.
  static IconData getIcon(String facility) {
    switch (facility) {
      case 'Parking':
        return Icons.local_parking_rounded;
      case 'Changing Room':
        return Icons.checkroom_rounded;
      case 'Shower':
        return Icons.shower_rounded;
      case 'Cafeteria':
        return Icons.restaurant_rounded;
      case 'WiFi':
        return Icons.wifi_rounded;
      case 'Lighting':
        return Icons.lightbulb_rounded;
      default:
        return Icons.check_circle_rounded;
    }
  }
}
