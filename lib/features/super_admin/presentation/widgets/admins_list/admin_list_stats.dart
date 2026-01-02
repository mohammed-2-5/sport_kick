import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

class AdminListStats extends StatelessWidget {
  final int filteredCount;
  final int totalCount;
  final bool isSelectionMode;
  final int selectedCount;

  const AdminListStats({
    required this.filteredCount,
    required this.totalCount,
    required this.isSelectionMode,
    required this.selectedCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(
            Icons.admin_panel_settings,
            size: 20,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 8),
          Text(
            context.l10n.showingAdminsCount(filteredCount, totalCount),
            style: AppTextStyles.withColor(
              AppTextStyles.titleSmall,
              colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          if (isSelectionMode) ...[
            const Spacer(),
            Text(
              context.l10n.selectedCount(selectedCount),
              style: AppTextStyles.bold(
                AppTextStyles.withColor(
                  AppTextStyles.titleSmall,
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
