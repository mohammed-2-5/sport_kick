import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';

/// Premium admin profile header with gold theme.
///
/// Features:
/// - Large avatar with gold gradient border
/// - Admin badge
/// - Status indicator
/// - Member since date
/// - Navy gradient background
class PremiumAdminProfileHeader extends StatelessWidget {
  final UserEntity admin;
  final String memberSince;

  const PremiumAdminProfileHeader({
    super.key,
    required this.admin,
    required this.memberSince,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.navyDeep, AppColors.navyLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          child: Column(
            children: [
              // Avatar with gold border
              Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.premiumGold,
                          AppColors.premiumGoldDark,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.premiumGold.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.navyDeep,
                        image: admin.avatarUrl != null
                            ? DecorationImage(
                                image: NetworkImage(admin.avatarUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: admin.avatarUrl == null
                          ? Center(
                              child: Text(
                                admin.initials,
                                style: AppTextStyles.headlineMedium.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                  // Admin badge
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.premiumGold,
                            AppColors.premiumGoldDark,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.navyDeep, width: 2),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.admin_panel_settings,
                            size: 12,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Admin',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Name
              Text(
                admin.displayName,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 4),

              // Email
              Text(
                admin.email,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),

              if (admin.phone != null) ...[
                const SizedBox(height: 4),
                Text(
                  admin.phone!,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // Status and member since row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Status badge
                  _AdminStatusBadge(isActive: admin.isActive),
                  const SizedBox(width: 16),
                  // Divider
                  Container(
                    width: 1,
                    height: 20,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  const SizedBox(width: 16),
                  // Member since
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Since $memberSince',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Admin status badge widget with gold theme.
class _AdminStatusBadge extends StatelessWidget {
  final bool isActive;

  const _AdminStatusBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final color = isActive ? Colors.green : Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            isActive ? 'Active' : 'Inactive',
            style: AppTextStyles.labelSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.green.shade300 : Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }
}
