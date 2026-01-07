import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/widgets/premium/premium_auth_text_field.dart';

/// Premium forgot password form.
///
/// Features:
/// - Glass text field
/// - Animated success state
/// - Responsive layout
class PremiumForgotPasswordForm extends StatefulWidget {
  final VoidCallback onSuccess;

  const PremiumForgotPasswordForm({super.key, required this.onSuccess});

  @override
  State<PremiumForgotPasswordForm> createState() =>
      _PremiumForgotPasswordFormState();
}

class _PremiumForgotPasswordFormState extends State<PremiumForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _InfoBox(),
          const SizedBox(height: 28),
          _EmailField(controller: _emailController),
          const SizedBox(height: 32),
          _SubmitButton(formKey: _formKey, emailController: _emailController),
          const SizedBox(height: 24),
          const _BackToLoginLink(),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.accentCyan, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              context.l10n.resetPasswordSubtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;

  const _EmailField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return PremiumAuthTextField(
      label: context.l10n.emailAddress,
      hintText: context.l10n.enterYourEmail,
      controller: controller,
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      isDark: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return context.l10n.fieldRequired;
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return context.l10n.enterValidEmail;
        }
        return null;
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;

  const _SubmitButton({required this.formKey, required this.emailController});

  @override
  Widget build(BuildContext context) {
    return PremiumButton(
      label: context.l10n.sendResetLink,
      onPressed: () {
        if (formKey.currentState?.validate() ?? false) {
          context.read<AuthCubit>().resetPassword(emailController.text.trim());
        }
      },
      icon: Icons.send,
      fullWidth: true,
    );
  }
}

class _BackToLoginLink extends StatelessWidget {
  const _BackToLoginLink();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.arrow_back,
              size: 18,
              color: Colors.white.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 8),
            Text(
              context.l10n.backToLogin,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
