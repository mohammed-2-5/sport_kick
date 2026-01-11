import 'package:flutter/material.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/components/owner_booking_action_button.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

class OwnerBookingActions extends StatelessWidget {
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const OwnerBookingActions({super.key, this.onApprove, this.onReject});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onReject != null)
          Expanded(
            child: OwnerBookingActionButton(
              label: context.l10n.reject,
              icon: Icons.close,
              color: Colors.red,
              onTap: onReject!,
            ),
          ),
        if (onReject != null && onApprove != null) const SizedBox(width: 12),
        if (onApprove != null)
          Expanded(
            child: OwnerBookingActionButton(
              label: context.l10n.approve,
              icon: Icons.check,
              color: Colors.green,
              onTap: onApprove!,
            ),
          ),
      ],
    );
  }
}
