/// Business Hours feature string constants.
///
/// Contains all text strings, labels, messages, and copy used throughout
/// the Business Hours feature. Centralizing strings makes it easier to
/// maintain consistency and prepare for internationalization.
class BusinessHoursStrings {
  BusinessHoursStrings._();

  // ============================================================================
  // PAGE TITLES
  // ============================================================================

  /// Main business hours page title
  static const String pageTitle = 'Business Hours';

  /// Edit business hours page title
  static const String editPageTitle = 'Edit Business Hours';

  /// View business hours page title
  static const String viewPageTitle = 'Operating Hours';

  // ============================================================================
  // DAY NAMES
  // ============================================================================

  /// Sunday full name
  static const String sunday = 'Sunday';

  /// Monday full name
  static const String monday = 'Monday';

  /// Tuesday full name
  static const String tuesday = 'Tuesday';

  /// Wednesday full name
  static const String wednesday = 'Wednesday';

  /// Thursday full name
  static const String thursday = 'Thursday';

  /// Friday full name
  static const String friday = 'Friday';

  /// Saturday full name
  static const String saturday = 'Saturday';

  /// Sunday short name
  static const String sundayShort = 'Sun';

  /// Monday short name
  static const String mondayShort = 'Mon';

  /// Tuesday short name
  static const String tuesdayShort = 'Tue';

  /// Wednesday short name
  static const String wednesdayShort = 'Wed';

  /// Thursday short name
  static const String thursdayShort = 'Thu';

  /// Friday short name
  static const String fridayShort = 'Fri';

  /// Saturday short name
  static const String saturdayShort = 'Sat';

  /// List of all full day names
  static const List<String> dayNames = [
    sunday,
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday,
  ];

  /// List of all short day names
  static const List<String> dayNamesShort = [
    sundayShort,
    mondayShort,
    tuesdayShort,
    wednesdayShort,
    thursdayShort,
    fridayShort,
    saturdayShort,
  ];

  // ============================================================================
  // LABELS & HEADERS
  // ============================================================================

  /// Opening time label
  static const String openingTime = 'Opening Time';

  /// Closing time label
  static const String closingTime = 'Closing Time';

  /// Open/Closed toggle label
  static const String isOpen = 'Open';

  /// Closed status label
  static const String closed = 'Closed';

  /// 24/7 operation label
  static const String open24Hours = 'Open 24 Hours';

  /// Field hours section header
  static const String fieldHours = 'Field Hours';

  /// Operating hours section header
  static const String operatingHours = 'Operating Hours';

  /// Weekly schedule header
  static const String weeklySchedule = 'Weekly Schedule';

  /// Set hours for all days
  static const String applyToAllDays = 'Apply to All Days';

  /// Copy from another day
  static const String copyFromDay = 'Copy from';

  // ============================================================================
  // BUTTONS
  // ============================================================================

  /// Save button text
  static const String save = 'Save';

  /// Save changes button text
  static const String saveChanges = 'Save Changes';

  /// Cancel button text
  static const String cancel = 'Cancel';

  /// Edit button text
  static const String edit = 'Edit';

  /// Apply button text
  static const String apply = 'Apply';

  /// Reset button text
  static const String reset = 'Reset';

  /// Retry button text
  static const String retry = 'Retry';

  /// Set default hours button
  static const String setDefaultHours = 'Set Default Hours';

  /// Copy hours button
  static const String copyHours = 'Copy Hours';

  // ============================================================================
  // STATUS MESSAGES
  // ============================================================================

  /// Currently open status
  static const String currentlyOpen = 'Currently Open';

  /// Currently closed status
  static const String currentlyClosed = 'Currently Closed';

  /// Opens soon message
  static const String opensSoon = 'Opens Soon';

  /// Closes soon message
  static const String closesSoon = 'Closes Soon';

  /// Open all day
  static const String openAllDay = 'Open All Day';

  /// Closed all day
  static const String closedAllDay = 'Closed All Day';

  /// Loading message
  static const String loadingMessage = 'Loading business hours...';

  /// Refresh tooltip
  static const String refreshTooltip = 'Refresh';

  /// Field currently accepting bookings
  static const String fieldAcceptingBookings =
      'Your field is currently accepting bookings';

