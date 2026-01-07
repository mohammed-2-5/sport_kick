/// Utility functions for field form validation and mapping.
///
/// Used by both super admin and owner field form pages.
class FieldFormUtils {
  FieldFormUtils._();

  /// Maps field capacity to display size string.
  ///
  /// Returns '5-a-side' for capacity <= 10, '7-a-side' for <= 14,
  /// '11-a-side' otherwise.
  static String mapCapacityToSize(
    int? capacity, {
    String defaultSize = '7-a-side',
  }) {
    if (capacity == null) return defaultSize;
    if (capacity <= 10) return '5-a-side';
    if (capacity <= 14) return '7-a-side';
    return '11-a-side';
  }

  /// Maps field capacity to owner format size string.
  ///
  /// Returns '5v5' for capacity <= 10, '7v7' for <= 14, '11v11' otherwise.
  static String mapCapacityToOwnerSize(
    int? capacity, {
    String defaultSize = '5v5',
  }) {
    if (capacity == null) return defaultSize;
    if (capacity <= 10) return '5v5';
    if (capacity <= 14) return '7v7';
    return '11v11';
  }

  /// Validates that a value exists in the allowed list.
  ///
  /// Returns the value if valid, otherwise returns the first allowed value.
  static String validateDropdownValue(String? value, List<String> allowed) {
    if (value != null && allowed.contains(value)) {
      return value;
    }
    return allowed.first;
  }
}
