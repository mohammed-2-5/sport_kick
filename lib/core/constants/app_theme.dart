import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Application theme configuration.
///
/// Provides light and dark theme data for the entire app.
/// Uses Material Design 3 (Material You) theming system.
///
/// Usage in MaterialApp:
/// ```dart
/// MaterialApp(
///   theme: AppTheme.lightTheme,
///   darkTheme: AppTheme.darkTheme,
///   themeMode: ThemeMode.system,
/// )
/// ```
class AppTheme {
  // Prevent instantiation
  AppTheme._();

  // ==================== LIGHT THEME ====================

  static ThemeData get lightTheme {
    return ThemeData(
      // Use Material 3
      useMaterial3: true,

      // Color scheme
      colorScheme: _lightColorScheme,

      // Scaffold background
      scaffoldBackgroundColor: AppColors.scaffoldBackground,

      // App bar theme
      appBarTheme: _lightAppBarTheme,

      // Text theme
      textTheme: _textTheme,

      // Icon theme
      iconTheme: _lightIconTheme,

      // Button themes
      elevatedButtonTheme: _elevatedButtonTheme,
      textButtonTheme: _textButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      filledButtonTheme: _filledButtonTheme,

      // Input decoration theme
      inputDecorationTheme: _inputDecorationTheme,

      // Card theme
      cardTheme: _cardThemeData,

      // Chip theme
      chipTheme: _chipThemeData,

      // Bottom navigation bar theme
      bottomNavigationBarTheme: _bottomNavigationBarTheme,

      // Navigation rail theme
      navigationRailTheme: _navigationRailTheme,

      // Divider theme
      dividerTheme: _dividerTheme,

      // Dialog theme
      dialogTheme: _dialogThemeData,

      // Floating action button theme
      floatingActionButtonTheme: _fabTheme,

      // Snackbar theme
      snackBarTheme: _snackBarTheme,

      // Tab bar theme
      tabBarTheme: _tabBarThemeData,

      // Tooltip theme
      tooltipTheme: _tooltipTheme,

      // Bottom sheet theme
      bottomSheetTheme: _bottomSheetTheme,

      // List tile theme
      listTileTheme: _listTileTheme,

      // Switch theme
      switchTheme: _switchTheme,

      // Checkbox theme
      checkboxTheme: _checkboxTheme,

      // Radio theme
      radioTheme: _radioTheme,

      // Slider theme
      sliderTheme: _sliderTheme,

      // Progress indicator theme
      progressIndicatorTheme: _progressIndicatorTheme,

      // Visual density
      visualDensity: VisualDensity.adaptivePlatformDensity,

      // Platform brightness
      brightness: Brightness.light,
    );
  }

  // ==================== DARK THEME ====================
  // TODO: Implement dark theme when needed

  static ThemeData get darkTheme {
    return lightTheme.copyWith(
      brightness: Brightness.dark,
      // Add dark theme customizations here
    );
  }

  // ==================== COLOR SCHEMES ====================

