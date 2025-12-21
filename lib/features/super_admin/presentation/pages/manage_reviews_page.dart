import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Reviews moderation page for super admin.
///
/// Features:
/// - View all platform reviews
/// - Filter by rating, field, user
/// - Delete inappropriate reviews
/// - View review statistics
class ManageReviewsPage extends StatelessWidget {
  const ManageReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PremiumCurvedHeader(
              title: context.l10n.reviews,
              subtitle: context.l10n.moderatePlatformReviews,
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
                            AppColors.accentCyan.withValues(alpha: 0.2),
                            AppColors.accentCyan.withValues(alpha: 0.1),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.rate_review_rounded,
                        size: 48,
                        color: AppColors.accentCyan,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      context.l10n.homeComingSoonTitle,
                      style: AppTextStyles.bold(AppTextStyles.headlineSmall),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.l10n.reviewsModerationWillBeNavailableIn,
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
