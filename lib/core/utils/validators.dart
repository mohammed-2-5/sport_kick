import 'package:flutter/widgets.dart';
import 'package:spo_kick/core/constants/app_constants.dart';
import 'package:spo_kick/core/constants/app_strings.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Form validation utilities.
///
/// Provides reusable validation functions for form fields.
/// All validators return null if validation passes, or an error string if it fails.
///
/// Usage in TextFormField:
/// ```dart
/// TextFormField(
///   validator: Validators.email,
/// )
/// ```
class Validators {
  // Prevent instantiation
  Validators._();

  // ==================== EMAIL VALIDATION ====================

  /// Validate email address.
  ///
  /// Checks:
  /// - Not empty
  /// - Valid email format (RFC 5322 simplified)
  ///
  /// Returns: Error message or null if valid
  static String? email(String? value, {BuildContext? context}) {
    final l10n = context?.l10n;
    if (value == null || value.trim().isEmpty) {
      return l10n?.fieldRequired ?? AppStrings.fieldRequired;
    }

    // Email regex pattern (simplified RFC 5322)
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

    final regex = RegExp(pattern);

    if (!regex.hasMatch(value.trim())) {
      return l10n?.invalidEmail ?? AppStrings.invalidEmail;
    }

    return null;
  }

  // ==================== PASSWORD VALIDATION ====================

  /// Validate password.
  ///
  /// Checks:
  /// - Not empty
  /// - Minimum length (from AppConstants.minPasswordLength)
  /// - Maximum length (from AppConstants.maxPasswordLength)
  ///
  /// Returns: Error message or null if valid
  static String? password(String? value, {BuildContext? context}) {
    final l10n = context?.l10n;
    if (value == null || value.isEmpty) {
      return l10n?.fieldRequired ?? AppStrings.fieldRequired;
    }

    if (value.length < AppConstants.minPasswordLength) {
      return l10n?.passwordTooShort ?? AppStrings.passwordTooShort;
    }

    if (value.length > AppConstants.maxPasswordLength) {
      return l10n?.passwordTooLong(AppConstants.maxPasswordLength) ??
          'Password must be less than ${AppConstants.maxPasswordLength} characters';
    }

    return null;
  }

  /// Validate password with strength requirements.
  ///
  /// Checks:
  /// - All password() checks
  /// - At least one uppercase letter
  /// - At least one lowercase letter
  /// - At least one number
  /// - At least one special character
  ///
  /// Returns: Error message or null if valid
  static String? strongPassword(String? value, {BuildContext? context}) {
    final l10n = context?.l10n;
    // First check basic password validation
    final basicValidation = password(value, context: context);
    if (basicValidation != null) {
      return basicValidation;
    }

    // Check for uppercase
    if (!value!.contains(RegExp(r'[A-Z]'))) {
      return l10n?.passwordNeedUppercase ??
          'Password must contain at least one uppercase letter';
    }

    // Check for lowercase
    if (!value.contains(RegExp(r'[a-z]'))) {
      return l10n?.passwordNeedLowercase ??
          'Password must contain at least one lowercase letter';
    }

    // Check for number
    if (!value.contains(RegExp(r'[0-9]'))) {
      return l10n?.passwordNeedNumber ??
          'Password must contain at least one number';
    }

    // Check for special character
    if (!value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
      return l10n?.passwordNeedSpecial ??
          'Password must contain at least one special character';
    }

    return null;
  }

  /// Confirm password matches.
  ///
  /// Returns a validator function that compares with original password.
  ///
  /// Usage:
  /// ```dart
  /// TextFormField(
  ///   validator: Validators.confirmPassword(passwordController.text),
  /// )
  /// ```
  static String? Function(String?) confirmPassword(
    String password, {
    BuildContext? context,
  }) {
    final l10n = context?.l10n;
    return (String? value) {
      if (value == null || value.isEmpty) {
        return l10n?.fieldRequired ?? AppStrings.fieldRequired;
      }

      if (value != password) {
        return l10n?.passwordsDoNotMatch ?? AppStrings.passwordsDoNotMatch;
      }

      return null;
    };
  }

  // ==================== NAME VALIDATION ====================

