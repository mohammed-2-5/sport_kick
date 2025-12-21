import 'dart:math';
import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Application text styles with responsive scaling.
///
/// Defines all text styles used in the app for consistency.
/// Based on Material Design 3 typography scale with responsive scaling.
///
/// Usage:
/// ```dart
/// // Static usage (base size):
/// Text('Hello', style: AppTextStyles.headlineLarge)
///
/// // Responsive usage (scales with screen):
/// Text('Hello', style: context.responsive.headlineLarge)
/// Text('Hello', style: AppTextStyles.headlineLarge.responsive(context))
/// ```
class AppTextStyles {
  // Prevent instantiation
  AppTextStyles._();

  // ==================== FONT FAMILIES ====================

  /// Primary font family for body text and general UI
  /// Cairo - Supports both Arabic and English (bilingual)
  static const String fontFamily = 'Cairo';

  /// Font family for headings (English-focused, premium look)
  /// Poppins - Modern, clean sans-serif
  static const String headingFontFamily = 'Poppins';

  /// Arabic-specific font family (same as primary for RTL support)
  static const String arabicFontFamily = 'Cairo';

  // ==================== RESPONSIVE SCALING ====================

  /// Design base width (typically iPhone 14 width)
  static const double _designWidth = 375.0;

  /// Minimum scale factor (prevents text from being too small)
  static const double _minScale = 0.85;

  /// Maximum scale factor (prevents text from being too large)
  static const double _maxScale = 1.3;

  /// Tablet breakpoint width
  static const double tabletBreakpoint = 600.0;

  /// Desktop breakpoint width
  static const double desktopBreakpoint = 1200.0;

