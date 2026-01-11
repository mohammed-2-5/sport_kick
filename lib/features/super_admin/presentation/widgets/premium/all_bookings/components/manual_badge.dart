import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Manual booking badge.
class ManualBadge extends StatelessWidget {
  const ManualBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.goldAccent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        context.l10n.manual,
        style: AppTextStyles.withColor(
          AppTextStyles.bold(AppTextStyles.badge),
          AppColors.goldAccent,
        ),
      ),
    );
  }
}
