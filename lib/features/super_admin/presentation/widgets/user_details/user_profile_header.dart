import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/constants/admin_ui_constants.dart';
import 'package:spo_kick/features/super_admin/utils/user_card_utils.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Profile header widget for user details page
class UserProfileHeader extends StatelessWidget {
  final UserEntity user;

  const UserProfileHeader({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AdminUIConstants.paddingHeader,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Color.fromRGBO(33, 150, 243, 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: AdminUIConstants.avatarSizeMedium,
            backgroundColor: Colors.white,
            child: Text(
              getInitials(user.fullName),
              style: AppTextStyles.bold(
                AppTextStyles.withColor(
                  AppTextStyles.headlineSmall,
                  Colors.blue,
                ),
              ),
            ),
          ),
          const SizedBox(height: AdminUIConstants.spacingMedium),

          // Name
          Text(
            user.fullName ?? user.email,
            style: AppTextStyles.bold(AppTextStyles.headlineLargeWhite),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AdminUIConstants.spacingSmall),

          // Role Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: AdminUIConstants.opacityMedium,
              ),
              borderRadius: BorderRadius.circular(
                AdminUIConstants.radiusXLarge,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.person,
                  size: AdminUIConstants.iconSizeSmall,
                  color: Colors.white,
                ),
                const SizedBox(width: 6),
                Text(
                  context.l10n.customerName,
                  style: AppTextStyles.bodyMediumWhite,
                ),
              ],
            ),
          ),

          const SizedBox(height: AdminUIConstants.spacingMedium),

          // Contact Info
          _buildContactInfo(Icons.email, user.email, Colors.white),
          if (user.phone != null && user.phone!.isNotEmpty) ...[
            const SizedBox(height: AdminUIConstants.spacingSmall),
            _buildContactInfo(Icons.phone, user.phone!, Colors.white),
          ],

          const SizedBox(height: AdminUIConstants.spacingMedium),

          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: user.isActive
                  ? AppColors.success.withValues(alpha: 0.2)
                  : AppColors.error.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(
                AdminUIConstants.radiusXLarge,
              ),
              border: Border.all(
                color: user.isActive ? AppColors.success : AppColors.error,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: AdminUIConstants.badgeIndicatorSize,
                  height: AdminUIConstants.badgeIndicatorSize,
                  decoration: BoxDecoration(
                    color: user.isActive ? AppColors.success : AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AdminUIConstants.spacingSmall),
                Text(
                  user.isActive
                      ? context.l10n.activeAccount
                      : context.l10n.inactiveAccount,
                  style: AppTextStyles.bold(
                    AppTextStyles.withColor(
                      AppTextStyles.bodyMedium,
                      user.isActive ? AppColors.success : AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AdminUIConstants.spacingMedium),

          // Member Since
          Text(
            context.l10n.memberSinceDate(
              DateFormat('MMM d, y').format(user.createdAt),
            ),
            style: AppTextStyles.bodySmallWhite,
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: AdminUIConstants.iconSizeSmall, color: color),
        const SizedBox(width: AdminUIConstants.spacingSmall),
        Flexible(
          child: Text(
            text,
            style: AppTextStyles.bodyMediumWhite,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
