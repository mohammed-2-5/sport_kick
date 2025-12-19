import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/recurring_bookings/domain/entities/recurring_booking_entity.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// Badge widget for displaying recurring booking status.
class RecurringStatusBadge extends StatelessWidget {
  final RecurringBookingStatus status;
  final bool isCompact;

  const RecurringStatusBadge({
    required this.status,
    this.isCompact = false,
    super.key,
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: isCompact ? 12 : 14, color: _iconColor),
          SizedBox(width: isCompact ? 4 : 6),
          Text(
            _label(context),
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
      case RecurringBookingStatus.active:
        return const Color(0xFF10B981).withValues(alpha: 0.1);
      case RecurringBookingStatus.pendingApproval:
        return AppColors.goldAccent.withValues(alpha: 0.1);
      case RecurringBookingStatus.canceled:
        return AppColors.error.withValues(alpha: 0.1);
      case RecurringBookingStatus.rejected:
        return AppColors.error.withValues(alpha: 0.1);
    }
  }

  Color get _borderColor {
    switch (status) {
      case RecurringBookingStatus.active:
        return const Color(0xFF10B981).withValues(alpha: 0.3);
      case RecurringBookingStatus.pendingApproval:
        return AppColors.goldAccent.withValues(alpha: 0.3);
      case RecurringBookingStatus.canceled:
        return AppColors.error.withValues(alpha: 0.3);
      case RecurringBookingStatus.rejected:
        return AppColors.error.withValues(alpha: 0.3);
    }
  }

  Color get _iconColor {
    switch (status) {
      case RecurringBookingStatus.active:
        return const Color(0xFF10B981);
      case RecurringBookingStatus.pendingApproval:
        return AppColors.goldAccent;
      case RecurringBookingStatus.canceled:
        return AppColors.error;
      case RecurringBookingStatus.rejected:
        return AppColors.error;
    }
  }

  Color get _textColor => _iconColor;

  IconData get _icon {
    switch (status) {
      case RecurringBookingStatus.active:
        return Icons.autorenew_rounded;
      case RecurringBookingStatus.pendingApproval:
        return Icons.hourglass_empty_rounded;
      case RecurringBookingStatus.canceled:
        return Icons.cancel_outlined;
      case RecurringBookingStatus.rejected:
        return Icons.block_rounded;
    }
  }

  String _label(BuildContext context) {
    switch (status) {
      case RecurringBookingStatus.active:
        return context.l10n.statusActive;
      case RecurringBookingStatus.pendingApproval:
        return context.l10n.statusPendingApproval;
      case RecurringBookingStatus.canceled:
        return context.l10n.statusCanceled;
      case RecurringBookingStatus.rejected:
        return context.l10n.statusRejected;
    }
  }
}
