import 'package:flutter/material.dart';

/// Application color palette.
///
/// Contains all colors used throughout the app organized by theme.
/// Use these constants instead of hardcoding colors for consistency.
///
/// ## Usage Guidelines:
///
/// ### For Theme-Aware Widgets:
/// Prefer using `Theme.of(context).colorScheme` for automatic theme switching:
/// ```dart
/// final colorScheme = Theme.of(context).colorScheme;
/// Container(color: colorScheme.surface);
/// Text('Hello', style: TextStyle(color: colorScheme.onSurface));
/// ```
///
/// ### For Semantic Colors (Success/Error/Warning/Info):
/// Use the dark-aware pattern:
/// ```dart
/// final isDark = Theme.of(context).brightness == Brightness.dark;
/// final successColor = isDark ? AppColors.darkSuccess : AppColors.success;
/// ```
///
/// ### Color Naming Convention:
/// - Light theme colors: Use base names (e.g., `primary`, `success`)
/// - Dark theme colors: Prefix with `dark` (e.g., `darkPrimary`, `darkSuccess`)
class AppColors {
  // Prevent instantiation
  AppColors._();

  // ============================================================================
  // BRAND COLORS (Used in both themes)
  // ============================================================================

  /// Primary brand color - Main app color (Blue)
  static const Color primary = Color(0xFF1565C0);

  /// Secondary brand color - Accent color (Orange)
  static const Color secondary = Color(0xFFFF6F00);

  /// Tertiary brand color - Additional accent
  static const Color tertiary = Color(0xFF00BCD4);

  // ============================================================================
  // LIGHT THEME - COLOR SCHEME COLORS
  // These map directly to ColorScheme properties for light theme
  // ============================================================================

  // --- Primary ---
  /// Light theme primary color
  static const Color lightPrimary = Color(0xFF1565C0);

  /// Light theme on-primary (text/icons on primary)
  static const Color lightOnPrimary = Color(0xFFFFFFFF);

  /// Light theme primary container
  static const Color lightPrimaryContainer = Color(0xFFD1E4FF);

  /// Light theme on-primary-container
  static const Color lightOnPrimaryContainer = Color(0xFF001D36);

  // --- Secondary ---
  /// Light theme secondary color
  static const Color lightSecondary = Color(0xFFFF6F00);

  /// Light theme on-secondary
  static const Color lightOnSecondary = Color(0xFFFFFFFF);

  /// Light theme secondary container
  static const Color lightSecondaryContainer = Color(0xFFFFDBCB);

  /// Light theme on-secondary-container
  static const Color lightOnSecondaryContainer = Color(0xFF331200);

  // --- Tertiary ---
  /// Light theme tertiary color
  static const Color lightTertiary = Color(0xFF00BCD4);

  /// Light theme on-tertiary
  static const Color lightOnTertiary = Color(0xFFFFFFFF);

  /// Light theme tertiary container
  static const Color lightTertiaryContainer = Color(0xFFB2EBF2);

  /// Light theme on-tertiary-container
  static const Color lightOnTertiaryContainer = Color(0xFF00363D);

  // --- Surface ---
  /// Light theme surface (cards, sheets, menus)
  static const Color lightSurface = Color(0xFFFFFFFF);

  /// Light theme on-surface (text on surface)
  static const Color lightOnSurface = Color(0xFF1C1B1F);

  /// Light theme on-surface-variant (secondary text)
  static const Color lightOnSurfaceVariant = Color(0xFF49454F);

  /// Light theme surface container (elevated surfaces)
  static const Color lightSurfaceContainer = Color(0xFFF3EDF7);

  /// Light theme surface container high
  static const Color lightSurfaceContainerHigh = Color(0xFFECE6F0);

  /// Light theme surface container highest
  static const Color lightSurfaceContainerHighest = Color(0xFFE6E0E9);

  // --- Background ---
  /// Light theme background (scaffold)
  static const Color lightBackground = Color(0xFFF8F9FA);

  /// Light theme on-background
  static const Color lightOnBackground = Color(0xFF1C1B1F);

  // --- Outline ---
  /// Light theme outline (borders, dividers)
  static const Color lightOutline = Color(0xFFE0E0E0);

  /// Light theme outline variant
  static const Color lightOutlineVariant = Color(0xFFCAC4D0);

