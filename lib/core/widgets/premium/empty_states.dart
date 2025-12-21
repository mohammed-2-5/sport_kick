import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_empty_state.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

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
                color: (iconColor ?? AppColors.accentCyan).withValues(
                  alpha: 0.1,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: iconColor ?? AppColors.accentCyan,
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
  static PremiumEmptyState noFavorites(
    BuildContext context, {
    VoidCallback? onBrowse,
  }) {
    return PremiumEmptyState(
      icon: Icons.bookmark_border,
      title: context.l10n.noFavoritesYet2,
      message: context.l10n.startAddingFavorites,
      actionLabel: onBrowse != null ? context.l10n.browseFields : null,
      onAction: onBrowse,
    );
  }

  /// No bookings found
  static PremiumEmptyState noBookings(
    BuildContext context, {
    VoidCallback? onBook,
  }) {
    return PremiumEmptyState(
      icon: Icons.calendar_today_outlined,
      title: context.l10n.noBookingsYet2,
      message: context.l10n.bookYourFirstFieldAndStartNplayingToday,
      actionLabel: onBook != null ? context.l10n.bookAField : null,
      onAction: onBook,
    );
  }

  /// No search results
  static PremiumEmptyState noResults(
    BuildContext context, {
    VoidCallback? onClear,
  }) {
    return PremiumEmptyState(
      icon: Icons.search_off,
      title: context.l10n.noResultsFound,
      message: context.l10n.tryAdjustingYourFiltersOrNsearchWithDiff,
      actionLabel: onClear != null ? context.l10n.clearFilters : null,
      onAction: onClear,
    );
  }

  /// No fields found
  static PremiumEmptyState noFields(
    BuildContext context, {
    VoidCallback? onRefresh,
  }) {
    return PremiumEmptyState(
      icon: Icons.sports_soccer,
      title: context.l10n.noFieldsAvailable2,
      message: context.l10n.thereAreNoFieldsInYourAreaYetNcheckBackS,
      actionLabel: onRefresh != null ? context.l10n.refresh : null,
      onAction: onRefresh,
    );
  }

  /// No reviews found
  static PremiumEmptyState noReviews(
    BuildContext context, {
    VoidCallback? onWrite,
  }) {
    return PremiumEmptyState(
      icon: Icons.rate_review_outlined,
      title: context.l10n.noReviewsYet,
      message: context.l10n.beTheFirstToShareYourNexperience,
      actionLabel: onWrite != null ? context.l10n.writeReview : null,
      onAction: onWrite,
    );
  }

  /// Network error
  static PremiumEmptyState networkError(
    BuildContext context, {
    VoidCallback? onRetry,
  }) {
    return PremiumEmptyState(
      icon: Icons.wifi_off,
      title: context.l10n.connectionError,
      message: context.l10n.unableToConnectToTheServerNpleaseCheckYo,
      actionLabel: onRetry != null ? context.l10n.tryAgain : null,
      onAction: onRetry,
      iconColor: AppColors.error,
    );
  }

  /// Generic error
  static PremiumEmptyState error(
    BuildContext context, {
    required String message,
    VoidCallback? onRetry,
  }) {
    return PremiumEmptyState(
      icon: Icons.error_outline,
      title: context.l10n.somethingWentWrong2,
      message: message,
      actionLabel: onRetry != null ? context.l10n.tryAgain : null,
      onAction: onRetry,
      iconColor: AppColors.error,
    );
  }

  /// Coming soon
  static PremiumEmptyState comingSoon(
    BuildContext context, {
    required String feature,
  }) {
    return PremiumEmptyState(
      icon: Icons.construction,
      title: context.l10n.homeComingSoonTitle,
      message: context.l10n.featureWillBeAvailableSoonNstayTuned,
      iconColor: AppColors.warning,
    );
  }
}