  static const ColorScheme _lightColorScheme = ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: AppColors.textOnPrimary,
    primaryContainer: AppColors.primaryLight,
    onPrimaryContainer: AppColors.primaryDark,
    secondary: AppColors.secondary,
    onSecondary: AppColors.white,
    secondaryContainer: AppColors.secondaryLight,
    onSecondaryContainer: AppColors.secondaryDark,
    error: AppColors.error,
    onError: AppColors.white,
    errorContainer: AppColors.errorLight,
    onErrorContainer: AppColors.error,
    surface: AppColors.white,
    onSurface: AppColors.textPrimary,
    surfaceContainerHighest: AppColors.veryLightGrey,
    outline: AppColors.border,
    shadow: AppColors.shadow,
  );

  // ==================== APP BAR THEME ====================

  static const AppBarTheme _lightAppBarTheme = AppBarTheme(
    backgroundColor: AppColors.appBarBackground,
    foregroundColor: AppColors.textOnPrimary,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: AppTextStyles.appBarTitle,
    iconTheme: IconThemeData(
      color: AppColors.textOnPrimary,
      size: 24,
    ),
    actionsIconTheme: IconThemeData(
      color: AppColors.textOnPrimary,
      size: 24,
    ),
    systemOverlayStyle: SystemUiOverlayStyle.light,
  );

  // ==================== TEXT THEME ====================

  static const TextTheme _textTheme = TextTheme(
    displayLarge: AppTextStyles.displayLarge,
    displayMedium: AppTextStyles.displayMedium,
    displaySmall: AppTextStyles.displaySmall,
    headlineLarge: AppTextStyles.headlineLarge,
    headlineMedium: AppTextStyles.headlineMedium,
    headlineSmall: AppTextStyles.headlineSmall,
    titleLarge: AppTextStyles.titleLarge,
    titleMedium: AppTextStyles.titleMedium,
    titleSmall: AppTextStyles.titleSmall,
    bodyLarge: AppTextStyles.bodyLarge,
    bodyMedium: AppTextStyles.bodyMedium,
    bodySmall: AppTextStyles.bodySmall,
    labelLarge: AppTextStyles.labelLarge,
    labelMedium: AppTextStyles.labelMedium,
    labelSmall: AppTextStyles.labelSmall,
  );

  // ==================== ICON THEME ====================

  static const IconThemeData _lightIconTheme = IconThemeData(
    color: AppColors.textPrimary,
    size: 24,
  );

  // ==================== BUTTON THEMES ====================

  static final ElevatedButtonThemeData _elevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.buttonPrimary,
      foregroundColor: AppColors.buttonPrimaryText,
      disabledBackgroundColor: AppColors.buttonDisabled,
      disabledForegroundColor: AppColors.buttonDisabledText,
      elevation: 2,
      shadowColor: AppColors.shadow,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: AppTextStyles.button,
      minimumSize: const Size(88, 48),
    ),
  );

  static final TextButtonThemeData _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.buttonText,
      disabledForegroundColor: AppColors.buttonDisabledText,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: AppTextStyles.labelLarge,
    ),
  );

  static final OutlinedButtonThemeData _outlinedButtonTheme =
      OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      disabledForegroundColor: AppColors.buttonDisabledText,
      side: const BorderSide(color: AppColors.primary, width: 1.5),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: AppTextStyles.button,
      minimumSize: const Size(88, 48),
    ),
  );

  static final FilledButtonThemeData _filledButtonTheme = FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      disabledBackgroundColor: AppColors.buttonDisabled,
      disabledForegroundColor: AppColors.buttonDisabledText,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: AppTextStyles.button,
      minimumSize: const Size(88, 48),
    ),
  );

  // ==================== INPUT DECORATION THEME ====================

  static final InputDecorationTheme _inputDecorationTheme =
      InputDecorationTheme(
    filled: true,
    fillColor: AppColors.inputBackground,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.inputBorder, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.inputBorder, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.inputBorderFocused, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.inputBorderError, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.inputBorderError, width: 2),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.lightGrey, width: 1),
    ),
    labelStyle: AppTextStyles.inputLabel,
    hintStyle: AppTextStyles.inputHint,
    errorStyle: AppTextStyles.error,
    helperStyle: AppTextStyles.caption,
  );

  // ==================== CARD THEME ====================

  static final CardThemeData _cardThemeData = CardThemeData(
    color: AppColors.cardBackground,
    elevation: 2,
    shadowColor: AppColors.shadow,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    margin: const EdgeInsets.all(8),
  );

  // ==================== CHIP THEME ====================

  static final ChipThemeData _chipThemeData = ChipThemeData(
    backgroundColor: AppColors.veryLightGrey,
    deleteIconColor: AppColors.textSecondary,
    disabledColor: AppColors.lightGrey,
    selectedColor: AppColors.primary,
    secondarySelectedColor: AppColors.primaryLight,
    labelStyle: AppTextStyles.chip,
    secondaryLabelStyle: AppTextStyles.chip.copyWith(color: AppColors.white),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  // ==================== BOTTOM NAVIGATION BAR THEME ====================

  static const BottomNavigationBarThemeData _bottomNavigationBarTheme =
      BottomNavigationBarThemeData(
    backgroundColor: AppColors.bottomNavBackground,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.mediumGrey,
    selectedLabelStyle: AppTextStyles.labelSmall,
    unselectedLabelStyle: AppTextStyles.labelSmall,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  );

  // ==================== NAVIGATION RAIL THEME ====================

  static const NavigationRailThemeData _navigationRailTheme =
      NavigationRailThemeData(
    backgroundColor: AppColors.white,
    selectedIconTheme: IconThemeData(color: AppColors.primary, size: 24),
    unselectedIconTheme: IconThemeData(color: AppColors.mediumGrey, size: 24),
    selectedLabelTextStyle: AppTextStyles.labelSmall,
    unselectedLabelTextStyle: AppTextStyles.labelSmall,
  );

  // ==================== DIVIDER THEME ====================

  static const DividerThemeData _dividerTheme = DividerThemeData(
    color: AppColors.divider,
    thickness: 1,
    space: 1,
  );

  // ==================== DIALOG THEME ====================

  static final DialogThemeData _dialogThemeData = DialogThemeData(
    backgroundColor: AppColors.white,
    elevation: 24,
    shadowColor: AppColors.shadow,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(28),
    ),
    titleTextStyle: AppTextStyles.headlineSmall,
    contentTextStyle: AppTextStyles.bodyMedium,
  );

  // ==================== FAB THEME ====================

  static const FloatingActionButtonThemeData _fabTheme =
      FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.white,
    elevation: 6,
    highlightElevation: 12,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  );

  // ==================== SNACKBAR THEME ====================

  static final SnackBarThemeData _snackBarTheme = SnackBarThemeData(
    backgroundColor: AppColors.darkGrey,
    contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    behavior: SnackBarBehavior.floating,
    elevation: 6,
  );

  // ==================== TAB BAR THEME ====================

  static const TabBarThemeData _tabBarThemeData = TabBarThemeData(
    labelColor: AppColors.primary,
    unselectedLabelColor: AppColors.mediumGrey,
    labelStyle: AppTextStyles.tab,
    unselectedLabelStyle: AppTextStyles.tab,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: AppColors.primary, width: 2),
    ),
  );

  // ==================== TOOLTIP THEME ====================

  static final TooltipThemeData _tooltipTheme = TooltipThemeData(
    decoration: BoxDecoration(
      color: AppColors.darkGrey.withAlpha(230),
      borderRadius: BorderRadius.circular(4),
    ),
    textStyle: AppTextStyles.caption.copyWith(color: AppColors.white),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    waitDuration: const Duration(milliseconds: 500),
  );

  // ==================== BOTTOM SHEET THEME ====================

  static const BottomSheetThemeData _bottomSheetTheme = BottomSheetThemeData(
    backgroundColor: AppColors.white,
    elevation: 16,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    clipBehavior: Clip.antiAliasWithSaveLayer,
  );

  // ==================== LIST TILE THEME ====================

  static const ListTileThemeData _listTileTheme = ListTileThemeData(
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    minLeadingWidth: 40,
    iconColor: AppColors.textPrimary,
    textColor: AppColors.textPrimary,
  );

  // ==================== SWITCH THEME ====================

  static final SwitchThemeData _switchTheme = SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary;
      }
      return AppColors.lightGrey;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primaryLight;
      }
      return AppColors.veryLightGrey;
    }),
  );

  // ==================== CHECKBOX THEME ====================

  static final CheckboxThemeData _checkboxTheme = CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary;
      }
      return AppColors.white;
    }),
    checkColor: WidgetStateProperty.all(AppColors.white),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
  );

  // ==================== RADIO THEME ====================

  static final RadioThemeData _radioTheme = RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary;
      }
      return AppColors.mediumGrey;
    }),
  );

  // ==================== SLIDER THEME ====================

  static final SliderThemeData _sliderTheme = SliderThemeData(
    activeTrackColor: AppColors.primary,
    inactiveTrackColor: AppColors.primaryLight,
    thumbColor: AppColors.primary,
    overlayColor: AppColors.primaryWithOpacity,
    valueIndicatorColor: AppColors.primary,
    valueIndicatorTextStyle:
        AppTextStyles.caption.copyWith(color: AppColors.white),
  );

  // ==================== PROGRESS INDICATOR THEME ====================

  static const ProgressIndicatorThemeData _progressIndicatorTheme =
      ProgressIndicatorThemeData(
    color: AppColors.primary,
    linearTrackColor: AppColors.primaryLight,
    circularTrackColor: AppColors.primaryLight,
  );
}
