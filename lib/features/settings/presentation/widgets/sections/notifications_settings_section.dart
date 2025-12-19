import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';
import 'package:spo_kick/features/settings/presentation/constants/settings_constants.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:spo_kick/features/settings/presentation/widgets/shared/settings_section.dart';
import 'package:spo_kick/features/settings/presentation/widgets/shared/settings_switch_tile.dart';

/// Notifications Settings Section
///
/// Contains all notification preference switches.
class NotificationsSettingsSection extends StatelessWidget {
  final UserPreferencesEntity preferences;

  const NotificationsSettingsSection({required this.preferences, super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: context.l10n.notificationsSettings,
      icon: Icons.notifications_outlined,
      children: [
        SettingsSwitchTile(
          icon: Icons.notifications_active,
          iconColor: AppColors.primary,
          title: context.l10n.pushNotifications,
          subtitle: context.l10n.pushNotificationsDesc,
          value: preferences.pushNotificationsEnabled,
          onChanged: (_) => context
              .read<SettingsCubit>()
              .togglePushNotifications(preferences),
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        SettingsSwitchTile(
          icon: Icons.email_outlined,
          iconColor: AppColors.secondary,
          title: context.l10n.emailNotifications,
          subtitle: context.l10n.emailNotificationsDesc,
          value: preferences.emailNotificationsEnabled,
          onChanged: (_) => context
              .read<SettingsCubit>()
              .toggleEmailNotifications(preferences),
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        SettingsSwitchTile(
          icon: Icons.check_circle_outline,
          iconColor: AppColors.success,
          title: context.l10n.bookingConfirmations,
          subtitle: context.l10n.bookingConfirmationsDesc,
          value: preferences.bookingConfirmationNotifications,
          onChanged: (_) => context
              .read<SettingsCubit>()
              .toggleBookingConfirmationNotifications(preferences),
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        SettingsSwitchTile(
          icon: Icons.alarm,
          iconColor: AppColors.warning,
          title: context.l10n.bookingReminders,
          subtitle: context.l10n.bookingRemindersDesc,
          value: preferences.bookingReminderNotifications,
          onChanged: (_) => context
              .read<SettingsCubit>()
              .toggleBookingReminderNotifications(preferences),
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        SettingsSwitchTile(
          icon: Icons.update,
          iconColor: AppColors.info,
          title: context.l10n.statusUpdates,
          subtitle: context.l10n.statusUpdatesDesc,
          value: preferences.bookingStatusNotifications,
          onChanged: (_) => context
              .read<SettingsCubit>()
              .toggleBookingStatusNotifications(preferences),
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        SettingsSwitchTile(
          icon: Icons.message,
          iconColor: AppColors.primary,
          title: context.l10n.fieldOwnerMessages,
          subtitle: context.l10n.fieldOwnerMessagesDesc,
          value: preferences.fieldOwnerMessagesNotifications,
          onChanged: (_) => context
              .read<SettingsCubit>()
              .toggleFieldOwnerMessagesNotifications(preferences),
        ),
      ],
    );
  }
}
