import 'package:flutter/material.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

class OwnerViewProofButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const OwnerViewProofButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.receipt_long_outlined, size: 16),
        label: Text(context.l10n.viewPaymentProof),
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.info,
          side: BorderSide(color: colorScheme.info.withValues(alpha: 0.5)),
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
