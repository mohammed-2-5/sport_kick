import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
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
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.7,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _statusLabel(context, booking.status),
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: _getStatusColor(context, booking.status),
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

  Color _getStatusColor(BuildContext context, BookingStatus status) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return colorScheme.success;
      case BookingStatus.canceled:
        return colorScheme.error;
      case BookingStatus.completed:
        return colorScheme.info;
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
    final gradientColors = _getGradientColors(context);
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(_getIcon(), color: Colors.white, size: 28),
    );
  }

  List<Color> _getGradientColors(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case BookingStatus.pending:
        return [Colors.orange, Colors.deepOrange];
      case BookingStatus.confirmed:
        return [colorScheme.success, Colors.green.shade700];
      case BookingStatus.canceled:
        return [colorScheme.error, Colors.red.shade700];
      case BookingStatus.completed:
        return [colorScheme.info, Colors.blue.shade700];
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
    final statusColor = _getColor(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        _label(context).toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          fontWeight: FontWeight.w700,
          color: statusColor,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Color _getColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return colorScheme.success;
      case BookingStatus.canceled:
        return colorScheme.error;
      case BookingStatus.completed:
        return colorScheme.info;
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
