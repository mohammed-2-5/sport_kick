import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/owner/presentation/models/business_hours_models.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/components/business_hours_day_card.dart';

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
          context.l10n.businessHours,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        ...schedule.map((daySchedule) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: BusinessHoursDayCard(
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
