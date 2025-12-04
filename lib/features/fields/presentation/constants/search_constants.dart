/// Search Constants
///
/// Constants for search and filter functionality.
class SearchConstants {
  // Spacing
  static const double filterSpacing = 12.0;
  static const double chipSpacing = 8.0;
  static const double sectionSpacing = 24.0;

  // Padding
  static const double filterPadding = 16.0;
  static const double chipPadding = 12.0;

  // Border radius
  static const double filterBorderRadius = 12.0;
  static const double chipBorderRadius = 20.0;

  // Search debounce
  static const int searchDebounceMs = 500;

  // Price range
  static const double minPriceValue = 0.0;
  static const double maxPriceValue = 1000.0;
  static const double priceStep = 10.0;

  // Filter labels
  static const String filterByCategory = 'Sport Type';
  static const String filterByCity = 'City';
  static const String filterByPrice = 'Price Range';
  static const String filterByAmenities = 'Amenities';
  static const String sortBy = 'Sort By';

  // Common amenities
  static const List<String> commonAmenities = [
    'Parking',
    'Lockers',
    'Showers',
    'Lighting',
    'Seating',
    'Scoreboard',
    'WiFi',
    'Cafeteria',
    'First Aid',
  ];

  // Messages
  static const String noFiltersActive = 'No filters applied';
  static const String clearAllFilters = 'Clear All';
  static const String applyFilters = 'Apply Filters';
  static const String resetFilters = 'Reset';
}
