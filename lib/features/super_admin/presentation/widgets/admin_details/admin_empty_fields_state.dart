import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/super_admin/presentation/constants/admin_ui_constants.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Empty state widget for when no fields are assigned
class AdminEmptyFieldsState extends StatelessWidget {
  final VoidCallback onAssignField;

  const AdminEmptyFieldsState({required this.onAssignField, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AdminUIConstants.emptyStatePadding),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: AdminUIConstants.borderRadiusMedium,
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Icon(
            Icons.sports_soccer_outlined,
            size: AdminUIConstants.emptyStateIconSize,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AdminUIConstants.listItemSpacing),
          Text(
            context.l10n.noFieldsAssigned,
            style: AppTextStyles.bold(AppTextStyles.titleMedium),
          ),
          const SizedBox(height: AdminUIConstants.spacingSmall),
          Text(
            context.l10n.thisAdminDoesntHaveAnyFieldsAssignedYet,
            textAlign: TextAlign.center,
            style: AppTextStyles.withColor(
              AppTextStyles.bodyMedium,
              Colors.grey[600]!,
            ),
          ),
          const SizedBox(height: AdminUIConstants.spacingMedium),
          ElevatedButton.icon(
            onPressed: onAssignField,
            icon: const Icon(Icons.add),
            label: Text(context.l10n.assignFirstField),
          ),
        ],
      ),
    );
  }
}
