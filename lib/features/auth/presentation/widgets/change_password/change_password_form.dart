import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/auth/presentation/widgets/change_password/first_login_banner.dart';
import 'package:spo_kick/features/auth/presentation/widgets/change_password/change_password_fields.dart';
import 'package:spo_kick/features/auth/presentation/widgets/change_password/password_requirements_list.dart';

/// Change password form widget.
///
/// Contains all form fields and submit button for changing password.
class ChangePasswordForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final bool isFirstLogin;
  final VoidCallback onSubmit;

  const ChangePasswordForm({
    required this.formKey,
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.isFirstLogin,
    required this.onSubmit,
    super.key,
  });

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.isFirstLogin) ...[
              const FirstLoginBanner(),
              const SizedBox(height: 32),
            ],
            _HeaderText(),
            const SizedBox(height: 32),
            if (!widget.isFirstLogin) ...[
              CurrentPasswordField(
                controller: widget.currentPasswordController,
              ),
              const SizedBox(height: 16),
            ],
            NewPasswordField(
              controller: widget.newPasswordController,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 8),
            PasswordRequirementsList(
              password: widget.newPasswordController.text,
            ),
            const SizedBox(height: 16),
            ConfirmPasswordField(
              controller: widget.confirmPasswordController,
              newPasswordController: widget.newPasswordController,
            ),
            const SizedBox(height: 32),
            ChangePasswordSubmitButton(onPressed: widget.onSubmit),
          ],
        ),
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.changePasswordDesc,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
