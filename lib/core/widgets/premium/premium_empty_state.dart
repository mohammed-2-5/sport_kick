import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';

/// Premium empty state widget with icon, message, and optional action.
///
/// Features:
/// - Large icon with cyan accent
/// - Bold title
/// - Descriptive message
/// - Optional action button
/// - Subtle floating animation
///
/// Usage:
/// ```dart
/// PremiumEmptyState(
///   icon: Icons.bookmark_border,
///   title: 'No Favorites Yet',
///   message: 'Start adding fields to your favorites',
///   actionLabel: 'Browse Fields',
///   onAction: () => navigate(),
/// )
/// ```
class PremiumEmptyState extends StatefulWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;
  final double iconSize;

  const PremiumEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.iconColor,
    this.iconSize = 120,
  });

  @override
  State<PremiumEmptyState> createState() => _PremiumEmptyStateState();
}

class _PremiumEmptyStateState extends State<PremiumEmptyState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated Icon
            AnimatedBuilder(
              animation: _floatAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _floatAnimation.value),
                  child: child,
                );
              },
              child: Container(
                width: widget.iconSize,
                height: widget.iconSize,
                decoration: BoxDecoration(
                  color: (widget.iconColor ?? const Color(0xFF00D9FF))
                      .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  size: widget.iconSize * 0.5,
                  color: widget.iconColor ?? const Color(0xFF00D9FF),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Title
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.lightTextPrimary,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 12),

            // Message
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.lightTextSecondary,
                height: 1.5,
              ),
            ),

            // Action Button
            if (widget.actionLabel != null && widget.onAction != null) ...[
              const SizedBox(height: 32),
              PremiumButton(
                label: widget.actionLabel!,
                onPressed: widget.onAction,
                style: PremiumButtonStyle.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Compact empty state for smaller areas.
///
/// Simplified version without action button.
class CompactEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color? iconColor;

  const CompactEmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: (iconColor ?? const Color(0xFF00D9FF)).withValues(
                  alpha: 0.1,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: iconColor ?? const Color(0xFF00D9FF),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Predefined empty states for common scenarios.
class EmptyStates {
  EmptyStates._();

  /// No favorites found
  static PremiumEmptyState noFavorites({VoidCallback? onBrowse}) {
    return PremiumEmptyState(
      icon: Icons.bookmark_border,
      title: 'No Favorites Yet',
      message:
          'Start adding fields to your favorites\nfor quick access anytime',
      actionLabel: onBrowse != null ? 'Browse Fields' : null,
      onAction: onBrowse,
    );
  }

  /// No bookings found
  static PremiumEmptyState noBookings({VoidCallback? onBook}) {
    return PremiumEmptyState(
      icon: Icons.calendar_today_outlined,
      title: 'No Bookings Yet',
      message: 'Book your first field and start\nplaying today!',
      actionLabel: onBook != null ? 'Book a Field' : null,
      onAction: onBook,
    );
  }

  /// No search results
  static PremiumEmptyState noResults({VoidCallback? onClear}) {
    return PremiumEmptyState(
      icon: Icons.search_off,
      title: 'No Results Found',
      message: 'Try adjusting your filters or\nsearch with different keywords',
      actionLabel: onClear != null ? 'Clear Filters' : null,
      onAction: onClear,
    );
  }

  /// No fields found
  static PremiumEmptyState noFields({VoidCallback? onRefresh}) {
    return PremiumEmptyState(
      icon: Icons.sports_soccer,
      title: 'No Fields Available',
      message: 'There are no fields in your area yet.\nCheck back soon!',
      actionLabel: onRefresh != null ? 'Refresh' : null,
      onAction: onRefresh,
    );
  }

  /// No reviews found
  static PremiumEmptyState noReviews({VoidCallback? onWrite}) {
    return PremiumEmptyState(
      icon: Icons.rate_review_outlined,
      title: 'No Reviews Yet',
      message: 'Be the first to share your\nexperience!',
      actionLabel: onWrite != null ? 'Write Review' : null,
      onAction: onWrite,
    );
  }

  /// Network error
  static PremiumEmptyState networkError({VoidCallback? onRetry}) {
    return PremiumEmptyState(
      icon: Icons.wifi_off,
      title: 'Connection Error',
      message: 'Unable to connect to the server.\nPlease check your internet.',
      actionLabel: onRetry != null ? 'Try Again' : null,
      onAction: onRetry,
      iconColor: AppColors.error,
    );
  }

  /// Generic error
  static PremiumEmptyState error({
    required String message,
    VoidCallback? onRetry,
  }) {
    return PremiumEmptyState(
      icon: Icons.error_outline,
      title: 'Something Went Wrong',
      message: message,
      actionLabel: onRetry != null ? 'Try Again' : null,
      onAction: onRetry,
      iconColor: AppColors.error,
    );
  }

  /// Coming soon
  static PremiumEmptyState comingSoon({required String feature}) {
    return PremiumEmptyState(
      icon: Icons.construction,
      title: 'Coming Soon',
      message: '$feature will be available soon.\nStay tuned!',
      iconColor: AppColors.warning,
    );
  }
}
