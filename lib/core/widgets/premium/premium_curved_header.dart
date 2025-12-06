import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/home/presentation/widgets/curved_header_clipper.dart';

/// Premium curved header component for user-facing screens.
///
/// Features:
/// - Dark navy gradient background
/// - Curved bottom edge using ClipPath
/// - Optional back button
/// - Flexible content area
/// - Smooth entrance animation
///
/// Usage:
/// ```dart
/// PremiumCurvedHeader(
///   title: 'My Bookings',
///   subtitle: 'View and manage your bookings',
///   showBackButton: true,
/// )
/// ```
class PremiumCurvedHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final List<Widget>? actions;
  final double height;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Widget? bottom;

  const PremiumCurvedHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.actions,
    this.height = 200,
    this.showBackButton = false,
    this.onBackPressed,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Curved Background
        ClipPath(
          clipper: CurvedHeaderClipper(),
          child: Container(
            height: height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A1F3A), // Deep Navy
                  Color(0xFF2C3E50), // Lighter Navy
                ],
              ),
            ),
          ),
        ),

        // Content
        SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar (Back button, title, actions)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    // Back Button
                    if (showBackButton)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed:
                              onBackPressed ??
                              () => Navigator.of(context).pop(),
                        ),
                      ),

                    if (showBackButton) const SizedBox(width: 16),

                    // Title Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              subtitle!,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Trailing Widget (Avatar, icons, etc.)
                    if (trailing != null) ...[
                      const SizedBox(width: 16),
                      trailing!,
                    ],

                    // Actions
                    if (actions != null) ...actions!,
                  ],
                ),
              ),

              // Bottom Content (Search bar, filters, etc.)
              if (bottom != null) ...[const SizedBox(height: 16), bottom!],
            ],
          ),
        ),
      ],
    );
  }
}

/// Premium curved header with search bar.
///
/// Variation of PremiumCurvedHeader with built-in search field.
class PremiumCurvedHeaderWithSearch extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String searchHint;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchTap;
  final Widget? trailing;
  final double height;

  const PremiumCurvedHeaderWithSearch({
    super.key,
    required this.title,
    this.subtitle,
    this.searchHint = 'Search...',
    this.searchController,
    this.onSearchChanged,
    this.onSearchTap,
    this.trailing,
    this.height = 240,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCurvedHeader(
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      height: height,
      bottom: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: _SearchBar(
          hint: searchHint,
          controller: searchController,
          onChanged: onSearchChanged,
          onTap: onSearchTap,
        ),
      ),
    );
  }
}

/// Search bar widget for curved header.
class _SearchBar extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;

  const _SearchBar({
    required this.hint,
    this.controller,
    this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onTap: onTap,
        readOnly: onTap != null,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: AppColors.lightTextSecondary,
            fontSize: 16,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.lightTextSecondary,
          ),
          suffixIcon: controller?.text.isNotEmpty == true
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: AppColors.lightTextSecondary,
                  ),
                  onPressed: () {
                    controller?.clear();
                    onChanged?.call('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }
}
