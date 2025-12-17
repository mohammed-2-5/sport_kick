import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/entities/payment_status.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking/payment_status_badge.dart';

/// Status card showing booking status with gradient.
///
/// Updated: 2025-12-13
class OwnerBookingStatusCard extends StatelessWidget {
  final BookingEntity booking;

  const OwnerBookingStatusCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            _StatusIcon(status: booking.status),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Booking Status',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    booking.status.displayName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _getStatusColor(booking.status),
                    ),
                  ),
                ],
              ),
            ),
            _StatusBadge(status: booking.status),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return AppColors.success;
      case BookingStatus.canceled:
        return AppColors.error;
      case BookingStatus.completed:
        return AppColors.info;
    }
  }
}

class _StatusIcon extends StatelessWidget {
  final BookingStatus status;

  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getGradientColors(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _getGradientColors().first.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(_getIcon(), color: Colors.white, size: 28),
    );
  }

  List<Color> _getGradientColors() {
    switch (status) {
      case BookingStatus.pending:
        return [Colors.orange, Colors.deepOrange];
      case BookingStatus.confirmed:
        return [AppColors.success, Colors.green.shade700];
      case BookingStatus.canceled:
        return [AppColors.error, Colors.red.shade700];
      case BookingStatus.completed:
        return [AppColors.info, Colors.blue.shade700];
    }
  }

  IconData _getIcon() {
    switch (status) {
      case BookingStatus.pending:
        return Icons.schedule_rounded;
      case BookingStatus.confirmed:
        return Icons.check_circle_rounded;
      case BookingStatus.canceled:
        return Icons.cancel_rounded;
      case BookingStatus.completed:
        return Icons.sports_soccer_rounded;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final BookingStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _getColor().withValues(alpha: 0.3)),
      ),
      child: Text(
        status.displayName.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: _getColor(),
          letterSpacing: 1,
        ),
      ),
    );
  }

  Color _getColor() {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return AppColors.success;
      case BookingStatus.canceled:
        return AppColors.error;
      case BookingStatus.completed:
        return AppColors.info;
    }
  }
}

/// Customer information card.
///
/// Updated: 2025-12-13
class OwnerBookingCustomerCard extends StatelessWidget {
  final BookingEntity booking;

  const OwnerBookingCustomerCard({super.key, required this.booking});

  String get _customerName {
    return booking.customerName ?? booking.userName ?? 'Unknown';
  }

  String? get _customerPhone => booking.customerPhone;

