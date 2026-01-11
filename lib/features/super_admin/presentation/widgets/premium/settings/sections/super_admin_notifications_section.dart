import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/settings/super_admin_settings_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/settings/super_admin_settings_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/premium_settings_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/premium_settings_toggle.dart';

/// Notifications section for super admin settings.
///
/// Manages email, push, and admin alert notifications.
class SuperAdminNotificationsSection extends StatelessWidget {
  final SuperAdminSettingsLoaded state;
  final SuperAdminSettingsCubit cubit;

  const SuperAdminNotificationsSection({
    super.key,
    required this.state,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumSettingsSection(
      title: context.l10n.notifications,
      icon: Icons.notifications,
      isSaving: state.savingSection == context.l10n.notificationsTab,
      children: [
        PremiumSettingsToggle(
          label: context.l10n.emailNotifications,
          description: context.l10n.receiveEmailAlerts,
          icon: Icons.email,
          iconColor: Colors.blue,
          value: state.emailNotifications,
          onChanged: cubit.toggleEmailNotifications,
        ),
        PremiumSettingsToggle(
          label: context.l10n.pushNotifications,
          description: context.l10n.receivePushAlerts,
          icon: Icons.phone_android,
          iconColor: Colors.purple,
          value: state.pushNotifications,
          onChanged: cubit.togglePushNotifications,
        ),
        PremiumSettingsToggle(
          label: context.l10n.adminAlerts,
          description: context.l10n.importantAdminNotifications,
          icon: Icons.warning_amber,
          iconColor: Colors.orange,
          value: state.adminAlerts,
          onChanged: cubit.toggleAdminAlerts,
        ),
      ],
    );
  }
}
