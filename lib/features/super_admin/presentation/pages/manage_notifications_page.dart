import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Notifications management page for super admin.
///
/// Features:
/// - View all platform notifications
/// - Send broadcast notifications
/// - Filter by type, user, status
/// - View notification statistics
class ManageNotificationsPage extends StatelessWidget {
  const ManageNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PremiumCurvedHeader(
              title: context.l10n.notifications,
              subtitle: context.l10n.managePlatformNotifications,
              showBackButton: true,
            ),
          ),
          SliverFillRemaining(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFF59E0B).withValues(alpha: 0.2),
                            const Color(0xFFF59E0B).withValues(alpha: 0.1),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_active_rounded,
                        size: 48,
                        color: Color(0xFFF59E0B),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      context.l10n.homeComingSoonTitle,
                      style: AppTextStyles.bold(AppTextStyles.headlineSmall),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.l10n.notificationManagementWillBeNavailableIn,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.withColor(
                        AppTextStyles.bodyLarge,
                        AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
