import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';

/// Dialog utility for user status toggle confirmation.
/// Shows appropriate message based on current user status.
void showUserStatusToggleDialog({
  required BuildContext context,
  required UserEntity user,
  required VoidCallback onStatusChanged,
}) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(user.isActive ? 'Deactivate User?' : 'Activate User?'),
      content: Text(
        user.isActive
            ? 'This will prevent the user from logging in and making new bookings.'
            : 'This will restore the user\'s access to the platform.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: user.isActive ? Colors.red : Colors.green,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            if (user.isActive) {
              context.read<SuperAdminCubit>().deactivateUser(user.id);
            } else {
              context.read<SuperAdminCubit>().activateUser(user.id);
            }

            Navigator.pop(dialogContext);
            onStatusChanged();

            final message = user.isActive
                ? 'User deactivated successfully'
                : 'User activated successfully';

            if (user.isActive) {
              SnackbarHelper.showError(context, message);
            } else {
              SnackbarHelper.showSuccess(context, message);
            }
          },
          child: Text(user.isActive ? 'Deactivate' : 'Activate'),
        ),
      ],
    ),
  );
}
