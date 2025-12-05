import 'package:flutter/material.dart';
import 'package:spo_kick/features/auth/presentation/constants/auth_constants.dart';
import 'package:spo_kick/features/auth/presentation/widgets/admin_login/admin_login_components.dart';
import 'package:spo_kick/features/auth/presentation/widgets/admin_login/admin_login_header.dart';

/// Admin login form widget.
///
/// Contains email, password fields and login button for admin login.
class AdminLoginForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;

  const AdminLoginForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
    super.key,
  });

  @override
  State<AdminLoginForm> createState() => _AdminLoginFormState();
}

class _AdminLoginFormState extends State<AdminLoginForm> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AuthConstants.formPadding),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Form(
            key: widget.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AuthConstants.topSpacing),
                const AdminLoginHeader(),
                const SizedBox(height: 40),
                AdminEmailField(controller: widget.emailController),
                const SizedBox(height: AuthConstants.formFieldSpacing),
                AdminPasswordField(controller: widget.passwordController),
                const SizedBox(height: 8),
                const AdminForgotPasswordLink(),
                const SizedBox(height: AuthConstants.formFieldSpacing * 2),
                AdminLoginButton(onPressed: widget.onSubmit),
                const SizedBox(height: AuthConstants.formFieldSpacing),
                const AdminUserLoginLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
