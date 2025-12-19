import 'package:flutter/widgets.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/auth/presentation/constants/auth_constants.dart';

/// Password validation utility.
///
/// Provides static methods for password validation following
/// the application's password requirements.
class PasswordValidator {
  PasswordValidator._();

  /// Validates a new password against all requirements.
  ///
  /// Returns null if valid, or an error message string if invalid.
  static String? validateNewPassword(String? value, {BuildContext? context}) {
    final l10n = context?.l10n;
    if (value == null || value.isEmpty) {
      return l10n?.fieldRequired ?? AuthConstants.newPasswordRequiredMsg;
    }

    if (value.length < AuthConstants.minPasswordLength) {
      return l10n?.passwordTooShort ?? AuthConstants.passwordTooShortMsg;
    }

    if (AuthConstants.requireUppercase &&
        !RegExp(AuthConstants.uppercasePattern).hasMatch(value)) {
      return l10n?.passwordNeedUppercase ?? AuthConstants.passwordUppercaseMsg;
    }

    if (AuthConstants.requireLowercase &&
        !RegExp(AuthConstants.lowercasePattern).hasMatch(value)) {
      return l10n?.passwordNeedLowercase ?? AuthConstants.passwordLowercaseMsg;
    }

    if (AuthConstants.requireNumber &&
        !RegExp(AuthConstants.numberPattern).hasMatch(value)) {
      return l10n?.passwordNeedNumber ?? AuthConstants.passwordNumberMsg;
    }

    return null;
  }

  /// Checks if password meets minimum length requirement.
  static bool hasMinLength(String password) {
    return password.length >= AuthConstants.minPasswordLength;
  }

  /// Checks if password contains uppercase letter.
  static bool hasUppercase(String password) {
    return RegExp(AuthConstants.uppercasePattern).hasMatch(password);
  }

  /// Checks if password contains lowercase letter.
  static bool hasLowercase(String password) {
    return RegExp(AuthConstants.lowercasePattern).hasMatch(password);
  }

  /// Checks if password contains number.
  static bool hasNumber(String password) {
    return RegExp(AuthConstants.numberPattern).hasMatch(password);
  }
}
