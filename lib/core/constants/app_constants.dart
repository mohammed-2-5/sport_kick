import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Application-wide constants.
///
/// Contains all constant values used throughout the app including:
/// - API configuration
/// - App configuration
/// - Time and date formats
/// - Validation rules
/// - Default values
class AppConstants {
  // Prevent instantiation
  AppConstants._();

  // ==================== APP INFO ====================

  /// Application name displayed in UI
  static const String appName = 'Sport Kick';

  /// Application tagline
  static const String appTagline = 'Book Your Football Field Instantly';

  /// Current app version
  static const String appVersion = '1.0.0';

  // ==================== SUPABASE CONFIG ====================

  /// Supabase project URL
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';

  /// Supabase anonymous key
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  /// Supabase service role key (admin access)
  static String get supabaseServiceRoleKey =>
      dotenv.env['SUPABASE_SERVICE_ROLE_KEY'] ?? '';

  // ==================== STORAGE BUCKETS ====================

  /// Storage bucket name for field images
  static const String fieldImagesBucket = 'field-images';

  /// Storage bucket name for profile avatars
  static const String profileAvatarsBucket = 'profile-avatars';

  // ==================== API ENDPOINTS ====================

  /// Base URL for REST API (if using custom API)
  static const String apiBaseUrl = '';

  /// API timeout duration in seconds
  static const int apiTimeout = 30;

  /// Maximum number of retry attempts for failed requests
  static const int maxRetryAttempts = 3;

  // ==================== CACHE KEYS ====================

  /// Key for storing user data in local cache
  static const String cacheKeyUser = 'cached_user';

  /// Key for storing auth token
  static const String cacheKeyToken = 'auth_token';

  /// Key for storing cached fields list
  static const String cacheKeyFields = 'cached_fields';

  /// Key for storing user preferences
  static const String cacheKeyPreferences = 'user_preferences';

  /// Key for storing bookings cache
  static const String cacheKeyBookings = 'cached_bookings';

  // ==================== HIVE BOX NAMES ====================

  /// Hive box name for user data
  static const String hiveBoxUser = 'user_box';

  /// Hive box name for fields data
  static const String hiveBoxFields = 'fields_box';

  /// Hive box name for bookings data
  static const String hiveBoxBookings = 'bookings_box';

  /// Hive box name for app settings
  static const String hiveBoxSettings = 'settings_box';

  // ==================== DATE & TIME FORMATS ====================

  /// Standard date format: DD/MM/YYYY
  static const String dateFormat = 'dd/MM/yyyy';

  /// Date format for API: YYYY-MM-DD
  static const String apiDateFormat = 'yyyy-MM-dd';

  /// Time format: HH:MM AM/PM
  static const String timeFormat = 'hh:mm a';

  /// Time format for API: HH:MM:SS
  static const String apiTimeFormat = 'HH:mm:ss';

  /// DateTime format for display: DD MMM YYYY, HH:MM AM
  static const String dateTimeFormat = 'dd MMM yyyy, hh:mm a';

  /// Full month date format: DD MMMM YYYY
  static const String fullDateFormat = 'dd MMMM yyyy';

  // ==================== VALIDATION RULES ====================

  /// Minimum password length
  static const int minPasswordLength = 8;

  /// Maximum password length
  static const int maxPasswordLength = 32;

  /// Minimum name length
  static const int minNameLength = 2;

  /// Maximum name length
  static const int maxNameLength = 50;

  /// Phone number length (Egypt)
  static const int phoneNumberLength = 11;

  /// Maximum field description length
  static const int maxDescriptionLength = 500;

  /// Maximum review comment length
  static const int maxReviewLength = 300;

  /// Minimum booking notice in hours (how far in advance bookings must be made)
  static const int minBookingNoticeHours = 2;

  /// Maximum booking days in advance
  static const int maxBookingDaysAdvance = 30;

  // ==================== PAGINATION ====================

  /// Default number of items per page
  static const int defaultPageSize = 20;

  /// Maximum number of items per page
  static const int maxPageSize = 100;

