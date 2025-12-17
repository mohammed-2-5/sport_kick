import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Duration selector widget for manual booking.
///
/// Allows selection between 1 hour or 2 hours booking duration.
/// Displays as two option cards in a row.
class DurationSelector extends StatelessWidget {
  final int selectedDuration;
  final ValueChanged<int> onDurationChanged;

  const DurationSelector({
    required this.selectedDuration,
    required this.onDurationChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DurationOptionCard(
            duration: 1,
            label: '1 Hour',
            isSelected: selectedDuration == 1,
            onTap: () => onDurationChanged(1),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _DurationOptionCard(
            duration: 2,
            label: '2 Hours',
            isSelected: selectedDuration == 2,
            onTap: () => onDurationChanged(2),
          ),
        ),
      ],
    );
  }
}

/// Individual duration option card.
class _DurationOptionCard extends StatelessWidget {
  final int duration;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DurationOptionCard({
    required this.duration,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.navyDeep.withValues(alpha: 0.1)
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? AppColors.navyDeep
                : Colors.grey.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.navyDeep : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.navyDeep : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
