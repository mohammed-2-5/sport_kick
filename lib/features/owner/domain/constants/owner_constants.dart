/// Owner domain constants
///
/// Contains all shared constant values used across the owner feature,
/// including field specifications, facility options, and analytics periods.
class OwnerConstants {
  // Prevent instantiation
  OwnerConstants._();

  /// Available field sizes for football fields
  static const List<String> fieldSizes = ['5v5', '7v7', '11v11'];

  /// Available surface types for fields
  static const List<String> surfaceTypes = [
    'Natural Grass',
    'Artificial Turf',
    'Hybrid',
  ];

  /// Available field types
  static const List<String> fieldTypes = ['Outdoor', 'Indoor'];

  /// Available facilities that can be offered at a field
  static const List<String> facilities = [
    'Parking',
    'Changing Room',
    'Shower',
    'Cafeteria',
    'WiFi',
    'Lighting',
  ];

  /// Analytics time period options
  static const List<String> analyticsPeriods = [
    'This Week',
    'This Month',
    'This Year',
  ];

  /// Default number of months to show in revenue trends
  static const int defaultMonthsToShow = 6;

  /// Maximum number of top performing fields to display
  static const int maxTopFields = 3;
}
