import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

class ForgotPasswordSendButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ForgotPasswordSendButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.send),
        label: Text(
          context.l10n.resetPassword,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