  // --- Inverse ---
  /// Light theme inverse surface
  static const Color lightInverseSurface = Color(0xFF313033);

  /// Light theme on-inverse-surface
  static const Color lightOnInverseSurface = Color(0xFFF4EFF4);

  /// Light theme inverse primary
  static const Color lightInversePrimary = Color(0xFFA0CAFD);

  // --- Shadow ---
  /// Light theme shadow color
  static const Color lightShadow = Color(0x1A000000);

  // ============================================================================
  // DARK THEME - COLOR SCHEME COLORS
  // These map directly to ColorScheme properties for dark theme
  // ============================================================================

  // --- Primary ---
  /// Dark theme primary color (lighter blue for visibility)
  static const Color darkPrimary = Color(0xFF90CAF9);

  /// Dark theme on-primary
  static const Color darkOnPrimary = Color(0xFF003258);

  /// Dark theme primary container
  static const Color darkPrimaryContainer = Color(0xFF0D47A1);

  /// Dark theme on-primary-container
  static const Color darkOnPrimaryContainer = Color(0xFFD1E4FF);

  // --- Secondary ---
  /// Dark theme secondary color (lighter orange)
  static const Color darkSecondary = Color(0xFFFFB74D);

  /// Dark theme on-secondary
  static const Color darkOnSecondary = Color(0xFF4A2800);

  /// Dark theme secondary container
  static const Color darkSecondaryContainer = Color(0xFFE65100);

  /// Dark theme on-secondary-container
  static const Color darkOnSecondaryContainer = Color(0xFFFFDBCB);

  // --- Tertiary ---
  /// Dark theme tertiary color
  static const Color darkTertiary = Color(0xFF4DD0E1);

  /// Dark theme on-tertiary
  static const Color darkOnTertiary = Color(0xFF003640);

  /// Dark theme tertiary container
  static const Color darkTertiaryContainer = Color(0xFF004D59);

  /// Dark theme on-tertiary-container
  static const Color darkOnTertiaryContainer = Color(0xFFB2EBF2);

  // --- Surface ---
  /// Dark theme surface
  static const Color darkSurface = Color(0xFF1E1E1E);

  /// Dark theme on-surface
  static const Color darkOnSurface = Color(0xFFE6E1E5);

  /// Dark theme on-surface-variant
  static const Color darkOnSurfaceVariant = Color(0xFFCAC4D0);

  /// Dark theme surface container
  static const Color darkSurfaceContainer = Color(0xFF252525);

  /// Dark theme surface container high
  static const Color darkSurfaceContainerHigh = Color(0xFF353535);

  /// Dark theme surface container highest
  static const Color darkSurfaceContainerHighest = Color(0xFF3D3D3D);

  // --- Background ---
  /// Dark theme background
  static const Color darkBackground = Color(0xFF121212);

  /// Dark theme on-background
  static const Color darkOnBackground = Color(0xFFE6E1E5);

  // --- Outline ---
  /// Dark theme outline
  static const Color darkOutline = Color(0xFF3D3D3D);

  /// Dark theme outline variant
  static const Color darkOutlineVariant = Color(0xFF49454F);

  // --- Inverse ---
  /// Dark theme inverse surface
  static const Color darkInverseSurface = Color(0xFFE6E1E5);

  /// Dark theme on-inverse-surface
  static const Color darkOnInverseSurface = Color(0xFF313033);

  /// Dark theme inverse primary
  static const Color darkInversePrimary = Color(0xFF1565C0);

  // --- Shadow ---
  /// Dark theme shadow color
  static const Color darkShadow = Color(0x40000000);

  // ============================================================================
  // SEMANTIC COLORS - SUCCESS
  // ============================================================================

  /// Success color - Light theme
  static const Color success = Color(0xFF4CAF50);

  /// Success color - Dark theme (lighter for visibility)
  static const Color darkSuccess = Color(0xFF81C784);

  /// Success container - Light theme
  static const Color successContainer = Color(0xFFE8F5E9);

  /// Success container - Dark theme
  static const Color darkSuccessContainer = Color(0xFF1B5E20);

  /// On success - Light theme
  static const Color onSuccess = Color(0xFFFFFFFF);

  /// On success - Dark theme
  static const Color darkOnSuccess = Color(0xFF003A00);

  // ============================================================================
  // SEMANTIC COLORS - ERROR
  // ============================================================================

