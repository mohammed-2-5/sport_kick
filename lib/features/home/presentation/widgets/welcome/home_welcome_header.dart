import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/core/constants/app_shadows.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/home/presentation/constants/home_constants.dart';
import 'package:spo_kick/features/home/presentation/widgets/welcome/role_badge.dart';

/// Welcome header widget for the home page.
///
/// Displays a gradient card with:
/// - Welcome message with wave icon
/// - User's display name
/// - User's email
/// - User's phone (if available)
/// - User's role badge
class HomeWelcomeHeader extends StatelessWidget {
  /// The current authenticated user
  final dynamic user;

  const HomeWelcomeHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(HomeConstants.welcomePadding),
      decoration: BoxDecoration(
        gradient: AppGradients.primary,
        borderRadius: BorderRadius.circular(HomeConstants.welcomeBorderRadius),
        boxShadow: AppShadows.large,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeRow(context),
          const SizedBox(height: HomeConstants.userInfoSpacing),
          _buildUserName(context),
          const SizedBox(height: HomeConstants.userInfoSmallSpacing),
          _buildUserEmail(context),
          if (user?.phone != null && user!.phone!.isNotEmpty) ...[
            const SizedBox(height: HomeConstants.userInfoSmallSpacing),
            _buildUserPhone(context),
          ],
          const SizedBox(height: HomeConstants.welcomeIconSpacing),
          HomeRoleBadge(role: user?.role ?? 'USER'),
        ],
      ),
    );
  }

  Widget _buildWelcomeRow(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.waving_hand,
          color: Colors.white,
          size: HomeConstants.welcomeIconSize,
        ),
        const SizedBox(width: HomeConstants.welcomeIconSpacing),
        Expanded(
          child: Text(
            context.l10n.homeWelcomeBack,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserName(BuildContext context) {
    return Text(
      user?.displayName ?? context.l10n.homeGuest,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildUserEmail(BuildContext context) {
    return Text(
      user?.email ?? '',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Colors.white.withValues(alpha: HomeConstants.highOpacity),
      ),
    );
  }

  Widget _buildUserPhone(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.phone_outlined,
          color: Colors.white,
          size: HomeConstants.phoneIconSize,
        ),
        const SizedBox(width: HomeConstants.phoneIconSpacing),
        Text(
          user!.phone!,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: HomeConstants.highOpacity),
          ),
        ),
      ],
    );
  }
}
