import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/auth/presentation/constants/auth_constants.dart';

class ForgotPasswordSendButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ForgotPasswordSendButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AuthConstants.buttonHeight,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.send),
        label: const Text(
          AuthConstants.sendResetLinkLabel,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AuthConstants.borderRadius),
          ),
        ),
      ),
    );
  }
}
