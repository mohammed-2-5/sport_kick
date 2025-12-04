import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/logout_button.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/settings_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/settings_section_header.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/settings_tile.dart';

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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account Section
              const SettingsSectionHeader(title: 'Account', icon: Icons.person),
              const SizedBox(height: 12),
              _buildAccountSection(context),

              const SizedBox(height: 32),

              // Platform Configuration
              const SettingsSectionHeader(
                title: 'Platform Configuration',
                icon: Icons.settings,
              ),
              const SizedBox(height: 12),
              _buildPlatformConfigSection(context),

              const SizedBox(height: 32),

              // System Preferences
              const SettingsSectionHeader(
                title: 'System Preferences',
                icon: Icons.tune,
              ),
              const SizedBox(height: 12),
              _buildSystemPreferencesSection(context),

              const SizedBox(height: 32),

              // Security
              const SettingsSectionHeader(
                title: 'Security',
                icon: Icons.security,
              ),
              const SizedBox(height: 12),
              _buildSecuritySection(context),

              const SizedBox(height: 32),

              // About
              const SettingsSectionHeader(
                title: 'About',
                icon: Icons.info_outline,
              ),
              const SizedBox(height: 12),
              _buildAboutSection(context),

              const SizedBox(height: 32),

              // Logout Button
              const LogoutButton(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          final user = state.user;

          return SettingsSection(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    user.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  user.fullName ?? user.email,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.email),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Super Admin',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showComingSoonDialog(context, 'Edit Profile');
                  },
                ),
              ),
              const Divider(height: 1),
              SettingsTile(
                icon: Icons.phone,
                title: 'Phone',
                subtitle: user.phone ?? 'Not set',
                onTap: () {
                  _showComingSoonDialog(context, 'Edit Phone');
                },
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildPlatformConfigSection(BuildContext context) {
    return SettingsSection(
      children: [
        SettingsTile(
          icon: Icons.access_time,
          title: 'Operating Hours',
          subtitle: 'Configure platform operating hours',
          onTap: () => _showComingSoonDialog(context, 'Operating Hours'),
        ),
        const Divider(height: 1, indent: 56),
        SettingsTile(
          icon: Icons.payments,
          title: 'Payment Settings',
          subtitle: 'Configure payment methods and fees',
          onTap: () => _showComingSoonDialog(context, 'Payment Settings'),
        ),
        const Divider(height: 1, indent: 56),
        SettingsTile(
          icon: Icons.email,
          title: 'Email Templates',
          subtitle: 'Customize email notifications',
          onTap: () => _showComingSoonDialog(context, 'Email Templates'),
        ),
        const Divider(height: 1, indent: 56),
        ListTile(
          leading: const Icon(Icons.construction),
          title: const Text('Maintenance Mode'),
          subtitle: const Text('Enable/disable platform access'),
          trailing: Switch(
            value: false,
            onChanged: (value) {
              _showMaintenanceModeDialog(context);
            },
            trackColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return Theme.of(context).primaryColor;
              }
              return null;
            }),
            thumbColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.white;
              }
              return null;
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildSystemPreferencesSection(BuildContext context) {
    return SettingsSection(
      children: [
        SettingsTile(
          icon: Icons.language,
          title: 'Language',
          subtitle: 'English',
          onTap: () => _showComingSoonDialog(context, 'Language Selection'),
        ),
        const Divider(height: 1, indent: 56),
        SettingsTile(
          icon: Icons.calendar_today,
          title: 'Date Format',
          subtitle: 'MMM d, yyyy',
          onTap: () => _showComingSoonDialog(context, 'Date Format Settings'),
        ),
        const Divider(height: 1, indent: 56),
        SettingsTile(
          icon: Icons.attach_money,
          title: 'Currency',
          subtitle: 'EGP (Egyptian Pound)',
          onTap: () => _showComingSoonDialog(context, 'Currency Settings'),
        ),
        const Divider(height: 1, indent: 56),
        SettingsTile(
          icon: Icons.notifications,
          title: 'Notifications',
          subtitle: 'System alerts and updates',
          onTap: () => _showComingSoonDialog(context, 'Notification Settings'),
        ),
      ],
    );
  }

  Widget _buildSecuritySection(BuildContext context) {
    return SettingsSection(
      children: [
        SettingsTile(
          icon: Icons.lock,
          title: 'Change Password',
          subtitle: 'Update your login password',
          onTap: () => _showComingSoonDialog(context, 'Change Password'),
        ),
        const Divider(height: 1, indent: 56),
        SettingsTile(
          icon: Icons.security,
          title: 'Two-Factor Authentication',
          subtitle: 'Add an extra layer of security',
          onTap: () => _showComingSoonDialog(context, '2FA Settings'),
        ),
        const Divider(height: 1, indent: 56),
        SettingsTile(
          icon: Icons.history,
          title: 'Login Activity',
          subtitle: 'View recent login attempts',
          onTap: () => _showComingSoonDialog(context, 'Login Activity'),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return SettingsSection(
      children: [
        SettingsTile(
          icon: Icons.info,
          title: 'Version',
          subtitle: '1.0.0+1',
          onTap: () {},
        ),
        const Divider(height: 1, indent: 56),
        SettingsTile(
          icon: Icons.description,
          title: 'Terms of Service',
          onTap: () => _showComingSoonDialog(context, 'Terms of Service'),
        ),
        const Divider(height: 1, indent: 56),
        SettingsTile(
          icon: Icons.privacy_tip,
          title: 'Privacy Policy',
          onTap: () => _showComingSoonDialog(context, 'Privacy Policy'),
        ),
      ],
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon'),
        content: Text('$feature will be available in a future update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showMaintenanceModeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Maintenance Mode'),
        content: const Text(
          'Are you sure you want to enable maintenance mode? '
          'This will prevent users from accessing the platform.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Maintenance mode feature coming soon'),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Enable'),
          ),
        ],
      ),
    );
  }
}
