import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// Premium profile action buttons.
///
/// Features:
/// - Edit profile button
/// - Change password button
/// - Settings button
/// - Logout button
class PremiumOwnerProfileActions extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onChangePassword;
  final VoidCallback onSettings;
  final VoidCallback onLogout;

  const PremiumOwnerProfileActions({
    super.key,
    required this.onEditProfile,
    required this.onChangePassword,
    required this.onSettings,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PremiumButton(
          label: context.l10n.editProfile,
          onPressed: () {
            HapticFeedback.lightImpact();
            onEditProfile();
          },
          style: PremiumButtonStyle.outline,
          icon: Icons.edit_outlined,
          fullWidth: true,
        ),
        const SizedBox(height: 12),
        PremiumButton(
          label: context.l10n.changePassword,
          onPressed: () {
            HapticFeedback.lightImpact();
            onChangePassword();
          },
          style: PremiumButtonStyle.outline,
          icon: Icons.lock_outline,
          fullWidth: true,
        ),
        const SizedBox(height: 12),
        PremiumButton(
          label: context.l10n.settings,
          onPressed: () {
            HapticFeedback.lightImpact();
            onSettings();
          },
          style: PremiumButtonStyle.outline,
          icon: Icons.settings_outlined,
          fullWidth: true,
        ),
        const SizedBox(height: 12),
        PremiumButton(
          label: context.l10n.logout,
          onPressed: () {
            HapticFeedback.mediumImpact();
            onLogout();
          },
          style: PremiumButtonStyle.outline,
          icon: Icons.logout,
          fullWidth: true,
        ),
      ],
    );
  }
}
