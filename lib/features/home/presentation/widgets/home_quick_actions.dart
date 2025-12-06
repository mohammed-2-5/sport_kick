import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/core/constants/app_shadows.dart';
import 'package:spo_kick/features/home/presentation/constants/home_constants.dart';

/// Quick actions section widget for the home page.
///
/// Displays a grid of quick action cards with staggered animations:
/// - My Profile
/// - Browse Fields
/// - My Bookings
/// - Favorites
class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final quickActions = _getQuickActions(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          HomeConstants.quickActionsTitle,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: HomeConstants.quickActionsTitleSpacing),
        AnimationLimiter(
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: HomeConstants.quickActionsGridCrossAxisCount,
              crossAxisSpacing: HomeConstants.quickActionsGridCrossAxisSpacing,
              mainAxisSpacing: HomeConstants.quickActionsGridMainAxisSpacing,
              childAspectRatio: HomeConstants.quickActionsGridChildAspectRatio,
            ),
            itemCount: quickActions.length,
            itemBuilder: (context, index) {
              final action = quickActions[index];
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(
                  milliseconds: HomeConstants.animationDurationMillis,
                ),
                columnCount: HomeConstants.quickActionsGridCrossAxisCount,
                child: SlideAnimation(
                  verticalOffset: HomeConstants.animationVerticalOffset,
                  child: FadeInAnimation(
                    child: _QuickActionCard(
                      icon: action.icon,
                      title: action.title,
                      subtitle: action.subtitle,
                      gradient: action.gradient,
                      onTap: action.onTap,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<_QuickActionData> _getQuickActions(BuildContext context) {
    return [
      _QuickActionData(
        icon: Icons.person_outline,
        title: HomeConstants.myProfileTitle,
        subtitle: HomeConstants.myProfileSubtitle,
        gradient: AppGradients.primary,
        onTap: () => context.pushNamed('profile'),
      ),
      _QuickActionData(
        icon: Icons.sports_soccer,
        title: HomeConstants.browseFieldsTitle,
        subtitle: HomeConstants.browseFieldsSubtitle,
        gradient: AppGradients.info,
        onTap: () => context.pushNamed('fieldsList'),
      ),
      _QuickActionData(
        icon: Icons.calendar_today_outlined,
        title: HomeConstants.myBookingsTitle,
        subtitle: HomeConstants.myBookingsSubtitle,
        gradient: AppGradients.success,
        onTap: () => context.pushNamed('myBookings'),
      ),
      _QuickActionData(
        icon: Icons.star_outline,
        title: HomeConstants.favoritesTitle,
        subtitle: HomeConstants.favoritesSubtitle,
        gradient: AppGradients.warning,
        onTap: () => context.pushNamed('favorites'),
      ),
    ];
  }
}

/// Data class for quick actions
class _QuickActionData {
  final IconData icon;
  final String title;
  final String subtitle;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _QuickActionData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });
}

/// Quick action card widget with premium gradient design
class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          HomeConstants.quickActionCardBorderRadius,
        ),
        child: Container(
          padding: const EdgeInsets.all(HomeConstants.quickActionCardPadding),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(
              HomeConstants.quickActionCardBorderRadius,
            ),
            boxShadow: AppShadows.medium,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildIconContainer(), _buildTextContent(context)],
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer() {
    return Container(
      padding: const EdgeInsets.all(HomeConstants.quickActionIconPadding),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: HomeConstants.mediumOpacity),
        borderRadius: BorderRadius.circular(
          HomeConstants.quickActionIconBorderRadius,
        ),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: HomeConstants.quickActionIconSize,
      ),
    );
  }

  Widget _buildTextContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: HomeConstants.quickActionTitleSubtitleSpacing),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: HomeConstants.highOpacity),
          ),
        ),
      ],
    );
  }
}