  /// Error color - Light theme
  static const Color error = Color(0xFFE53935);

  /// Error color - Dark theme (lighter for visibility)
  static const Color darkError = Color(0xFFEF5350);

  /// Error container - Light theme
  static const Color errorContainer = Color(0xFFFFEBEE);

  /// Error container - Dark theme
  static const Color darkErrorContainer = Color(0xFF93000A);

  /// On error - Light theme
  static const Color onError = Color(0xFFFFFFFF);

  /// On error - Dark theme
  static const Color darkOnError = Color(0xFF690005);

  // ============================================================================
  // SEMANTIC COLORS - WARNING
  // ============================================================================

  /// Warning color - Light theme
  static const Color warning = Color(0xFFFFA726);

  /// Warning color - Dark theme (lighter for visibility)
  static const Color darkWarning = Color(0xFFFFB74D);

  /// Warning container - Light theme
  static const Color warningContainer = Color(0xFFFFF3E0);

  /// Warning container - Dark theme
  static const Color darkWarningContainer = Color(0xFF5D4200);

  /// On warning - Light theme
  static const Color onWarning = Color(0xFF000000);

  /// On warning - Dark theme
  static const Color darkOnWarning = Color(0xFF3D2E00);

  // ============================================================================
  // SEMANTIC COLORS - INFO
  // ============================================================================

  /// Info color - Light theme
  static const Color info = Color(0xFF2196F3);

  /// Info color - Dark theme (lighter for visibility)
  static const Color darkInfo = Color(0xFF64B5F6);

  /// Info container - Light theme
  static const Color infoContainer = Color(0xFFE3F2FD);

  /// Info container - Dark theme
  static const Color darkInfoContainer = Color(0xFF004B73);

  /// On info - Light theme
  static const Color onInfo = Color(0xFFFFFFFF);

  /// On info - Dark theme
  static const Color darkOnInfo = Color(0xFF003355);

  // ============================================================================
  // TEXT COLORS
  // ============================================================================

  /// Primary text - Light theme
  static const Color textPrimary = Color(0xFF212121);

  /// Primary text - Dark theme
  static const Color darkTextPrimary = Color(0xFFE1E1E1);

  /// Secondary text - Light theme
  static const Color textSecondary = Color(0xFF757575);

  /// Secondary text - Dark theme
  static const Color darkTextSecondary = Color(0xFFA0A0A0);

  /// Disabled text - Light theme
  static const Color textDisabled = Color(0xFFBDBDBD);

  /// Disabled text - Dark theme
  static const Color darkTextDisabled = Color(0xFF5C5C5C);

  /// Text on primary color
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  /// Text on dark background
  static const Color textOnDark = Color(0xFFFFFFFF);

  /// Link text color
  static const Color textLink = Color(0xFF2196F3);

  // ============================================================================
  // NEUTRAL COLORS
  // ============================================================================

  /// Pure white
  static const Color white = Color(0xFFFFFFFF);

  /// Pure black
  static const Color black = Color(0xFF000000);

  /// Border color - Light theme
  static const Color border = Color(0xFFE0E0E0);

  /// Border color - Dark theme
  static const Color darkBorder = Color(0xFF3D3D3D);

  /// Divider color - Light theme
  static const Color divider = Color(0xFFE0E0E0);

  /// Divider color - Dark theme
  static const Color darkDivider = Color(0xFF2A2A2A);

  /// Surface variant - Light theme
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  /// Surface variant - Dark theme
  static const Color darkSurfaceVariant = Color(0xFF2D2D2D);

  // ============================================================================
  // BOOKING STATUS COLORS
  // ============================================================================

  /// Pending booking color
  static const Color bookingPending = warning;

  /// Pending booking color - Dark theme
  static const Color darkBookingPending = darkWarning;

  /// Confirmed booking color
  static const Color bookingConfirmed = success;

  /// Confirmed booking color - Dark theme
  static const Color darkBookingConfirmed = darkSuccess;

  /// Cancelled booking color
  static const Color bookingCancelled = error;

  /// Cancelled booking color - Dark theme
  static const Color darkBookingCancelled = darkError;

  /// Completed booking color
  static const Color bookingCompleted = Color(0xFF757575);

  /// Completed booking color - Dark theme
  static const Color darkBookingCompleted = Color(0xFFA0A0A0);

