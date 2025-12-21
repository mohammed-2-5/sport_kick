import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

class AdminListEmptyState extends StatelessWidget {
  final bool isSearchEmpty;

  const AdminListEmptyState({required this.isSearchEmpty, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearchEmpty
                ? Icons.admin_panel_settings_outlined
                : Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            isSearchEmpty
                ? context.l10n.noAdminsYet
                : context.l10n.noResultsFound,
            style: AppTextStyles.bold(
              AppTextStyles.withColor(
                AppTextStyles.titleLarge,
                Colors.grey[700]!,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isSearchEmpty
                ? context.l10n.createYourFirstFieldOwnerAccount
                : 'Try adjusting your filters',
            style: AppTextStyles.withColor(
              AppTextStyles.bodyMedium,
              Colors.grey[600]!,
            ),
          ),
        ],
      ),
    );
  }
}
