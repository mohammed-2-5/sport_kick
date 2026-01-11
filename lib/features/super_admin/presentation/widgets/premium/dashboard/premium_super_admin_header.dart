import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'components/header/menu_button.dart';
import 'components/header/notification_button.dart';
import 'components/header/admin_avatar.dart';
import 'components/header/admin_badge.dart';

/// Premium super admin header with gold accent theme.
///
/// Features:
/// - Gradient background with gold accent
/// - Glass morphism effects
/// - Admin avatar with crown badge
/// - Notification bell with count
/// - Animated elements
class PremiumSuperAdminHeader extends StatelessWidget {
  final String greeting;
  final String adminName;
  final String date;
  final VoidCallback onMenuTap;
  final VoidCallback onNotificationTap;
  final int notificationCount;

  const PremiumSuperAdminHeader({
    super.key,
    required this.greeting,
    required this.adminName,
    required this.date,
    required this.onMenuTap,
    required this.onNotificationTap,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // Top row with menu and notification
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MenuButton(onTap: onMenuTap),
              NotificationButton(
                count: notificationCount,
                onTap: onNotificationTap,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Admin info row
          Row(
            children: [
              // Avatar with crown
              AdminAvatar(name: adminName),
              const SizedBox(width: 16),

              // Greeting and info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(greeting, style: AppTextStyles.bodyMediumWhite),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            adminName,
                            style: AppTextStyles.withColor(
                              AppTextStyles.titleLargeBold,
                              Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const AdminBadge(),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 14,
                          color: AppColors.goldAccent.withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 6),
                        Text(date, style: AppTextStyles.bodySmallWhite),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
