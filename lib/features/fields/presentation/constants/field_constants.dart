/// Field-related constants for field browsing and details
///
/// Contains all hard-coded values used in field pages:
/// - UI dimensions and spacing
/// - Image gallery settings
/// - Booking button configurations
/// - Labels and text
class FieldConstants {
  // Prevent instantiation
  FieldConstants._();

  // ==================== UI DIMENSIONS ====================

  /// Image gallery height
  static const double imageGalleryHeight = 300.0;

  /// Image gallery height (collapsed)
  static const double imageGalleryHeightCollapsed = 200.0;

  /// Field card height
  static const double fieldCardHeight = 280.0;

  /// Field card image height
  static const double fieldCardImageHeight = 160.0;

  /// Border radius for cards
  static const double cardBorderRadius = 12.0;

  /// Border radius for images
  static const double imageBorderRadius = 12.0;

  /// Standard padding
  static const double standardPadding = 16.0;

  /// Large padding
  static const double largePadding = 24.0;

  /// Small padding
  static const double smallPadding = 8.0;

  /// Section spacing
  static const double sectionSpacing = 24.0;

  /// Item spacing
  static const double itemSpacing = 12.0;

  /// Chip spacing
  static const double chipSpacing = 8.0;

  // ==================== IMAGE GALLERY ====================

  /// Max images to show in gallery
  static const int maxGalleryImages = 10;

  /// Image gallery indicator size
  static const double galleryIndicatorSize = 8.0;

  /// Image gallery indicator spacing
  static const double galleryIndicatorSpacing = 4.0;

  /// Placeholder image path
  static const String placeholderImagePath =
      'assets/images/field_placeholder.png';

  // ==================== RATING & REVIEWS ====================

  /// Star icon size
  static const double starIconSize = 20.0;

  /// Rating display size (large)
  static const double ratingLargeSize = 48.0;

  /// Max rating value
  static const double maxRating = 5.0;

  /// Min rating value
  static const double minRating = 0.0;

  // ==================== FACILITY CHIPS ====================

  /// Facility chip height
  static const double facilityChipHeight = 32.0;

  /// Facility chip padding
  static const double facilityChipPadding = 12.0;

  /// Facility icon size
  static const double facilityIconSize = 18.0;

  // ==================== BOOKING BUTTON ====================

  /// Booking button height
  static const double bookingButtonHeight = 56.0;

  /// Booking button bottom padding
  static const double bookingButtonBottomPadding = 16.0;

  /// Booking button elevation
  static const double bookingButtonElevation = 8.0;

  // ==================== FIELD CARD ====================

  /// Field card elevation
  static const double fieldCardElevation = 2.0;

  /// Price tag font size
  static const double priceTagFontSize = 18.0;

  /// Rating badge size
  static const double ratingBadgeSize = 24.0;

  // ==================== LABELS ====================

  /// "Book Now" button label
  static const String bookNowLabel = 'Book Now';

  /// "View Details" button label
  static const String viewDetailsLabel = 'View Details';

  /// "Facilities" section title
  static const String facilitiesTitle = 'Facilities';

  /// "Location" section title
  static const String locationTitle = 'Location';

  /// "About" section title
  static const String aboutTitle = 'About This Field';

  /// "Reviews" section title
  static const String reviewsTitle = 'Reviews & Ratings';

  /// "Price" label
  static const String priceLabel = 'Price';

  /// "Per Hour" label
  static const String perHourLabel = 'per hour';

  /// "Available" label
  static const String availableLabel = 'Available';

  /// "Not Available" label
  static const String notAvailableLabel = 'Not Available';

  /// "Add to Favorites" label
  static const String addToFavoritesLabel = 'Add to Favorites';

  /// "Remove from Favorites" label
  static const String removeFromFavoritesLabel = 'Remove from Favorites';

  /// "Share" label
  static const String shareLabel = 'Share';

  /// "No reviews yet" message
  static const String noReviewsMessage = 'No reviews yet';

  /// "Be the first to review" message
  static const String beFirstReviewMessage =
      'Be the first to review this field';

  // ==================== FILTER OPTIONS ====================

  /// "All" filter label
  static const String filterAllLabel = 'All';

  /// "Sort By" label
  static const String sortByLabel = 'Sort By';

  /// "Price: Low to High" option
  static const String sortPriceLowLabel = 'Price: Low to High';

  /// "Price: High to Low" option
  static const String sortPriceHighLabel = 'Price: High to Low';

  /// "Rating" option
  static const String sortRatingLabel = 'Rating';

  /// "Newest" option
  static const String sortNewestLabel = 'Newest';

  // ==================== SEARCH ====================

  /// Search hint text
  static const String searchHintText = 'Search for football fields...';

  /// Search history max items
  static const int maxSearchHistoryItems = 10;

  /// Search debounce duration (milliseconds)
  static const int searchDebounceDuration = 500;

  // ==================== FAVORITES ====================

  /// Favorites empty message
  static const String favoritesEmptyMessage = 'No favorite fields yet';

  /// Favorites empty subtitle
  static const String favoritesEmptySubtitle =
      'Tap the heart icon on any field to add it to your favorites';

  // ==================== FIELD SIZES ====================

  /// Available field sizes
  static const List<String> fieldSizes = ['5v5', '7v7', '11v11'];

  /// Field size display names
  static const Map<String, String> fieldSizeDisplayNames = {
    '5v5': '5-a-side',
    '7v7': '7-a-side',
    '11v11': 'Full Size (11v11)',
  };

  // ==================== SURFACE TYPES ====================

  /// Available surface types
  static const List<String> surfaceTypes = [
    'Natural Grass',
    'Artificial Turf',
    'Hybrid',
    'Indoor',
  ];

  // ==================== COMMON FACILITIES ====================

  /// List of common facilities
  static const List<String> commonFacilities = [
    'Parking',
    'Changing Rooms',
    'Showers',
    'Toilets',
    'Lighting',
    'Seating',
    'Refreshments',
    'First Aid',
    'Equipment Rental',
    'WiFi',
  ];

  /// Facility icon mapping
  static const Map<String, String> facilityIcons = {
    'Parking': '🅿️',
    'Changing Rooms': '👕',
    'Showers': '🚿',
    'Toilets': '🚻',
    'Lighting': '💡',
    'Seating': '🪑',
    'Refreshments': '☕',
    'First Aid': '🏥',
    'Equipment Rental': '⚽',
    'WiFi': '📶',
  };

  // ==================== ANIMATION DURATIONS ====================

  /// Standard animation duration (milliseconds)
  static const int animationDuration = 300;

  /// Image fade-in duration (milliseconds)
  static const int imageFadeInDuration = 200;

  /// Gallery page change duration (milliseconds)
  static const int galleryPageDuration = 350;

  // ==================== OPACITY VALUES ====================

  /// Disabled opacity
  static const double disabledOpacity = 0.5;

  /// Overlay opacity
  static const double overlayOpacity = 0.3;

  /// Shadow opacity
  static const double shadowOpacity = 0.1;
}
