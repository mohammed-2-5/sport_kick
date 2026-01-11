import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/owner/presentation/models/business_hours_models.dart';

class BusinessHoursTimeSlotRow extends StatelessWidget {
  final TimeSlotRange slot;
  final ValueChanged<TimeSlotRange> onUpdate;
  final VoidCallback onRemove;

  const BusinessHoursTimeSlotRow({
    super.key,
    required this.slot,
    required this.onUpdate,
    required this.onRemove,
  });

  Future<void> _pickTime(BuildContext context, bool isStart) async {
    final currentTime = isStart ? slot.start : slot.end;
    final parts = currentTime.split(':');
    final initialTime = TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      final formattedTime =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      onUpdate(
        isStart
            ? TimeSlotRange(start: formattedTime, end: slot.end)
            : TimeSlotRange(start: slot.start, end: formattedTime),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        // Start time
        Expanded(
          child: InkWell(
            onTap: () => _pickTime(context, true),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    slot.start,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Icon(
            Icons.arrow_forward,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        // End time
        Expanded(
          child: InkWell(
            onTap: () => _pickTime(context, false),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    slot.end,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Remove button
        const SizedBox(width: 8),
        InkWell(
          onTap: onRemove,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.error.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorScheme.error.withValues(alpha: 0.2),
              ),
            ),
            child: Icon(
              Icons.delete_outline,
              size: 16,
              color: colorScheme.error,
            ),
          ),
        ),
      ],
    );
  }
}
