import 'package:flutter/material.dart';
import 'package:spo_kick/features/auth/presentation/widgets/forgot_password/forgot_password_back_to_login_button.dart';
import 'package:spo_kick/features/auth/presentation/widgets/forgot_password/forgot_password_email_field.dart';
import 'package:spo_kick/features/auth/presentation/widgets/forgot_password/forgot_password_header.dart';
import 'package:spo_kick/features/auth/presentation/widgets/forgot_password/forgot_password_send_button.dart';

/// Forgot password form widget.
///
/// Contains email input field and submit button.
class ForgotPasswordForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final VoidCallback onSubmit;
  final VoidCallback onBackToLogin;

  const ForgotPasswordForm({
    required this.formKey,
    required this.emailController,
    required this.onSubmit,
    required this.onBackToLogin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ForgotPasswordHeader(),
                const SizedBox(height: 40),
                ForgotPasswordEmailField(controller: emailController),
                const SizedBox(height: 32),
                ForgotPasswordSendButton(onPressed: onSubmit),
                const SizedBox(height: 16),
                ForgotPasswordBackToLoginButton(onPressed: onBackToLogin),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
