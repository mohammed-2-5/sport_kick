import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/empty_states.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/settings/presentation/constants/settings_constants.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_state.dart';
import 'package:spo_kick/features/settings/presentation/widgets/sections/about_settings_section.dart';
import 'package:spo_kick/features/settings/presentation/widgets/sections/account_settings_section.dart';
import 'package:spo_kick/features/settings/presentation/widgets/sections/appearance_settings_section.dart';
import 'package:spo_kick/features/settings/presentation/widgets/sections/bookings_settings_section.dart';
import 'package:spo_kick/features/settings/presentation/widgets/sections/notifications_settings_section.dart';
import 'package:spo_kick/features/settings/presentation/widgets/sections/privacy_settings_section.dart';
import 'package:spo_kick/features/settings/presentation/widgets/sections/security_settings_section.dart';

/// Body content for User Settings Page.
///
/// Handles state management and section rendering.
/// adhereing to "Strict Code Quality":
/// - Logic delegated to [SettingsCubit] (loading, refreshing).
/// - No private _build methods for sections.
class UserSettingsBody extends StatelessWidget {
  const UserSettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) => _handleStateChange(context, state),
      builder: (context, state) => _buildContent(context, state),
    );
  }

  void _handleStateChange(BuildContext context, SettingsState state) {
    if (state is SettingsUpdated) {
      SnackbarHelper.showSuccess(context, state.message);
      // Trigger reload via Cubit if needed, or let state update naturally.
      // Assuming SettingsUpdated carries the new prefs or causes a refresh logic in Cubit.
      // If manual refresh is needed, do it here safely.
      final authState = context.read<AuthCubit>().state;
      if (authState is Authenticated) {
        context.read<SettingsCubit>().loadPreferences(authState.user.id);
      }
    } else if (state is SettingsError) {
      SnackbarHelper.showError(context, state.message);
    }
  }

  Widget _buildContent(BuildContext context, SettingsState state) {
    if (state is SettingsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is SettingsError) {
      return EmptyStates.error(
        context,
        message: state.message,
        onRetry: () => _refreshSettings(context),
      );
    }

    final preferences = (state is SettingsLoaded)
        ? state.preferences
        : (state is SettingsUpdating)
        ? state.currentPreferences
        : null;

    if (preferences == null) {
      return Center(child: Text(context.l10n.noPreferencesLoaded));
    }

    return ListView(
      padding: const EdgeInsets.all(SettingsConstants.screenPadding),
      children: [
        const BookingsSettingsSection(),
        const SizedBox(height: SettingsConstants.sectionSpacing),
        AppearanceSettingsSection(preferences: preferences),
        const SizedBox(height: SettingsConstants.sectionSpacing),
        NotificationsSettingsSection(preferences: preferences),
        const SizedBox(height: SettingsConstants.sectionSpacing),
        PrivacySettingsSection(preferences: preferences),
        const SizedBox(height: SettingsConstants.sectionSpacing),
        const AccountSettingsSection(),
        const SizedBox(height: SettingsConstants.sectionSpacing),
        const SecuritySettingsSection(),
        const SizedBox(height: SettingsConstants.sectionSpacing),
        const AboutSettingsSection(),
      ],
    );
  }

  void _refreshSettings(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    if (authState is Authenticated) {
      context.read<SettingsCubit>().loadPreferences(authState.user.id);
    }
  }
}
