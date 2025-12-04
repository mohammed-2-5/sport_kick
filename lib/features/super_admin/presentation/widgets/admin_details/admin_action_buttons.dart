import 'package:flutter/material.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/constants/admin_ui_constants.dart';

/// Action buttons for admin details page
class AdminActionButtons extends StatelessWidget {
  final UserEntity admin;
  final VoidCallback onAssignField;
  final VoidCallback? onToggleStatus;

  const AdminActionButtons({
    required this.admin,
    required this.onAssignField,
    this.onToggleStatus,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AdminUIConstants.paddingHorizontal,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onAssignField,
              icon: const Icon(Icons.add_business),
              label: const Text('Assign Field'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: AdminUIConstants.paddingButton,
                shape: RoundedRectangleBorder(
                  borderRadius: AdminUIConstants.borderRadiusMedium,
                ),
              ),
            ),
          ),
          const SizedBox(width: AdminUIConstants.listItemSpacing),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: admin.role == 'super_admin' ? null : onToggleStatus,
              icon: Icon(admin.isActive ? Icons.block : Icons.check_circle),
              label: Text(admin.isActive ? 'Deactivate' : 'Activate'),
              style: OutlinedButton.styleFrom(
                foregroundColor: admin.isActive ? Colors.red : Colors.green,
                side: BorderSide(
                  color: admin.isActive ? Colors.red : Colors.green,
                ),
                padding: AdminUIConstants.paddingButton,
                shape: RoundedRectangleBorder(
                  borderRadius: AdminUIConstants.borderRadiusMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
