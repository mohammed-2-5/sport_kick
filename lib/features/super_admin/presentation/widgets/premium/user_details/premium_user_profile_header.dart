import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';

/// Premium user profile header.
///
/// Features:
/// - Large avatar with gradient border
/// - User name and email
/// - Status badge
/// - Member since date
/// - Navy gradient background
class PremiumUserProfileHeader extends StatelessWidget {
  final UserEntity user;
  final String memberSince;

  const PremiumUserProfileHeader({
    super.key,
    required this.user,
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
              // Avatar
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: user.isActive
                        ? [AppColors.accentCyan, AppColors.accentCyanDark]
                        : [Colors.grey, Colors.grey.shade600],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          (user.isActive ? AppColors.accentCyan : Colors.grey)
                              .withValues(alpha: 0.4),
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
                    image: user.avatarUrl != null
                        ? DecorationImage(
                            image: NetworkImage(user.avatarUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: user.avatarUrl == null
                      ? Center(
                          child: Text(
                            user.initials,
                            style: AppTextStyles.headlineMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : null,
                ),
              ),

              const SizedBox(height: 16),

              // Name
              Text(
                user.displayName,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 4),

              // Email
              Text(
                user.email,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),

              const SizedBox(height: 16),

              // Status and member since row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Status badge
                  _StatusBadge(isActive: user.isActive),
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
                        'Joined $memberSince',
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

/// Status badge widget.
class _StatusBadge extends StatelessWidget {
  final bool isActive;

  const _StatusBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: (isActive ? Colors.green : Colors.grey).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (isActive ? Colors.green : Colors.grey).withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.grey,
              shape: BoxShape.circle,
            ),
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
