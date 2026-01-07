import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/filters/models/filter_option.dart';

/// Dropdown filter widget for selecting a single option from a list.
///
/// Displays a [DropdownButtonFormField] with customizable options.
/// Allows filtering by selecting one value from a predefined list.
///
/// Example:
/// ```dart
/// DropdownFilterWidget(
///   value: selectedStatus,
///   options: [
///     FilterOption(value: 'active', label: 'Active'),
///     FilterOption(value: 'inactive', label: 'Inactive'),
///   ],
///   onChanged: (value) {
///     setState(() {
///       selectedStatus = value;
///     });
///   },
///   hint: 'Select Status',
/// )
/// ```
class DropdownFilterWidget extends StatelessWidget {
  /// The currently selected value, or null if no selection has been made.
  final String? value;

  /// List of selectable filter options.
  final List<FilterOption> options;

  /// Callback triggered when the selected value changes.
  final Function(String?) onChanged;

  /// Placeholder text shown when no value is selected.
  final String hint;

  /// Creates a dropdown filter widget.
  const DropdownFilterWidget({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: options.map((option) {
        return DropdownMenuItem<String>(
          value: option.value,
          child: Text(option.label),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