  /// Field currently closed for bookings
  static const String fieldClosedForBookings =
      'Your field is currently closed for bookings';

  // ============================================================================
  // SUCCESS MESSAGES
  // ============================================================================

  /// Hours saved successfully
  static const String hoursSavedSuccess = 'Business hours saved successfully';

  /// Hours updated successfully
  static const String hoursUpdatedSuccess =
      'Business hours updated successfully';

  /// Default hours set
  static const String defaultHoursSet = 'Default hours (24/7) set for all days';

  /// Hours copied successfully
  static const String hoursCopiedSuccess = 'Hours copied successfully';

  // ============================================================================
  // ERROR MESSAGES
  // ============================================================================

  /// Failed to load hours
  static const String failedToLoadHours = 'Failed to load business hours';

  /// Failed to save hours
  static const String failedToSaveHours = 'Failed to save business hours';

  /// Failed to update hours
  static const String failedToUpdateHours = 'Failed to update business hours';

  /// Invalid time range error
  static const String invalidTimeRange =
      'Opening time must be before closing time';

  /// No changes to save
  static const String noChangesToSave = 'No changes to save';

  /// Minimum hours requirement
  static const String minimumHoursRequired =
      'Field must be open for at least 1 hour';

  /// Time conflict error
  static const String timeConflictError =
      'Time conflicts with existing bookings';

  /// Network error
  static const String networkError =
      'Network error. Please check your connection';

  // ============================================================================
  // HELP TEXT
  // ============================================================================

  /// Help text for business hours
  static const String helpText =
      'Set when your field is available for bookings. You can set different hours for each day of the week.';

  /// Help text for 24/7 operations
  static const String help24Hours =
      'Field will be available for booking at any time, 24/7.';

  /// Help text for closed days
  static const String helpClosedDay =
      'Field will not be available for bookings on this day.';

  /// Help text for applying to all days
  static const String helpApplyToAll =
      'This will set the same hours for all 7 days of the week.';

  /// Help text for time selection
  static const String helpTimeSelection =
      'Select opening and closing times in 15-minute intervals.';

  /// Warning about existing bookings
  static const String warningExistingBookings =
      'Changing hours may affect existing bookings outside new hours.';

  // ============================================================================
  // EMPTY STATES
  // ============================================================================

  /// No hours set message
  static const String noHoursSet = 'No business hours set';

  /// No hours set description
  static const String noHoursSetDescription =
      'Set your field operating hours to allow users to make bookings.';

  /// Default hours active
  static const String defaultHoursActive =
      'Default hours (24/7) are currently active';

  // ============================================================================
  // DIALOG MESSAGES
  // ============================================================================

  /// Confirm changes dialog title
  static const String confirmChanges = 'Confirm Changes';

  /// Confirm changes dialog message
  static const String confirmChangesMessage =
      'Are you sure you want to save these changes?';

  /// Discard changes dialog title
  static const String discardChanges = 'Discard Changes';

  /// Discard changes dialog message
  static const String discardChangesMessage =
      'You have unsaved changes. Are you sure you want to discard them?';

  /// Reset to default dialog title
  static const String resetToDefault = 'Reset to Default';

  /// Reset to default dialog message
  static const String resetToDefaultMessage =
      'This will reset all days to 24/7 operation. Continue?';

  // ============================================================================
  // ACCESSIBILITY
  // ============================================================================

  /// Semantic label for open/closed switch
  static const String toggleOpenClosedLabel = 'Toggle field open or closed';

  /// Semantic label for opening time picker
  static const String selectOpeningTimeLabel = 'Select opening time';

  /// Semantic label for closing time picker
  static const String selectClosingTimeLabel = 'Select closing time';

  /// Semantic label for day card
  static String dayCardLabel(String day) => '$day hours';

  // ============================================================================
  // TIME FORMATTING
  // ============================================================================

  /// Opens at prefix
  static const String opensAt = 'Opens at';

  /// Closes at prefix
  static const String closesAt = 'Closes at';

  /// Time separator
  static const String timeSeparator = ' - ';

  /// From time prefix
  static const String from = 'From';

  /// To time prefix
  static const String to = 'to';
}
