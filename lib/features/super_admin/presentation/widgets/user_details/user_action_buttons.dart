import 'package:flutter/material.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/constants/admin_ui_constants.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';

/// Action buttons for user details page
class UserActionButtons extends StatelessWidget {
  final UserEntity user;
  final VoidCallback onToggleStatus;

  const UserActionButtons({
    required this.user,
    required this.onToggleStatus,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AdminUIConstants.paddingHorizontal,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onToggleStatus,
          icon: Icon(user.isActive ? Icons.block : Icons.check_circle),
          label: Text(
            user.isActive
                ? context.l10n.deactivateAccount
                : context.l10n.activateAccount,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: user.isActive
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.success,
            foregroundColor: user.isActive
                ? Theme.of(context).colorScheme.onError
                : Theme.of(context).colorScheme.onSuccess,
            padding: AdminUIConstants.paddingButton,
            shape: RoundedRectangleBorder(
              borderRadius: AdminUIConstants.borderRadiusMedium,
            ),
          ),
        ),
      ),
    );
  }
}