  // ==================== IMAGES ====================

  /// Maximum image size in MB
  static const double maxImageSizeMB = 5.0;

  /// Maximum image size in bytes
  static const int maxImageSizeBytes = 5 * 1024 * 1024;

  /// Supported image formats
  static const List<String> supportedImageFormats = [
    'jpg',
    'jpeg',
    'png',
    'webp',
  ];

  /// Image quality for compression (0-100)
  static const int imageQuality = 80;

  /// Maximum number of images per field
  static const int maxFieldImages = 10;

  // ==================== RATINGS ====================

  /// Minimum rating value
  static const int minRating = 1;

  /// Maximum rating value
  static const int maxRating = 5;

  // ==================== BOOKING STATUS ====================

  /// Booking status: Pending confirmation
  static const String bookingStatusPending = 'pending';

  /// Booking status: Confirmed by owner
  static const String bookingStatusConfirmed = 'confirmed';

  /// Booking status: Cancelled
  static const String bookingStatusCancelled = 'cancelled';

  /// Booking status: Completed (past booking)
  static const String bookingStatusCompleted = 'completed';

  // ==================== USER ROLES ====================

  /// User role: Regular user
  static const String roleUser = 'user';

  /// User role: Field owner
  static const String roleOwner = 'owner';

  /// User role: Administrator
  static const String roleAdmin = 'admin';

  // ==================== FIELD SIZES ====================

  /// Field size options
  static const List<String> fieldSizes = ['5v5', '6v6', '7v7', '11v11'];

  /// Surface type options
  static const List<String> surfaceTypes = [
    'Grass',
    'Artificial Turf',
    'Concrete',
  ];

  // ==================== FACILITIES ====================

  /// Available facilities for fields
  static const List<String> availableFacilities = [
    'Parking',
    'Lockers',
    'Showers',
    'Changing Rooms',
    'Water Fountain',
    'First Aid',
    'Cafe',
    'Equipment Rental',
    'Lighting',
    'Seating Area',
  ];

  // ==================== NOTIFICATION TYPES ====================

  /// Notification: Booking confirmed
  static const String notificationBookingConfirmed = 'booking_confirmed';

  /// Notification: Booking cancelled
  static const String notificationBookingCancelled = 'booking_cancelled';

  /// Notification: Booking reminder
  static const String notificationBookingReminder = 'booking_reminder';

  /// Notification: New booking (for owners)
  static const String notificationNewBooking = 'new_booking';

  // ==================== MAP CONFIG ====================

  /// Default map zoom level
  static const double defaultMapZoom = 15.0;

  /// Default map latitude (Cairo, Egypt)
  static const double defaultMapLatitude = 30.0444;

  /// Default map longitude (Cairo, Egypt)
  static const double defaultMapLongitude = 31.2357;

  // ==================== ANIMATION DURATIONS ====================

  /// Short animation duration in milliseconds
  static const int animationDurationShort = 200;

  /// Medium animation duration in milliseconds
  static const int animationDurationMedium = 300;

  /// Long animation duration in milliseconds
  static const int animationDurationLong = 500;

  // ==================== DEBOUNCE & THROTTLE ====================

  /// Search debounce duration in milliseconds
  static const int searchDebounceDuration = 500;

  /// Button press debounce duration in milliseconds
  static const int buttonDebounceDuration = 1000;

  // ==================== EXTERNAL LINKS ====================

  /// Privacy policy URL
  static const String privacyPolicyUrl = 'https://spoKick.com/privacy';

  /// Terms of service URL
  static const String termsOfServiceUrl = 'https://spoKick.com/terms';

  /// Support email
  static const String supportEmail = 'support@spoKick.com';

  /// Support phone
  static const String supportPhone = '+20 123 456 7890';

  // ==================== LOGGING ====================

  /// Enables verbose debug logs (Bloc events/changes and debug statements).
  static const bool enableVerboseLogs = true;

  /// Enables ANSI colors in console logs (set false if terminal doesn't support colors).
  static const bool enableColoredLogs = true;
}
