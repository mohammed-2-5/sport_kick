import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Utility class for building consistent text field decorations
///
/// Provides factory methods to create [InputDecoration] with proper styling,
/// borders, and color handling for different text field states.
class TextFieldDecorator {
  TextFieldDecorator._(); // Private constructor to prevent instantiation

  /// The border radius used for all borders
  static const double _borderRadius = 12;

  /// Builds an [InputDecoration] with consistent styling
  ///
  /// Creates a complete input decoration with:
  ///   - Hint text and styling
  ///   - Prefix icon (optional)
  ///   - Suffix icon (optional)
  ///   - Helper and error text
  ///   - Filled background with appropriate colors
  ///   - Styled borders for all states
  ///
  /// Parameters:
  ///   - [hint]: Placeholder text
  ///   - [prefixIcon]: Optional icon before input
  ///   - [suffixIcon]: Optional icon after input
  ///   - [helperText]: Optional helper text below field
  ///   - [errorText]: Error message to display
  ///   - [enabled]: Whether field is enabled (affects background color)
  ///   - [showCounter]: Whether to show character counter
  ///
  /// Returns:
  ///   A fully styled [InputDecoration] for the text field
  static InputDecoration build({
    required String hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? helperText,
    String? errorText,
    required bool enabled,
    bool showCounter = false,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondary,
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      helperText: helperText,
      errorText: errorText,
      counterText: showCounter ? null : '',
      filled: true,
      fillColor: enabled ? AppColors.inputBackground : AppColors.disabled,
      border: _buildBorder(),
      enabledBorder: _buildBorder(borderColor: AppColors.border),
      focusedBorder: _buildBorder(borderColor: AppColors.primary, width: 2),
      errorBorder: _buildBorder(borderColor: AppColors.error, width: 1.5),
      focusedErrorBorder: _buildBorder(borderColor: AppColors.error, width: 2),
      disabledBorder: _buildBorder(borderColor: AppColors.border),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  /// Builds an [OutlineInputBorder] with consistent styling
  ///
  /// Parameters:
  ///   - [borderColor]: Color of the border (default: border color)
  ///   - [width]: Width of the border (default: 1)
  ///
  /// Returns:
  ///   An [OutlineInputBorder] with the specified styling
  static OutlineInputBorder _buildBorder({
    Color borderColor = AppColors.border,
    double width = 1,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(_borderRadius),
      borderSide: BorderSide(color: borderColor, width: width),
    );
  }
}
