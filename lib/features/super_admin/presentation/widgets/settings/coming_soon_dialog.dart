import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Shows a "Coming Soon" dialog for features not yet implemented.
void showComingSoonDialog(BuildContext context, String feature) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(context.l10n.homeComingSoonTitle),
      content: Text(context.l10n.featureWillBeAvailableInAFutureUpdate),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.ok),
        ),
      ],
    ),
  );
}

/// Shows a maintenance mode confirmation dialog.
void showMaintenanceModeDialog(BuildContext context, VoidCallback onConfirm) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(context.l10n.maintenanceMode),
      content: Text(
        '${context.l10n.areYouSureYouWantTo}${context.l10n.thisWillPreventUsersFromAccessing}',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: Text(context.l10n.enable),
        ),
      ],
    ),
  );
}
