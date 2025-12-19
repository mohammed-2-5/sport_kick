import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple cubit to manage current app locale and persist the selection.
class AppLocaleCubit extends Cubit<Locale> {
  AppLocaleCubit(this._prefs) : super(const Locale('en'));

  static const String _prefsKey = 'app_locale';
  static const List<String> _supportedCodes = ['en', 'ar'];

  final SharedPreferences _prefs;

  /// Load saved locale from preferences, if available.
  Future<void> loadSavedLocale() async {
    final saved = _prefs.getString(_prefsKey);
    if (saved != null && _supportedCodes.contains(saved)) {
      final locale = Locale(saved);
      Intl.defaultLocale = locale.languageCode;
      emit(locale);
    }
  }

  /// Update locale and persist it.
  Future<void> setLocale(String code) async {
    if (!_supportedCodes.contains(code)) {
      return;
    }
    final locale = Locale(code);
    Intl.defaultLocale = locale.languageCode;
    emit(locale);
    await _prefs.setString(_prefsKey, code);
  }
}
