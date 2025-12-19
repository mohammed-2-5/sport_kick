import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/payment_status.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking/payment_status_badge.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// Payment status and proof card.
///
/// Updated: 2025-12-19
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
                Text(
                  context.l10n.paymentInformation,
                  style: AppTextStyles.bodyLarge.copyWith(
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
                  _getTitle(context),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _getIconColor(),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _getDescription(context),
                  style: AppTextStyles.labelSmall.copyWith(
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

  String _getTitle(BuildContext context) {
    switch (status) {
      case PaymentStatus.pending:
        return context.l10n.paymentStatusPendingTitle;
      case PaymentStatus.uploaded:
        return context.l10n.paymentProofUploadedTitle;
      case PaymentStatus.verified:
        return context.l10n.paymentVerifiedTitle;
      case PaymentStatus.rejected:
        return context.l10n.paymentRejectedTitle;
    }
  }

  String _getDescription(BuildContext context) {
    switch (status) {
      case PaymentStatus.pending:
        return context.l10n.paymentStatusPendingDesc;
      case PaymentStatus.uploaded:
        return context.l10n.paymentProofUploadedDesc;
      case PaymentStatus.verified:
        return context.l10n.paymentVerifiedDesc;
      case PaymentStatus.rejected:
        return context.l10n.paymentRejectedDesc;
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
        label: Text(context.l10n.viewPaymentProof),
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
            label: Text(context.l10n.ownerRejectPayment),
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
            label: Text(context.l10n.ownerVerifyPayment),
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
                Text(
                  context.l10n.rejectionReason,
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reason,
                  style: AppTextStyles.bodySmall.copyWith(
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