  /// Get device type based on screen width
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= desktopBreakpoint) return DeviceType.desktop;
    if (width >= tabletBreakpoint) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  /// Calculate responsive scale factor based on screen width
  static double getScaleFactor(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final textScaleFactor = MediaQuery.textScalerOf(context).scale(1.0);

    // Calculate base scale from screen width
    double scale = screenWidth / _designWidth;

    // Apply device-specific adjustments
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.tablet:
        scale = scale * 0.85; // Slightly smaller on tablets
        break;
      case DeviceType.desktop:
        scale = scale * 0.7; // Smaller on desktop
        break;
      case DeviceType.mobile:
        break; // Use calculated scale
    }

    // Clamp to min/max and respect user's text scale preference
    return (scale.clamp(_minScale, _maxScale)) * min(textScaleFactor, 1.2);
  }

  /// Get responsive font size
  static double responsiveFontSize(BuildContext context, double baseSize) {
    return baseSize * getScaleFactor(context);
  }

  // ==================== DISPLAY STYLES ====================
  // Used for the largest, most prominent text (rarely used)

  /// Display Large - 57sp
  /// Use for: Hero sections, splash screens
  static const TextStyle displayLarge = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
    color: AppColors.textPrimary,
  );

  /// Display Medium - 45sp
  /// Use for: Large marketing text, special announcements
  static const TextStyle displayMedium = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.16,
    color: AppColors.textPrimary,
  );

  /// Display Small - 36sp
  /// Use for: Prominent UI elements
  static const TextStyle displaySmall = TextStyle(
    fontFamily: headingFontFamily,
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
    fontFamily: headingFontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  /// Headline Medium - 28sp
  /// Use for: Section headers, dialog titles
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.29,
    color: AppColors.textPrimary,
  );

  /// Headline Small - 24sp
  /// Use for: Smaller section headers, card titles
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: headingFontFamily,
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
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.27,
    color: AppColors.textPrimary,
  );

  /// Title Medium - 16sp
  /// Use for: List item titles, card headers
  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.50,
    color: AppColors.textPrimary,
  );

  /// Title Small - 14sp
  /// Use for: Smaller titles, button text
  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
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
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.50,
    color: AppColors.textPrimary,
  );

  /// Body Medium - 14sp
  /// Use for: Standard body text, descriptions
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
    color: AppColors.textPrimary,
  );

  /// Body Small - 12sp
  /// Use for: Supporting text, captions
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
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
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    color: AppColors.textPrimary,
  );

  /// Label Medium - 12sp
  /// Use for: Standard buttons, tabs, chips
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
    color: AppColors.textPrimary,
  );

  /// Label Small - 11sp
  /// Use for: Small buttons, tags, badges
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
    color: AppColors.textPrimary,
  );

  // ==================== CUSTOM STYLES ====================

  /// Button text style for primary buttons
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
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
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    height: 1.29,
    color: AppColors.buttonPrimaryText,
  );

  /// Price text style - Large, bold prices
  static const TextStyle price = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.33,
    color: AppColors.primary,
  );

  /// Price text style - Medium prices
  static const TextStyle priceMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.33,
    color: AppColors.primary,
  );

  /// Price text style - Small prices
  static const TextStyle priceSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.43,
    color: AppColors.primary,
  );

  /// Caption text style - For image captions, hints
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    color: AppColors.textSecondary,
  );

  /// Overline text style - For category labels, timestamps
  static const TextStyle overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.0,
    height: 1.33,
    color: AppColors.textSecondary,
  );

  /// Link text style - For clickable text
  static const TextStyle link = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.25,
    height: 1.43,
    color: AppColors.textLink,
    decoration: TextDecoration.underline,
  );

  /// Error text style - For error messages
  static const TextStyle error = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    color: AppColors.error,
  );

  /// Success text style - For success messages
  static const TextStyle success = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    color: AppColors.success,
  );

  /// Input hint text style - For text field hints
  static const TextStyle inputHint = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.50,
    color: AppColors.inputHint,
  );

  /// Input text style - For text field content
  static const TextStyle inputText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.50,
    color: AppColors.textPrimary,
  );

  /// Input label text style - For floating labels
  static const TextStyle inputLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    color: AppColors.inputLabel,
  );

  /// AppBar title text style
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.20,
    color: AppColors.textOnPrimary,
  );

  /// Tab text style - For tab labels
  static const TextStyle tab = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    color: AppColors.textPrimary,
  );

  /// Chip text style - For chip labels
  static const TextStyle chip = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    color: AppColors.textPrimary,
  );

  /// Badge text style - For notification badges
  static const TextStyle badge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.40,
    color: AppColors.white,
  );

  /// Rating text style - For rating numbers
  static const TextStyle rating = TextStyle(
    fontFamily: fontFamily,
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

  // ==================== SEMANTIC VARIANTS (WHITE) ====================
  // Used for text on dark backgrounds

  /// Headline Large (White)
  static const TextStyle headlineLargeWhite = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.25,
    color: Colors.white,
  );

  /// Headline Medium (White)
  static const TextStyle headlineMediumWhite = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.29,
    color: Colors.white,
  );

  /// Headline Small (White)
  static const TextStyle headlineSmallWhite = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.33,
    color: Colors.white,
  );

  /// Title Large (White)
  static const TextStyle titleLargeWhite = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.27,
    color: Colors.white,
  );

  /// Title Medium (White)
  static const TextStyle titleMediumWhite = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.50,
    color: Colors.white,
  );

  /// Title Small (White)
  static const TextStyle titleSmallWhite = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    color: Colors.white,
  );

  /// Title Medium (Primary)
  /// Note: The default titleMedium is textPrimary (usually dark).
  static const TextStyle titleMediumPrimary = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.50,
    color: AppColors.primary,
  );

  /// Body Medium (White)
  static const TextStyle bodyMediumWhite = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
    color: Colors.white,
  );

  /// Body Small (White)
  static const TextStyle bodySmallWhite = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    color: Colors.white,
  );

  /// Body Large (White)
  static const TextStyle bodyLargeWhite = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.50,
    color: Colors.white,
  );

  /// Label Large (White)
  static const TextStyle labelLargeWhite = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    color: Colors.white,
  );

  /// Label Medium (White)
  static const TextStyle labelMediumWhite = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
    color: Colors.white,
  );

  /// Label Small (White)
  static const TextStyle labelSmallWhite = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
    color: Colors.white,
  );

  /// Label Medium (Secondary)
  static const TextStyle labelMediumSecondary = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
    color: AppColors.textSecondary,
  );

  // ==================== STATUS VARIANTS ====================

  /// Status: Active (Green)
  static const TextStyle statusActive = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12, // labelMedium size
    fontWeight: FontWeight.w600, // Medium/Bold
    letterSpacing: 0.5,
    height: 1.33,
    color: Colors.green,
  );

  /// Status: Inactive (Red/Orange)
  static const TextStyle statusInactive = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.33,
    color: Colors.red,
  );

  /// Status Badge Text (Active) - Small
  static const TextStyle statusBadgeActive = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11, // labelSmall size
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    height: 1.45,
    color: Colors.green,
  );

  /// Status Badge Text (Inactive) - Small
  static const TextStyle statusBadgeInactive = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    height: 1.45,
    color: Colors.orange,
  );

  /// Avatar Initial (Large)
  static const TextStyle avatarInitial = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.22,
    color: AppColors.primary,
  );

  /// Status Large: Active (Green)
  static const TextStyle statusLargeActive = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
    height: 1.43,
    color: Colors.green,
  );

  /// Status Large: Inactive (Red)
  static const TextStyle statusLargeInactive = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
    height: 1.43,
    color: Colors.red,
  );

  // ==================== BOLD VARIANTS ====================

  /// Headline Small (Bold)
  static const TextStyle headlineSmallBold = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.33,
    color: AppColors.textPrimary,
  );

  /// Title Large (Bold)
  static const TextStyle titleLargeBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.27,
    color: AppColors.textPrimary,
  );

  /// Title Medium (Bold)
  static const TextStyle titleMediumBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.15,
    height: 1.50,
    color: AppColors.textPrimary,
  );

  /// Label Small (Bold)
  static const TextStyle labelSmallBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    height: 1.45,
    color: AppColors.textPrimary,
  );

  // ==================== SECONDARY TEXT VARIANTS ====================

  /// Title Small (Secondary)
  static const TextStyle titleSmallSecondary = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    color: AppColors.textSecondary,
  );

  /// Body Medium (Secondary)
  static const TextStyle bodyMediumSecondary = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
    color: AppColors.textSecondary,
  );

  /// Body Small (Secondary)
  static const TextStyle bodySmallSecondary = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    color: AppColors.textSecondary,
  );

  /// Caption (Secondary)
  static const TextStyle captionSecondary = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.45,
    color: AppColors.textSecondary,
  );
}

