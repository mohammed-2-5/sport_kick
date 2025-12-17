import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Widget for selecting a day of the week for recurring booking.
class DaySelector extends StatelessWidget {
  final int? selectedDay;
  final ValueChanged<int> onDaySelected;
  final Set<int>? disabledDays;

  const DaySelector({
    required this.selectedDay,
    required this.onDaySelected,
    this.disabledDays,
    super.key,
  });

  static const _days = [
    (index: 0, short: 'Sat', full: 'Saturday'),
    (index: 1, short: 'Sun', full: 'Sunday'),
    (index: 2, short: 'Mon', full: 'Monday'),
    (index: 3, short: 'Tue', full: 'Tuesday'),
    (index: 4, short: 'Wed', full: 'Wednesday'),
    (index: 5, short: 'Thu', full: 'Thursday'),
    (index: 6, short: 'Fri', full: 'Friday'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Day',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.navyDeep,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Choose the day you want to reserve every week',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _days.map((day) {
            final isSelected = selectedDay == day.index;
            final isDisabled = disabledDays?.contains(day.index) ?? false;

            return _DayChip(
              shortName: day.short,
              isSelected: isSelected,
              isDisabled: isDisabled,
              onTap: isDisabled ? null : () => onDaySelected(day.index),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _DayChip extends StatelessWidget {
  final String shortName;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback? onTap;

  const _DayChip({
    required this.shortName,
    required this.isSelected,
    required this.isDisabled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 56,
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderColor, width: isSelected ? 2 : 1),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.accentCyan.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              shortName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.accentCyan,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color get _backgroundColor {
    if (isDisabled) return AppColors.textSecondary.withValues(alpha: 0.1);
    if (isSelected) return AppColors.accentCyan.withValues(alpha: 0.1);
    return Colors.white;
  }

  Color get _borderColor {
    if (isDisabled) return AppColors.textSecondary.withValues(alpha: 0.2);
    if (isSelected) return AppColors.accentCyan;
    return AppColors.border;
  }

  Color get _textColor {
    if (isDisabled) return AppColors.textSecondary.withValues(alpha: 0.5);
    if (isSelected) return AppColors.accentCyan;
    return AppColors.navyDeep;
  }
}
