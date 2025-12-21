import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(
                  Icons.admin_panel_settings,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                Text(
                  context.l10n.roleSuperAdmin,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  context.l10n.sportKickPlatform,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: Text(context.l10n.dashboard),
            selected: true,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person_add),
            title: Text(context.l10n.createAdmin),
            onTap: () {
              Navigator.pop(context);
              context.pushNamed('superAdminCreateAdmin');
            },
          ),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings),
            title: Text(context.l10n.viewAdmins),
            onTap: () {
              Navigator.pop(context);
              context.pushNamed('superAdminAdmins');
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: Text(context.l10n.viewUsers),
            onTap: () {
              Navigator.pop(context);
              context.pushNamed('superAdminUsers');
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_city),
            title: Text(context.l10n.manageCities),
            onTap: () {
              Navigator.pop(context);
              context.pushNamed('superAdminCities');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(context.l10n.settings),
            onTap: () {
              Navigator.pop(context);
              context.pushNamed('superAdminSettings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              context.l10n.logout,
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context);
              _showLogoutConfirmation(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.logout),
        content: Text(context.l10n.logoutConfirmationMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _performLogout(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(context.l10n.logout),
          ),
        ],
      ),
    );
  }

  /// Logs out super admin, clears related cubit state, and redirects to login.
  Future<void> _performLogout(BuildContext context) async {
    final authCubit = context.read<AuthCubit>();
    final superAdminCubit = context.read<SuperAdminCubit?>();
    final router = GoRouter.of(context);

    superAdminCubit?.reset();
    await authCubit.logout();
    router.goNamed('login');
  }
}
