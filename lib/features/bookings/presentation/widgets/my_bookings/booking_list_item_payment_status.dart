import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/bookings/domain/entities/payment_status.dart';

/// Payment status badge widget for booking list items.
///
/// Displays the current payment status with appropriate
/// icon, color, and action button when needed.
class BookingListItemPaymentStatus extends StatelessWidget {
  final PaymentStatus paymentStatus;
  final bool hasPaymentProof;
  final VoidCallback? onPayNowPressed;
  final VoidCallback? onViewProofPressed;

  const BookingListItemPaymentStatus({
    super.key,
    required this.paymentStatus,
    required this.hasPaymentProof,
    this.onPayNowPressed,
    this.onViewProofPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getBorderColor()),
      ),
      child: Row(
        children: [
          _PaymentStatusIcon(paymentStatus: paymentStatus),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.paymentStatusLabel,
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _statusLabel(context),
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _getTextColor(),
                  ),
                ),
              ],
            ),
          ),
          _PaymentActionButton(
            paymentStatus: paymentStatus,
            hasPaymentProof: hasPaymentProof,
            onPayNowPressed: onPayNowPressed,
            onViewProofPressed: onViewProofPressed,
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (paymentStatus) {
      case PaymentStatus.pending:
        return AppColors.warning.withValues(alpha: 0.1);
      case PaymentStatus.uploaded:
        return AppColors.info.withValues(alpha: 0.1);
      case PaymentStatus.verified:
        return AppColors.success.withValues(alpha: 0.1);
      case PaymentStatus.rejected:
        return AppColors.error.withValues(alpha: 0.1);
    }
  }

  Color _getBorderColor() {
    switch (paymentStatus) {
      case PaymentStatus.pending:
        return AppColors.warning.withValues(alpha: 0.3);
      case PaymentStatus.uploaded:
        return AppColors.info.withValues(alpha: 0.3);
      case PaymentStatus.verified:
        return AppColors.success.withValues(alpha: 0.3);
      case PaymentStatus.rejected:
        return AppColors.error.withValues(alpha: 0.3);
    }
  }

  Color _getTextColor() {
    switch (paymentStatus) {
      case PaymentStatus.pending:
        return AppColors.warning;
      case PaymentStatus.uploaded:
        return AppColors.info;
      case PaymentStatus.verified:
        return AppColors.success;
      case PaymentStatus.rejected:
        return AppColors.error;
    }
  }

  String _statusLabel(BuildContext context) {
    final l10n = context.l10n;
    switch (paymentStatus) {
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

/// Payment status icon widget.
class _PaymentStatusIcon extends StatelessWidget {
  final PaymentStatus paymentStatus;

  const _PaymentStatusIcon({required this.paymentStatus});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _getIconBackgroundColor(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(_getIcon(), size: 20, color: Colors.white),
    );
  }

  IconData _getIcon() {
    switch (paymentStatus) {
      case PaymentStatus.pending:
        return Icons.schedule;
      case PaymentStatus.uploaded:
        return Icons.hourglass_empty;
      case PaymentStatus.verified:
        return Icons.check_circle;
      case PaymentStatus.rejected:
        return Icons.cancel;
    }
  }

  Color _getIconBackgroundColor() {
    switch (paymentStatus) {
      case PaymentStatus.pending:
        return AppColors.warning;
      case PaymentStatus.uploaded:
        return AppColors.info;
      case PaymentStatus.verified:
        return AppColors.success;
      case PaymentStatus.rejected:
        return AppColors.error;
    }
  }
}

/// Payment action button widget.
class _PaymentActionButton extends StatelessWidget {
  final PaymentStatus paymentStatus;
  final bool hasPaymentProof;
  final VoidCallback? onPayNowPressed;
  final VoidCallback? onViewProofPressed;

  const _PaymentActionButton({
    required this.paymentStatus,
    required this.hasPaymentProof,
    this.onPayNowPressed,
    this.onViewProofPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (paymentStatus == PaymentStatus.verified) {
      return const SizedBox.shrink();
    }

    if (paymentStatus.needsUserAction) {
      return _ActionButton(
        label: context.l10n.payNow,
        icon: Icons.payment,
        color: AppColors.primary,
        onPressed: onPayNowPressed,
      );
    }

    if (hasPaymentProof) {
      return _ActionButton(
        label: context.l10n.view,
        icon: Icons.visibility,
        color: AppColors.info,
        onPressed: onViewProofPressed,
      );
    }

    return const SizedBox.shrink();
  }
}

/// Generic action button widget.
class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: Icon(icon, size: 16),
      label: Text(
        label,
        style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
