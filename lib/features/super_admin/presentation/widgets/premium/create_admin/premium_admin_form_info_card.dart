import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium info card explaining the admin creation process.
///
/// Features:
/// - Gold gradient icon background
/// - Clear step-by-step instructions
/// - Premium card styling
class PremiumAdminFormInfoCard extends StatelessWidget {
  const PremiumAdminFormInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.premiumGold, AppColors.premiumGoldDark],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.premiumGold.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.admin_panel_settings,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.createAdminAccount,
                      style: AppTextStyles.titleMediumBold,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      context.l10n.fieldOwnerManagement,
                      style: AppTextStyles.bodyMediumSecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.premiumGold.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.premiumGold.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoStepItem(
                  number: '1',
                  text: context.l10n.enterTheAdminsEmailAndPersonalDetails,
                ),
                const SizedBox(height: 12),
                _InfoStepItem(
                  number: '2',
                  text: context.l10n.aTemporaryPasswordWillBeGenerated,
                ),
                const SizedBox(height: 12),
                _InfoStepItem(
                  number: '3',
                  text: context.l10n.shareCredentialsSecurelyWithTheNew,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.security,
                      size: 16,
                      color: AppColors.premiumGold.withValues(alpha: 0.8),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        context.l10n.adminMustChangePasswordOnFirst,
                        style: AppTextStyles.withColor(
                          AppTextStyles.bold(AppTextStyles.bodySmall),
                          AppColors.premiumGold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Info step item widget.
class _InfoStepItem extends StatelessWidget {
  final String number;
  final String text;

  const _InfoStepItem({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.premiumGold, AppColors.premiumGoldDark],
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: AppTextStyles.withColor(
                AppTextStyles.bold(AppTextStyles.labelSmall),
                Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(text, style: AppTextStyles.bodyMedium),
          ),
        ),
      ],
    );
  }
}
