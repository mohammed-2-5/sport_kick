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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.navyDeep.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.navyDeep.withValues(alpha: 0.08)),
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
          Container(width: 1, height: 40, color: AppColors.border),
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
          Container(width: 1, height: 40, color: AppColors.border),
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
              valueColor: const Color(0xFF10B981),
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
    return Column(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: valueColor ?? AppColors.navyDeep,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
