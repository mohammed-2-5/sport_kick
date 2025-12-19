import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';

/// Logout button widget for owner settings page.
class OwnerLogoutButton extends StatelessWidget {
  const OwnerLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showLogoutDialog(context),
        icon: const Icon(Icons.logout),
        label: Text(context.l10n.logoutTitle),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.logout, color: Colors.red),
            const SizedBox(width: 12),
            Text(context.l10n.logoutTitle),
          ],
        ),
        content: Text(
          context.l10n.logoutMessage,
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthCubit>().logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(context.l10n.logoutTitle),
          ),
        ],
      ),
    );
  }
}
