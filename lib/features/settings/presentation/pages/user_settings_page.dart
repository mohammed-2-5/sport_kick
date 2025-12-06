import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/settings/presentation/constants/settings_constants.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_state.dart';
import 'package:spo_kick/features/settings/presentation/widgets/about_settings_section.dart';
import 'package:spo_kick/features/settings/presentation/widgets/account_settings_section.dart';
import 'package:spo_kick/features/settings/presentation/widgets/appearance_settings_section.dart';
import 'package:spo_kick/features/settings/presentation/widgets/notifications_settings_section.dart';
import 'package:spo_kick/features/settings/presentation/widgets/privacy_settings_section.dart';

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
    // Load settings using cubit
    final authState = context.read<AuthCubit>().state;
    if (authState is Authenticated) {
      context.read<SettingsCubit>().loadPreferences(authState.user.id);
    }
  }

  void _refreshSettings() {
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
            onPressed: _refreshSettings,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state is SettingsUpdated) {
            SnackbarHelper.showSuccess(context, state.message);
            // Reload to show updated state
            Future.delayed(const Duration(milliseconds: 500), () {
              if (context.mounted) {
                context.read<SettingsCubit>().loadPreferences(
                  state.preferences.userId,
                );
              }
            });
          } else if (state is SettingsError) {
            SnackbarHelper.showError(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SettingsError) {
            return _SettingsErrorState(
              message: state.message,
              onRetry: _refreshSettings,
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
              AppearanceSettingsSection(preferences: preferences),
              const SizedBox(height: SettingsConstants.sectionSpacing),
              NotificationsSettingsSection(preferences: preferences),
              const SizedBox(height: SettingsConstants.sectionSpacing),
              PrivacySettingsSection(preferences: preferences),
              const SizedBox(height: SettingsConstants.sectionSpacing),
              const AccountSettingsSection(),
              const SizedBox(height: SettingsConstants.sectionSpacing),
              const AboutSettingsSection(),
            ],
          );
        },
      ),
    );
  }
}

/// Error state widget for settings page.
class _SettingsErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _SettingsErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
