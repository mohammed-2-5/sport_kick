import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';

/// Empty state widget.
class EmptyState extends StatelessWidget {
  final bool hasFilters;
  final VoidCallback onClearFilters;
  final VoidCallback onCreateAdmin;

  const EmptyState({
    super.key,
    required this.hasFilters,
    required this.onClearFilters,
    required this.onCreateAdmin,
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
                gradient: LinearGradient(
                  colors: [
                    AppColors.premiumGold.withValues(alpha: 0.2),
                    AppColors.premiumGoldDark.withValues(alpha: 0.1),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.admin_panel_settings,
                size: 40,
                color: AppColors.premiumGold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              hasFilters
                  ? context.l10n.noAdminsMatchYourFilters
                  : context.l10n.noAdminsFound,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasFilters
                  ? context.l10n.tryAdjustingYourSearchOrFilters
                  : 'Create your first admin to get started',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (hasFilters)
              TextButton(
                onPressed: onClearFilters,
                child: Text(
                  context.l10n.clearFilters,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.premiumGold,
                  ),
                ),
              )
            else
              PremiumButton(
                label: context.l10n.createAdmin,
                onPressed: onCreateAdmin,
                icon: Icons.person_add,
              ),
          ],
        ),
      ),
    );
  }
}
