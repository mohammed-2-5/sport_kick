import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/owner/presentation/models/business_hours_models.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/components/business_hours_time_slot_row.dart';

class BusinessHoursDayCard extends StatelessWidget {
  final DaySchedule schedule;
  final VoidCallback onToggleDay;
  final VoidCallback onAddTimeSlot;
  final ValueChanged<int> onRemoveTimeSlot;
  final void Function(int, TimeSlotRange) onUpdateTimeSlot;

  const BusinessHoursDayCard({
    super.key,
    required this.schedule,
    required this.onToggleDay,
    required this.onAddTimeSlot,
    required this.onRemoveTimeSlot,
    required this.onUpdateTimeSlot,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: schedule.isOpen
              ? colorScheme.secondary.withValues(alpha: 0.3)
              : colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day header
          Row(
            children: [
              Expanded(
                child: Text(
                  schedule.day,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Switch(
                value: schedule.isOpen,
                onChanged: (_) {
                  HapticFeedback.selectionClick();
                  onToggleDay();
                },
                activeThumbColor: colorScheme.secondary,
                activeTrackColor: colorScheme.secondary.withValues(alpha: 0.5),
              ),
            ],
          ),
          // Time slots
          if (schedule.isOpen) ...[
            const SizedBox(height: 12),
            ...schedule.timeSlots.asMap().entries.map((entry) {
              final index = entry.key;
              final slot = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: BusinessHoursTimeSlotRow(
                  slot: slot,
                  onUpdate: (newSlot) => onUpdateTimeSlot(index, newSlot),
                  onRemove: () => onRemoveTimeSlot(index),
                ),
              );
            }),
            // Add slot button
            InkWell(
              onTap: onAddTimeSlot,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colorScheme.secondary.withValues(alpha: 0.2),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 16, color: colorScheme.secondary),
                    const SizedBox(width: 6),
                    Text(
                      context.l10n.addTimeSlot,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            const SizedBox(height: 4),
            Text(
              context.l10n.closed,
              style: AppTextStyles.bodySmall.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
