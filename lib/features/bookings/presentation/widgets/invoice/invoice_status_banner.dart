import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/payment_status.dart';

/// Status banner showing payment status for a booking invoice.
///
/// Displays different colors and icons based on payment status:
/// - Verified: Green success
/// - Uploaded: Blue info (awaiting verification)
/// - Rejected: Red error
/// - Pending: Yellow warning
class InvoiceStatusBanner extends StatelessWidget {
  final BookingEntity booking;

  const InvoiceStatusBanner({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final status = booking.paymentStatus;
    final l10n = context.l10n;
    final colorScheme = context.colors;
    final textTheme = context.textTheme;

    final Color backgroundColor;
    final Color textColor;
    final IconData icon;
    final String message;

    switch (status) {
      case PaymentStatus.verified:
        backgroundColor = colorScheme.success.withAlpha(26);
        textColor = colorScheme.success;
        icon = Icons.check_circle_rounded;
        message = l10n.paymentVerified;
      case PaymentStatus.uploaded:
        backgroundColor = colorScheme.info.withAlpha(26);
        textColor = colorScheme.info;
        icon = Icons.hourglass_empty_rounded;
        message = l10n.paymentAwaitingVerification;
      case PaymentStatus.rejected:
        backgroundColor = colorScheme.error.withAlpha(26);
        textColor = colorScheme.error;
        icon = Icons.error_rounded;
        message = booking.paymentRejectionReason ?? l10n.paymentRejected;
      case PaymentStatus.pending:
        backgroundColor = colorScheme.warning.withAlpha(26);
        textColor = colorScheme.warning;
        icon = Icons.payment_rounded;
        message = l10n.paymentRequired;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getStatusLabel(context),
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: textTheme.bodySmall?.copyWith(
                    color: textColor.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusLabel(BuildContext context) {
    final l10n = context.l10n;
    switch (booking.paymentStatus) {
      case PaymentStatus.pending:
        return l10n.paymentStatusPending;
      case PaymentStatus.uploaded:
        return l10n.paymentStatusUploaded;
      case PaymentStatus.verified:
        return l10n.paymentStatusVerified;
      case PaymentStatus.rejected:
        return l10n.paymentStatusRejected;
    }
  }
}
