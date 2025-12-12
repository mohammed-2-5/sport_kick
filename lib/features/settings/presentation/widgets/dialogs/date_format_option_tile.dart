import 'package:flutter/material.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';

/// Date format option tile widget.
///
/// A single selectable tile for date format option using Material 3 design.
class DateFormatOptionTile extends StatelessWidget {
  final String label;
  final String example;
  final DateFormatOption format;
  final bool isSelected;
  final VoidCallback onTap;

  const DateFormatOptionTile({
    required this.label,
    required this.example,
    required this.format,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: isSelected ? colorScheme.primary : colorScheme.outline,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? colorScheme.primary : null,
        ),
      ),
      subtitle: Text(
        example,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
      ),
      onTap: onTap,
    );
  }
}
