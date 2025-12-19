import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

class ForgotPasswordEmailField extends StatelessWidget {
  final TextEditingController controller;

  const ForgotPasswordEmailField({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: l10n.email,
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        hintText: l10n.enterYourEmail,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return l10n.fieldRequired;
        }
        final emailRegex = RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
        );
        if (!emailRegex.hasMatch(value)) {
          return l10n.invalidEmail;
        }
        return null;
      },
    );
  }
}
