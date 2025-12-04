import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_shadows.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';

/// Dropdown to select an admin for the field
class FieldAdminSelector extends StatelessWidget {
  final UserEntity? selectedAdmin;
  final List<UserEntity> admins;
  final bool isLoading;
  final ValueChanged<UserEntity?> onChanged;

  const FieldAdminSelector({
    required this.selectedAdmin,
    required this.admins,
    required this.isLoading,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: AppShadows.small,
      ),
      child: isLoading
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('Loading admins...'),
                ],
              ),
            )
          : DropdownButtonFormField<UserEntity>(
              key: ValueKey(selectedAdmin),
              initialValue: selectedAdmin,
              decoration: const InputDecoration(
                labelText: 'Select Admin',
                prefixIcon: Icon(Icons.person_outline),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              items: admins.map((admin) {
                return DropdownMenuItem<UserEntity>(
                  value: admin,
                  child: Text(admin.fullName ?? admin.email),
                );
              }).toList(),
              onChanged: onChanged,
              validator: (v) => v == null ? 'Please select an admin' : null,
            ),
    );
  }
}
