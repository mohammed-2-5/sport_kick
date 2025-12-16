/// Booking-related constants
///
/// Contains all hard-coded values used in booking pages:
/// - Time slot configurations
/// - Booking flow settings
/// - UI dimensions
/// - Labels and messages
class BookingConstants {
  // Prevent instantiation
  BookingConstants._();

  // ==================== TIME SLOT SETTINGS ====================

  /// Booking advance days (how far in advance can users book)
  static const int bookingAdvanceDays = 90;

  /// Time slot duration (in minutes)
  static const int timeSlotDuration = 60;

  /// Operating hours start
  static const int operatingHoursStart = 6;

  /// Operating hours end
  static const int operatingHoursEnd = 23;

  /// Min booking duration (hours)
  static const int minBookingDuration = 1;

  /// Max booking duration (hours)
  static const int maxBookingDuration = 4;

  // ==================== UI DIMENSIONS ====================

  /// Date picker height
  static const double datePickerHeight = 100.0;

  /// Time slot height
  static const double timeSlotHeight = 60.0;

  /// Time slot width
  static const double timeSlotWidth = 120.0;

  /// Booking card height
  static const double bookingCardHeight = 180.0;

  /// Booking card elevation
  static const double bookingCardElevation = 2.0;

  /// Border radius
  static const double borderRadius = 12.0;

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

  // ==================== BOOKING STATUS COLORS ====================

  /// Status badge height
  static const double statusBadgeHeight = 28.0;

  /// Status badge padding
  static const double statusBadgePadding = 12.0;

  /// Status icon size
  static const double statusIconSize = 16.0;

  // ==================== TIMELINE ====================

  /// Timeline item height
  static const double timelineItemHeight = 60.0;

  /// Timeline dot size
  static const double timelineDotSize = 12.0;

  /// Timeline line width
  static const double timelineLineWidth = 2.0;

  // ==================== LABELS ====================

  /// "Select Date" label
  static const String selectDateLabel = 'Select Date';

  /// "Select Time Slot" label
  static const String selectTimeSlotLabel = 'Select Time Slot';

  /// "Booking Summary" label
  static const String bookingSummaryLabel = 'Booking Summary';

  /// "Book Field" title
  static const String bookFieldTitle = 'Book Field';

  /// "Confirm Booking" button label
  static const String confirmBookingLabel = 'Confirm Booking';

  /// "Cancel Booking" button label
  static const String cancelBookingLabel = 'Cancel Booking';

  /// "My Bookings" title
  static const String myBookingsTitle = 'My Bookings';

  /// "Upcoming" tab label
  static const String upcomingTabLabel = 'Upcoming';

  /// "History" tab label
  static const String historyTabLabel = 'History';

  /// "Booking Details" title
  static const String bookingDetailsTitle = 'Booking Details';

  /// "Field" label
  static const String fieldLabel = 'Field';

  /// "Date" label
  static const String dateLabel = 'Date';

  /// "Time" label
  static const String timeLabel = 'Time';

  /// "Duration" label
  static const String durationLabel = 'Duration';

  /// Date & Time label
  static const String dateTimeLabel = 'Date & Time';

  /// Time slot label
  static const String timeSlotLabel = 'Time Slot';

  /// "Total Price" label
  static const String totalPriceLabel = 'Total Price';

  /// "Status" label
  static const String statusLabel = 'Status';

  /// "Booking ID" label
  static const String bookingIdLabel = 'Booking ID';

  /// "hours" suffix
  static const String hoursSuffix = 'hours';

  /// "hour" suffix
  static const String hourSuffix = 'hour';

  // ==================== STATUS LABELS ====================

  /// "Pending" status label
  static const String pendingLabel = 'Pending';

  /// "Confirmed" status label
  static const String confirmedLabel = 'Confirmed';

  /// "Completed" status label
  static const String completedLabel = 'Completed';

  /// "Cancelled" status label
  static const String cancelledLabel = 'Cancelled';

