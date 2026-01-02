import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

import '../../constants/auth_constants.dart';

/// Admin login header widget.
///
/// Displays admin icon, title, and subtitle for the admin login page.
class AdminLoginHeader extends StatelessWidget {
  const AdminLoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.admin_panel_settings,
            size: AuthConstants.logoSize,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: AuthConstants.formFieldSpacing),
        Text(
          context.l10n.adminPortalTitle,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.adminPortalSubtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
