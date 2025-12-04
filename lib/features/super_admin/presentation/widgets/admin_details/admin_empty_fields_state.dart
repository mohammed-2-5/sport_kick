import 'package:flutter/material.dart';
import 'package:spo_kick/features/super_admin/presentation/constants/admin_ui_constants.dart';

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
          const Text(
            'No Fields Assigned',
            style: TextStyle(
              fontSize: AdminUIConstants.fontSizeLarge,
              fontWeight: AdminUIConstants.fontWeightBold,
            ),
          ),
          const SizedBox(height: AdminUIConstants.spacingSmall),
          Text(
            'This admin doesn\'t have any fields assigned yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AdminUIConstants.fontSizeMedium,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: AdminUIConstants.spacingMedium),
          ElevatedButton.icon(
            onPressed: onAssignField,
            icon: const Icon(Icons.add),
            label: const Text('Assign First Field'),
          ),
        ],
      ),
    );
  }
}
