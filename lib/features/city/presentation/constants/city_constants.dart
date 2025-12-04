/// City Feature Constants
///
/// Contains all constants used in the city selection feature.
class CityConstants {
  CityConstants._();

  // Padding & Spacing
  static const double screenPadding = 16.0;
  static const double cardPadding = 16.0;
  static const double cardSpacing = 12.0;
  static const double sectionSpacing = 24.0;
  static const double iconSize = 48.0;
  static const double smallIconSize = 20.0;

  // Border Radius
  static const double cardBorderRadius = 12.0;
  static const double buttonBorderRadius = 8.0;

  // Elevation
  static const double cardElevation = 2.0;
  static const double selectedCardElevation = 4.0;

  // Animation
  static const int animationDurationMs = 200;

  // Text
  static const String citySelectionTitle = 'Select Your City';
  static const String citySelectionSubtitle =
      'Choose your city to see available football fields';
  static const String continueButtonText = 'Continue';
  static const String changeCityText = 'Change City';
  static const String noCitiesAvailable = 'No cities available';
  static const String loadingCities = 'Loading cities...';
  static const String errorLoadingCities = 'Failed to load cities';
  static const String selectCityPrompt = 'Please select a city';
  static const String citySelectedSuccess = 'City selected successfully';
}
