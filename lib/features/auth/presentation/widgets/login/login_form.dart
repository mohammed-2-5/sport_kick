import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_constants.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/custom_button.dart';
import 'package:spo_kick/core/widgets/custom_text_field.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/widgets/login/login_mode_selector.dart';

/// Login form widget with email and password fields.
///
/// Handles form validation and submission.
class LoginForm extends StatefulWidget {
  final Function(String)? onLoginModeChanged;

  const LoginForm({super.key, this.onLoginModeChanged});

  @override
  State<LoginForm> createState() => LoginFormState();
}

// Public state class so it can be accessed via GlobalKey
class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Login mode: 'user' or 'admin'
  String _loginMode = 'user';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Getter to expose login mode to parent
  String get loginMode => _loginMode;

  void _setLoginMode(String mode) {
    setState(() {
      _loginMode = mode;
    });
    // Notify parent if callback is provided
    widget.onLoginModeChanged?.call(mode);
  }

  void _handleLogin() {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Trigger login
    context.read<AuthCubit>().login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Login Mode Selector
          LoginModeSelector(
            currentMode: _loginMode,
            onModeChanged: _setLoginMode,
          ),

          const SizedBox(height: 24),

          // Email Field
          CustomTextField(
            label: context.l10n.email,
            hint: context.l10n.enterYourEmail,
            controller: _emailController,
            type: TextFieldType.email,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return context.l10n.fieldRequired;
              }
              final regex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!regex.hasMatch(value.trim())) {
                return context.l10n.invalidEmail;
              }
              return null;
            },
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 16),

          // Password Field
          CustomTextField(
            label: context.l10n.password,
            hint: context.l10n.enterPassword,
            controller: _passwordController,
            type: TextFieldType.password,
            prefixIcon: Icons.lock_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.l10n.fieldRequired;
              }
              if (value.length < AppConstants.minPasswordLength) {
                return context.l10n.passwordTooShort;
              }
              return null;
            },
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _handleLogin(),
          ),

          const SizedBox(height: 8),

          // Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                _showForgotPasswordDialog(context);
              },
              child: Text(context.l10n.forgotPassword),
            ),
          ),

          const SizedBox(height: 24),

          // Login Button
          CustomButton(
            text: context.l10n.login,
            onPressed: _handleLogin,
            variant: ButtonVariant.primary,
          ),
        ],
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.resetPasswordTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.l10n.resetPasswordSubtitle),
            const SizedBox(height: 16),
            CustomTextField(
              label: context.l10n.email,
              hint: context.l10n.enterYourEmail,
              controller: emailController,
              type: TextFieldType.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return context.l10n.fieldRequired;
                }
                final regex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!regex.hasMatch(value.trim())) {
                  return context.l10n.invalidEmail;
                }
                return null;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.l10n.cancel),
          ),
          CustomButton(
            text: context.l10n.resetPassword,
            onPressed: () {
              final email = emailController.text.trim();
              String? emailError;
              if (email.isEmpty) {
                emailError = context.l10n.fieldRequired;
              } else {
                final regex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!regex.hasMatch(email)) {
                  emailError = context.l10n.invalidEmail;
                }
              }
              if (emailError != null) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(emailError)));
                return;
              }

              // Close dialog
              Navigator.pop(dialogContext);

              // Send password reset email
              context.read<AuthCubit>().resetPassword(email);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.resetEmailSentMessage)),
              );
            },
            variant: ButtonVariant.primary,
          ),
        ],
      ),
    );
  }
}
