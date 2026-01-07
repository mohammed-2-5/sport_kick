import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';

/// Action buttons for the invoice page based on payment status.
///
/// Shows different button configurations:
/// - Verified: View My Bookings + Back to Home
/// - Uploaded: Info message + View My Bookings
/// - Pending/Rejected: View My Bookings + Back to Home
class InvoiceActionButtons extends StatelessWidget {
  final BookingEntity booking;

  const InvoiceActionButtons({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;
    final textTheme = context.textTheme;

    // If payment is verified, show "View My Bookings" button
    if (booking.paymentStatus.isComplete) {
      return Column(
        children: [
          PremiumButton(
            label: context.l10n.viewMyBookings,
            onPressed: () => context.goNamed(context.l10n.mybookings),
            fullWidth: true,
            icon: Icons.list_alt_rounded,
          ),
          const SizedBox(height: 12),
          PremiumButton(
            label: context.l10n.backToHome,
            onPressed: () => context.go('/'),
            fullWidth: true,
            style: PremiumButtonStyle.outline,
          ),
        ],
      );
    }

    // If payment proof is uploaded, show waiting message
    if (booking.paymentStatus.needsOwnerAction) {
      return Column(
        children: [
          PremiumCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.info.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: colorScheme.info,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    context.l10n.paymentProofSubmittedMessage,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PremiumButton(
            label: context.l10n.viewMyBookings,
            onPressed: () => context.goNamed(context.l10n.mybookings),
            fullWidth: true,
            icon: Icons.list_alt_rounded,
          ),
        ],
      );
    }

    // Payment required or rejected - show upload instructions
    return Column(
      children: [
        PremiumButton(
          label: context.l10n.viewMyBookings,
          onPressed: () => context.goNamed(context.l10n.mybookings),
          fullWidth: true,
          icon: Icons.list_alt_rounded,
        ),
        const SizedBox(height: 12),
        PremiumButton(
          label: context.l10n.backToHome,
          onPressed: () => context.go('/'),
          fullWidth: true,
          style: PremiumButtonStyle.outline,
        ),
      ],
    );
  }
}
