import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Super Admin badge.
class AdminBadge extends StatelessWidget {
  const AdminBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.goldAccent.withValues(alpha: 0.3),
            const Color(0xFFD4A574).withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.goldAccent.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.verified_rounded,
            size: 12,
            color: AppColors.goldAccent,
          ),
          const SizedBox(width: 4),
          Text(
            context.l10n.superAdminRole,
            style: AppTextStyles.withColor(
              AppTextStyles.labelSmallBold,
              AppColors.goldAccent,
            ),
          ),
        ],
      ),
    );
  }
}
