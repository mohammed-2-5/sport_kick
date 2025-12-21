import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium Empty Fields Message widget.
///
/// Features:
/// - Centered message with icon
/// - Rounded container
class PremiumEmptyFieldsMessage extends StatelessWidget {
  const PremiumEmptyFieldsMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.sports_soccer_rounded,
              size: 40,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.noFieldDataAvailable,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
