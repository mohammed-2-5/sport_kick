import 'package:flutter/material.dart';

/// UI constants for Super Admin feature
class AdminUIConstants {
  AdminUIConstants._();

  // Spacing
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  // Padding
  static const EdgeInsets paddingAll = EdgeInsets.all(spacingMedium);
  static const EdgeInsets paddingHorizontal = EdgeInsets.symmetric(
    horizontal: spacingMedium,
  );
  static const EdgeInsets paddingVertical = EdgeInsets.symmetric(
    vertical: spacingMedium,
  );
  static const EdgeInsets paddingCard = EdgeInsets.all(12.0);
  static const EdgeInsets paddingButton = EdgeInsets.symmetric(vertical: 14.0);
  static const EdgeInsets paddingHeader = EdgeInsets.all(24.0);

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;
  static const double radiusCircular = 50.0;

  static BorderRadius borderRadiusSmall = BorderRadius.circular(radiusSmall);
  static BorderRadius borderRadiusMedium = BorderRadius.circular(radiusMedium);
  static BorderRadius borderRadiusLarge = BorderRadius.circular(radiusLarge);
  static BorderRadius borderRadiusXLarge = BorderRadius.circular(radiusXLarge);

  // Icon Sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;

  // Avatar Sizes
  static const double avatarSizeSmall = 32.0;
  static const double avatarSizeMedium = 50.0;
  static const double avatarSizeLarge = 80.0;

  // Card Dimensions
  static const double cardElevation = 2.0;
  static const double cardMarginBottom = 12.0;
  static const double cardImageSize = 60.0;

  // Typography Sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 20.0;
  static const double fontSizeXXLarge = 24.0;
  static const double fontSizeTitle = 36.0;

  // Font Weights
  static const FontWeight fontWeightNormal = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;
  static const FontWeight fontWeightExtraBold = FontWeight.w800;

  // Component Dimensions
  static const double buttonHeight = 48.0;
  static const double inputHeight = 56.0;
  static const double appBarHeight = 56.0;
  static const double tabBarHeight = 48.0;

  // List Item Dimensions
  static const double listItemHeight = 72.0;
  static const double listItemImageSize = 60.0;
  static const double listItemSpacing = 12.0;

  // Stats Card
  static const double statCardIconSize = 32.0;
  static const double statCardValueSize = 24.0;
  static const double statCardLabelSize = 12.0;

  // Dialog
  static const double dialogMaxWidth = 500.0;
  static const double dialogPadding = 24.0;

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Opacity Values
  static const double opacityDisabled = 0.5;
  static const double opacityLight = 0.1;
  static const double opacityMedium = 0.3;
  static const double opacityHeavy = 0.8;

  // Status Badge
  static const EdgeInsets badgePadding = EdgeInsets.symmetric(
    horizontal: 8.0,
    vertical: 4.0,
  );
  static const double badgeFontSize = 11.0;
  static const double badgeIndicatorSize = 8.0;

  // Empty State
  static const double emptyStateIconSize = 48.0;
  static const double emptyStatePadding = 32.0;
}
