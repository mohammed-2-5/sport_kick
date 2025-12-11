import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
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
      title: 'Notifications',
      icon: Icons.notifications_outlined,
      children: [
        SettingsSwitchTile(
          icon: Icons.notifications_active,
          iconColor: AppColors.primary,
          title: 'Push Notifications',
          subtitle: 'Receive push notifications on your device',
          value: preferences.pushNotificationsEnabled,
          onChanged: (_) => context
              .read<SettingsCubit>()
              .togglePushNotifications(preferences),
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        SettingsSwitchTile(
          icon: Icons.email_outlined,
          iconColor: AppColors.secondary,
          title: 'Email Notifications',
          subtitle: 'Receive notifications via email',
          value: preferences.emailNotificationsEnabled,
          onChanged: (_) => context
              .read<SettingsCubit>()
              .toggleEmailNotifications(preferences),
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        SettingsSwitchTile(
          icon: Icons.check_circle_outline,
          iconColor: AppColors.success,
          title: 'Booking Confirmations',
          subtitle: 'Get notified when bookings are confirmed',
          value: preferences.bookingConfirmationNotifications,
          onChanged: (_) => context
              .read<SettingsCubit>()
              .toggleBookingConfirmationNotifications(preferences),
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        SettingsSwitchTile(
          icon: Icons.alarm,
          iconColor: AppColors.warning,
          title: 'Booking Reminders',
          subtitle: 'Get reminded 1 hour before your booking',
          value: preferences.bookingReminderNotifications,
          onChanged: (_) => context
              .read<SettingsCubit>()
              .toggleBookingReminderNotifications(preferences),
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        SettingsSwitchTile(
          icon: Icons.update,
          iconColor: AppColors.info,
          title: 'Status Updates',
          subtitle: 'Get notified of booking status changes',
          value: preferences.bookingStatusNotifications,
          onChanged: (_) => context
              .read<SettingsCubit>()
              .toggleBookingStatusNotifications(preferences),
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        SettingsSwitchTile(
          icon: Icons.message,
          iconColor: AppColors.primary,
          title: 'Field Owner Messages',
          subtitle: 'Get notified of messages from field owners',
          value: preferences.fieldOwnerMessagesNotifications,
          onChanged: (_) => context
              .read<SettingsCubit>()
              .toggleFieldOwnerMessagesNotifications(preferences),
        ),
      ],
    );
  }
}
