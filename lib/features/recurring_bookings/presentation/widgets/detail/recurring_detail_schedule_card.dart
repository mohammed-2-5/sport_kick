import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/recurring_bookings/domain/entities/recurring_booking_entity.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/widgets/detail/recurring_detail_card.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// Schedule section for the recurring booking detail view.
class RecurringDetailScheduleCard extends StatelessWidget {
  final RecurringBookingEntity booking;

  const RecurringDetailScheduleCard({required this.booking, super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final successColor = isDark ? AppColors.darkSuccess : AppColors.success;
    return RecurringDetailCard(
      title: context.l10n.scheduleTitle,
      icon: Icons.schedule_rounded,
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.calendar_today_rounded,
            label: context.l10n.dayLabel,
            value: context.l10n.everyDay(
              LocaleFormatters.weekdayName(context, booking.dayOfWeek),
            ),
            color: colorScheme.primary,
          ),
          const Divider(height: 24),
          _InfoRow(
            icon: Icons.access_time_rounded,
            label: context.l10n.timeLabel,
            value: LocaleFormatters.formatTimeRange(
              context,
              startTime: booking.startTime,
              endTime: booking.endTime,
            ),
            color: colorScheme.secondary,
          ),
          const Divider(height: 24),
          _InfoRow(
            icon: Icons.timer_outlined,
            label: context.l10n.durationLabel,
            value: context.l10n.recurringHoursLabel(
              booking.durationHours,
              LocaleFormatters.formatNumber(
                context,
                booking.durationHours,
                decimalDigits: 0,
              ),
            ),
            color: isDark ? Colors.orange[300]! : Colors.orange,
          ),
          const Divider(height: 24),
          _InfoRow(
            icon: Icons.payments_outlined,
            label: context.l10n.weeklyPriceLabel,
            value: LocaleFormatters.formatPrice(
              context,
              amount: booking.pricePerBooking,
              currency: 'EGP',
              decimalDigits: 0,
            ),
            color: successColor,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
