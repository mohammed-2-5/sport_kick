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
}
