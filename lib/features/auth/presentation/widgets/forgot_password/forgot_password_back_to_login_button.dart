import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

class ForgotPasswordBackToLoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ForgotPasswordBackToLoginButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.arrow_back, color: AppColors.primary),
      label: Text(
        context.l10n.backToLogin,
        style: const TextStyle(color: AppColors.primary),
      ),
    );
  }
}
