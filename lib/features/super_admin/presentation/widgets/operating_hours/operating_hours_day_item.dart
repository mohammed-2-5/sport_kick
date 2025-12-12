import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/super_admin/domain/entities/day_hours_entity.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_settings_entity.dart';

/// Operating Hours Day Item Widget
///
/// Displays and allows editing of operating hours for a single day.
class OperatingHoursDayItem extends StatelessWidget {
  final DayOfWeek day;
  final DayHoursEntity hours;
  final ValueChanged<bool> onToggleOpen;
  final ValueChanged<String> onOpenTimeChanged;
  final ValueChanged<String> onCloseTimeChanged;

  const OperatingHoursDayItem({
    super.key,
    required this.day,
    required this.hours,
    required this.onToggleOpen,
    required this.onOpenTimeChanged,
    required this.onCloseTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _DayLabel(day: day),
            const SizedBox(width: 16),
            Expanded(
              child: hours.isOpen
                  ? _TimeSelectors(
                      hours: hours,
                      onOpenTimeChanged: onOpenTimeChanged,
                      onCloseTimeChanged: onCloseTimeChanged,
                    )
                  : const _ClosedLabel(),
            ),
            _OpenToggle(isOpen: hours.isOpen, onToggle: onToggleOpen),
          ],
        ),
      ),
    );
  }
}

/// Day label widget.
class _DayLabel extends StatelessWidget {
  final DayOfWeek day;

  const _DayLabel({required this.day});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Text(
        day.displayName,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

/// Time selectors widget.
class _TimeSelectors extends StatelessWidget {
  final DayHoursEntity hours;
  final ValueChanged<String> onOpenTimeChanged;
  final ValueChanged<String> onCloseTimeChanged;

  const _TimeSelectors({
    required this.hours,
    required this.onOpenTimeChanged,
    required this.onCloseTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TimeButton(
          time: hours.openTime,
          label: 'Open',
          onTap: () =>
              _showTimePicker(context, hours.openTime, onOpenTimeChanged),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '-',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withValues(alpha: 0.6),
            ),
          ),
        ),
        _TimeButton(
          time: hours.closeTime,
          label: 'Close',
          onTap: () =>
              _showTimePicker(context, hours.closeTime, onCloseTimeChanged),
        ),
      ],
    );
  }

  void _showTimePicker(
    BuildContext context,
    String currentTime,
    ValueChanged<String> onTimeSelected,
  ) async {
    HapticFeedback.selectionClick();

    final parts = currentTime.split(':');
    final hour = int.tryParse(parts[0]) ?? 8;
    final minute = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.premiumGold,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      final formattedTime =
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      onTimeSelected(formattedTime);
    }
  }
}

/// Time button widget.
class _TimeButton extends StatelessWidget {
  final String time;
  final String label;
  final VoidCallback onTap;

  const _TimeButton({
    required this.time,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          time,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

/// Closed label widget.
class _ClosedLabel extends StatelessWidget {
  const _ClosedLabel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Closed',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.red,
        ),
      ),
    );
  }
}

/// Open toggle widget.
class _OpenToggle extends StatelessWidget {
  final bool isOpen;
  final ValueChanged<bool> onToggle;

  const _OpenToggle({required this.isOpen, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isOpen,
      onChanged: (value) {
        HapticFeedback.selectionClick();
        onToggle(value);
      },
      activeTrackColor: AppColors.success.withValues(alpha: 0.5),
      activeThumbColor: AppColors.success,
      inactiveThumbColor: Colors.grey,
      inactiveTrackColor: Colors.grey.withValues(alpha: 0.3),
    );
  }
}
