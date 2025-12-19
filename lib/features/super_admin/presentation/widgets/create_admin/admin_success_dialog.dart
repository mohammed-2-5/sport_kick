import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/super_admin/domain/entities/admin_invitation_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/create_admin/credential_field.dart';

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
          const Text('Admin Created!'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Admin account has been created successfully. Please save these credentials:',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 20),
            CredentialField(
              label: 'Email',
              value: invitation.email,
              icon: Icons.email,
            ),
            const SizedBox(height: 12),
            CredentialField(
              label: 'Password',
              value: invitation.defaultPassword,
              icon: Icons.lock,
              isPassword: true,
            ),
            const SizedBox(height: 12),
            CredentialField(
              label: 'Full Name',
              value: invitation.fullName,
              icon: Icons.person,
            ),
            if (invitation.phone != null) ...[
              const SizedBox(height: 12),
              CredentialField(
                label: 'Phone',
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
              child: const Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Admin must change password on first login',
                      style: TextStyle(fontSize: 12, color: Colors.orange),
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
                text:
                    'Email: ${invitation.email}\n'
                    'Password: ${invitation.defaultPassword}\n'
                    'Name: ${invitation.fullName}',
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Credentials copied to clipboard'),
                backgroundColor: Colors.green,
              ),
            );
          },
          child: const Text('Copy All'),
        ),
        ElevatedButton(onPressed: onDone, child: const Text('Done')),
      ],
    );
  }
}
