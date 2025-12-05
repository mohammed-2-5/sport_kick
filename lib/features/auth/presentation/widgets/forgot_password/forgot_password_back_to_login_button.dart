import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/auth/presentation/constants/auth_constants.dart';

class ForgotPasswordBackToLoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ForgotPasswordBackToLoginButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.arrow_back, color: AppColors.primary),
      label: const Text(
        AuthConstants.backToLoginLabel,
        style: TextStyle(color: AppColors.primary),
      ),
    );
  }
}
