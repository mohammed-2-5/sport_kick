import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/custom_button.dart';

/// Empty state widget to display when there's no data.
///
/// Shows a friendly message when lists are empty or no content is available.
/// Supports custom icons, messages, and action buttons.
///
/// Usage:
/// ```dart
/// EmptyStateWidget(
///   icon: Icons.event_busy,
///   title: 'No Bookings',
///   message: 'You have no bookings yet',
///   actionText: 'Browse Fields',
///   onAction: () => Navigator.push(...),
/// )
/// ```
class EmptyStateWidget extends StatelessWidget {
  /// Icon to display
  final IconData icon;

  /// Title text
  final String title;

  /// Message text
  final String message;

  /// Optional action button text
  final String? actionText;

  /// Callback when action button is pressed
  final VoidCallback? onAction;

  /// Custom icon color
  final Color? iconColor;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
    this.iconColor,
  });

  /// Empty bookings state
  const EmptyStateWidget.bookings({super.key, this.actionText, this.onAction})
    : icon = Icons.event_busy_rounded,
      title = 'No Bookings Yet',
      message =
          'You haven\'t made any bookings.\nStart by browsing available fields.',
      iconColor = null;

  /// Empty fields state
  const EmptyStateWidget.fields({
    super.key,
    this.actionText,
    this.onAction,
    String? message,
  }) : icon = Icons.sports_soccer_rounded,
       title = 'No Fields Found',
       message =
           message ??
           'We couldn\'t find any football fields.\nTry adjusting your search.',
       iconColor = null;

  /// Empty search results
  const EmptyStateWidget.searchResults({
    super.key,
    this.actionText,
    this.onAction,
  }) : icon = Icons.search_off_rounded,
       title = 'No Results',
       message =
           'We couldn\'t find anything matching your search.\nTry different keywords.',
       iconColor = null;

  /// Empty favorites
  const EmptyStateWidget.favorites({super.key, this.actionText, this.onAction})
    : icon = Icons.favorite_border_rounded,
      title = 'No Favorites',
      message =
          'You haven\'t added any favorite fields yet.\nTap the heart icon to save fields.',
      iconColor = null;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Container
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 60,
                color: iconColor ?? AppColors.primary,
              ),
            ),

            const SizedBox(height: 32),

            // Title
            Text(
              title,
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Message
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            // Action Button
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 32),
              CustomButton(
                text: actionText!,
                onPressed: onAction,
                variant: ButtonVariant.primary,
                width: 220,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
