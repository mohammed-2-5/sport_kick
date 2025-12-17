import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Widget for selecting duration (1 or 2 hours) for recurring booking.
class RecurringDurationSelector extends StatelessWidget {
  final int selectedDuration;
  final double pricePerHour;
  final ValueChanged<int> onDurationChanged;

  const RecurringDurationSelector({
    required this.selectedDuration,
    required this.pricePerHour,
    required this.onDurationChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Duration',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.navyDeep,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'How long do you want to play each week?',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _DurationCard(
                hours: 1,
                price: pricePerHour,
                isSelected: selectedDuration == 1,
                onTap: () => onDurationChanged(1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _DurationCard(
                hours: 2,
                price: pricePerHour * 2,
                isSelected: selectedDuration == 2,
                onTap: () => onDurationChanged(2),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DurationCard extends StatelessWidget {
  final int hours;
  final double price;
  final bool isSelected;
  final VoidCallback onTap;

  const _DurationCard({
    required this.hours,
    required this.price,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accentCyan.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.accentCyan : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.accentCyan.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            // Duration icon and text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 20,
                  color: isSelected ? AppColors.accentCyan : AppColors.navyDeep,
                ),
                const SizedBox(width: 8),
                Text(
                  '$hours Hour${hours > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? AppColors.accentCyan
                        : AppColors.navyDeep,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Price
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.accentCyan.withValues(alpha: 0.2)
                    : AppColors.navyDeep.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${price.toStringAsFixed(0)} EGP',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.accentCyan : AppColors.navyDeep,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Per week label
            const Text(
              'per week',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
            // Selection indicator
            if (isSelected) ...[
              const SizedBox(height: 8),
              const Icon(
                Icons.check_circle_rounded,
                size: 20,
                color: AppColors.accentCyan,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
