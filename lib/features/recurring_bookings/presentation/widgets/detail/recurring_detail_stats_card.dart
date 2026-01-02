import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/recurring_bookings/domain/entities/recurring_booking_entity.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/widgets/detail/recurring_detail_card.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// Statistics section for the recurring booking detail view.
class RecurringDetailStatsCard extends StatelessWidget {
  final RecurringBookingEntity booking;

  const RecurringDetailStatsCard({required this.booking, super.key});

  @override
  Widget build(BuildContext context) {
    final progress = booking.totalBookingsCount > 0
        ? booking.completedBookingsCount / booking.totalBookingsCount
        : 0.0;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final successColor = isDark ? AppColors.darkSuccess : AppColors.success;

    return RecurringDetailCard(
      title: context.l10n.statistics,
      icon: Icons.bar_chart_rounded,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                value: LocaleFormatters.formatNumber(
                  context,
                  booking.totalBookingsCount,
                  decimalDigits: 0,
                ),
                label: context.l10n.totalLabel,
                color: colorScheme.primary,
              ),
              _StatItem(
                value: LocaleFormatters.formatNumber(
                  context,
                  booking.completedBookingsCount,
                  decimalDigits: 0,
                ),
                label: context.l10n.completedLabel,
                color: successColor,
              ),
              _StatItem(
                value: LocaleFormatters.formatNumber(
                  context,
                  booking.totalBookingsCount - booking.completedBookingsCount,
                  decimalDigits: 0,
                ),
                label: context.l10n.upcomingLabel,
                color: colorScheme.tertiary,
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(successColor),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.progressCompleted(
              LocaleFormatters.formatNumber(
                context,
                (progress * 100).round(),
                decimalDigits: 0,
              ),
            ),
            style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
