import 'package:spo_kick/features/city/presentation/cubit/city_state.dart';

/// Helper class for city-related operations in fields feature.
///
/// Provides utility methods to extract city information from [CityState].
class CityHelper {
  // Prevent instantiation
  CityHelper._();

  /// Extracts the current city ID from a [CityState].
  ///
  /// Returns the city ID if:
  /// - State is [CitySelected] → returns `cityState.city.id`
  /// - State is [CitySaved] → returns `cityState.city.id`
  /// - State is [CitiesLoaded] with a selected city → returns `cityState.selectedCityId`
  ///
  /// Returns `null` otherwise.
  static String? getCurrentCityId(CityState cityState) {
    if (cityState is CitySelected) {
      return cityState.city.id;
    } else if (cityState is CitySaved) {
      return cityState.city.id;
    } else if (cityState is CitiesLoaded && cityState.selectedCityId != null) {
      return cityState.selectedCityId;
    }
    return null;
  }
}
