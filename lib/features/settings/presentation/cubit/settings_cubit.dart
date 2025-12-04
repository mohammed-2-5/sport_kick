import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';
import 'package:spo_kick/features/settings/domain/usecases/get_user_preferences_usecase.dart';
import 'package:spo_kick/features/settings/domain/usecases/reset_preferences_usecase.dart';
import 'package:spo_kick/features/settings/domain/usecases/update_user_preferences_usecase.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_state.dart';

/// Settings Cubit
///
/// Manages user settings and preferences state.
class SettingsCubit extends Cubit<SettingsState> {
  final GetUserPreferencesUseCase getUserPreferences;
  final UpdateUserPreferencesUseCase updateUserPreferences;
  final ResetPreferencesUseCase resetPreferences;

  SettingsCubit({
    required this.getUserPreferences,
    required this.updateUserPreferences,
    required this.resetPreferences,
  }) : super(const SettingsInitial());

  /// Load user preferences
  Future<void> loadPreferences(String userId) async {
    emit(const SettingsLoading());

    final result = await getUserPreferences(userId);

    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (preferences) => emit(SettingsLoaded(preferences)),
    );
  }

  /// Update single preference field
  Future<void> updatePreference(
    UserPreferencesEntity currentPreferences,
    UserPreferencesEntity updatedPreferences,
  ) async {
    emit(SettingsUpdating(currentPreferences));

    final result = await updateUserPreferences(updatedPreferences);

    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (preferences) =>
          emit(SettingsUpdated(preferences, 'Settings updated successfully')),
    );
  }

  /// Update theme mode
  Future<void> updateThemeMode(
    UserPreferencesEntity currentPreferences,
    AppThemeMode themeMode,
  ) async {
    final updatedPreferences = currentPreferences.copyWith(
      themeMode: themeMode,
    );
    await updatePreference(currentPreferences, updatedPreferences);
  }

  /// Update language
  Future<void> updateLanguage(
    UserPreferencesEntity currentPreferences,
    String language,
  ) async {
    final updatedPreferences = currentPreferences.copyWith(language: language);
    await updatePreference(currentPreferences, updatedPreferences);
  }

  /// Toggle push notifications
  Future<void> togglePushNotifications(
    UserPreferencesEntity currentPreferences,
  ) async {
    final updatedPreferences = currentPreferences.copyWith(
      pushNotificationsEnabled: !currentPreferences.pushNotificationsEnabled,
    );
    await updatePreference(currentPreferences, updatedPreferences);
  }

  /// Toggle email notifications
  Future<void> toggleEmailNotifications(
    UserPreferencesEntity currentPreferences,
  ) async {
    final updatedPreferences = currentPreferences.copyWith(
      emailNotificationsEnabled: !currentPreferences.emailNotificationsEnabled,
    );
    await updatePreference(currentPreferences, updatedPreferences);
  }

  /// Toggle booking confirmation notifications
  Future<void> toggleBookingConfirmationNotifications(
    UserPreferencesEntity currentPreferences,
  ) async {
    final updatedPreferences = currentPreferences.copyWith(
      bookingConfirmationNotifications:
          !currentPreferences.bookingConfirmationNotifications,
    );
    await updatePreference(currentPreferences, updatedPreferences);
  }

  /// Toggle booking reminder notifications
  Future<void> toggleBookingReminderNotifications(
    UserPreferencesEntity currentPreferences,
  ) async {
    final updatedPreferences = currentPreferences.copyWith(
      bookingReminderNotifications:
          !currentPreferences.bookingReminderNotifications,
    );
    await updatePreference(currentPreferences, updatedPreferences);
  }

  /// Toggle booking status notifications
  Future<void> toggleBookingStatusNotifications(
    UserPreferencesEntity currentPreferences,
  ) async {
    final updatedPreferences = currentPreferences.copyWith(
      bookingStatusNotifications:
          !currentPreferences.bookingStatusNotifications,
    );
    await updatePreference(currentPreferences, updatedPreferences);
  }

  /// Toggle field owner messages notifications
  Future<void> toggleFieldOwnerMessagesNotifications(
    UserPreferencesEntity currentPreferences,
  ) async {
    final updatedPreferences = currentPreferences.copyWith(
      fieldOwnerMessagesNotifications:
          !currentPreferences.fieldOwnerMessagesNotifications,
    );
    await updatePreference(currentPreferences, updatedPreferences);
  }

  /// Toggle show profile picture
  Future<void> toggleShowProfilePicture(
    UserPreferencesEntity currentPreferences,
  ) async {
    final updatedPreferences = currentPreferences.copyWith(
      showProfilePicture: !currentPreferences.showProfilePicture,
    );
    await updatePreference(currentPreferences, updatedPreferences);
  }

  /// Toggle show phone number
  Future<void> toggleShowPhoneNumber(
    UserPreferencesEntity currentPreferences,
  ) async {
    final updatedPreferences = currentPreferences.copyWith(
      showPhoneNumber: !currentPreferences.showPhoneNumber,
    );
    await updatePreference(currentPreferences, updatedPreferences);
  }

  /// Toggle show email
  Future<void> toggleShowEmail(UserPreferencesEntity currentPreferences) async {
    final updatedPreferences = currentPreferences.copyWith(
      showEmail: !currentPreferences.showEmail,
    );
    await updatePreference(currentPreferences, updatedPreferences);
  }

  /// Reset preferences to defaults
  Future<void> resetToDefaults(String userId) async {
    emit(const SettingsLoading());

    final result = await resetPreferences(userId);

    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (preferences) =>
          emit(SettingsUpdated(preferences, 'Settings reset to defaults')),
    );
  }
}