  /// Validate full name.
  ///
  /// Checks:
  /// - Not empty
  /// - Minimum length (from AppConstants.minNameLength)
  /// - Maximum length (from AppConstants.maxNameLength)
  /// - Contains only letters and spaces
  ///
  /// Returns: Error message or null if valid
  static String? name(String? value, {BuildContext? context}) {
    final l10n = context?.l10n;
    if (value == null || value.trim().isEmpty) {
      return l10n?.fieldRequired ?? AppStrings.fieldRequired;
    }

    final trimmed = value.trim();

    if (trimmed.length < AppConstants.minNameLength) {
      return l10n?.nameTooShort ?? AppStrings.nameTooShort;
    }

    if (trimmed.length > AppConstants.maxNameLength) {
      return l10n?.nameTooLong(AppConstants.maxNameLength) ??
          'Name must be less than ${AppConstants.maxNameLength} characters';
    }

    // Allow letters, spaces, hyphens, apostrophes
    const pattern = r"^[a-zA-Z\s\-']+$";
    final regex = RegExp(pattern);

    if (!regex.hasMatch(trimmed)) {
      return l10n?.nameLettersOnly ??
          'Name can only contain letters and spaces';
    }

    return null;
  }

  // ==================== PHONE VALIDATION ====================

  /// Validate Egyptian phone number.
  ///
  /// Checks:
  /// - Not empty
  /// - 11 digits
  /// - Starts with 01
  ///
  /// Returns: Error message or null if valid
  static String? egyptianPhone(String? value, {BuildContext? context}) {
    final l10n = context?.l10n;
    if (value == null || value.trim().isEmpty) {
      return l10n?.fieldRequired ?? AppStrings.fieldRequired;
    }

    // Remove any spaces or dashes
    final cleaned = value.replaceAll(RegExp(r'[\s\-]'), '');

    // Must be 11 digits
    if (cleaned.length != AppConstants.phoneNumberLength) {
      return l10n?.phoneMustBe11Digits ?? 'Phone number must be 11 digits';
    }

    // Must be all digits
    if (!RegExp(r'^\d+$').hasMatch(cleaned)) {
      return l10n?.phoneDigitsOnly ?? 'Phone number can only contain digits';
    }

    // Must start with 01
    if (!cleaned.startsWith('01')) {
      return l10n?.phoneMustStartWith01 ?? 'Phone number must start with 01';
    }

    return null;
  }

  /// Validate international phone number.
  ///
  /// Checks:
  /// - Not empty
  /// - Valid international format (+XXX...)
  /// - Between 10 and 15 digits
  ///
  /// Returns: Error message or null if valid
  static String? internationalPhone(String? value, {BuildContext? context}) {
    final l10n = context?.l10n;
    if (value == null || value.trim().isEmpty) {
      return l10n?.fieldRequired ?? AppStrings.fieldRequired;
    }

    // Remove spaces and dashes
    final cleaned = value.replaceAll(RegExp(r'[\s\-]'), '');

    // Must start with + or be all digits
    const pattern = r'^\+?\d{10,15}$';
    final regex = RegExp(pattern);

    if (!regex.hasMatch(cleaned)) {
      return l10n?.invalidPhone ?? AppStrings.invalidPhone;
    }

    return null;
  }

  // ==================== NUMBER VALIDATION ====================

  /// Validate number.
  ///
  /// Checks:
  /// - Not empty
  /// - Is a valid number
  /// - Optional: within min/max range
  ///
  /// Returns: Error message or null if valid
  static String? number(
    String? value, {
    double? min,
    double? max,
    BuildContext? context,
  }) {
    final l10n = context?.l10n;
    if (value == null || value.trim().isEmpty) {
      return l10n?.fieldRequired ?? AppStrings.fieldRequired;
    }

    final number = double.tryParse(value);
    if (number == null) {
      return l10n?.enterValidNumber ?? 'Please enter a valid number';
    }

    if (min != null && number < min) {
      return l10n?.numberAtLeast(min) ?? 'Number must be at least $min';
    }

    if (max != null && number > max) {
      return l10n?.numberAtMost(max) ?? 'Number must be at most $max';
    }

    return null;
  }

