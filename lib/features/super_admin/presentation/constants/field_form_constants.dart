/// Constants for field creation form.
///
/// Contains all static data used in the field creation form.
class FieldFormConstants {
  const FieldFormConstants._();

  /// Available field sizes
  static const List<String> sizes = ['5v5', '7v7', '11v11'];

  /// Available surface types
  static const List<String> surfaces = [
    'Natural Grass',
    'Artificial Turf',
    'Hybrid',
  ];

  /// Available facilities
  static const List<String> facilities = [
    'Parking',
    'Changing Room',
    'Shower',
    'Cafeteria',
    'WiFi',
    'Lighting',
  ];

  /// Default field size
  static const String defaultSize = '5v5';

  /// Default surface type
  static const String defaultSurface = 'Natural Grass';

  /// Default indoor value
  static const bool defaultIsIndoor = false;

  /// Get capacity based on field size
  static int getSizeCapacity(String size) {
    switch (size) {
      case '5v5':
        return 10;
      case '7v7':
        return 14;
      case '11v11':
        return 22;
      default:
        return 10;
    }
  }
}
