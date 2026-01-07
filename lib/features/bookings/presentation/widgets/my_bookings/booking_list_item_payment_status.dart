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
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = _getStatusColor(isDark);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
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
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _statusLabel(context),
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: statusColor,
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

  Color _getStatusColor(bool isDark) {
    switch (paymentStatus) {
      case PaymentStatus.pending:
        return isDark ? AppColors.darkWarning : AppColors.warning;
      case PaymentStatus.uploaded:
        return isDark ? AppColors.darkInfo : AppColors.info;
      case PaymentStatus.verified:
        return isDark ? AppColors.darkSuccess : AppColors.success;
      case PaymentStatus.rejected:
        return isDark ? AppColors.darkError : AppColors.error;
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _getIconBackgroundColor(isDark),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(_getIcon(), size: 20, color: colorScheme.onPrimary),
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

  Color _getIconBackgroundColor(bool isDark) {
    switch (paymentStatus) {
      case PaymentStatus.pending:
        return isDark ? AppColors.darkWarning : AppColors.warning;
      case PaymentStatus.uploaded:
        return isDark ? AppColors.darkInfo : AppColors.info;
      case PaymentStatus.verified:
        return isDark ? AppColors.darkSuccess : AppColors.success;
      case PaymentStatus.rejected:
        return isDark ? AppColors.darkError : AppColors.error;
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
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final infoColor = isDark ? AppColors.darkInfo : AppColors.info;

    if (paymentStatus == PaymentStatus.verified) {
      return const SizedBox.shrink();
    }

    if (paymentStatus.needsUserAction) {
      return _ActionButton(
        label: context.l10n.payNow,
        icon: Icons.payment,
        color: colorScheme.primary,
        onPressed: onPayNowPressed,
      );
    }

    if (hasPaymentProof) {
      return _ActionButton(
        label: context.l10n.view,
        icon: Icons.visibility,
        color: infoColor,
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
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
