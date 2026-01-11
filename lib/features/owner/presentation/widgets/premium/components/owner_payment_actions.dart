import 'package:flutter/material.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

class OwnerPaymentActions extends StatelessWidget {
  final VoidCallback? onVerify;
  final VoidCallback? onReject;

  const OwnerPaymentActions({super.key, this.onVerify, this.onReject});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onReject,
            icon: const Icon(Icons.close_rounded, size: 16),
            label: Text(context.l10n.reject),
            style: OutlinedButton.styleFrom(
              foregroundColor: colorScheme.error,
              side: BorderSide(color: colorScheme.error.withValues(alpha: 0.5)),
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onVerify,
            icon: const Icon(Icons.check_rounded, size: 16),
            label: Text(context.l10n.verify),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.success,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
