import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/home/presentation/widgets/curved_header_clipper.dart';

/// Premium curved header component for user-facing screens.
///
/// Features:
/// - Dark navy gradient background
/// - Curved bottom edge using ClipPath
/// - Optional back button with haptic feedback
/// - Flexible content area
/// - SafeArea handling
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
            decoration: const BoxDecoration(gradient: AppColors.navyGradient),
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
                          color: AppColors.glassHighlight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: AppColors.textOnNavy,
                            size: 20,
                          ),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            if (onBackPressed != null) {
                              onBackPressed!();
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
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
                              color: AppColors.textOnNavy,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              subtitle!,
                              style: const TextStyle(
                                color: AppColors.textOnNavySecondary,
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