  /// Validate integer.
  ///
  /// Checks:
  /// - Not empty
  /// - Is a valid integer
  /// - Optional: within min/max range
  ///
  /// Returns: Error message or null if valid
  static String? integer(
    String? value, {
    int? min,
    int? max,
    BuildContext? context,
  }) {
    final l10n = context?.l10n;
    if (value == null || value.trim().isEmpty) {
      return l10n?.fieldRequired ?? AppStrings.fieldRequired;
    }

    final number = int.tryParse(value);
    if (number == null) {
      return l10n?.enterValidInteger ?? 'Please enter a valid whole number';
    }

    if (min != null && number < min) {
      return l10n?.numberAtLeast(min) ?? 'Number must be at least $min';
    }

    if (max != null && number > max) {
      return l10n?.numberAtMost(max) ?? 'Number must be at most $max';
    }

    return null;
  }

  // ==================== REQUIRED FIELD ====================

  /// Validate required field.
  ///
  /// Checks:
  /// - Not empty
  /// - Not just whitespace
  ///
  /// Returns: Error message or null if valid
  static String? required(String? value, {BuildContext? context}) {
    final l10n = context?.l10n;
    if (value == null || value.trim().isEmpty) {
      return l10n?.fieldRequired ?? AppStrings.fieldRequired;
    }
    return null;
  }

  // ==================== LENGTH VALIDATION ====================

  /// Validate minimum length.
  ///
  /// Returns a validator function that checks minimum length.
  ///
  /// Usage:
  /// ```dart
  /// TextFormField(
  ///   validator: Validators.minLength(3),
  /// )
  /// ```
  static String? Function(String?) minLength(
    int length, {
    BuildContext? context,
  }) {
    final l10n = context?.l10n;
    return (String? value) {
      if (value == null || value.isEmpty) {
        return l10n?.fieldRequired ?? AppStrings.fieldRequired;
      }

      if (value.length < length) {
        return l10n?.minLengthChars(length) ??
            'Must be at least $length characters';
      }

      return null;
    };
  }

  /// Validate maximum length.
  ///
  /// Returns a validator function that checks maximum length.
  static String? Function(String?) maxLength(
    int length, {
    BuildContext? context,
  }) {
    final l10n = context?.l10n;
    return (String? value) {
      if (value != null && value.length > length) {
        return l10n?.maxLengthChars(length) ??
            'Must be at most $length characters';
      }
      return null;
    };
  }

  /// Validate exact length.
  ///
  /// Returns a validator function that checks exact length.
  static String? Function(String?) exactLength(
    int length, {
    BuildContext? context,
  }) {
    final l10n = context?.l10n;
    return (String? value) {
      if (value == null || value.isEmpty) {
        return l10n?.fieldRequired ?? AppStrings.fieldRequired;
      }

      if (value.length != length) {
        return l10n?.exactLengthChars(length) ??
            'Must be exactly $length characters';
      }

      return null;
    };
  }

  // ==================== URL VALIDATION ====================

  /// Validate URL.
  ///
  /// Checks:
  /// - Not empty
  /// - Valid URL format
  ///
  /// Returns: Error message or null if valid
  static String? url(String? value, {BuildContext? context}) {
    final l10n = context?.l10n;
    if (value == null || value.trim().isEmpty) {
      return l10n?.fieldRequired ?? AppStrings.fieldRequired;
    }

    const pattern =
        r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$';
    final regex = RegExp(pattern);

    if (!regex.hasMatch(value.trim())) {
      return l10n?.enterValidUrl ?? 'Please enter a valid URL';
    }

    return null;
  }

  // ==================== COMPOSITE VALIDATORS ====================

  /// Combine multiple validators.
  ///
  /// Returns the first error encountered, or null if all pass.
  ///
  /// Usage:
  /// ```dart
  /// TextFormField(
  ///   validator: Validators.compose([
  ///     Validators.required,
  ///     Validators.email,
  ///     Validators.minLength(5),
  ///   ]),
  /// )
  /// ```
  static String? Function(String?) compose(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) {
          return error;
        }
      }
      return null;
    };
  }
}
