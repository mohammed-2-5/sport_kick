import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_settings/owner_settings_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_settings/owner_settings_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/premium_owner_settings_section.dart';

/// Notifications section for owner settings.
///
/// Handles email, push, booking, and instant notification preferences.
class OwnerNotificationsSection extends StatelessWidget {
  final OwnerSettingsState state;
  final OwnerSettingsCubit cubit;

  const OwnerNotificationsSection({
    super.key,
    required this.state,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumOwnerSettingsSection(
      title: context.l10n.notificationsSection,
      icon: Icons.notifications_outlined,
      children: [
        OwnerSettingsToggle(
          label: context.l10n.emailNotifications,
          description: context.l10n.emailNotificationsDesc,
          icon: Icons.email_outlined,
          value: state.emailNotifications,
          onChanged: (value) {
            HapticFeedback.selectionClick();
            cubit.toggleEmailNotifications(value);
          },
        ),
        OwnerSettingsToggle(
          label: context.l10n.pushNotifications,
          description: context.l10n.pushNotificationsDesc,
          icon: Icons.phone_android,
          value: state.pushNotifications,
          onChanged: (value) {
            HapticFeedback.selectionClick();
            cubit.togglePushNotifications(value);
          },
        ),
        OwnerSettingsToggle(
          label: context.l10n.bookingAlerts,
          description: context.l10n.bookingAlertsDesc,
          icon: Icons.calendar_today_outlined,
          value: state.bookingNotifications,
          onChanged: (value) {
            HapticFeedback.selectionClick();
            cubit.toggleBookingNotifications(value);
          },
        ),
        OwnerSettingsToggle(
          label: context.l10n.instantNotifications,
          description: context.l10n.instantNotificationsDesc,
          icon: Icons.bolt,
          value: state.instantNotifications,
          onChanged: (value) {
            HapticFeedback.selectionClick();
            cubit.toggleInstantNotifications(value);
          },
        ),
      ],
    );
  }
}
