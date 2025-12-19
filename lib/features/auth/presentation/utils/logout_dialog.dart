import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
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
      title: Text(context.l10n.logout),
      content: Text(context.l10n.logoutConfirmationMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(context.l10n.cancel),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(dialogContext);
            cubit.logout();
          },
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          child: Text(context.l10n.logout),
        ),
      ],
    ),
  );
}
