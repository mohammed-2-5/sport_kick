import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';

/// Shows a logout confirmation dialog.
///
/// Asks user to confirm logout and calls [AuthCubit.logout] on confirmation.
Future<void> showLogoutConfirmation(BuildContext context) async {
  final cubit = context.read<AuthCubit>();

  await showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(dialogContext);
            cubit.logout();
          },
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          child: const Text('Logout'),
        ),
      ],
    ),
  );
}
