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
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(Icons.people, size: 20, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(
            context.l10n.showingUsersCount(filteredCount, totalCount),
            style: AppTextStyles.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          if (isSelectionMode)
            Text(
              context.l10n.selectedCount(selectedCount),
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            )
          else
            Text(
              context.l10n.activeCount(activeCount),
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.green[400] : Colors.green[700],
              ),
            ),
        ],
      ),
    );
  }
}
