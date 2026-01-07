import 'package:spo_kick/l10n/app_localizations.dart';

/// Form validation utilities for auth forms
class FormValidators {
  FormValidators._();

  static const _emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const _minPasswordLength = 6;

  /// Validates email format
  static String? validateEmail(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.fieldRequired;
    }
    if (!RegExp(_emailRegex).hasMatch(value.trim())) {
      return l10n.enterValidEmail;
    }
    return null;
  }

  /// Validates password (minimum length)
  static String? validatePassword(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.fieldRequired;
    }
    if (value.length < _minPasswordLength) {
      return l10n.passwordMinChars;
    }
    return null;
  }

  /// Validates required field
  static String? validateRequired(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.fieldRequired;
    }
    return null;
  }
}
