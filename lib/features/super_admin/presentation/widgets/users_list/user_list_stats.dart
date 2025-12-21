import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

class UserListStats extends StatelessWidget {
  final int filteredCount;
  final int totalCount;
  final int activeCount;
  final bool isSelectionMode;
  final int selectedCount;

  const UserListStats({
    required this.filteredCount,
    required this.totalCount,
    required this.activeCount,
    required this.isSelectionMode,
    required this.selectedCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(Icons.people, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            context.l10n.showingUsersCount(filteredCount, totalCount),
            style: AppTextStyles.bodyMediumSecondary,
          ),
          const Spacer(),
          if (isSelectionMode)
            Text(
              context.l10n.selectedCount(selectedCount),
              style: AppTextStyles.bold(
                AppTextStyles.withColor(
                  AppTextStyles.bodyMedium,
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            )
          else
            Text(
              context.l10n.activeCount(activeCount),
              style: AppTextStyles.withColor(
                AppTextStyles.labelSmallBold,
                Colors.green[700]!,
              ),
            ),
        ],
      ),
    );
  }
}