  // ============================================================================
  // FIELD STATUS COLORS
  // ============================================================================

  /// Field available
  static const Color fieldAvailable = success;

  /// Field available - Dark theme
  static const Color darkFieldAvailable = darkSuccess;

  /// Field occupied
  static const Color fieldOccupied = error;

  /// Field occupied - Dark theme
  static const Color darkFieldOccupied = darkError;

  /// Field inactive
  static const Color fieldInactive = Color(0xFF757575);

  /// Field inactive - Dark theme
  static const Color darkFieldInactive = Color(0xFFA0A0A0);

  // ============================================================================
  // RATING COLORS
  // ============================================================================

  /// Star rating - Active
  static const Color ratingActive = Color(0xFFFFB300);

  /// Star rating - Inactive (Light theme)
  static const Color ratingInactive = Color(0xFFE0E0E0);

  /// Star rating - Inactive (Dark theme)
  static const Color darkRatingInactive = Color(0xFF4A4A4A);

  // ============================================================================
  // SPECIAL PURPOSE COLORS
  // ============================================================================

  /// Overlay background (modals, dialogs) - Light theme
  static const Color overlay = Color(0x80000000);

  /// Overlay background - Dark theme
  static const Color darkOverlay = Color(0xB3000000);

  /// Shimmer base - Light theme
  static const Color shimmerBase = Color(0xFFE0E0E0);

  /// Shimmer base - Dark theme
  static const Color darkShimmerBase = Color(0xFF2D2D2D);

  /// Shimmer highlight - Light theme
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  /// Shimmer highlight - Dark theme
  static const Color darkShimmerHighlight = Color(0xFF3D3D3D);

  /// Icon color - Light theme
  static const Color icon = Color(0xFF757575);

  /// Icon color - Dark theme
  static const Color darkIcon = Color(0xFFB0B0B0);

  // ============================================================================
  // BACKGROUND COLORS
  // ============================================================================

  /// Scaffold background - Light theme
  static const Color scaffoldBackground = Color(0xFFFAFAFA);

  /// Scaffold background - Dark theme
  static const Color darkScaffoldBackground = Color(0xFF121212);

  /// Card background - Light theme
  static const Color cardBackground = Color(0xFFFFFFFF);

  /// Card background - Dark theme
  static const Color darkCardBackground = Color(0xFF1E1E1E);

  /// App bar background - Light theme
  static const Color appBarBackground = Color(0xFF1565C0);

  /// App bar background - Dark theme
  static const Color darkAppBarBackground = Color(0xFF1E1E1E);

  /// Bottom nav background - Light theme
  static const Color bottomNavBackground = Color(0xFFFFFFFF);

  /// Bottom nav background - Dark theme
  static const Color darkBottomNavBackground = Color(0xFF1E1E1E);

  // ============================================================================
  // INPUT COLORS
  // ============================================================================

  /// Input background - Light theme
  static const Color inputBackground = Color(0xFFFFFFFF);

  /// Input background - Dark theme
  static const Color darkInputBackground = Color(0xFF2D2D2D);

  /// Input border - Light theme
  static const Color inputBorder = Color(0xFFE0E0E0);

  /// Input border - Dark theme
  static const Color darkInputBorder = Color(0xFF3D3D3D);

  /// Input border focused - Light theme
  static const Color inputBorderFocused = Color(0xFF1565C0);

  /// Input border focused - Dark theme
  static const Color darkInputBorderFocused = Color(0xFF90CAF9);

  /// Input border error
  static const Color inputBorderError = Color(0xFFE53935);

  /// Input hint - Light theme
  static const Color inputHint = Color(0xFF757575);

  /// Input hint - Dark theme
  static const Color darkInputHint = Color(0xFFA0A0A0);

  // ============================================================================
  // BUTTON COLORS
  // ============================================================================

  /// Primary button background
  static const Color buttonPrimary = Color(0xFF1565C0);

  /// Primary button text
  static const Color buttonPrimaryText = Color(0xFFFFFFFF);

  /// Secondary button background
  static const Color buttonSecondary = Color(0xFFFF6F00);

  /// Secondary button text
  static const Color buttonSecondaryText = Color(0xFFFFFFFF);

  /// Disabled button background - Light theme
  static const Color buttonDisabled = Color(0xFFBDBDBD);

