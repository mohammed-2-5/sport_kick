import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/entities/payment_status.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/components/owner_booking_actions.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/components/owner_booking_card_header.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/components/owner_booking_date_time_row.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/components/owner_booking_payment_row.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/components/owner_payment_actions.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/components/owner_view_proof_button.dart';

/// Premium owner booking card with payment status.
///
/// Features:
/// - PremiumCard container
/// - Status badge with gradient
/// - Payment status badge
/// - Customer info
/// - Time slot display
/// - Action buttons for booking and payment
class PremiumOwnerBookingCard extends StatelessWidget {
  final BookingEntity booking;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onTap;
  final VoidCallback? onViewPaymentProof;
  final VoidCallback? onVerifyPayment;
  final VoidCallback? onRejectPayment;

  const PremiumOwnerBookingCard({
    super.key,
    required this.booking,
    this.onApprove,
    this.onReject,
    this.onTap,
    this.onViewPaymentProof,
    this.onVerifyPayment,
    this.onRejectPayment,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OwnerBookingCardHeader(booking: booking),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            OwnerBookingDateTimeRow(booking: booking),
            const SizedBox(height: 12),
            OwnerBookingPaymentRow(booking: booking),
            if (booking.hasPaymentProof) ...[
              const SizedBox(height: 12),
              OwnerViewProofButton(onPressed: onViewPaymentProof),
            ],
            if (booking.paymentStatus == PaymentStatus.uploaded) ...[
              const SizedBox(height: 12),
              OwnerPaymentActions(
                onVerify: onVerifyPayment,
                onReject: onRejectPayment,
              ),
            ],
            if (booking.status == BookingStatus.pending &&
                booking.paymentStatus != PaymentStatus.uploaded &&
                (onApprove != null || onReject != null)) ...[
              const SizedBox(height: 16),
              OwnerBookingActions(onApprove: onApprove, onReject: onReject),
            ],
          ],
        ),
      ),
    );
  }
}
