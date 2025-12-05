import 'package:flutter/material.dart';
import 'package:spo_kick/features/auth/presentation/constants/auth_constants.dart';

class ForgotPasswordEmailField extends StatelessWidget {
  final TextEditingController controller;

  const ForgotPasswordEmailField({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: AuthConstants.emailLabel,
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AuthConstants.borderRadius),
        ),
        hintText: 'Enter your email address',
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return AuthConstants.emailRequiredMsg;
        }
        final emailRegex = RegExp(AuthConstants.emailPattern);
        if (!emailRegex.hasMatch(value)) {
          return AuthConstants.emailInvalidMsg;
        }
        return null;
      },
    );
  }
}
