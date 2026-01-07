import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/filters/models/filter_option.dart';

/// Multi-select chip filter widget for selecting multiple options.
///
/// Displays selectable [FilterChip] widgets in a wrap layout. Multiple values
/// can be selected simultaneously, with the selected values indicated visually.
///
/// Example:
/// ```dart
/// ChipFilterWidget(
///   selectedValues: selectedCities,
///   options: [
///     FilterOption(value: 'cairo', label: 'Cairo'),
///     FilterOption(value: 'alex', label: 'Alexandria'),
///     FilterOption(value: 'giza', label: 'Giza'),
///   ],
///   onChanged: (values) {
///     setState(() {
///       selectedCities = values;
///     });
///   },
/// )
/// ```
class ChipFilterWidget extends StatelessWidget {
  /// List of currently selected option values.
  final List<String> selectedValues;

  /// List of available filter options to display as chips.
  final List<FilterOption> options;

  /// Callback triggered when selections change.
  /// Called with the updated list of selected values.
  final Function(List<String>) onChanged;

  /// Creates a chip filter widget.
  const ChipFilterWidget({
    super.key,
    required this.selectedValues,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selectedValues.contains(option.value);
        return FilterChip(
          label: Text(option.label),
          selected: isSelected,
          onSelected: (selected) {
            final newValues = List<String>.from(selectedValues);
            if (selected) {
              newValues.add(option.value);
            } else {
              newValues.remove(option.value);
            }
            onChanged(newValues);
          },
        );
      }).toList(),
    );
  }
}
