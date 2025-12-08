import 'package:flutter/material.dart';

/// Application color palette.
///
/// Contains all colors used throughout the app.
/// Use these constants instead of hardcoding colors for consistency.
///
/// Color naming convention:
/// - Use descriptive names that indicate usage
/// - Suffix with light/dark for variants
/// - Group related colors together
class AppColors {
  // Prevent instantiation
  AppColors._();

  // ==================== PRIMARY COLORS ====================

  /// Primary brand color - Main app color
  static const Color primary = Color(0xFF1565C0); // Medium Blue

  /// Primary color - Dark variant
  static const Color primaryDark = Color(0xFF1B5E20);

  /// Primary color - Light variant
  static const Color primaryLight = Color(0xFF4CAF50);

  /// Primary color with opacity
  static const Color primaryWithOpacity = Color(0x802E7D32);

  // ==================== SECONDARY COLORS ====================

  /// Secondary brand color - Accent color
  static const Color secondary = Color(0xFFFF6F00); // Orange accent

  /// Secondary color - Dark variant
  static const Color secondaryDark = Color(0xFFE65100);

  /// Secondary color - Light variant
  static const Color secondaryLight = Color(0xFFFF9800);

  // ==================== NEUTRAL COLORS ====================

  /// Pure black
  static const Color black = Color(0xFF000000);

  /// Pure white
  static const Color white = Color(0xFFFFFFFF);

  /// Dark grey - Primary text color
  static const Color darkGrey = Color(0xFF212121);

  /// Medium grey - Secondary text color
  static const Color mediumGrey = Color(0xFF757575);

  /// Light grey - Disabled text/borders
  static const Color lightGrey = Color(0xFFBDBDBD);

  /// Very light grey - Backgrounds
  static const Color veryLightGrey = Color(0xFFF5F5F5);

  /// Border color
  static const Color border = Color(0xFFE0E0E0);

  /// Outline color (for borders, dividers)
  static const Color outline = Color(0xFFE0E0E0);

  /// Surface variant color (for subtle backgrounds)
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  // ==================== SEMANTIC COLORS ====================

  /// Success color - Confirmed bookings, success messages
  static const Color success = Color(0xFF4CAF50);

  /// Success color - Light variant for backgrounds
  static const Color successLight = Color(0xFFE8F5E9);

  /// Error color - Cancelled bookings, error messages
  static const Color error = Color(0xFFE53935);

  /// Error color - Light variant for backgrounds
  static const Color errorLight = Color(0xFFFFEBEE);

  /// Warning color - Pending status, warnings
  static const Color warning = Color(0xFFFFA726);

  /// Warning color - Light variant for backgrounds
  static const Color warningLight = Color(0xFFFFF3E0);

  /// Info color - Information messages
  static const Color info = Color(0xFF2196F3);

  /// Info color - Light variant for backgrounds
  static const Color infoLight = Color(0xFFE3F2FD);

  // ==================== BOOKING STATUS COLORS ====================

  /// Pending booking color
  static const Color bookingPending = warning;

  /// Confirmed booking color
  static const Color bookingConfirmed = success;

  /// Cancelled booking color
  static const Color bookingCancelled = error;

  /// Completed booking color
  static const Color bookingCompleted = Color(0xFF757575);

  // ==================== FIELD STATUS COLORS ====================

  /// Field available - Can be booked
  static const Color fieldAvailable = success;

  /// Field occupied - Currently booked
  static const Color fieldOccupied = error;

  /// Field inactive - Not available for booking
  static const Color fieldInactive = mediumGrey;

  // ==================== RATING COLORS ====================

  /// Star rating color - Active star
  static const Color ratingActive = Color(0xFFFFB300); // Amber

  /// Star rating color - Inactive star
  static const Color ratingInactive = Color(0xFFE0E0E0);

  // ==================== SPECIAL PURPOSE COLORS ====================

  /// Overlay background (for modals, dialogs)
  static const Color overlay = Color(0x80000000);

  /// Shimmer base color for loading placeholders
  static const Color shimmerBase = Color(0xFFE0E0E0);

  /// Shimmer highlight color for loading placeholders
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  /// Divider color
  static const Color divider = Color(0xFFE0E0E0);

  /// Shadow color
  static const Color shadow = Color(0x1A000000);

  // ==================== BACKGROUND COLORS ====================

  /// Scaffold background color
  static const Color scaffoldBackground = Color(0xFFFAFAFA);

  /// Page background color (alias for scaffoldBackground)
  static const Color background = scaffoldBackground;

  /// Card background color
  static const Color cardBackground = white;

  /// App bar background color
  static const Color appBarBackground = primary;

  /// Bottom navigation bar background
  static const Color bottomNavBackground = white;

  // ==================== TEXT COLORS ====================

  /// Primary text color (dark on light background)
  static const Color textPrimary = darkGrey;

  /// Secondary text color (medium emphasis)
  static const Color textSecondary = mediumGrey;

  /// Disabled text color
  static const Color textDisabled = lightGrey;

  /// Text on primary color background
  static const Color textOnPrimary = white;

  /// Text on dark background
  static const Color textOnDark = white;

  /// Link text color
  static const Color textLink = info;

  // ==================== BUTTON COLORS ====================

  /// Primary button background
  static const Color buttonPrimary = primary;

  /// Primary button text
  static const Color buttonPrimaryText = white;

  /// Secondary button background
  static const Color buttonSecondary = secondary;

  /// Secondary button text
  static const Color buttonSecondaryText = white;

  /// Disabled button background
  static const Color buttonDisabled = lightGrey;

  /// Disabled button text
  static const Color buttonDisabledText = Color(0xFF9E9E9E);

  /// Text button color
  static const Color buttonText = primary;

