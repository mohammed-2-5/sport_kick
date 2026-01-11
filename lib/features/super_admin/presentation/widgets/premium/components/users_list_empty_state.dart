import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Empty state widget for users list.
class UsersListEmptyState extends StatelessWidget {
  final bool hasFilters;
  final VoidCallback onClearFilters;

  const UsersListEmptyState({
    super.key,
    required this.hasFilters,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.premiumGold.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.people_outline,
                size: 40,
                color: AppColors.premiumGold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              hasFilters
                  ? context.l10n.noUsersMatchYourFilters
                  : context.l10n.noUsersFound,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasFilters
                  ? context.l10n.tryAdjustingYourSearchOrFilters
                  : 'Users will appear here once they register',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (hasFilters) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: onClearFilters,
                child: Text(
                  context.l10n.clearFilters,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.premiumGold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
