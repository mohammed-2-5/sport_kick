import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/logout_button.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/platform_config_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/security_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/settings_section_header.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/super_admin_about_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/super_admin_account_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/system_preferences_section.dart';

/// Super Admin Settings Page
///
/// Platform configuration and system settings for super administrators.
class SuperAdminSettingsPage extends StatelessWidget {
  const SuperAdminSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            context.goNamed('login');
          }

          if (state is AuthError) {
            SnackbarHelper.showError(context, state.message);
          }
        },
        child: const SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account Section
              SettingsSectionHeader(title: 'Account', icon: Icons.person),
              SizedBox(height: 12),
              SuperAdminAccountSection(),

              SizedBox(height: 32),

              // Platform Configuration
              SettingsSectionHeader(
                title: 'Platform Configuration',
                icon: Icons.settings,
              ),
              SizedBox(height: 12),
              PlatformConfigSection(),

              SizedBox(height: 32),

              // System Preferences
              SettingsSectionHeader(
                title: 'System Preferences',
                icon: Icons.tune,
              ),
              SizedBox(height: 12),
              SystemPreferencesSection(),

              SizedBox(height: 32),

              // Security
              SettingsSectionHeader(title: 'Security', icon: Icons.security),
              SizedBox(height: 12),
              SecuritySection(),

              SizedBox(height: 32),

              // About
              SettingsSectionHeader(title: 'About', icon: Icons.info_outline),
              SizedBox(height: 12),
              SuperAdminAboutSection(),

              SizedBox(height: 32),

              // Logout Button
              LogoutButton(),

              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
