/// Settings Constants
///
/// Contains all constants used in the settings feature.
class SettingsConstants {
  // Spacing
  static const double sectionSpacing = 24.0;
  static const double itemSpacing = 8.0;
  static const double iconSpacing = 12.0;

  // Border radius
  static const double borderRadius = 12.0;
  static const double tileBorderRadius = 8.0;

  // Padding
  static const double screenPadding = 16.0;
  static const double sectionPadding = 16.0;
  static const double tileVerticalPadding = 8.0;
  static const double titleBottomPadding = 12.0;

  // Icon sizes
  static const double leadingIconSize = 40.0;
  static const double sectionIconSize = 20.0;
  static const double trailingIconSize = 20.0;

  // Language codes
  static const String languageEnglish = 'en';
  static const String languageArabic = 'ar';

  // Language names
  static const Map<String, String> languageNames = {
    languageEnglish: 'English',
    languageArabic: 'العربية (Arabic)',
  };

  // Theme mode names
  static const Map<String, String> themeModeNames = {
    'light': 'Light',
    'dark': 'Dark',
    'system': 'System Default',
  };

  // App version
  static const String appVersion = '1.0.0';

  // Support contact
  static const String supportEmail = 'mohammedyasser2023@gmail.com';

  // Note: Privacy Policy and Terms of Service are now in-app pages
  // Routes defined in AppRouter: AppRouter.privacyPolicy, AppRouter.termsOfService

  // Messages
  static const String settingsUpdateSuccess = 'Settings updated successfully';
  static const String settingsResetSuccess = 'Settings reset to defaults';
  static const String settingsLoadError = 'Failed to load settings';
  static const String settingsUpdateError = 'Failed to update settings';
}
