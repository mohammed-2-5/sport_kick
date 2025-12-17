/// Map location picker constants.
///
/// Contains all constants for the MapLocationPicker widget.
class MapLocationPickerConstants {
  MapLocationPickerConstants._();

  // Default map settings
  static const double defaultZoom = 15.0;
  static const double minZoom = 3.0;
  static const double maxZoom = 18.0;

  // Default location (Cairo, Egypt)
  static const double defaultLatitude = 30.0444;
  static const double defaultLongitude = 31.2357;

  // UI dimensions
  static const double searchBarHeight = 56.0;
  static const double markerSize = 50.0;
  static const double fabSize = 56.0;
  static const double bottomSheetHeight = 180.0;

  // Padding
  static const double horizontalPadding = 16.0;
  static const double verticalPadding = 12.0;
  static const double cardPadding = 16.0;

  // Border radius
  static const double borderRadius = 16.0;
  static const double searchBarRadius = 28.0;

  // Animation durations
  static const Duration searchDebounce = Duration(milliseconds: 500);
  static const Duration animationDuration = Duration(milliseconds: 300);

  // Strings
  static const String searchHint = 'Search for a location...';
  static const String confirmButton = 'Confirm Location';
  static const String myLocationTooltip = 'My Location';
  static const String noResultsText = 'No results found';
  static const String loadingText = 'Searching...';
  static const String errorText = 'Failed to get location';

  // Tile URL
  static const String tileUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String tileAttribution = '© OpenStreetMap contributors';
}
