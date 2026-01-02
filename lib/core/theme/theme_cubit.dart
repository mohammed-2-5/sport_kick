import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spo_kick/core/theme/theme_state.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';

/// Theme Cubit
///
/// Manages the application theme mode (light/dark/system).
/// Listens to user preferences and updates the theme accordingly.
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState.initial());

  /// Set theme mode from user preference
  void setThemeMode(AppThemeMode mode) {
    if (kDebugMode) {
      debugPrint('[ThemeCubit] Setting theme mode: $mode');
    }
    emit(ThemeState.fromPreference(mode));
  }

  /// Toggle between light and dark mode
  ///
  /// If current mode is system, switches to light.
  /// If current mode is light, switches to dark.
  /// If current mode is dark, switches to light.
  void toggleTheme() {
    final newMode = switch (state.appThemeMode) {
      AppThemeMode.system => AppThemeMode.light,
      AppThemeMode.light => AppThemeMode.dark,
      AppThemeMode.dark => AppThemeMode.light,
    };
    setThemeMode(newMode);
  }

  /// Set to light mode
  void setLightMode() => setThemeMode(AppThemeMode.light);

  /// Set to dark mode
  void setDarkMode() => setThemeMode(AppThemeMode.dark);

  /// Set to system mode
  void setSystemMode() => setThemeMode(AppThemeMode.system);

  /// Check if current theme is dark
  bool get isDarkMode => state.themeMode == ThemeMode.dark;

  /// Check if current theme is light
  bool get isLightMode => state.themeMode == ThemeMode.light;

  /// Check if current theme follows system
  bool get isSystemMode => state.themeMode == ThemeMode.system;
}
