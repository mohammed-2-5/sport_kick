import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/recurring_bookings/domain/entities/recurring_booking_entity.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// Subscription details section for active subscription card.
class RecurringActiveSubscriptionDetails extends StatelessWidget {
  final RecurringBookingEntity subscription;

  const RecurringActiveSubscriptionDetails({
    required this.subscription,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final successColor = isDark ? AppColors.darkSuccess : AppColors.success;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _DetailItem(
              icon: Icons.calendar_today_rounded,
              label: context.l10n.everyLabel,
              value: LocaleFormatters.weekdayName(
                context,
                subscription.dayOfWeek,
              ),
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
          Expanded(
            child: _DetailItem(
              icon: Icons.access_time_rounded,
              label: context.l10n.timeLabel,
              value: LocaleFormatters.formatTimeRange(
                context,
                startTime: subscription.startTime,
                endTime: subscription.endTime,
              ),
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
          Expanded(
            child: _DetailItem(
              icon: Icons.payments_outlined,
              label: context.l10n.weeklyLabel,
              value: LocaleFormatters.formatPrice(
                context,
                amount: subscription.pricePerBooking,
                currency: 'EGP',
                decimalDigits: 0,
              ),
              valueColor: successColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: valueColor ?? colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
