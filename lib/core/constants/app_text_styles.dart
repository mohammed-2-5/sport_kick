import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Application text styles.
///
/// Defines all text styles used in the app for consistency.
/// Based on Material Design 3 typography scale.
///
/// Usage:
/// ```dart
/// Text('Hello', style: AppTextStyles.headlineLarge)
/// ```
class AppTextStyles {
  // Prevent instantiation
  AppTextStyles._();

  /// Base font family for the app
  static const String _fontFamily = 'Roboto';

  /// Alternative font family for headings (optional)
  static const String _headingFontFamily = 'Roboto';

  // ==================== DISPLAY STYLES ====================
  // Used for the largest, most prominent text (rarely used)

  /// Display Large - 57sp
  /// Use for: Hero sections, splash screens
  static const TextStyle displayLarge = TextStyle(
    fontFamily: _headingFontFamily,
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
    color: AppColors.textPrimary,
  );

  /// Display Medium - 45sp
  /// Use for: Large marketing text, special announcements
  static const TextStyle displayMedium = TextStyle(
    fontFamily: _headingFontFamily,
    fontSize: 45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.16,
    color: AppColors.textPrimary,
  );

  /// Display Small - 36sp
  /// Use for: Prominent UI elements
  static const TextStyle displaySmall = TextStyle(
    fontFamily: _headingFontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.22,
    color: AppColors.textPrimary,
  );

  // ==================== HEADLINE STYLES ====================
  // Used for short, important text (screen titles, dialog headers)

  /// Headline Large - 32sp
  /// Use for: Main screen titles
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: _headingFontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  /// Headline Medium - 28sp
  /// Use for: Section headers, dialog titles
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: _headingFontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.29,
    color: AppColors.textPrimary,
  );

  /// Headline Small - 24sp
  /// Use for: Smaller section headers, card titles
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: _headingFontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.33,
    color: AppColors.textPrimary,
  );

  // ==================== TITLE STYLES ====================
  // Used for medium-emphasis text (list item titles, section headers)

  /// Title Large - 22sp
  /// Use for: Prominent list items, emphasized content
  static const TextStyle titleLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.27,
    color: AppColors.textPrimary,
  );

  /// Title Medium - 16sp
  /// Use for: List item titles, card headers
  static const TextStyle titleMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.50,
    color: AppColors.textPrimary,
  );

  /// Title Small - 14sp
  /// Use for: Smaller titles, button text
  static const TextStyle titleSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    color: AppColors.textPrimary,
  );

  // ==================== BODY STYLES ====================
  // Used for most UI text (paragraphs, descriptions)

  /// Body Large - 16sp
  /// Use for: Longer paragraphs, main content
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.50,
    color: AppColors.textPrimary,
  );

  /// Body Medium - 14sp
  /// Use for: Standard body text, descriptions
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
    color: AppColors.textPrimary,
  );

  /// Body Small - 12sp
  /// Use for: Supporting text, captions
  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    color: AppColors.textSecondary,
  );

  // ==================== LABEL STYLES ====================
  // Used for UI components (buttons, tabs, labels)

  /// Label Large - 14sp
  /// Use for: Large buttons, prominent labels
  static const TextStyle labelLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    color: AppColors.textPrimary,
  );

  /// Label Medium - 12sp
  /// Use for: Standard buttons, tabs, chips
  static const TextStyle labelMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
    color: AppColors.textPrimary,
  );

  /// Label Small - 11sp
  /// Use for: Small buttons, tags, badges
  static const TextStyle labelSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
    color: AppColors.textPrimary,
  );

  // ==================== CUSTOM STYLES ====================

  /// Button text style for primary buttons
  static const TextStyle button = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.25,
    color: AppColors.buttonPrimaryText,
  );

  /// Button text style (alias for button)
  static const TextStyle buttonText = button;

  /// Button text style for small buttons
  static const TextStyle buttonSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    height: 1.29,
    color: AppColors.buttonPrimaryText,
  );

  /// Price text style - Large, bold prices
  static const TextStyle price = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.33,
    color: AppColors.primary,
  );

  /// Price text style - Medium prices
  static const TextStyle priceMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.33,
    color: AppColors.primary,
  );

  /// Price text style - Small prices
  static const TextStyle priceSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.43,
    color: AppColors.primary,
  );

  /// Caption text style - For image captions, hints
  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    color: AppColors.textSecondary,
  );

  /// Overline text style - For category labels, timestamps
  static const TextStyle overline = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.0,
    height: 1.33,
    color: AppColors.textSecondary,
  );

  /// Link text style - For clickable text
  static const TextStyle link = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.25,
    height: 1.43,
    color: AppColors.textLink,
    decoration: TextDecoration.underline,
  );

  /// Error text style - For error messages
  static const TextStyle error = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    color: AppColors.error,
  );

  /// Success text style - For success messages
  static const TextStyle success = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    color: AppColors.success,
  );

  /// Input hint text style - For text field hints
  static const TextStyle inputHint = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.50,
    color: AppColors.inputHint,
  );

  /// Input text style - For text field content
  static const TextStyle inputText = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.50,
    color: AppColors.textPrimary,
  );

  /// Input label text style - For floating labels
  static const TextStyle inputLabel = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    color: AppColors.inputLabel,
  );

  /// AppBar title text style
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: _headingFontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.20,
    color: AppColors.textOnPrimary,
  );

  /// Tab text style - For tab labels
  static const TextStyle tab = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    color: AppColors.textPrimary,
  );

  /// Chip text style - For chip labels
  static const TextStyle chip = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    color: AppColors.textPrimary,
  );

  /// Badge text style - For notification badges
  static const TextStyle badge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.40,
    color: AppColors.white,
  );

  /// Rating text style - For rating numbers
  static const TextStyle rating = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.50,
    color: AppColors.textPrimary,
  );

  // ==================== HELPER METHODS ====================

  /// Create a custom text style based on bodyMedium
  static TextStyle custom({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return bodyMedium.copyWith(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  /// Apply color to any text style
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Apply weight to any text style
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  /// Make any text style bold
  static TextStyle bold(TextStyle style) {
    return style.copyWith(fontWeight: FontWeight.w700);
  }

  /// Make any text style semibold
  static TextStyle semiBold(TextStyle style) {
    return style.copyWith(fontWeight: FontWeight.w600);
  }

  /// Make any text style italic
  static TextStyle italic(TextStyle style) {
    return style.copyWith(fontStyle: FontStyle.italic);
  }
}
