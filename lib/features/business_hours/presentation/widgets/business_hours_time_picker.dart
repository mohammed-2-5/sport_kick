import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_constants.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_strings.dart';

/// Time picker widget for selecting business hours.
///
/// Provides a user-friendly interface for selecting opening and closing times
/// with 15-minute intervals.
class BusinessHoursTimePicker extends StatelessWidget {
  /// Label for the time picker
  final String label;

  /// Currently selected time (HH:MM:SS format)
  final String selectedTime;

  /// Callback when time is changed
  final ValueChanged<String> onTimeChanged;

  /// Whether this picker is for opening time
  final bool isOpeningTime;

  /// Optional minimum time constraint (for closing time)
  final String? minTime;

  /// Whether the picker is enabled
  final bool enabled;

  const BusinessHoursTimePicker({
    super.key,
    required this.label,
    required this.selectedTime,
    required this.onTimeChanged,
    this.isOpeningTime = true,
    this.minTime,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: enabled ? null : Colors.grey,
          ),
        ),
        const SizedBox(height: BusinessHoursConstants.smallSpacing),

        // Time display and picker button
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? () => _showTimePicker(context) : null,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: enabled
                    ? theme.cardColor
                    : Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: enabled ? AppColors.primary : Colors.grey,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time,
                    size: BusinessHoursConstants.timeIconSize,
                    color: enabled ? AppColors.primary : Colors.grey,
                  ),
                  const SizedBox(width: BusinessHoursConstants.itemSpacing),
                  Text(
                    _formatTimeDisplay(selectedTime),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: enabled ? null : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: BusinessHoursConstants.smallSpacing),
                  Icon(
                    Icons.arrow_drop_down,
                    color: enabled ? Colors.grey : Colors.grey[400],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Shows the time picker dialog
  Future<void> _showTimePicker(BuildContext context) async {
    final currentTime = _parseTime(selectedTime);

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: currentTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (!context.mounted) return;

    if (picked != null) {
      // Check if the selected time meets constraints
      if (minTime != null && !isOpeningTime) {
        final minTimeOfDay = _parseTime(minTime!);
        if (_isTimeBefore(picked, minTimeOfDay)) {
          _showTimeError(context);
          return;
        }
      }

      final formattedTime = _formatTimeToString(picked);
      onTimeChanged(formattedTime);
    }
  }

  /// Parses time string (HH:MM:SS) to TimeOfDay
  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    if (parts.length < 2) {
      return const TimeOfDay(hour: 0, minute: 0);
    }

    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;

    return TimeOfDay(hour: hour, minute: minute);
  }

  /// Formats TimeOfDay to string (HH:MM:SS)
  String _formatTimeToString(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00';
  }

  /// Formats time string for display (HH:MM AM/PM)
  String _formatTimeDisplay(String time) {
    final timeOfDay = _parseTime(time);

    int hour = timeOfDay.hour;
    final minute = timeOfDay.minute.toString().padLeft(2, '0');

    final period = hour >= 12 ? 'PM' : 'AM';
    if (hour > 12) {
      hour -= 12;
    } else if (hour == 0) {
      hour = 12;
    }

    return '$hour:$minute $period';
  }

  /// Checks if time1 is before time2
  bool _isTimeBefore(TimeOfDay time1, TimeOfDay time2) {
    if (time1.hour < time2.hour) return true;
    if (time1.hour == time2.hour && time1.minute < time2.minute) return true;
    return false;
  }

  /// Shows error message for invalid time selection
  void _showTimeError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(BusinessHoursStrings.invalidTimeRange),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
