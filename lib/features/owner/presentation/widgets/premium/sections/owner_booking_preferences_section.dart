import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_settings/owner_settings_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_settings/owner_settings_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/premium_owner_settings_section.dart';

/// Booking preferences section for owner settings.
///
/// Handles auto-approve settings and booking rules configuration.
class OwnerBookingPreferencesSection extends StatelessWidget {
  final OwnerSettingsState state;
  final OwnerSettingsCubit cubit;

  const OwnerBookingPreferencesSection({
    super.key,
    required this.state,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumOwnerSettingsSection(
      title: context.l10n.bookingPreferencesSection,
      icon: Icons.settings_outlined,
      children: [
        OwnerSettingsToggle(
          label: context.l10n.autoApproveBookings,
          description: context.l10n.autoApproveBookingsDesc,
          icon: Icons.check_circle_outline,
          value: state.autoApproveBookings,
          onChanged: (value) {
            HapticFeedback.selectionClick();
            cubit.toggleAutoApproveBookings(value);
          },
        ),
        OwnerSettingsTile(
          label: context.l10n.bookingRules,
          icon: Icons.rule,
          value: context.l10n.configure,
          onTap: () {
            HapticFeedback.lightImpact();
            // Navigate to booking rules
          },
        ),
        OwnerSettingsTile(
          label: context.l10n.pricingSettings,
          icon: Icons.attach_money,
          value: context.l10n.manage,
          onTap: () {
            HapticFeedback.lightImpact();
            // Navigate to pricing settings
          },
        ),
      ],
    );
  }
}