  // ==================== MESSAGES ====================

  /// No bookings message
  static const String noBookingsMessage = 'No bookings yet';

  /// No upcoming bookings message
  static const String noUpcomingMessage = 'No upcoming bookings';

  /// No history message
  static const String noHistoryMessage = 'No booking history';

  /// Create first booking message
  static const String createFirstBookingMessage =
      'Book your first football field now!';

  /// Booking confirmed message
  static const String bookingConfirmedMessage =
      'Booking confirmed successfully!';

  /// Booking cancelled message
  static const String bookingCancelledMessage = 'Booking cancelled';

  /// Cancel confirmation message
  static const String cancelConfirmationMessage =
      'Are you sure you want to cancel this booking?';

  /// Cancel warning message
  static const String cancelWarningMessage = 'This action cannot be undone.';

  /// No available slots message
  static const String noAvailableSlotsMessage =
      'No available time slots for this date';

  /// Select date first message
  static const String selectDateFirstMessage = 'Please select a date first';

  /// Select time slot first message
  static const String selectTimeSlotFirstMessage = 'Please select a time slot';

  /// Booking in progress message
  static const String bookingInProgressMessage = 'Processing your booking...';

  /// Cancelling booking message
  static const String cancellingBookingMessage = 'Cancelling booking...';

  // ==================== PRICE BREAKDOWN ====================

  /// "Price Breakdown" label
  static const String priceBreakdownLabel = 'Price Breakdown';

  /// "Field Price" label
  static const String fieldPriceLabel = 'Field Price';

  /// "Service Fee" label
  static const String serviceFeeLabel = 'Service Fee';

  /// "Discount" label
  static const String discountLabel = 'Discount';

  /// "Total" label
  static const String totalLabel = 'Total';

  /// Service fee percentage
  static const double serviceFeePercentage = 0.05;

  // ==================== DATE FORMATS ====================

  /// Date display format (e.g., "Mon, Jan 15")
  static const String dateDisplayFormat = 'EEE, MMM d';

  /// Full date format (e.g., "Monday, January 15, 2024")
  static const String fullDateFormat = 'EEEE, MMMM d, yyyy';

  /// Time format (e.g., "2:00 PM")
  static const String timeFormat = 'h:mm a';

  /// Short time format (e.g., "14:00")
  static const String shortTimeFormat = 'HH:mm';

  // ==================== ANIMATION DURATIONS ====================

  /// Tab animation duration (milliseconds)
  static const int tabAnimationDuration = 300;

  /// Booking card animation duration (milliseconds)
  static const int cardAnimationDuration = 200;

  /// Status change animation duration (milliseconds)
  static const int statusAnimationDuration = 400;

  // ==================== LAYOUT ====================

  /// My bookings header height
  static const double myBookingsHeaderHeight = 180.0;

  // ==================== BOOKING TIMELINE STEPS ====================

  /// Timeline step labels
  static const List<String> timelineSteps = [
    'Booking Created',
    'Awaiting Confirmation',
    'Confirmed',
    'Completed',
  ];

  // ==================== TAB INDICES ====================

  /// Upcoming tab index
  static const int upcomingTabIndex = 0;

  /// History tab index
  static const int historyTabIndex = 1;

  // ==================== DURATION SELECTOR ====================

  /// Available booking durations (in hours)
  static const List<int> availableDurations = [1, 2];

  /// Duration selector title
  static const String durationSelectorTitle = 'Booking Duration';

  /// Duration recommended label
  static const String durationRecommendedLabel = 'Recommended';

  /// Duration best value label
  static const String durationBestValueLabel = 'Best Value';

  /// Duration unavailable message
  static const String durationUnavailableMessage =
      'Not available for this time slot';

  /// Duration chip height
  static const double durationChipHeight = 80.0;

  /// Duration chip border radius
  static const double durationChipBorderRadius = 16.0;
}
