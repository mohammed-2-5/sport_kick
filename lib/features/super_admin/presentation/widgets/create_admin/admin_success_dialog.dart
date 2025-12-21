import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/super_admin/domain/entities/admin_invitation_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/create_admin/credential_field.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

class AdminSuccessDialog extends StatelessWidget {
  final AdminInvitationEntity invitation;
  final VoidCallback onDone;

  const AdminSuccessDialog({
    required this.invitation,
    required this.onDone,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 32,
            ),
          ),
          const SizedBox(width: 12),
          Text(context.l10n.adminCreated),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.adminAccountHasBeenCreatedSuccessfully,
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 20),
            CredentialField(
              label: context.l10n.email,
              value: invitation.email,
              icon: Icons.email,
            ),
            const SizedBox(height: 12),
            CredentialField(
              label: context.l10n.password,
              value: invitation.defaultPassword,
              icon: Icons.lock,
              isPassword: true,
            ),
            const SizedBox(height: 12),
            CredentialField(
              label: context.l10n.fullName,
              value: invitation.fullName,
              icon: Icons.person,
            ),
            if (invitation.phone != null) ...[
              const SizedBox(height: 12),
              CredentialField(
                label: context.l10n.phone2,
                value: invitation.phone!,
                icon: Icons.phone,
              ),
            ],
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber,
                    color: Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      context.l10n.adminMustChangePasswordOnFirst,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Clipboard.setData(
              ClipboardData(
                text: [
                  context.l10n.labelWithValue(
                    context.l10n.email,
                    invitation.email,
                  ),
                  context.l10n.labelWithValue(
                    context.l10n.password,
                    invitation.defaultPassword,
                  ),
                  context.l10n.labelWithValue(
                    context.l10n.fullName,
                    invitation.fullName,
                  ),
                ].join('\n'),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.credentialsCopiedToClipboard),
                backgroundColor: Colors.green,
              ),
            );
          },
          child: Text(context.l10n.copyAll),
        ),
        ElevatedButton(onPressed: onDone, child: Text(context.l10n.done)),
      ],
    );
  }
}
