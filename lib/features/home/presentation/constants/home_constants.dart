/// Home page constants including dimensions, spacing, and strings.
///
/// This file contains all hard-coded values used in the home feature
/// to maintain consistency and ease of maintenance.
class HomeConstants {
  // Prevent instantiation
  const HomeConstants._();

  // ==================== Spacing & Dimensions ====================

  /// Main padding around the home page content
  static const double mainPadding = 24.0;

  /// Spacing between major sections
  static const double sectionSpacing = 32.0;

  /// Welcome section padding
  static const double welcomePadding = 20.0;

  /// Welcome section border radius
  static const double welcomeBorderRadius = 16.0;

  /// Welcome icon size
  static const double welcomeIconSize = 28.0;

  /// Welcome icon spacing
  static const double welcomeIconSpacing = 12.0;

  /// User info spacing
  static const double userInfoSpacing = 8.0;

  /// User info small spacing
  static const double userInfoSmallSpacing = 4.0;

  /// Phone icon size
  static const double phoneIconSize = 16.0;

  /// Phone icon spacing
  static const double phoneIconSpacing = 6.0;

  /// Role badge padding horizontal
  static const double roleBadgePaddingHorizontal = 12.0;

  /// Role badge padding vertical
  static const double roleBadgePaddingVertical = 6.0;

  /// Role badge border radius
  static const double roleBadgeBorderRadius = 20.0;

  /// Role badge font size
  static const double roleBadgeFontSize = 12.0;

  // Quick Actions Grid

  /// Quick actions grid cross axis count
  static const int quickActionsGridCrossAxisCount = 2;

  /// Quick actions grid cross axis spacing
  static const double quickActionsGridCrossAxisSpacing = 12.0;

  /// Quick actions grid main axis spacing
  static const double quickActionsGridMainAxisSpacing = 12.0;

  /// Quick actions grid child aspect ratio
  static const double quickActionsGridChildAspectRatio = 1.3;

  /// Quick actions section title spacing
  static const double quickActionsTitleSpacing = 16.0;

  /// Quick action card padding
  static const double quickActionCardPadding = 16.0;

  /// Quick action card border radius
  static const double quickActionCardBorderRadius = 16.0;

  /// Quick action icon container padding
  static const double quickActionIconPadding = 10.0;

  /// Quick action icon container border radius
  static const double quickActionIconBorderRadius = 12.0;

  /// Quick action icon size
  static const double quickActionIconSize = 28.0;

  /// Quick action title-subtitle spacing
  static const double quickActionTitleSubtitleSpacing = 2.0;

  // Upcoming Features

  /// Upcoming features section padding
  static const double upcomingFeaturesPadding = 20.0;

  /// Upcoming features border radius
  static const double upcomingFeaturesBorderRadius = 12.0;

  /// Upcoming features icon size
  static const double upcomingFeaturesIconSize = 18.0;

  /// Upcoming features icon spacing
  static const double upcomingFeaturesIconSpacing = 8.0;

  /// Upcoming features title spacing
  static const double upcomingFeaturesTitleSpacing = 12.0;

  /// Upcoming features item bottom spacing
  static const double upcomingFeaturesItemBottomSpacing = 8.0;

  // AppBar

  /// Profile icon radius
  static const double profileIconRadius = 16.0;

  /// Profile icon font size
  static const double profileIconFontSize = 14.0;

  /// AppBar trailing spacing
  static const double appBarTrailingSpacing = 8.0;

  // Animations

  /// Staggered animation duration in milliseconds
  static const int animationDurationMillis = 375;

  /// Slide animation vertical offset
  static const double animationVerticalOffset = 50.0;

  // Opacity values

  /// High opacity for white overlays
  static const double highOpacity = 0.9;

  /// Medium opacity for white overlays
  static const double mediumOpacity = 0.3;

  /// Low opacity for borders
  static const double lowOpacity = 0.2;

  // ==================== Strings ====================

  /// Welcome message
  static const String welcomeMessage = 'Welcome back!';

  /// Quick actions section title
  static const String quickActionsTitle = 'Quick Actions';

  /// Coming soon section title
  static const String comingSoonTitle = 'Coming Soon';

  /// Logout button text
  static const String logoutButtonText = 'Logout';

  /// Logout dialog title
  static const String logoutDialogTitle = 'Logout';

  /// Logout dialog message
  static const String logoutDialogMessage = 'Are you sure you want to logout?';

  /// Logout dialog cancel button
  static const String logoutDialogCancel = 'Cancel';

  /// Profile tooltip
  static const String profileTooltip = 'Profile';

  /// Guest user fallback
  static const String guestUserFallback = 'Guest';

  /// Unknown user initials fallback
  static const String unknownUserInitials = '?';

  // Quick Actions Data

  /// My profile quick action title
  static const String myProfileTitle = 'My Profile';

  /// My profile quick action subtitle
  static const String myProfileSubtitle = 'View & edit';

  /// Browse fields quick action title
  static const String browseFieldsTitle = 'Browse Fields';

  /// Browse fields quick action subtitle
  static const String browseFieldsSubtitle = 'Find fields';

  /// My bookings quick action title
  static const String myBookingsTitle = 'My Bookings';

  /// My bookings quick action subtitle
  static const String myBookingsSubtitle = 'View & manage';

  /// Favorites quick action title
  static const String favoritesTitle = 'Favorites';

  /// Favorites quick action subtitle
  static const String favoritesSubtitle = 'Coming soon';

  /// Favorites coming soon message
  static const String favoritesComingSoonMessage =
      'Favorites feature coming soon!';

  // Upcoming Features Text

  /// Browse fields feature text
  static const String featureBrowseFields = 'Browse and search sports fields';

  /// Book slots feature text
  static const String featureBookSlots = 'Book time slots instantly';

  /// Payments feature text
  static const String featurePayments = 'Secure online payments';

  /// Reviews feature text
  static const String featureReviews = 'Review and rate fields';
}