// ==================== DEVICE TYPE ENUM ====================

/// Device type for responsive design
enum DeviceType { mobile, tablet, desktop }

// ==================== RESPONSIVE EXTENSION ====================

/// Extension to make any TextStyle responsive
extension ResponsiveTextStyle on TextStyle {
  /// Get responsive version of this text style
  TextStyle responsive(BuildContext context) {
    final scale = AppTextStyles.getScaleFactor(context);
    return copyWith(fontSize: (fontSize ?? 14) * scale);
  }

  /// Get responsive version with custom scale
  TextStyle responsiveScale(BuildContext context, double customScale) {
    final baseScale = AppTextStyles.getScaleFactor(context);
    return copyWith(fontSize: (fontSize ?? 14) * baseScale * customScale);
  }
}

/// Extension on BuildContext for easy access to responsive text styles
extension ResponsiveTextStyles on BuildContext {
  /// Get responsive text styles helper
  ResponsiveStylesHelper get responsive => ResponsiveStylesHelper(this);

  /// Get device type
  DeviceType get deviceType => AppTextStyles.getDeviceType(this);

  /// Check if device is mobile
  bool get isMobile => deviceType == DeviceType.mobile;

  /// Check if device is tablet
  bool get isTablet => deviceType == DeviceType.tablet;

  /// Check if device is desktop
  bool get isDesktop => deviceType == DeviceType.desktop;
}

/// Helper class for responsive text styles
/// Usage: context.responsive.headlineLarge
class ResponsiveStylesHelper {
  final BuildContext _context;
  const ResponsiveStylesHelper(this._context);

  // Display styles
  TextStyle get displayLarge => AppTextStyles.displayLarge.responsive(_context);
  TextStyle get displayMedium =>
      AppTextStyles.displayMedium.responsive(_context);
  TextStyle get displaySmall => AppTextStyles.displaySmall.responsive(_context);

  // Headline styles
  TextStyle get headlineLarge =>
      AppTextStyles.headlineLarge.responsive(_context);
  TextStyle get headlineMedium =>
      AppTextStyles.headlineMedium.responsive(_context);
  TextStyle get headlineSmall =>
      AppTextStyles.headlineSmall.responsive(_context);

  // Title styles
  TextStyle get titleLarge => AppTextStyles.titleLarge.responsive(_context);
  TextStyle get titleMedium => AppTextStyles.titleMedium.responsive(_context);
  TextStyle get titleSmall => AppTextStyles.titleSmall.responsive(_context);

  // Body styles
  TextStyle get bodyLarge => AppTextStyles.bodyLarge.responsive(_context);
  TextStyle get bodyMedium => AppTextStyles.bodyMedium.responsive(_context);
  TextStyle get bodySmall => AppTextStyles.bodySmall.responsive(_context);

  // Label styles
  TextStyle get labelLarge => AppTextStyles.labelLarge.responsive(_context);
  TextStyle get labelMedium => AppTextStyles.labelMedium.responsive(_context);
  TextStyle get labelSmall => AppTextStyles.labelSmall.responsive(_context);

  // Custom styles
  TextStyle get button => AppTextStyles.button.responsive(_context);
  TextStyle get buttonSmall => AppTextStyles.buttonSmall.responsive(_context);
  TextStyle get price => AppTextStyles.price.responsive(_context);
  TextStyle get priceMedium => AppTextStyles.priceMedium.responsive(_context);
  TextStyle get priceSmall => AppTextStyles.priceSmall.responsive(_context);
  TextStyle get caption => AppTextStyles.caption.responsive(_context);
  TextStyle get overline => AppTextStyles.overline.responsive(_context);
  TextStyle get link => AppTextStyles.link.responsive(_context);
  TextStyle get error => AppTextStyles.error.responsive(_context);
  TextStyle get success => AppTextStyles.success.responsive(_context);
  TextStyle get inputHint => AppTextStyles.inputHint.responsive(_context);
  TextStyle get inputText => AppTextStyles.inputText.responsive(_context);
  TextStyle get inputLabel => AppTextStyles.inputLabel.responsive(_context);
  TextStyle get appBarTitle => AppTextStyles.appBarTitle.responsive(_context);
  TextStyle get tab => AppTextStyles.tab.responsive(_context);
  TextStyle get chip => AppTextStyles.chip.responsive(_context);
  TextStyle get badge => AppTextStyles.badge.responsive(_context);
  TextStyle get rating => AppTextStyles.rating.responsive(_context);
}
