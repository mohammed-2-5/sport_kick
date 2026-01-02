import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';

/// Theme State
///
/// Represents the current theme mode of the application.
class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final AppThemeMode appThemeMode;

  const ThemeState({required this.themeMode, required this.appThemeMode});

  /// Default state with system theme
  const ThemeState.initial()
    : themeMode = ThemeMode.system,
      appThemeMode = AppThemeMode.system;

  /// Create state from AppThemeMode preference
  factory ThemeState.fromPreference(AppThemeMode mode) {
    return ThemeState(themeMode: _mapToThemeMode(mode), appThemeMode: mode);
  }

  /// Maps AppThemeMode to Flutter ThemeMode
  static ThemeMode _mapToThemeMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  ThemeState copyWith({ThemeMode? themeMode, AppThemeMode? appThemeMode}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      appThemeMode: appThemeMode ?? this.appThemeMode,
    );
  }

  @override
  List<Object?> get props => [themeMode, appThemeMode];
}
