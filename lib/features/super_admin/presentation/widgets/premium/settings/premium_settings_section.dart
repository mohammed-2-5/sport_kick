import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium settings section card.
///
/// Features:
/// - Icon header with gold gradient
/// - Title and optional saving indicator
/// - Child widgets list
/// - Dividers between items
class PremiumSettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSaving;
  final List<Widget> children;

  const PremiumSettingsSection({
    super.key,
    required this.title,
    required this.icon,
    this.isSaving = false,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.premiumGold, AppColors.premiumGoldDark],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.premiumGold.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: AppTextStyles.titleMediumBold)),
            if (isSaving) ...[
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.premiumGold.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                context.l10n.saving,
                style: AppTextStyles.withColor(
                  AppTextStyles.bodySmall,
                  AppColors.premiumGold,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        // Content
        PremiumCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1)
                  Divider(
                    height: 1,
                    indent: 56,
                    color: AppColors.border.withValues(alpha: 0.5),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
