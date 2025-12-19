import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Empty state widget for comparison page.
///
/// Displays when no fields are selected for comparison.
class ComparisonEmptyState extends StatelessWidget {
  const ComparisonEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.compare_arrows,
              size: 80,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.noFieldsFound,
              style: AppTextStyles.appBarTitle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.searchForFields,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
