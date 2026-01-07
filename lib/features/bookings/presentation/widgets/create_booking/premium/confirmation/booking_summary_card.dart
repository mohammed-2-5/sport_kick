import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Booking summary card with field and time details.
class BookingSummaryCard extends StatelessWidget {
  final String fieldName;
  final DateTime selectedDate;
  final TimeSlotEntity selectedSlot;
  final int durationHours;

  const BookingSummaryCard({
    super.key,
    required this.fieldName,
    required this.selectedDate,
    required this.selectedSlot,
    required this.durationHours,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    // Use navy gradient for consistent premium design
    const textColor = Colors.white;

    return Container(
      decoration: BoxDecoration(
        gradient: context.navyGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: textColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.sports_soccer,
                        color: textColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fieldName,
                            style: AppTextStyles.titleLarge.copyWith(
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.l10n.footballField,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: textColor.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Divider(color: textColor.withValues(alpha: 0.24), height: 1),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _InfoItem(
                        icon: Icons.calendar_today,
                        label: context.l10n.bookingDate,
                        value: DateFormat(
                          context.l10n.eeeMmmD,
                          locale,
                        ).format(selectedDate),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: textColor.withValues(alpha: 0.24),
                    ),
                    Expanded(
                      child: _InfoItem(
                        icon: Icons.access_time,
                        label: context.l10n.bookingTime,
                        value: selectedSlot.formattedTimeRange,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: textColor.withValues(alpha: 0.24),
                    ),
                    Expanded(
                      child: _InfoItem(
                        icon: Icons.timer_outlined,
                        label: context.l10n.durationLabel,
                        value: context.l10n.durationHours(durationHours),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Info item widget for displaying label and value.
class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    // Use white/light colors for navy gradient background
    const textColor = Colors.white;
    const iconColor = Color(0xFF00D9FF); // Cyan accent for icons

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: textColor.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
