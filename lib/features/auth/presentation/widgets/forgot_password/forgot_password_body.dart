import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/core/widgets/premium/premium_text_field.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/forgot_password_cubit.dart';

/// Body widget for forgot password page.
class ForgotPasswordBody extends StatefulWidget {
  const ForgotPasswordBody({super.key});

  @override
  State<ForgotPasswordBody> createState() => _ForgotPasswordBodyState();
}

class _ForgotPasswordBodyState extends State<ForgotPasswordBody> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.l10n.resetPasswordSubtitle,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _EmailField(controller: _emailController),
            const SizedBox(height: 32),
            _ResetButton(formKey: _formKey, emailController: _emailController),
          ],
        ),
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;

  const _EmailField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return PremiumTextField(
      label: context.l10n.email,
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Icons.email_outlined,
      onChanged: (value) =>
          context.read<ForgotPasswordCubit>().updateEmail(value),
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
    );
  }
}

class _ResetButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;

  const _ResetButton({required this.formKey, required this.emailController});

  @override
  Widget build(BuildContext context) {
    return PremiumButton(
      label: context.l10n.resetPassword,
      onPressed: () {
        if (formKey.currentState?.validate() ?? false) {
          context.read<AuthCubit>().resetPassword(emailController.text.trim());
        }
      },
      icon: Icons.send_rounded,
    );
  }
}
