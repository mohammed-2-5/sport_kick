import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/auth/presentation/widgets/profile/initials_avatar.dart';

/// Profile page header with curved background and avatar.
///
/// Refactored to use [PremiumCurvedHeader] for consistent styling.
/// Theme-aware: adapts to light/dark mode.
class ProfileHeader extends StatelessWidget {
  final String? avatarUrl;
  final String initials;
  final VoidCallback onBackPressed;

  const ProfileHeader({
    super.key,
    required this.avatarUrl,
    required this.initials,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        PremiumCurvedHeader(
          title: context.l10n.myProfile,
          showBackButton: true,
          onBackPressed: onBackPressed,
          height: 220,
        ),
        Positioned(
          bottom: -50,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.4)
                      : Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: colorScheme.surfaceContainerHighest,
              child: _buildAvatarImage(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarImage() {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          avatarUrl!,
          width: 112,
          height: 112,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              InitialsAvatar(initials: initials),
        ),
      );
    }
    return InitialsAvatar(initials: initials);
  }
}
