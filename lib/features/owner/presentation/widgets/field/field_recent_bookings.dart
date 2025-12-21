import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// Recent bookings section for field detail page.
///
/// Shows the most recent bookings for a specific field.
class FieldRecentBookings extends StatelessWidget {
  final String fieldId;
  final List<BookingEntity> bookings;

  const FieldRecentBookings({
    super.key,
    required this.fieldId,
    required this.bookings,
  });

  @override
  Widget build(BuildContext context) {
    // Filter bookings for this field only
    final fieldBookings = bookings
        .where((booking) => booking.fieldId == fieldId)
        .take(5)
        .toList();

    if (fieldBookings.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.recentBookings,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.event_busy,
                      size: 48,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.noBookingsYet,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.recentBookings,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                context.l10n.countOfTotal(
                  LocaleFormatters.formatNumber(context, fieldBookings.length),
                  LocaleFormatters.formatNumber(context, bookings.length),
                ),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...fieldBookings.map(
            (booking) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _BookingItem(booking: booking),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingItem extends StatelessWidget {
  final BookingEntity booking;

  const _BookingItem({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                booking.userName ?? context.l10n.unknownCustomer,
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              _StatusBadge(status: booking.status),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                DateFormat.yMMMd(context.l10n.localeName).format(booking.date),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.access_time,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                '${booking.startTime} - ${booking.endTime}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            LocaleFormatters.formatPrice(
              context,
              amount: booking.totalPrice,
              currency: context.l10n.currencyEgp,
            ),
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final BookingStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    String statusText;

    switch (status) {
      case BookingStatus.confirmed:
        color = AppColors.success;
        icon = Icons.check_circle;
        statusText = context.l10n.statusConfirmed;
        break;
      case BookingStatus.pending:
        color = AppColors.warning;
        icon = Icons.pending;
        statusText = context.l10n.statusPending;
        break;
      case BookingStatus.canceled:
        color = AppColors.error;
        icon = Icons.cancel;
        statusText = context.l10n.statusCancelled;
        break;
      case BookingStatus.completed:
        color = AppColors.info;
        icon = Icons.done_all;
        statusText = context.l10n.statusCompleted;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            statusText,
            style: AppTextStyles.labelSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
