import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/core/widgets/premium/premium_text_field.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/forgot_password_cubit.dart';

class ForgotPasswordBody extends StatefulWidget {
  const ForgotPasswordBody({super.key});

  @override
  State<ForgotPasswordBody> createState() => _ForgotPasswordBodyState();
}

class _ForgotPasswordBodyState extends State<ForgotPasswordBody> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize controller with current cubit state if any (for persistence usually, but new instance here)
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onResetPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().resetPassword(_emailController.text.trim());
    }
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
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            PremiumTextField(
              label: context.l10n.email,
              controller: _emailController,
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
            ),
            const SizedBox(height: 32),
            PremiumButton(
              label: context.l10n.resetPassword,
              onPressed: _onResetPressed,
              icon: Icons.send_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
