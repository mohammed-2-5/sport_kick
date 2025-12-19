import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/entities/payment_status.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking/booking_action_buttons.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking/booking_card_header.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking/booking_info_chip.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking/payment_status_badge.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// Card displaying booking details for field owners.
///
/// Shows customer info, date/time, duration, price, payment status,
/// and action buttons based on booking and payment state.
class OwnerBookingCard extends StatelessWidget {
  final BookingEntity booking;
  final VoidCallback? onViewPaymentProof;
  final VoidCallback? onVerifyPayment;
  final VoidCallback? onRejectPayment;

  const OwnerBookingCard({
    super.key,
    required this.booking,
    this.onViewPaymentProof,
    this.onVerifyPayment,
    this.onRejectPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: _buildCardDecoration(),
      child: Column(
        children: [
          BookingCardHeader(booking: booking),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _CustomerInfoRow(booking: booking),
                const SizedBox(height: 16),
                _DateTimeRow(booking: booking),
                const SizedBox(height: 12),
                _DurationPriceRow(booking: booking),
                const SizedBox(height: 16),
                _PaymentStatusRow(booking: booking),
                if (booking.hasPaymentProof) ...[
                  const SizedBox(height: 12),
                  _ViewPaymentProofButton(onPressed: onViewPaymentProof),
                ],
                if (booking.paymentStatus == PaymentStatus.uploaded) ...[
                  const SizedBox(height: 16),
                  _PaymentVerificationButtons(
                    onVerify: onVerifyPayment,
                    onReject: onRejectPayment,
                  ),
                ],
                if (booking.status == BookingStatus.pending &&
                    booking.paymentStatus != PaymentStatus.uploaded) ...[
                  const SizedBox(height: 20),
                  BookingActionButtons(booking: booking),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.white, booking.status.color.withValues(alpha: 0.03)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: booking.status.color.withValues(alpha: 0.3),
        width: 2,
      ),
      boxShadow: [
        BoxShadow(
          color: booking.status.color.withValues(alpha: 0.2),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}

class _CustomerInfoRow extends StatelessWidget {
  final BookingEntity booking;

  const _CustomerInfoRow({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.person_rounded,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.customerName,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                booking.userName ?? context.l10n.unknownCustomer,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DateTimeRow extends StatelessWidget {
  final BookingEntity booking;

  const _DateTimeRow({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BookingInfoChip(
            icon: Icons.calendar_today_rounded,
            label: context.l10n.dateLabel,
            value: booking.formattedDate,
            color: const Color(0xFF42A5F5),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: BookingInfoChip(
            icon: Icons.access_time_rounded,
            label: context.l10n.timeLabel,
            value: booking.formattedTimeSlot,
            color: const Color(0xFF66BB6A),
          ),
        ),
      ],
    );
  }
}

class _DurationPriceRow extends StatelessWidget {
  final BookingEntity booking;

  const _DurationPriceRow({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BookingInfoChip(
            icon: Icons.timer_rounded,
            label: context.l10n.durationLabel,
            value: context.l10n.hoursLabel(
              booking.durationInHours,
              LocaleFormatters.formatNumber(
                context,
                booking.durationInHours,
                decimalDigits: 0,
              ),
            ),
            color: const Color(0xFFAB47BC),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: BookingInfoChip(
            icon: Icons.attach_money_rounded,
            label: context.l10n.price,
            value: LocaleFormatters.formatPrice(
              context,
              amount: booking.totalPrice,
              currency: context.l10n.currencyEgp,
              decimalDigits: 0,
            ),
            color: const Color(0xFFFFA726),
          ),
        ),
      ],
    );
  }
}

class _PaymentStatusRow extends StatelessWidget {
  final BookingEntity booking;

  const _PaymentStatusRow({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.accentCyan.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.payment_rounded,
            color: AppColors.accentCyan,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${context.l10n.payment}:',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 8),
        PaymentStatusBadge(status: booking.paymentStatus),
      ],
    );
  }
}

class _ViewPaymentProofButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _ViewPaymentProofButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.receipt_long_outlined, size: 18),
        label: Text(context.l10n.viewPaymentProof),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.info,
          side: BorderSide(color: AppColors.info.withValues(alpha: 0.5)),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _PaymentVerificationButtons extends StatelessWidget {
  final VoidCallback? onVerify;
  final VoidCallback? onReject;

  const _PaymentVerificationButtons({this.onVerify, this.onReject});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onReject,
            icon: const Icon(Icons.close_rounded, size: 18),
            label: Text(context.l10n.reject),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: BorderSide(color: AppColors.error.withValues(alpha: 0.5)),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onVerify,
            icon: const Icon(Icons.check_rounded, size: 18),
            label: Text(context.l10n.verify),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
