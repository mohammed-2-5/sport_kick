import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/owner/presentation/widgets/settings/settings_section.dart';
import 'package:spo_kick/features/owner/presentation/widgets/settings/switch_tile.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// Notification settings section widget for owner settings page.
class OwnerNotificationSection extends StatelessWidget {
  final bool emailNotifications;
  final bool pushNotifications;
  final bool bookingNotifications;
  final ValueChanged<bool> onEmailChanged;
  final ValueChanged<bool> onPushChanged;
  final ValueChanged<bool> onBookingChanged;

  const OwnerNotificationSection({
    super.key,
    required this.emailNotifications,
    required this.pushNotifications,
    required this.bookingNotifications,
    required this.onEmailChanged,
    required this.onPushChanged,
    required this.onBookingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: context.l10n.notificationsSection,
      icon: Icons.notifications_outlined,
      children: [
        SwitchTile(
          icon: Icons.email_outlined,
          iconColor: AppColors.primary,
          title: context.l10n.emailNotifications,
          subtitle: context.l10n.emailNotificationsDesc,
          value: emailNotifications,
          onChanged: onEmailChanged,
        ),
        const SizedBox(height: 8),
        SwitchTile(
          icon: Icons.notifications_active,
          iconColor: AppColors.secondary,
          title: context.l10n.pushNotifications,
          subtitle: context.l10n.pushNotificationsDesc,
          value: pushNotifications,
          onChanged: onPushChanged,
        ),
        const SizedBox(height: 8),
        SwitchTile(
          icon: Icons.event_available,
          iconColor: AppColors.success,
          title: context.l10n.bookingAlerts,
          subtitle: context.l10n.bookingAlertsDesc,
          value: bookingNotifications,
          onChanged: onBookingChanged,
        ),
      ],
    );
  }
}
