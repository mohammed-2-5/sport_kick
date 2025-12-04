import 'package:equatable/equatable.dart';

/// User Preferences Entity
///
/// Represents all user preferences and settings
/// including notifications, theme, and privacy options.
class UserPreferencesEntity extends Equatable {
  final String userId;
  final bool pushNotificationsEnabled;
  final bool emailNotificationsEnabled;
  final bool bookingConfirmationNotifications;
  final bool bookingReminderNotifications;
  final bool bookingStatusNotifications;
  final bool fieldOwnerMessagesNotifications;
  final AppThemeMode themeMode;
  final String language;
  final bool showProfilePicture;
  final bool showPhoneNumber;
  final bool showEmail;

  const UserPreferencesEntity({
    required this.userId,
    this.pushNotificationsEnabled = true,
    this.emailNotificationsEnabled = true,
    this.bookingConfirmationNotifications = true,
    this.bookingReminderNotifications = true,
    this.bookingStatusNotifications = true,
    this.fieldOwnerMessagesNotifications = true,
    this.themeMode = AppThemeMode.system,
    this.language = 'en',
    this.showProfilePicture = true,
    this.showPhoneNumber = false,
    this.showEmail = false,
  });

  UserPreferencesEntity copyWith({
    String? userId,
    bool? pushNotificationsEnabled,
    bool? emailNotificationsEnabled,
    bool? bookingConfirmationNotifications,
    bool? bookingReminderNotifications,
    bool? bookingStatusNotifications,
    bool? fieldOwnerMessagesNotifications,
    AppThemeMode? themeMode,
    String? language,
    bool? showProfilePicture,
    bool? showPhoneNumber,
    bool? showEmail,
  }) {
    return UserPreferencesEntity(
      userId: userId ?? this.userId,
      pushNotificationsEnabled:
          pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      emailNotificationsEnabled:
          emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      bookingConfirmationNotifications:
          bookingConfirmationNotifications ??
          this.bookingConfirmationNotifications,
      bookingReminderNotifications:
          bookingReminderNotifications ?? this.bookingReminderNotifications,
      bookingStatusNotifications:
          bookingStatusNotifications ?? this.bookingStatusNotifications,
      fieldOwnerMessagesNotifications:
          fieldOwnerMessagesNotifications ??
          this.fieldOwnerMessagesNotifications,
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      showProfilePicture: showProfilePicture ?? this.showProfilePicture,
      showPhoneNumber: showPhoneNumber ?? this.showPhoneNumber,
      showEmail: showEmail ?? this.showEmail,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    pushNotificationsEnabled,
    emailNotificationsEnabled,
    bookingConfirmationNotifications,
    bookingReminderNotifications,
    bookingStatusNotifications,
    fieldOwnerMessagesNotifications,
    themeMode,
    language,
    showProfilePicture,
    showPhoneNumber,
    showEmail,
  ];
}

/// App Theme mode enum for user preferences
enum AppThemeMode { light, dark, system }