  String? get _customerEmail => booking.customerEmail;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.person_rounded,
                  color: AppColors.accentCyan,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  booking.isManual
                      ? 'Walk-in Customer'
                      : 'Customer Information',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (booking.isManual) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentCyan.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'MANUAL',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentCyan,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.badge_outlined,
              label: 'Name',
              value: _customerName,
            ),
            if (_customerPhone != null) ...[
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.phone_outlined,
                label: 'Phone',
                value: _customerPhone!,
                onTap: () => _copyToClipboard(context, _customerPhone!),
              ),
            ],
            if (_customerEmail != null) ...[
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.email_outlined,
                label: 'Email',
                value: _customerEmail!,
              ),
            ],
            if (_customerPhone == null && _customerEmail == null) ...[
              const SizedBox(height: 12),
              const _InfoRow(
                icon: Icons.info_outline,
                label: 'Contact',
                value: 'No contact info available',
              ),
            ],
            // Show admin information for manual bookings
            if (booking.isManual && booking.createdByName != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.navyDeep.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.navyDeep.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.admin_panel_settings,
                          color: AppColors.navyDeep,
                          size: 16,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Created By',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navyDeep,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(
                      icon: Icons.person_outline,
                      label: 'Admin',
                      value: booking.createdByName!,
                    ),
                    if (booking.createdByEmail != null) ...[
                      const SizedBox(height: 8),
                      _InfoRow(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: booking.createdByEmail!,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied: $text'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

/// Date and time information card.
///
/// Updated: 2025-12-13
class OwnerBookingDateTimeCard extends StatelessWidget {
  final BookingEntity booking;

  const OwnerBookingDateTimeCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: AppColors.accentCyan,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Date & Time',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _DateTimeBox(
                    icon: Icons.calendar_month_rounded,
                    label: 'Date',
                    value: _formatDate(booking.date),
                    gradient: const [
                      AppColors.accentCyan,
                      AppColors.premiumPeriwinkle,
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DateTimeBox(
                    icon: Icons.access_time_rounded,
                    label: 'Time',
                    value: '${booking.startTime} - ${booking.endTime}',
                    gradient: const [
                      AppColors.premiumPeriwinkle,
                      AppColors.accentCyan,
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _InfoChip(
                    icon: Icons.timer_outlined,
                    label:
                        '${booking.durationHours} Hour${booking.durationHours > 1 ? 's' : ''}',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoChip(
                    icon: Icons.sports_soccer_rounded,
                    label: booking.fieldName ?? 'Unknown Field',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEE, MMM d, y').format(date);
  }
}

class _DateTimeBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final List<Color> gradient;

  const _DateTimeBox({
    required this.icon,
    required this.label,
    required this.value,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient.map((c) => c.withValues(alpha: 0.1)).toList(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: gradient.first.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: gradient.first),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Payment status and proof card.
///
/// Updated: 2025-12-13
class OwnerBookingPaymentCard extends StatelessWidget {
  final BookingEntity booking;
  final VoidCallback? onViewProof;
  final VoidCallback? onVerifyPayment;
  final VoidCallback? onRejectPayment;

  const OwnerBookingPaymentCard({
    super.key,
    required this.booking,
    this.onViewProof,
    this.onVerifyPayment,
    this.onRejectPayment,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.payment_rounded,
                  color: AppColors.accentCyan,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Payment Information',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                PaymentStatusBadge(status: booking.paymentStatus),
              ],
            ),
            const SizedBox(height: 16),
            _PaymentStatusInfo(status: booking.paymentStatus),
            if (booking.hasPaymentProof) ...[
              const SizedBox(height: 16),
              _ViewProofButton(onPressed: onViewProof),
            ],
            if (booking.paymentStatus == PaymentStatus.uploaded) ...[
              const SizedBox(height: 16),
              _PaymentVerificationActions(
                onVerify: onVerifyPayment,
                onReject: onRejectPayment,
              ),
            ],
            if (booking.paymentRejectionReason != null) ...[
              const SizedBox(height: 16),
              _RejectionReasonBox(reason: booking.paymentRejectionReason!),
            ],
          ],
        ),
      ),
    );
  }
}

class _PaymentStatusInfo extends StatelessWidget {
  final PaymentStatus status;

  const _PaymentStatusInfo({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getBorderColor()),
      ),
      child: Row(
        children: [
          Icon(_getIcon(), color: _getIconColor(), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getTitle(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _getIconColor(),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _getDescription(),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (status) {
      case PaymentStatus.pending:
        return Colors.orange.withValues(alpha: 0.1);
      case PaymentStatus.uploaded:
        return AppColors.info.withValues(alpha: 0.1);
      case PaymentStatus.verified:
        return AppColors.success.withValues(alpha: 0.1);
      case PaymentStatus.rejected:
        return AppColors.error.withValues(alpha: 0.1);
    }
  }

  Color _getBorderColor() {
    switch (status) {
      case PaymentStatus.pending:
        return Colors.orange.withValues(alpha: 0.3);
      case PaymentStatus.uploaded:
        return AppColors.info.withValues(alpha: 0.3);
      case PaymentStatus.verified:
        return AppColors.success.withValues(alpha: 0.3);
      case PaymentStatus.rejected:
        return AppColors.error.withValues(alpha: 0.3);
    }
  }

  Color _getIconColor() {
    switch (status) {
      case PaymentStatus.pending:
        return Colors.orange;
      case PaymentStatus.uploaded:
        return AppColors.info;
      case PaymentStatus.verified:
        return AppColors.success;
      case PaymentStatus.rejected:
        return AppColors.error;
    }
  }

  IconData _getIcon() {
    switch (status) {
      case PaymentStatus.pending:
        return Icons.hourglass_empty_rounded;
      case PaymentStatus.uploaded:
        return Icons.upload_file_rounded;
      case PaymentStatus.verified:
        return Icons.verified_rounded;
      case PaymentStatus.rejected:
        return Icons.cancel_rounded;
    }
  }

  String _getTitle() {
    switch (status) {
      case PaymentStatus.pending:
        return 'Awaiting Payment';
      case PaymentStatus.uploaded:
        return 'Payment Proof Uploaded';
      case PaymentStatus.verified:
        return 'Payment Verified';
      case PaymentStatus.rejected:
        return 'Payment Rejected';
    }
  }

  String _getDescription() {
    switch (status) {
      case PaymentStatus.pending:
        return 'Customer has not yet uploaded payment proof';
      case PaymentStatus.uploaded:
        return 'Review the payment proof and verify or reject';
      case PaymentStatus.verified:
        return 'Payment has been confirmed';
      case PaymentStatus.rejected:
        return 'Payment was rejected, awaiting new proof';
    }
  }
}

class _ViewProofButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _ViewProofButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.receipt_long_outlined, size: 18),
        label: const Text('View Payment Proof'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.info,
          side: BorderSide(color: AppColors.info.withValues(alpha: 0.5)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _PaymentVerificationActions extends StatelessWidget {
  final VoidCallback? onVerify;
  final VoidCallback? onReject;

  const _PaymentVerificationActions({this.onVerify, this.onReject});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onReject,
            icon: const Icon(Icons.close_rounded, size: 18),
            label: const Text('Reject Payment'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: BorderSide(color: AppColors.error.withValues(alpha: 0.5)),
              padding: const EdgeInsets.symmetric(vertical: 14),
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
            label: const Text('Verify Payment'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
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

class _RejectionReasonBox extends StatelessWidget {
  final String reason;

  const _RejectionReasonBox({required this.reason});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.error,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rejection Reason',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reason,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Price breakdown card.
///
/// Updated: 2025-12-13
class OwnerBookingPriceCard extends StatelessWidget {
  final BookingEntity booking;

  const OwnerBookingPriceCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final pricePerHour = booking.totalPrice / booking.durationHours;

    return PremiumCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.receipt_outlined,
                  color: AppColors.accentCyan,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Price Breakdown',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _PriceRow(
              label: 'Price per hour',
              value: '${pricePerHour.toStringAsFixed(0)} ${booking.currency}',
            ),
            const SizedBox(height: 8),
            _PriceRow(
              label: 'Duration',
              value:
                  '${booking.durationHours} hour${booking.durationHours > 1 ? 's' : ''}',
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),
            _PriceRow(
              label: 'Total',
              value:
                  '${booking.totalPrice.toStringAsFixed(0)} ${booking.currency}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 14,
            fontWeight: FontWeight.w700,
            color: isTotal ? AppColors.success : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

/// Notes card.
///
/// Updated: 2025-12-13
class OwnerBookingNotesCard extends StatelessWidget {
  final String notes;

  const OwnerBookingNotesCard({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.notes_rounded,
                  color: AppColors.accentCyan,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Booking Notes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                notes,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.accentCyan.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.accentCyan, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary.withValues(alpha: 0.7),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        if (onTap != null)
          Icon(
            Icons.copy_rounded,
            size: 18,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: content,
      );
    }

    return content;
  }
}
