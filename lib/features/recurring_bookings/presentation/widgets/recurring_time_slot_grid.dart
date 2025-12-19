import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/business_hours/domain/entities/business_hours_entity.dart';
import 'package:spo_kick/features/recurring_bookings/domain/repositories/recurring_booking_repository.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// Grid widget for selecting time slots for recurring booking.
class RecurringTimeSlotGrid extends StatelessWidget {
  final int? selectedDayOfWeek;
  final String? selectedTime;
  final int durationHours;
  final List<BusinessHoursEntity> businessHours;
  final List<ReservedSlot> reservedSlots;
  final ValueChanged<String> onTimeSelected;

  const RecurringTimeSlotGrid({
    required this.selectedDayOfWeek,
    required this.selectedTime,
    required this.durationHours,
    required this.businessHours,
    required this.reservedSlots,
    required this.onTimeSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedDayOfWeek == null) {
      return _buildSelectDayPrompt(context);
    }

    final dayBusinessHours = _getBusinessHoursForDay();
    if (dayBusinessHours == null || !dayBusinessHours.isOpen) {
      return _buildClosedMessage(context);
    }

    final slots = _generateTimeSlots(dayBusinessHours);
    if (slots.isEmpty) {
      return _buildNoSlotsMessage(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.selectTime,
          style: AppTextStyles.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.navyDeep,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.availableSlotsForDay(_getDayName(context)),
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 2.0,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: slots.length,
          itemBuilder: (context, index) {
            final slot = slots[index];
            return _TimeSlotChip(
              time: slot.time,
              isSelected: selectedTime == slot.time,
              isReserved: slot.isReserved,
              reservedBy: slot.reservedBy,
              onTap: slot.isReserved ? null : () => onTimeSelected(slot.time),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSelectDayPrompt(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.navyDeep.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.navyDeep.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.touch_app_rounded,
            size: 48,
            color: AppColors.navyDeep.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.selectDayFirst,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClosedMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const Icon(Icons.block_rounded, size: 48, color: AppColors.error),
          const SizedBox(height: 12),
          Text(
            context.l10n.fieldClosedOnDay(_getDayName(context)),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.selectDifferentDay,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSlotsMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.goldAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.goldAccent.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.event_busy_rounded,
            size: 48,
            color: AppColors.goldAccent,
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.noAvailableSlots,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.goldAccent,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getDayName(BuildContext context) {
    if (selectedDayOfWeek == null) return '';
    return LocaleFormatters.weekdayName(context, selectedDayOfWeek!);
  }

  BusinessHoursEntity? _getBusinessHoursForDay() {
    if (selectedDayOfWeek == null) return null;
    try {
      return businessHours.firstWhere(
        (bh) => bh.dayOfWeek == selectedDayOfWeek,
      );
    } catch (_) {
      return null;
    }
  }

  List<_SlotInfo> _generateTimeSlots(BusinessHoursEntity bh) {
    final slots = <_SlotInfo>[];
    if (bh.openingTime == null || bh.closingTime == null) return slots;
    final openHour = int.parse(bh.openingTime!.split(':')[0]);
    final closeHour = int.parse(bh.closingTime!.split(':')[0]);

    // Account for duration - don't show slots that would end after closing
    final lastSlotHour = closeHour - durationHours;

    for (int hour = openHour; hour <= lastSlotHour; hour++) {
      final time = '${hour.toString().padLeft(2, '0')}:00';
      final isReserved = _isSlotReserved(time);
      final reservedBy = _getReservedBy(time);

      slots.add(
        _SlotInfo(time: time, isReserved: isReserved, reservedBy: reservedBy),
      );
    }

    return slots;
  }

  bool _isSlotReserved(String time) {
    if (selectedDayOfWeek == null) return false;

    final timeHour = int.parse(time.split(':')[0]);

    return reservedSlots.any((slot) {
      if (slot.dayOfWeek != selectedDayOfWeek) return false;
      final startHour = int.parse(slot.startTime.split(':')[0]);
      final endHour = int.parse(slot.endTime.split(':')[0]);
      return timeHour >= startHour && timeHour < endHour;
    });
  }

  String? _getReservedBy(String time) {
    if (selectedDayOfWeek == null) return null;

    final timeHour = int.parse(time.split(':')[0]);

    for (final slot in reservedSlots) {
      if (slot.dayOfWeek != selectedDayOfWeek) continue;
      final startHour = int.parse(slot.startTime.split(':')[0]);
      final endHour = int.parse(slot.endTime.split(':')[0]);
      if (timeHour >= startHour && timeHour < endHour) {
        return slot.userName;
      }
    }
    return null;
  }
}

class _SlotInfo {
  final String time;
  final bool isReserved;
  final String? reservedBy;

  const _SlotInfo({
    required this.time,
    required this.isReserved,
    this.reservedBy,
  });
}

class _TimeSlotChip extends StatelessWidget {
  final String time;
  final bool isSelected;
  final bool isReserved;
  final String? reservedBy;
  final VoidCallback? onTap;

  const _TimeSlotChip({
    required this.time,
    required this.isSelected,
    required this.isReserved,
    this.reservedBy,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayTime = LocaleFormatters.formatTime(context, time);
    final reservedTooltip = isReserved
        ? context.l10n.reservedBy(
            reservedBy ?? context.l10n.reservedByAnotherUser,
          )
        : '';

    return Tooltip(
      message: reservedTooltip,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _borderColor, width: isSelected ? 2 : 1),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.accentCyan.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  displayTime,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _textColor,
                  ),
                ),
              ),
              if (isReserved)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color get _backgroundColor {
    if (isReserved) return AppColors.error.withValues(alpha: 0.1);
    if (isSelected) return AppColors.accentCyan.withValues(alpha: 0.1);
    return Colors.white;
  }

  Color get _borderColor {
    if (isReserved) return AppColors.error.withValues(alpha: 0.3);
    if (isSelected) return AppColors.accentCyan;
    return AppColors.border;
  }

  Color get _textColor {
    if (isReserved) return AppColors.error.withValues(alpha: 0.7);
    if (isSelected) return AppColors.accentCyan;
    return AppColors.navyDeep;
  }
}
