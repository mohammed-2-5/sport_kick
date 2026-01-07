import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/presentation/extensions/booking_status_ui_extension.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// Header for the booking card displaying status and field name.
class BookingCardHeader extends StatelessWidget {
  final BookingEntity booking;

  const BookingCardHeader({required this.booking, super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = booking.status.getColor(isDark: isDark);
    final statusGradient = booking.status.getGradient(isDark: isDark);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: statusGradient,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.onPrimary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              booking.status.icon,
              color: colorScheme.onPrimary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _statusLabel(context, booking.status).toUpperCase(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onPrimary,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  booking.fieldName ?? context.l10n.unknownField,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colorScheme.onPrimary.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              context.l10n.bookingShortId(
                booking.id.substring(0, 6).toUpperCase(),
              ),
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: statusColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
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
