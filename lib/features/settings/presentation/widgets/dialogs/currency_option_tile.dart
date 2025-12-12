import 'package:flutter/material.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';

/// Currency option tile widget.
///
/// A single selectable tile for currency option using Material 3 design.
class CurrencyOptionTile extends StatelessWidget {
  final String label;
  final String code;
  final CurrencyOption currency;
  final bool isSelected;
  final VoidCallback onTap;

  const CurrencyOptionTile({
    required this.label,
    required this.code,
    required this.currency,
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
        code,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
      ),
      onTap: onTap,
    );
  }
}
