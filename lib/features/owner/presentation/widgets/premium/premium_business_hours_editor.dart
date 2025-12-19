import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Premium business hours editor.
///
/// Features:
/// - Day of week toggles
/// - Time range pickers
/// - Add/remove time slots
/// - Clean white cards
class PremiumBusinessHoursEditor extends StatelessWidget {
  final List<DaySchedule> schedule;
  final ValueChanged<List<DaySchedule>> onChanged;

  const PremiumBusinessHoursEditor({
    super.key,
    required this.schedule,
    required this.onChanged,
  });

  void _toggleDay(String day) {
    final updated = List<DaySchedule>.from(schedule);
    final index = updated.indexWhere((s) => s.day == day);
    if (index != -1) {
      updated[index] = DaySchedule(
        day: day,
        isOpen: !updated[index].isOpen,
        timeSlots: updated[index].timeSlots,
      );
      onChanged(updated);
    }
  }

  void _addTimeSlot(String day) {
    final updated = List<DaySchedule>.from(schedule);
    final index = updated.indexWhere((s) => s.day == day);
    if (index != -1) {
      final slots = List<TimeSlotRange>.from(updated[index].timeSlots);
      slots.add(const TimeSlotRange(start: '09:00', end: '17:00'));
      updated[index] = DaySchedule(
        day: day,
        isOpen: updated[index].isOpen,
        timeSlots: slots,
      );
      onChanged(updated);
    }
  }

  void _removeTimeSlot(String day, int slotIndex) {
    final updated = List<DaySchedule>.from(schedule);
    final index = updated.indexWhere((s) => s.day == day);
    if (index != -1) {
      final slots = List<TimeSlotRange>.from(updated[index].timeSlots);
      slots.removeAt(slotIndex);
      updated[index] = DaySchedule(
        day: day,
        isOpen: updated[index].isOpen,
        timeSlots: slots,
      );
      onChanged(updated);
    }
  }

  void _updateTimeSlot(String day, int slotIndex, TimeSlotRange newSlot) {
    final updated = List<DaySchedule>.from(schedule);
    final index = updated.indexWhere((s) => s.day == day);
    if (index != -1) {
      final slots = List<TimeSlotRange>.from(updated[index].timeSlots);
      slots[slotIndex] = newSlot;
      updated[index] = DaySchedule(
        day: day,
        isOpen: updated[index].isOpen,
        timeSlots: slots,
      );
      onChanged(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Hours',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...schedule.map((daySchedule) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _DayScheduleCard(
              schedule: daySchedule,
              onToggleDay: () => _toggleDay(daySchedule.day),
              onAddTimeSlot: () => _addTimeSlot(daySchedule.day),
              onRemoveTimeSlot: (index) =>
                  _removeTimeSlot(daySchedule.day, index),
              onUpdateTimeSlot: (index, slot) =>
                  _updateTimeSlot(daySchedule.day, index, slot),
            ),
          );
        }),
      ],
    );
  }
}

/// Day schedule data model.
class DaySchedule {
  final String day;
  final bool isOpen;
  final List<TimeSlotRange> timeSlots;

  const DaySchedule({
    required this.day,
    required this.isOpen,
    required this.timeSlots,
  });
}

/// Time slot range data model.
class TimeSlotRange {
  final String start;
  final String end;

  const TimeSlotRange({required this.start, required this.end});
}

/// Day schedule card.
class _DayScheduleCard extends StatelessWidget {
  final DaySchedule schedule;
  final VoidCallback onToggleDay;
  final VoidCallback onAddTimeSlot;
  final ValueChanged<int> onRemoveTimeSlot;
  final void Function(int, TimeSlotRange) onUpdateTimeSlot;

  const _DayScheduleCard({
    required this.schedule,
    required this.onToggleDay,
    required this.onAddTimeSlot,
    required this.onRemoveTimeSlot,
    required this.onUpdateTimeSlot,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: schedule.isOpen
              ? AppColors.accentCyan.withValues(alpha: 0.3)
              : AppColors.border,
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
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Switch(
                value: schedule.isOpen,
                onChanged: (_) {
                  HapticFeedback.selectionClick();
                  onToggleDay();
                },
                activeThumbColor: AppColors.accentCyan,
                activeTrackColor: AppColors.accentCyan.withValues(alpha: 0.5),
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
                child: _TimeSlotRow(
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
                  color: AppColors.accentCyan.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.accentCyan.withValues(alpha: 0.2),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.add,
                      size: 16,
                      color: AppColors.accentCyan,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Add Time Slot',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentCyan,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            const SizedBox(height: 4),
            Text(
              'Closed',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary.withValues(alpha: 0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Time slot row with start/end pickers.
class _TimeSlotRow extends StatelessWidget {
  final TimeSlotRange slot;
  final ValueChanged<TimeSlotRange> onUpdate;
  final VoidCallback onRemove;

  const _TimeSlotRow({
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
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    slot.start,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(
            Icons.arrow_forward,
            size: 16,
            color: AppColors.textSecondary,
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
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    slot.end,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
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
              color: Colors.red.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
            ),
            child: const Icon(
              Icons.delete_outline,
              size: 16,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
