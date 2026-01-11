import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';

/// Loading overlay for super admin settings.
///
/// Displays a full-screen overlay with loading spinner during logout.
class SuperAdminLoadingOverlay extends StatelessWidget {
  const SuperAdminLoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.overlayColor,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.premiumGold),
            const SizedBox(height: 16),
            Text(
              context.l10n.loggingOut,
              style: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
