import 'package:flutter/services.dart';
import 'package:spo_kick/core/widgets/custom_text_field.dart';

/// Utility functions for custom text field configuration
class TextFieldUtils {
  TextFieldUtils._(); // Private constructor to prevent instantiation

  /// Determines the keyboard type based on text field type
  ///
  /// Returns the appropriate [TextInputType] for the given [TextFieldType].
  /// If a custom keyboard type is provided, it takes precedence.
  ///
  /// Parameters:
  ///   - [type]: The [TextFieldType] to determine keyboard for
  ///   - [customKeyboardType]: Optional custom keyboard type override
  ///
  /// Returns:
  ///   A [TextInputType] suitable for the field type
  static TextInputType getKeyboardType(
    TextFieldType type, {
    TextInputType? customKeyboardType,
  }) {
    // Custom keyboard type takes precedence
    if (customKeyboardType != null) {
      return customKeyboardType;
    }

    return switch (type) {
      TextFieldType.email => TextInputType.emailAddress,
      TextFieldType.phone => TextInputType.phone,
      TextFieldType.number => TextInputType.number,
      TextFieldType.multiline => TextInputType.multiline,
      TextFieldType.password || TextFieldType.text => TextInputType.text,
    };
  }

  /// Determines input formatters based on text field type
  ///
  /// Returns a list of [TextInputFormatter] for the given [TextFieldType].
  /// Each type has specific formatting requirements:
  ///   - phone: Digits only, max 11 characters
  ///   - number: Digits only
  ///   - other types: No specific formatting
  ///
  /// Parameters:
  ///   - [type]: The [TextFieldType] to determine formatters for
  ///   - [customFormatters]: Optional custom formatters (takes precedence)
  ///
  /// Returns:
  ///   A list of [TextInputFormatter], or null if no formatters needed
  static List<TextInputFormatter>? getInputFormatters(
    TextFieldType type, {
    List<TextInputFormatter>? customFormatters,
  }) {
    // Custom formatters take precedence
    if (customFormatters != null) {
      return customFormatters;
    }

    return switch (type) {
      TextFieldType.phone => [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11),
      ],
      TextFieldType.number => [FilteringTextInputFormatter.digitsOnly],
      _ => null,
    };
  }
}
