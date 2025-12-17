import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/bookings/domain/entities/payment_status.dart';

/// Badge displaying payment status with appropriate color and icon.
///
/// Used in booking cards and booking details to show payment state.
class PaymentStatusBadge extends StatelessWidget {
  final PaymentStatus status;
  final bool isCompact;

  const PaymentStatusBadge({
    super.key,
    required this.status,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: isCompact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(isCompact ? 6 : 8),
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: isCompact ? 12 : 14, color: _iconColor),
          SizedBox(width: isCompact ? 4 : 6),
          Text(
            status.displayName,
            style: TextStyle(
              fontSize: isCompact ? 10 : 12,
              fontWeight: FontWeight.w600,
              color: _textColor,
            ),
          ),
        ],
      ),
    );
  }

  Color get _backgroundColor {
    switch (status) {
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

  Color get _borderColor {
    switch (status) {
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

  Color get _iconColor {
    switch (status) {
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

  Color get _textColor => _iconColor;

  IconData get _icon {
    switch (status) {
      case PaymentStatus.pending:
        return Icons.schedule_outlined;
      case PaymentStatus.uploaded:
        return Icons.hourglass_top_outlined;
      case PaymentStatus.verified:
        return Icons.check_circle_outline;
      case PaymentStatus.rejected:
        return Icons.cancel_outlined;
    }
  }
}
