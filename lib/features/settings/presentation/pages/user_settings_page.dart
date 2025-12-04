import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/auth/presentation/widgets/edit_profile_dialog.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';
import 'package:spo_kick/features/settings/presentation/constants/settings_constants.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_state.dart';
import 'package:spo_kick/features/settings/presentation/widgets/language_selector_dialog.dart';
import 'package:spo_kick/features/settings/presentation/widgets/notifications_settings_section.dart';
import 'package:spo_kick/features/settings/presentation/widgets/settings_section.dart';
import 'package:spo_kick/features/settings/presentation/widgets/settings_switch_tile.dart';
import 'package:spo_kick/features/settings/presentation/widgets/settings_tile.dart';
import 'package:spo_kick/features/settings/presentation/widgets/theme_selector_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

/// User Settings Page
///
/// Settings page for regular users with:
/// - Notification preferences
/// - Theme selection (Light/Dark/System)
/// - Language selection
/// - Privacy settings
/// - Account management
class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({super.key});

  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    final authState = context.read<AuthCubit>().state;
    if (authState is Authenticated) {
      context.read<SettingsCubit>().loadPreferences(authState.user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSettings,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state is SettingsUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
            // Reload to show updated state
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                context.read<SettingsCubit>().loadPreferences(
                  state.preferences.userId,
                );
              }
            });
          } else if (state is SettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SettingsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadSettings,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final preferences = (state is SettingsLoaded)
              ? state.preferences
              : (state is SettingsUpdating)
              ? state.currentPreferences
              : null;

          if (preferences == null) {
            return const Center(child: Text('No preferences loaded'));
          }

          return ListView(
            padding: const EdgeInsets.all(SettingsConstants.screenPadding),
            children: [
              _buildAppearanceSection(preferences),
              const SizedBox(height: SettingsConstants.sectionSpacing),
              NotificationsSettingsSection(preferences: preferences),
              const SizedBox(height: SettingsConstants.sectionSpacing),
              _buildPrivacySection(preferences),
              const SizedBox(height: SettingsConstants.sectionSpacing),
              _buildAccountSection(),
              const SizedBox(height: SettingsConstants.sectionSpacing),
              _buildAboutSection(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppearanceSection(UserPreferencesEntity preferences) {
    return SettingsSection(
      title: 'Appearance',
      icon: Icons.palette_outlined,
      children: [
        SettingsTile(
          leading: const Icon(Icons.brightness_6, color: AppColors.primary),
          title: 'Theme',
          subtitle: SettingsConstants
              .themeModeNames[_themeModeToString(preferences.themeMode)]!,
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showThemeDialog(preferences),
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        SettingsTile(
          leading: const Icon(Icons.language, color: AppColors.info),
          title: 'Language',
          subtitle:
              SettingsConstants.languageNames[preferences.language] ??
              'English',
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showLanguageDialog(preferences),
        ),
      ],
    );
  }

  Widget _buildPrivacySection(UserPreferencesEntity preferences) {
    return SettingsSection(
      title: 'Privacy',
      icon: Icons.privacy_tip_outlined,
      children: [
        SettingsSwitchTile(
          icon: Icons.account_circle,
          iconColor: AppColors.primary,
          title: 'Show Profile Picture',
          subtitle: 'Display your profile picture to field owners',
          value: preferences.showProfilePicture,
          onChanged: (_) => context
              .read<SettingsCubit>()
              .toggleShowProfilePicture(preferences),
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        SettingsSwitchTile(
          icon: Icons.phone,
          iconColor: AppColors.info,
          title: 'Show Phone Number',
          subtitle: 'Display your phone number to field owners',
          value: preferences.showPhoneNumber,
          onChanged: (_) =>
              context.read<SettingsCubit>().toggleShowPhoneNumber(preferences),
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        SettingsSwitchTile(
          icon: Icons.email,
          iconColor: AppColors.secondary,
          title: 'Show Email',
          subtitle: 'Display your email to field owners',
          value: preferences.showEmail,
          onChanged: (_) =>
              context.read<SettingsCubit>().toggleShowEmail(preferences),
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return SettingsSection(
      title: 'Account',
      icon: Icons.person_outline,
      children: [
        SettingsTile(
          leading: const Icon(Icons.edit, color: AppColors.info),
          title: 'Edit Profile',
          subtitle: 'Update your personal information',
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showEditProfileDialog(),
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        SettingsTile(
          leading: const Icon(Icons.lock_reset, color: AppColors.primary),
          title: 'Change Password',
          subtitle: 'Update your account password',
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            context.pushNamed('changePassword');
          },
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return SettingsSection(
      title: 'About',
      icon: Icons.info_outline,
      children: [
        SettingsTile(
          leading: const Icon(
            Icons.privacy_tip_outlined,
            color: AppColors.info,
          ),
          title: 'Privacy Policy',
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            context.pushNamed('privacyPolicy');
          },
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        SettingsTile(
          leading: const Icon(
            Icons.description_outlined,
            color: AppColors.info,
          ),
          title: 'Terms of Service',
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            context.pushNamed('termsOfService');
          },
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        SettingsTile(
          leading: const Icon(Icons.help_outline, color: AppColors.warning),
          title: 'Help & Support',
          subtitle: 'Email us your questions',
          trailing: const Icon(Icons.email),
          onTap: () => _launchUrl(
            'mailto:${SettingsConstants.supportEmail}?subject=Sport%20Kick%20Support',
          ),
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        const SettingsTile(
          leading: Icon(Icons.info, color: AppColors.mediumGrey),
          title: 'Version',
          trailing: Text(
            SettingsConstants.appVersion,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  void _showThemeDialog(UserPreferencesEntity preferences) {
    showDialog(
      context: context,
      builder: (context) => ThemeSelectorDialog(preferences: preferences),
    );
  }

  void _showLanguageDialog(UserPreferencesEntity preferences) {
    showDialog(
      context: context,
      builder: (context) => LanguageSelectorDialog(preferences: preferences),
    );
  }

  String _themeModeToString(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'light';
      case AppThemeMode.dark:
        return 'dark';
      case AppThemeMode.system:
        return 'system';
    }
  }

  /// Shows the edit profile dialog.
  void _showEditProfileDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => BlocProvider.value(
        value: this.context.read<AuthCubit>(),
        child: const EditProfileDialog(),
      ),
    );
  }

  /// Launches a URL in the default browser.
  ///
  /// Shows an error message if the URL cannot be launched.
  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open the link'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening link: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
