import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';

class BookingDateTimeCard extends StatelessWidget {
  final BookingEntity booking;

  const BookingDateTimeCard({required this.booking, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(BookingConstants.standardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(BookingConstants.borderRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.dateTimeLabel,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: BookingConstants.standardPadding),
          _DateRow(
            label: context.l10n.bookingDate,
            value: LocaleFormatters.formatDate(context, booking.date),
            icon: Icons.calendar_today,
          ),
          const SizedBox(height: BookingConstants.standardPadding),
          Row(
            children: [
              _DateRow(
                label: context.l10n.timeSlot,
                value: LocaleFormatters.formatTimeRange(
                  context,
                  startTime: booking.startTime,
                  endTime: booking.endTime,
                  baseDate: booking.date,
                ),
                icon: Icons.access_time,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: BookingConstants.itemSpacing,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  context.l10n.durationHours(booking.durationInHours),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DateRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(BookingConstants.smallPadding),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(BookingConstants.smallPadding),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: BookingConstants.itemSpacing),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