  /// Disabled button background - Dark theme
  static const Color darkButtonDisabled = Color(0xFF4A4A4A);

  /// Disabled button text
  static const Color buttonDisabledText = Color(0xFF9E9E9E);

  /// Text button color
  static const Color buttonText = Color(0xFF1565C0);

  // ============================================================================
  // PREMIUM / DESIGN-SPECIFIC COLORS
  // ============================================================================

  /// Navy deep (Header gradient start)
  static const Color navyDeep = Color(0xFF1A1F3A);

  /// Navy light (Header gradient end)
  static const Color navyLight = Color(0xFF2C3E50);

  /// Accent cyan (Premium accent)
  static const Color accentCyan = Color(0xFF00D9FF);

  /// Accent cyan light
  static const Color accentCyanLight = Color(0xFF66E7FF);

  /// Accent cyan dark
  static const Color accentCyanDark = Color(0xFF00A7CC);

  /// Gold accent (Super admin)
  static const Color goldAccent = Color(0xFFD4A574);

  /// Gold accent light
  static const Color goldAccentLight = Color(0xFFE8C9A8);

  /// Gold accent dark
  static const Color goldAccentDark = Color(0xFFB8875A);

  /// Premium gold
  static const Color premiumGold = Color(0xFFD4AF37);

  /// Premium gold dark
  static const Color premiumGoldDark = Color(0xFFB08C2F);

  // ============================================================================
  // GLASS COLORS
  // ============================================================================

  /// Glass white (20% opacity)
  static const Color glassWhite = Color(0x33FFFFFF);

  /// Glass border (30% opacity)
  static const Color glassBorder = Color(0x4DFFFFFF);

  /// Glass highlight (10% opacity)
  static const Color glassHighlight = Color(0x1AFFFFFF);

  // ============================================================================
  // SOCIAL MEDIA COLORS
  // ============================================================================

  /// Facebook
  static const Color facebook = Color(0xFF1877F2);

  /// Google
  static const Color google = Color(0xFFDB4437);

  /// WhatsApp
  static const Color whatsapp = Color(0xFF25D366);

  // ============================================================================
  // GRADIENTS - LIGHT THEME
  // ============================================================================

