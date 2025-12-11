import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';

/// User Preferences Model
///
/// Data model for user preferences with JSON serialization.
class UserPreferencesModel extends UserPreferencesEntity {
  const UserPreferencesModel({
    required super.userId,
    super.pushNotificationsEnabled,
    super.emailNotificationsEnabled,
    super.bookingConfirmationNotifications,
    super.bookingReminderNotifications,
    super.bookingStatusNotifications,
    super.fieldOwnerMessagesNotifications,
    super.themeMode,
    super.language,
    super.dateFormat,
    super.currency,
    super.showProfilePicture,
    super.showPhoneNumber,
    super.showEmail,
  });

  /// Create from JSON
  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) {
    return UserPreferencesModel(
      userId: json['user_id'] as String,
      pushNotificationsEnabled:
          json['push_notifications_enabled'] as bool? ?? true,
      emailNotificationsEnabled:
          json['email_notifications_enabled'] as bool? ?? true,
      bookingConfirmationNotifications:
          json['booking_confirmation_notifications'] as bool? ?? true,
      bookingReminderNotifications:
          json['booking_reminder_notifications'] as bool? ?? true,
      bookingStatusNotifications:
          json['booking_status_notifications'] as bool? ?? true,
      fieldOwnerMessagesNotifications:
          json['field_owner_messages_notifications'] as bool? ?? true,
      themeMode: _themeModeFromString(json['theme_mode'] as String?),
      language: json['language'] as String? ?? 'en',
      dateFormat: _dateFormatFromString(json['date_format'] as String?),
      currency: _currencyFromString(json['currency'] as String?),
      showProfilePicture: json['show_profile_picture'] as bool? ?? true,
      showPhoneNumber: json['show_phone_number'] as bool? ?? false,
      showEmail: json['show_email'] as bool? ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'push_notifications_enabled': pushNotificationsEnabled,
      'email_notifications_enabled': emailNotificationsEnabled,
      'booking_confirmation_notifications': bookingConfirmationNotifications,
      'booking_reminder_notifications': bookingReminderNotifications,
      'booking_status_notifications': bookingStatusNotifications,
      'field_owner_messages_notifications': fieldOwnerMessagesNotifications,
      'theme_mode': _themeModeToString(themeMode),
      'language': language,
      'date_format': _dateFormatToString(dateFormat),
      'currency': _currencyToString(currency),
      'show_profile_picture': showProfilePicture,
      'show_phone_number': showPhoneNumber,
      'show_email': showEmail,
    };
  }

  /// Convert from entity
  factory UserPreferencesModel.fromEntity(UserPreferencesEntity entity) {
    return UserPreferencesModel(
      userId: entity.userId,
      pushNotificationsEnabled: entity.pushNotificationsEnabled,
      emailNotificationsEnabled: entity.emailNotificationsEnabled,
      bookingConfirmationNotifications: entity.bookingConfirmationNotifications,
      bookingReminderNotifications: entity.bookingReminderNotifications,
      bookingStatusNotifications: entity.bookingStatusNotifications,
      fieldOwnerMessagesNotifications: entity.fieldOwnerMessagesNotifications,
      themeMode: entity.themeMode,
      language: entity.language,
      dateFormat: entity.dateFormat,
      currency: entity.currency,
      showProfilePicture: entity.showProfilePicture,
      showPhoneNumber: entity.showPhoneNumber,
      showEmail: entity.showEmail,
    );
  }

  /// Helper to convert string to AppThemeMode
  static AppThemeMode _themeModeFromString(String? value) {
    switch (value) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      case 'system':
      default:
        return AppThemeMode.system;
    }
  }

  /// Helper to convert AppThemeMode to string
  static String _themeModeToString(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'light';
      case AppThemeMode.dark:
        return 'dark';
      case AppThemeMode.system:
        return 'system';
    }
  }

  /// Helper to convert string to DateFormatOption
  static DateFormatOption _dateFormatFromString(String? value) {
    switch (value) {
      case 'dd_mm_yyyy':
        return DateFormatOption.ddMMyyyy;
      case 'mm_dd_yyyy':
        return DateFormatOption.mmDdYyyy;
      case 'yyyy_mm_dd':
        return DateFormatOption.yyyyMmDd;
      default:
        return DateFormatOption.ddMMyyyy;
    }
  }

  /// Helper to convert DateFormatOption to string
  static String _dateFormatToString(DateFormatOption format) {
    switch (format) {
      case DateFormatOption.ddMMyyyy:
        return 'dd_mm_yyyy';
      case DateFormatOption.mmDdYyyy:
        return 'mm_dd_yyyy';
      case DateFormatOption.yyyyMmDd:
        return 'yyyy_mm_dd';
    }
  }

  /// Helper to convert string to CurrencyOption
  static CurrencyOption _currencyFromString(String? value) {
    switch (value) {
      case 'egp':
        return CurrencyOption.egp;
      case 'usd':
        return CurrencyOption.usd;
      case 'eur':
        return CurrencyOption.eur;
      case 'sar':
        return CurrencyOption.sar;
      default:
        return CurrencyOption.egp;
    }
  }

  /// Helper to convert CurrencyOption to string
  static String _currencyToString(CurrencyOption currency) {
    switch (currency) {
      case CurrencyOption.egp:
        return 'egp';
      case CurrencyOption.usd:
        return 'usd';
      case CurrencyOption.eur:
        return 'eur';
      case CurrencyOption.sar:
        return 'sar';
    }
  }
}
