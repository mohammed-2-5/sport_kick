import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

class ForgotPasswordBackToLoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ForgotPasswordBackToLoginButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(
        Icons.arrow_back,
        color: Theme.of(context).colorScheme.primary,
      ),
      label: Text(
        context.l10n.backToLogin,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