  /// Primary gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF0D47A1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Secondary gradient
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, Color(0xFFE65100)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Success gradient
  static const LinearGradient successGradient = LinearGradient(
    colors: [success, Color(0xFF2E7D32)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Error gradient
  static const LinearGradient errorGradient = LinearGradient(
    colors: [error, Color(0xFFB71C1C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Navy gradient (Headers)
  static const LinearGradient navyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [navyDeep, navyLight],
  );

  /// Cyan gradient (Buttons)
  static const LinearGradient cyanGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentCyan, accentCyanDark],
  );

  /// Shimmer gradient
  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [shimmerBase, shimmerHighlight, shimmerBase],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment(-1.0, -0.5),
    end: Alignment(1.0, 0.5),
  );

  // ============================================================================
  // GRADIENTS - DARK THEME
  // ============================================================================

  /// Dark primary gradient
  static const LinearGradient darkPrimaryGradient = LinearGradient(
    colors: [darkPrimary, Color(0xFF42A5F5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Dark surface gradient
  static const LinearGradient darkSurfaceGradient = LinearGradient(
    colors: [darkSurface, darkSurfaceVariant],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Dark navy gradient (Headers)
  static const LinearGradient darkNavyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D1117), Color(0xFF161B22)],
  );

  /// Dark shimmer gradient
  static const LinearGradient darkShimmerGradient = LinearGradient(
    colors: [darkShimmerBase, darkShimmerHighlight, darkShimmerBase],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment(-1.0, -0.5),
    end: Alignment(1.0, 0.5),
  );

  // ============================================================================
  // MISSING COLORS EXPECTED BY OTHER FILES
  // ============================================================================

  /// Shadow color (for use in BoxShadow)
  static const Color shadow = Color(0x1A000000);

  /// Surface white
  static const Color surfaceWhite = Color(0xFFFFFFFF);

  /// Text on navy backgrounds
  static const Color textOnNavy = Color(0xFFFFFFFF);

  /// Secondary text on navy backgrounds
  static const Color textOnNavySecondary = Color(0xB3FFFFFF);

  /// Light theme text primary (explicit name)
  static const Color lightTextPrimary = Color(0xFF212121);

  /// Light theme text secondary (explicit name)
  static const Color lightTextSecondary = Color(0xFF757575);

  /// Navy medium (between deep and light)
  static const Color navyMedium = Color(0xFF1E3A5F);

  /// Navy gradient deep (for headers)
  static const Color navyGradientDeep = Color(0xFF1A1F3A);

  /// Dark error light (for error containers in dark theme)
  static const Color darkErrorLight = Color(0xFFFFB4AB);

  /// Status success (alias for success)
  static const Color statusSuccess = success;

  /// Dark status success (alias for darkSuccess)
  static const Color darkStatusSuccess = darkSuccess;

  /// Status error (alias for error)
  static const Color statusError = error;

  /// Dark status error (alias for darkError)
  static const Color darkStatusError = darkError;

  /// Status warning (alias for warning)
  static const Color statusWarning = warning;

  /// Dark status warning (alias for darkWarning)
  static const Color darkStatusWarning = darkWarning;

  /// Status info (alias for info)
  static const Color statusInfo = info;

  /// Dark status info (alias for darkInfo)
  static const Color darkStatusInfo = darkInfo;

  /// Background light (explicit name)
  static const Color backgroundLight = Color(0xFFF8F9FA);

  /// Light accent (for light theme accent highlights)
  static const Color lightAccent = Color(0xFF64B5F6);

  /// Premium background
  static const Color premiumBackground = Color(0xFFF5F5F7);

  /// Premium surface
  static const Color premiumSurface = Color(0xFFFFFFFF);

  /// Premium periwinkle (accent for premium UI)
  static const Color premiumPeriwinkle = Color(0xFFB8C0FF);

  /// Dark premium periwinkle
  static const Color darkPremiumPeriwinkle = Color(0xFF818CF8);

  /// Premium text primary
  static const Color premiumTextPrimary = Color(0xFF1A1A2E);

  /// Premium text secondary
  static const Color premiumTextSecondary = Color(0xFF6B7280);

  /// Premium surface highlight
  static const Color premiumSurfaceHighlight = Color(0xFFF0F4F8);

  /// Premium border
  static const Color premiumBorder = Color(0xFFE5E7EB);

  // ============================================================================
  // LEGACY ALIASES (For backwards compatibility)
  // ============================================================================

  /// @Deprecated Use lightPrimary or darkPrimary instead
  static const Color primaryDark = Color(0xFF0D47A1);

  /// @Deprecated Use lightPrimaryContainer instead
  static const Color primaryLight = Color(0xFF4CAF50);

  /// @Deprecated Use colorScheme.primary.withOpacity instead
  static const Color primaryWithOpacity = Color(0x802E7D32);

  /// @Deprecated Use lightSecondary instead
  static const Color secondaryDark = Color(0xFFE65100);

  /// @Deprecated Use lightSecondaryContainer instead
  static const Color secondaryLight = Color(0xFFFF9800);

  /// @Deprecated Use colorScheme.surface instead
  static const Color surface = Color(0xFFFFFFFF);

  /// @Deprecated Use lightBackground instead
  static const Color background = Color(0xFFFAFAFA);

  /// @Deprecated Use lightOutline instead
  static const Color outline = Color(0xFFE0E0E0);

  /// @Deprecated Use buttonDisabled instead
  static const Color disabled = Color(0xFFBDBDBD);

  /// @Deprecated Use textSecondary instead
  static const Color darkGrey = Color(0xFF212121);

  /// @Deprecated Use textSecondary instead
  static const Color mediumGrey = Color(0xFF757575);

  /// @Deprecated Use textDisabled instead
  static const Color lightGrey = Color(0xFFBDBDBD);

  /// @Deprecated Use surfaceVariant instead
  static const Color veryLightGrey = Color(0xFFF5F5F5);

  /// @Deprecated Use success instead
  static const Color successLight = Color(0xFFE8F5E9);

  /// @Deprecated Use errorContainer instead
  static const Color errorLight = Color(0xFFFFEBEE);

  /// @Deprecated Use warningContainer instead
  static const Color warningLight = Color(0xFFFFF3E0);

  /// @Deprecated Use infoContainer instead
  static const Color infoLight = Color(0xFFE3F2FD);

  /// @Deprecated Use lightOnPrimary instead
  static const Color inputLabel = Color(0xFF212121);
}
