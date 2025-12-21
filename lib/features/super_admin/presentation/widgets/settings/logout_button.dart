import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showLogoutDialog(context),
        icon: const Icon(Icons.logout),
        label: Text(context.l10n.logout),
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
      builder: (context) => AlertDialog(
        title: Text(context.l10n.logout),
        content: Text(context.l10n.logoutConfirmationMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _performLogout(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(context.l10n.logout),
          ),
        ],
      ),
    );
  }

  /// Logs out the current super admin, resets state, and returns to login.
  Future<void> _performLogout(BuildContext context) async {
    final authCubit = context.read<AuthCubit>();
    final superAdminCubit = context.read<SuperAdminCubit?>();
    final router = GoRouter.of(context);

    superAdminCubit?.reset();
    await authCubit.logout();
    router.goNamed('login');
  }
}
