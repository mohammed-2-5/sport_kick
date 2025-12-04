import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/home/presentation/constants/home_constants.dart';

/// Upcoming features section widget for the home page.
///
/// Displays an info card with a list of upcoming features:
/// - Browse and search sports fields
/// - Book time slots instantly
/// - Secure online payments
/// - Review and rate fields
class HomeUpcomingFeatures extends StatelessWidget {
  const HomeUpcomingFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(HomeConstants.upcomingFeaturesPadding),
      decoration: BoxDecoration(
        color: AppColors.infoLight,
        borderRadius: BorderRadius.circular(
          HomeConstants.upcomingFeaturesBorderRadius,
        ),
        border: Border.all(
          color: AppColors.info.withValues(alpha: HomeConstants.mediumOpacity),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: HomeConstants.upcomingFeaturesTitleSpacing),
          const _FeatureItem(
            icon: Icons.sports_soccer,
            text: HomeConstants.featureBrowseFields,
          ),
          const _FeatureItem(
            icon: Icons.book_online,
            text: HomeConstants.featureBookSlots,
          ),
          const _FeatureItem(
            icon: Icons.payment,
            text: HomeConstants.featurePayments,
          ),
          const _FeatureItem(
            icon: Icons.rate_review_outlined,
            text: HomeConstants.featureReviews,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.info_outline, color: AppColors.info),
        const SizedBox(width: HomeConstants.upcomingFeaturesIconSpacing),
        Text(
          HomeConstants.comingSoonTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.info,
              ),
        ),
      ],
    );
  }
}

/// Feature item widget for displaying individual upcoming features
class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: HomeConstants.upcomingFeaturesItemBottomSpacing,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: HomeConstants.upcomingFeaturesIconSize,
            color: AppColors.info,
          ),
          const SizedBox(width: HomeConstants.upcomingFeaturesIconSpacing),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
