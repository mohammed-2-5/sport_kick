import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';

/// Settings State
///
/// Represents the state of user settings and preferences.
abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

/// Loading state
class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

/// Loaded state with preferences
class SettingsLoaded extends SettingsState {
  final UserPreferencesEntity preferences;

  const SettingsLoaded(this.preferences);

  @override
  List<Object?> get props => [preferences];
}

/// Updating state (for showing loading indicator on specific updates)
class SettingsUpdating extends SettingsState {
  final UserPreferencesEntity currentPreferences;

  const SettingsUpdating(this.currentPreferences);

  @override
  List<Object?> get props => [currentPreferences];
}

/// Updated state (success after update)
class SettingsUpdated extends SettingsState {
  final UserPreferencesEntity preferences;
  final String message;

  const SettingsUpdated(this.preferences, this.message);

  @override
  List<Object?> get props => [preferences, message];
}

/// Error state
class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
