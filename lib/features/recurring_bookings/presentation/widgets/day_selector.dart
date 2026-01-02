import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final days = List.generate(
      7,
      (index) => (
        index: index,
        short: LocaleFormatters.weekdayName(context, index, short: true),
        full: LocaleFormatters.weekdayName(context, index),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.selectDay,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.selectDaySubtitle,
          style: AppTextStyles.labelMedium.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: days.map((day) {
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
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 56,
        decoration: BoxDecoration(
          color: _backgroundColor(colorScheme),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _borderColor(colorScheme),
            width: isSelected ? 2 : 1,
          ),
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
              style: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: _textColor(colorScheme),
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

  Color _backgroundColor(ColorScheme colorScheme) {
    if (isDisabled) return colorScheme.onSurface.withValues(alpha: 0.05);
    if (isSelected) return AppColors.accentCyan.withValues(alpha: 0.1);
    return colorScheme.surface;
  }

  Color _borderColor(ColorScheme colorScheme) {
    if (isDisabled) return colorScheme.onSurface.withValues(alpha: 0.12);
    if (isSelected) return AppColors.accentCyan;
    return colorScheme.outline.withValues(alpha: 0.3);
  }

  Color _textColor(ColorScheme colorScheme) {
    if (isDisabled) return colorScheme.onSurface.withValues(alpha: 0.38);
    if (isSelected) return AppColors.accentCyan;
    return colorScheme.onSurface;
  }
}
