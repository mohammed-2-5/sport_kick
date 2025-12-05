import 'package:flutter/material.dart';

/// Maps category names/icons to Material Icons.
///
/// Provides a centralized mapping from sport category icon names
/// to Flutter [IconData] for consistent icon display across the app.
class CategoryIconMapper {
  // Prevent instantiation
  CategoryIconMapper._();

  /// Returns the appropriate [IconData] for a given category icon name.
  ///
  /// Supports common sport categories:
  /// - Football/Soccer
  /// - Basketball
  /// - Tennis
  /// - Volleyball
  /// - Cricket
  /// - Rugby
  /// - Golf
  /// - Pool/Billiards
  /// - Gym/Fitness
  ///
  /// Returns [Icons.sports] as the default for unknown categories.
  static IconData getIconForCategory(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'sports_soccer':
      case 'football':
      case 'soccer':
        return Icons.sports_soccer;
      case 'sports_basketball':
      case 'basketball':
        return Icons.sports_basketball;
      case 'sports_tennis':
      case 'tennis':
        return Icons.sports_tennis;
      case 'sports_volleyball':
      case 'volleyball':
        return Icons.sports_volleyball;
      case 'sports_cricket':
      case 'cricket':
        return Icons.sports_cricket;
      case 'sports_rugby':
      case 'rugby':
        return Icons.sports_rugby;
      case 'sports_golf':
      case 'golf':
        return Icons.sports_golf;
      case 'pool':
      case 'billiards':
        return Icons.pool;
      case 'fitness_center':
      case 'gym':
        return Icons.fitness_center;
      case '🏟️':
        return Icons.stadium;
      default:
        return Icons.sports;
    }
  }
}
