import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/entities/payment_status.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking/payment_status_badge.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

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
            _CardHeader(booking: booking),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            _DateTimeRow(booking: booking),
            const SizedBox(height: 12),
            _PaymentRow(booking: booking),
            if (booking.hasPaymentProof) ...[
              const SizedBox(height: 12),
              _ViewProofButton(onPressed: onViewPaymentProof),
            ],
            if (booking.paymentStatus == PaymentStatus.uploaded) ...[
              const SizedBox(height: 12),
              _PaymentActions(
                onVerify: onVerifyPayment,
                onReject: onRejectPayment,
              ),
            ],
            if (booking.status == BookingStatus.pending &&
                booking.paymentStatus != PaymentStatus.uploaded &&
                (onApprove != null || onReject != null)) ...[
              const SizedBox(height: 16),
              _BookingActions(onApprove: onApprove, onReject: onReject),
            ],
          ],
        ),
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final BookingEntity booking;

  const _CardHeader({required this.booking});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booking.fieldName ?? context.l10n.unknownField,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                booking.userName ?? context.l10n.unknownCustomer,
                style: AppTextStyles.bodySmall.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
        _StatusBadge(status: booking.status),
      ],
    );
  }
}

class _DateTimeRow extends StatelessWidget {
  final BookingEntity booking;

  const _DateTimeRow({required this.booking});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: 16,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 8),
        Text(booking.formattedDate, style: AppTextStyles.bodyMedium),
        const SizedBox(width: 16),
        Icon(
          Icons.access_time,
          size: 16,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 8),
        Text(
          LocaleFormatters.formatTimeRange(
            context,
            startTime: booking.startTime,
            endTime: booking.endTime,
            baseDate: booking.date,
          ),
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }
}

class _PaymentRow extends StatelessWidget {
  final BookingEntity booking;

  const _PaymentRow({required this.booking});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(
          Icons.payment_rounded,
          size: 16,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 8),
        Text(
          '${context.l10n.payment}:',
          style: AppTextStyles.bodyMedium.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 8),
        PaymentStatusBadge(status: booking.paymentStatus, isCompact: true),
        const Spacer(),
        Text(
          LocaleFormatters.formatPrice(
            context,
            amount: booking.totalPrice,
            currency: context.l10n.currencyEgp,
            decimalDigits: 0,
          ),
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.success,
          ),
        ),
      ],
    );
  }
}

class _ViewProofButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _ViewProofButton({this.onPressed});

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

class _PaymentActions extends StatelessWidget {
  final VoidCallback? onVerify;
  final VoidCallback? onReject;

  const _PaymentActions({this.onVerify, this.onReject});

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

class _BookingActions extends StatelessWidget {
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const _BookingActions({this.onApprove, this.onReject});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onReject != null)
          Expanded(
            child: _ActionButton(
              label: context.l10n.reject,
              icon: Icons.close,
              color: Colors.red,
              onTap: onReject!,
            ),
          ),
        if (onReject != null && onApprove != null) const SizedBox(width: 12),
        if (onApprove != null)
          Expanded(
            child: _ActionButton(
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

class _StatusBadge extends StatelessWidget {
  final BookingStatus status;

  const _StatusBadge({required this.status});

  List<Color> get _gradientColors {
    switch (status) {
      case BookingStatus.pending:
        return [Colors.orange, Colors.deepOrange];
      case BookingStatus.confirmed:
        return [Colors.green, Colors.teal];
      case BookingStatus.canceled:
        return [Colors.red, Colors.redAccent];
      case BookingStatus.completed:
        return [Colors.blue, Colors.blueAccent];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: _gradientColors),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _gradientColors.first.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        _statusLabel(context),
        style: AppTextStyles.labelSmall.copyWith(
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  String _statusLabel(BuildContext context) {
    switch (status) {
      case BookingStatus.pending:
        return context.l10n.statusPending;
      case BookingStatus.confirmed:
        return context.l10n.statusConfirmed;
      case BookingStatus.canceled:
        return context.l10n.statusCancelled;
      case BookingStatus.completed:
        return context.l10n.statusCompleted;
    }
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
