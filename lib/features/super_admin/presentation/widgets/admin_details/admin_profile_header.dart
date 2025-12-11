import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/constants/admin_ui_constants.dart';
import 'package:spo_kick/features/super_admin/utils/user_card_utils.dart';

/// Profile header widget for admin details page
class AdminProfileHeader extends StatelessWidget {
  final UserEntity admin;

  const AdminProfileHeader({required this.admin, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AdminUIConstants.paddingHeader,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withValues(
              alpha: AdminUIConstants.opacityHeavy,
            ),
          ],
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
              getInitials(admin.fullName),
              style: TextStyle(
                fontSize: AdminUIConstants.fontSizeTitle,
                fontWeight: AdminUIConstants.fontWeightBold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: AdminUIConstants.spacingMedium),

          // Name
          Text(
            admin.fullName ?? admin.email,
            style: const TextStyle(
              fontSize: AdminUIConstants.fontSizeXXLarge,
              fontWeight: AdminUIConstants.fontWeightBold,
              color: Colors.white,
            ),
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
                Icon(
                  admin.role == 'super_admin'
                      ? Icons.verified_user
                      : Icons.admin_panel_settings,
                  size: AdminUIConstants.iconSizeSmall,
                  color: Colors.white,
                ),
                const SizedBox(width: 6),
                Text(
                  admin.role == 'super_admin' ? 'Super Admin' : 'Field Owner',
                  style: const TextStyle(
                    fontSize: AdminUIConstants.fontSizeMedium,
                    fontWeight: AdminUIConstants.fontWeightMedium,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AdminUIConstants.spacingMedium),

          // Contact Info
          _buildContactInfo(Icons.email, admin.email, Colors.white),
          if (admin.phone != null && admin.phone!.isNotEmpty) ...[
            const SizedBox(height: AdminUIConstants.spacingSmall),
            _buildContactInfo(Icons.phone, admin.phone!, Colors.white),
          ],

          const SizedBox(height: AdminUIConstants.spacingMedium),

          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: admin.isActive
                  ? Colors.green.withValues(alpha: 0.2)
                  : Colors.red.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(
                AdminUIConstants.radiusXLarge,
              ),
              border: Border.all(
                color: admin.isActive ? Colors.green : Colors.red,
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
                    color: admin.isActive ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AdminUIConstants.spacingSmall),
                Text(
                  admin.isActive ? 'Active Account' : 'Inactive Account',
                  style: TextStyle(
                    fontSize: AdminUIConstants.fontSizeMedium,
                    fontWeight: AdminUIConstants.fontWeightBold,
                    color: admin.isActive ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AdminUIConstants.spacingMedium),

          // Member Since
          Text(
            'Member since ${DateFormat('MMM d, y').format(admin.createdAt)}',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.9),
            ),
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
            style: TextStyle(
              fontSize: AdminUIConstants.fontSizeMedium,
              color: color.withValues(alpha: 0.95),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
