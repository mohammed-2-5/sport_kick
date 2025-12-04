/// Business Hours feature constants.
///
/// Contains all numerical constants, dimensions, and configuration values
/// used throughout the Business Hours feature.
class BusinessHoursConstants {
  BusinessHoursConstants._();

  // ============================================================================
  // DAY OF WEEK CONSTANTS
  // ============================================================================

  /// Sunday (day 0)
  static const int sunday = 0;

  /// Monday (day 1)
  static const int monday = 1;

  /// Tuesday (day 2)
  static const int tuesday = 2;

  /// Wednesday (day 3)
  static const int wednesday = 3;

  /// Thursday (day 4)
  static const int thursday = 4;

  /// Friday (day 5)
  static const int friday = 5;

  /// Saturday (day 6)
  static const int saturday = 6;

  /// Total days in a week
  static const int daysInWeek = 7;

  /// List of all day indices
  static const List<int> allDays = [
    sunday,
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday,
  ];

  // ============================================================================
  // TIME CONSTANTS
  // ============================================================================

  /// Default opening time (00:00)
  static const String defaultOpeningTime = '00:00:00';

  /// Default closing time (23:59)
  static const String defaultClosingTime = '23:59:59';

  /// Standard opening time for most fields (08:00)
  static const String standardOpeningTime = '08:00:00';

  /// Standard closing time for most fields (22:00)
  static const String standardClosingTime = '22:00:00';

  /// Time slot duration in minutes
  static const int timeSlotDurationMinutes = 60;

  /// Time picker interval in minutes
  static const int timePickerIntervalMinutes = 15;

  /// Minimum booking duration in minutes
  static const int minBookingDurationMinutes = 60;

  /// Hours in a day
  static const int hoursInDay = 24;

  /// Minutes in an hour
  static const int minutesInHour = 60;

  // ============================================================================
  // UI DIMENSIONS
  // ============================================================================

  /// Standard padding for cards
  static const double cardPadding = 16.0;

  /// Border radius for cards
  static const double cardBorderRadius = 12.0;

  /// Spacing between sections
  static const double sectionSpacing = 24.0;

  /// Spacing between items
  static const double itemSpacing = 12.0;

  /// Small spacing
  static const double smallSpacing = 8.0;

  /// Tiny spacing
  static const double tinySpacing = 4.0;

  /// Day card height
  static const double dayCardHeight = 80.0;

  /// Day card width
  static const double dayCardWidth = 60.0;

  /// Icon size for time picker
  static const double timeIconSize = 24.0;

  /// Switch scale
  static const double switchScale = 0.9;

  /// Divider thickness
  static const double dividerThickness = 1.0;

  /// Divider indent
  static const double dividerIndent = 16.0;

  // ============================================================================
  // ANIMATION
  // ============================================================================

  /// Animation duration in milliseconds
  static const int animationDurationMs = 200;

  /// Long animation duration in milliseconds
  static const int longAnimationDurationMs = 300;

  // ============================================================================
  // VALIDATION
  // ============================================================================

  /// Minimum hours between opening and closing (in hours)
  static const int minHoursDifference = 1;

  /// Maximum advance booking days
  static const int maxAdvanceBookingDays = 30;

  // ============================================================================
  // OPACITY VALUES
  // ============================================================================

  /// Disabled opacity
  static const double disabledOpacity = 0.4;

  /// Card hover opacity
  static const double hoverOpacity = 0.05;

  /// Card selected opacity
  static const double selectedOpacity = 0.1;

  // ============================================================================
  // BATCH OPERATION LIMITS
  // ============================================================================

  /// Maximum days to update in one batch operation
  static const int maxBatchUpdateDays = 7;
}
