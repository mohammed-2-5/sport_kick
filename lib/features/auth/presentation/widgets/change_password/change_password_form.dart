import 'package:flutter/material.dart';
import 'package:spo_kick/features/auth/presentation/constants/auth_constants.dart';
import 'package:spo_kick/features/auth/presentation/widgets/change_password/first_login_banner.dart';
import 'package:spo_kick/features/auth/presentation/widgets/change_password/change_password_fields.dart';
import 'package:spo_kick/features/auth/presentation/widgets/change_password/password_requirements_list.dart';

import '../../../../../core/constants/app_colors.dart';

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
      padding: const EdgeInsets.all(AuthConstants.formPadding),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.isFirstLogin) ...[
              const FirstLoginBanner(),
              const SizedBox(height: AuthConstants.formFieldSpacing * 2),
            ],

            // Header
            Text(
              AuthConstants.changePasswordSubtitle,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AuthConstants.formFieldSpacing * 2),

            // Current Password (skip if first login)
            if (!widget.isFirstLogin) ...[
              CurrentPasswordField(
                controller: widget.currentPasswordController,
              ),
              const SizedBox(height: AuthConstants.formFieldSpacing),
            ],

            // New Password
            NewPasswordField(
              controller: widget.newPasswordController,
              onChanged: _onNewPasswordChanged,
            ),
            const SizedBox(height: 8),
            PasswordRequirementsList(
              password: widget.newPasswordController.text,
            ),
            const SizedBox(height: AuthConstants.formFieldSpacing),

            // Confirm Password
            ConfirmPasswordField(
              controller: widget.confirmPasswordController,
              newPasswordController: widget.newPasswordController,
            ),
            const SizedBox(height: AuthConstants.formFieldSpacing * 2),

            // Submit Button
            ChangePasswordSubmitButton(onPressed: widget.onSubmit),
          ],
        ),
      ),
    );
  }

  void _onNewPasswordChanged(String _) {
    // Rebuild to refresh requirements list
    setState(() {});
  }
}