  /// Disabled state background color
  static const Color disabled = lightGrey;

  // ==================== INPUT COLORS ====================

  /// Text field background
  static const Color inputBackground = white;

  /// Text field border
  static const Color inputBorder = border;

  /// Text field focused border
  static const Color inputBorderFocused = primary;

  /// Text field error border
  static const Color inputBorderError = error;

  /// Text field hint text
  static const Color inputHint = mediumGrey;

  /// Text field label text
  static const Color inputLabel = darkGrey;

  // ==================== SOCIAL MEDIA COLORS ====================

  /// Facebook brand color
  static const Color facebook = Color(0xFF1877F2);

  /// Google brand color
  static const Color google = Color(0xFFDB4437);

  /// WhatsApp brand color
  static const Color whatsapp = Color(0xFF25D366);

  // ==================== GRADIENTS ====================

  /// Primary gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Secondary gradient
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Success gradient
  static const LinearGradient successGradient = LinearGradient(
    colors: [success, Color(0xFF2E7D32)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Shimmer gradient for loading effect
  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [shimmerBase, shimmerHighlight, shimmerBase],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment(-1.0, -0.5),
    end: Alignment(1.0, 0.5),
  );
  // ==================== PREMIUM PALETTE (COMFORTABLE LUXURY) ====================

  /// Premium Background (Deep Matte Charcoal)
  static const Color premiumBackground = Color(0xFF121212);

  /// Premium Surface (Dark Grey)
  static const Color premiumSurface = Color(0xFF1E1E1E);

  /// Premium Surface Highlight
  static const Color premiumSurfaceHighlight = Color(0xFF2C2C2C);

  /// Premium Primary Accent (Muted Gold)
  static const Color premiumGold = Color(0xFFD4AF37);

  /// Premium Secondary Accent (Soft Periwinkle)
  static const Color premiumPeriwinkle = Color(0xFFA5A6F6);

  /// Premium Text Primary (Off-White)
  static const Color premiumTextPrimary = Color(0xFFE1E1E1);

  /// Premium Text Secondary (Medium Grey)
  static const Color premiumTextSecondary = Color(0xFFA0A0A0);

  // ==================== LIGHT THEME PALETTE (CLEAN & BRIGHT) ====================

  /// Light Theme Background (Soft White)
  static const Color lightBackground = Color(0xFFF8F9FA);

  /// Light Theme Surface (Pure White)
  static const Color lightSurface = Color(0xFFFFFFFF);

  /// Light Theme Text Primary (Dark Navy)
  static const Color lightTextPrimary = Color(0xFF1A1F3A);

  /// Light Theme Text Secondary (Medium Grey)
  static const Color lightTextSecondary = Color(0xFF6C757D);

  /// Light Theme Accent (Electric Cyan)
  static const Color lightAccent = Color(0xFF00D9FF);

  // ==================== USER THEME COLORS (PREMIUM UI) ====================

  /// User Theme - Deep Navy (Primary Dark)
  static const Color navyDeep = Color(0xFF1A1F3A);

  /// User Theme - Light Navy (Primary Light)
  static const Color navyLight = Color(0xFF2C3E50);

  /// User Theme - Accent Cyan (Primary Accent)
  static const Color accentCyan = Color(0xFF00D9FF);

  /// User Theme - Accent Cyan Light (Hover/Active States)
  static const Color accentCyanLight = Color(0xFF66E7FF);

  /// User Theme - Accent Cyan Dark (Pressed States)
  static const Color accentCyanDark = Color(0xFF00A7CC);

  /// User Theme - Surface White (Cards)
  static const Color surfaceWhite = Color(0xFFFFFFFF);

  /// User Theme - Background Light (Page Background)
  static const Color backgroundLight = Color(0xFFF8F9FA);

  /// User Theme - Text on Navy
  static const Color textOnNavy = Color(0xFFFFFFFF);

  /// User Theme - Text on Navy Secondary (70% opacity)
  static const Color textOnNavySecondary = Color(0xB3FFFFFF);

  // ==================== GLASS COLORS ====================

  /// Glass - White with 20% opacity
  static const Color glassWhite = Color(0x33FFFFFF);

  /// Glass - White border with 30% opacity
  static const Color glassBorder = Color(0x4DFFFFFF);

  /// Glass - White highlight with 10% opacity
  static const Color glassHighlight = Color(0x1AFFFFFF);

  // ==================== STATUS COLORS (VIBRANT FOR USER APP) ====================

  /// Status - Success (Emerald)
  static const Color statusSuccess = Color(0xFF10B981);

  /// Status - Warning (Amber)
  static const Color statusWarning = Color(0xFFF59E0B);

  /// Status - Error (Red)
  static const Color statusError = Color(0xFFEF4444);

  /// Status - Info (Blue)
  static const Color statusInfo = Color(0xFF3B82F6);

  // ==================== ENHANCED GRADIENTS ====================

  /// Navy Gradient (Header Background)
  static const LinearGradient navyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [navyDeep, navyLight],
  );

  /// Cyan Gradient (Primary Buttons)
  static const LinearGradient cyanGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentCyan, accentCyanDark],
  );

  /// Cyan Glow Gradient (Button Shadows)
  static const LinearGradient cyanGlowGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x4D00D9FF), // 30% opacity
      Color(0x0000D9FF), // 0% opacity
    ],
  );

  /// Success Gradient
  static const LinearGradient successGradientEnhanced = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF059669)],
  );

  /// Warning Gradient
  static const LinearGradient warningGradientEnhanced = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
  );

  /// Icon color
  static const Color icon = Color(0xFF757575);

  /// Surface color (Cards, Dialogs)
  static const Color surface = Color(0xFFFFFFFF);
}
