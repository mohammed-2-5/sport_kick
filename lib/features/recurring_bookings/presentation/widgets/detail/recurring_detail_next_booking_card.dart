import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/recurring_bookings/domain/entities/recurring_booking_entity.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// Card showing the next upcoming booking for a subscription.
class RecurringDetailNextBookingCard extends StatelessWidget {
  final RecurringBookingEntity booking;

  const RecurringDetailNextBookingCard({required this.booking, super.key});

  @override
  Widget build(BuildContext context) {
    final isPaid = booking.nextBookingPaid ?? false;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successColor = isDark ? AppColors.darkSuccess : AppColors.success;
    final successColorDark = isDark
        ? const Color(0xFF059669)
        : const Color(0xFF047857);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPaid
              ? [successColor, successColorDark]
              : [
                  AppColors.goldAccent,
                  AppColors.goldAccent.withValues(alpha: 0.8),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isPaid ? successColor : AppColors.goldAccent).withValues(
              alpha: 0.3,
            ),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isPaid ? Icons.check_circle_rounded : Icons.payment_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.nextBooking,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  LocaleFormatters.formatDate(
                    context,
                    booking.nextBookingDate!,
                    pattern: 'EEEE, MMM d, y',
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              isPaid ? '✓ ${context.l10n.paidLabel}' : context.l10n.payNow,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isPaid ? successColor : AppColors.goldAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
