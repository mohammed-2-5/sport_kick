import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

class UserListEmptyState extends StatelessWidget {
  final bool hasFilters;

  const UserListEmptyState({required this.hasFilters, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasFilters ? Icons.search_off : Icons.people_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            hasFilters ? context.l10n.noResultsFound : context.l10n.noUsersYet,
            style: AppTextStyles.bold(
              AppTextStyles.withColor(
                AppTextStyles.headlineSmall,
                Colors.grey[700]!,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasFilters
                ? context.l10n.tryAdjustingYourFilters
                : 'Users will appear here once they register',
            style: AppTextStyles.bodyMediumSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
