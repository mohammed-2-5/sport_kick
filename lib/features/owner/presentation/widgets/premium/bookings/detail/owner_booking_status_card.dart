import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// Status card showing booking status with gradient.
///
/// Updated: 2025-12-19
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
                    context.l10n.bookingStatus,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _statusLabel(context, booking.status),
                    style: AppTextStyles.titleMedium.copyWith(
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

  String _statusLabel(BuildContext context, BookingStatus status) {
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
        _label(context).toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
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

  String _label(BuildContext context) {
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
