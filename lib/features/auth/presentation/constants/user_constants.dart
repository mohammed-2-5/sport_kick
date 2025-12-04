/// User-related constants for settings and preferences
///
/// Contains all hard-coded values used in user settings:
/// - UI dimensions and spacing
/// - Labels and text
/// - Notification preferences
/// - Theme and language options
class UserConstants {
  // Prevent instantiation
  UserConstants._();

  // ==================== UI DIMENSIONS ====================

  /// Section spacing
  static const double sectionSpacing = 24.0;

  /// Item spacing
  static const double itemSpacing = 8.0;

  /// Border radius
  static const double borderRadius = 12.0;

  /// Standard padding
  static const double standardPadding = 16.0;

  /// Icon size
  static const double iconSize = 24.0;

  /// Section icon size
  static const double sectionIconSize = 20.0;

  /// Card elevation
  static const double cardElevation = 2.0;

  /// Switch tile icon width
  static const double switchIconWidth = 40.0;

  /// Settings tile padding vertical
  static const double settingsTilePaddingVertical = 8.0;

  /// Settings tile padding horizontal
  static const double settingsTilePaddingHorizontal = 12.0;

  /// Settings section title spacing
  static const double sectionTitleSpacing = 12.0;

  // ==================== LABELS ====================

  /// Settings page title
  static const String settingsTitle = 'Settings';

  /// Account section title
  static const String accountTitle = 'Account';

  /// Preferences section title
  static const String preferencesTitle = 'Preferences';

  /// Notifications section title
  static const String notificationsTitle = 'Notifications';

  /// About section title
  static const String aboutTitle = 'About';

  /// Edit Profile label
  static const String editProfileLabel = 'Edit Profile';

  /// Edit Profile subtitle
  static const String editProfileSubtitle = 'Update your personal information';

  /// Change Password label
  static const String changePasswordLabel = 'Change Password';

  /// Change Password subtitle
  static const String changePasswordSubtitle = 'Update your account password';

  /// Logout label
  static const String logoutLabel = 'Logout';

  /// Logout subtitle
  static const String logoutSubtitle = 'Sign out of your account';

  /// Theme label
  static const String themeLabel = 'Theme';

  /// Theme subtitle
  static const String themeSubtitle = 'Choose your preferred theme';

  /// Dark Mode label
  static const String darkModeLabel = 'Dark Mode';

  /// Dark Mode subtitle
  static const String darkModeSubtitle = 'Use dark theme';

  /// Language label
  static const String languageLabel = 'Language';

  /// Language subtitle
  static const String languageSubtitle = 'Select your preferred language';

  /// Email Notifications label
  static const String emailNotificationsLabel = 'Email Notifications';

  /// Email Notifications subtitle
  static const String emailNotificationsSubtitle =
      'Receive notifications via email';

  /// Push Notifications label
  static const String pushNotificationsLabel = 'Push Notifications';

  /// Push Notifications subtitle
  static const String pushNotificationsSubtitle =
      'Receive push notifications on your device';

  /// Booking Notifications label
  static const String bookingNotificationsLabel = 'Booking Alerts';

  /// Booking Notifications subtitle
  static const String bookingNotificationsSubtitle =
      'Get notified about booking updates';

  /// Reminder Notifications label
  static const String reminderNotificationsLabel = 'Booking Reminders';

  /// Reminder Notifications subtitle
  static const String reminderNotificationsSubtitle =
      'Get reminded before your bookings';

  /// Privacy Policy label
  static const String privacyPolicyLabel = 'Privacy Policy';

  /// Terms of Service label
  static const String termsOfServiceLabel = 'Terms of Service';

  /// Help & Support label
  static const String helpSupportLabel = 'Help & Support';

  /// Rate App label
  static const String rateAppLabel = 'Rate App';

  /// Rate App subtitle
  static const String rateAppSubtitle = 'Enjoying Sport Kick? Rate us!';

  /// Version label
  static const String versionLabel = 'Version';

  /// App version
  static const String appVersion = '1.0.0';

  // ==================== THEME OPTIONS ====================

  /// Theme options
  static const List<String> themeOptions = ['System Default', 'Light', 'Dark'];

  /// Theme option values
  static const Map<String, String> themeValues = {
    'System Default': 'system',
    'Light': 'light',
    'Dark': 'dark',
  };

  // ==================== LANGUAGE OPTIONS ====================

  /// Available languages
  static const List<String> languages = [
    'English',
    'Arabic',
    'French',
    'Spanish',
  ];

  /// Language codes
  static const Map<String, String> languageCodes = {
    'English': 'en',
    'Arabic': 'ar',
    'French': 'fr',
    'Spanish': 'es',
  };

  /// Language display names with flags
  static const Map<String, String> languageDisplayNames = {
    'English': '🇬🇧 English',
    'Arabic': '🇸🇦 العربية',
    'French': '🇫🇷 Français',
    'Spanish': '🇪🇸 Español',
  };

  // ==================== MESSAGES ====================

  /// Logout confirmation message
  static const String logoutConfirmationMessage =
      'Are you sure you want to logout?';

  /// Logout success message
  static const String logoutSuccessMessage = 'Logged out successfully';

  /// Settings saved message
  static const String settingsSavedMessage = 'Settings saved successfully';

  /// Theme changed message
  static const String themeChangedMessage = 'Theme updated';

  /// Language changed message
  static const String languageChangedMessage = 'Language updated';

  /// Dark mode enabled message
  static const String darkModeEnabledMessage = 'Dark mode enabled';

  /// Dark mode disabled message
  static const String darkModeDisabledMessage = 'Dark mode disabled';

  /// Notifications enabled message
  static const String notificationsEnabledMessage = 'Notifications enabled';

  /// Notifications disabled message
  static const String notificationsDisabledMessage = 'Notifications disabled';

  // ==================== DIALOG MESSAGES ====================

  /// Logout dialog title
  static const String logoutDialogTitle = 'Confirm Logout';

  /// Theme dialog title
  static const String themeDialogTitle = 'Select Theme';

  /// Language dialog title
  static const String languageDialogTitle = 'Select Language';

  /// Confirm button label
  static const String confirmLabel = 'Confirm';

  /// Cancel button label
  static const String cancelLabel = 'Cancel';

  /// OK button label
  static const String okLabel = 'OK';

  // ==================== NOTIFICATION SETTINGS ====================

  /// Default notification values
  static const bool defaultEmailNotifications = true;
  static const bool defaultPushNotifications = true;
  static const bool defaultBookingNotifications = true;
  static const bool defaultReminderNotifications = true;

  // ==================== ACCESSIBILITY ====================

  /// Settings icon semantics
  static const String settingsIconSemantics = 'Settings icon';

  /// Account icon semantics
  static const String accountIconSemantics = 'Account settings';

  /// Preferences icon semantics
  static const String preferencesIconSemantics = 'Preferences';

  /// Notifications icon semantics
  static const String notificationsIconSemantics = 'Notification settings';

  /// About icon semantics
  static const String aboutIconSemantics = 'About';
}
