import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Custom app bar for map location picker screen.
///
/// Features:
/// - Transparent background with custom back button
/// - Title in rounded container with shadow
/// - Semi-transparent styling to overlay the map
class MapAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Title to display in the app bar.
  final String title;

  /// Callback invoked when back button is pressed.
  final VoidCallback onBackPressed;

  /// Radius for the title container corners.
  static const double _titleBorderRadius = 20;

  /// Padding for the title container.
  static const EdgeInsets _titlePadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );

  /// Size of the back button icon.
  static const double _backButtonIconSize = 24;

  /// Margin around the back button.
  static const double _backButtonMargin = 8;

  /// Blur radius for shadow effects.
  static const double _shadowBlurRadius = 8;

  /// Alpha value for shadow colors.
  static const double _shadowAlpha = 0.15;

  const MapAppBar({
    super.key,
    required this.title,
    required this.onBackPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: _buildBackButton(),
      title: _buildTitleContainer(),
      centerTitle: true,
    );
  }

  /// Builds the styled back button with circular white background.
  Widget _buildBackButton() {
    return Container(
      margin: const EdgeInsets.all(_backButtonMargin),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: _shadowAlpha),
            blurRadius: _shadowBlurRadius,
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: AppColors.lightTextPrimary,
          size: _backButtonIconSize,
        ),
        onPressed: onBackPressed,
      ),
    );
  }

  /// Builds the title container with rounded corners and shadow.
  Widget _buildTitleContainer() {
    return Container(
      padding: _titlePadding,
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(_titleBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: _shadowAlpha),
            blurRadius: _shadowBlurRadius,
          ),
        ],
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.lightTextPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
