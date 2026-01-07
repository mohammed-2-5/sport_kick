import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Widget for selecting a date range with a convenient button interface.
///
/// Displays a button that opens a [showDateRangePicker] dialog when tapped.
/// The button text shows the selected date range or a placeholder text.
///
/// Example:
/// ```dart
/// DateRangeFilterWidget(
///   dateRange: selectedRange,
///   onChanged: (range) {
///     setState(() {
///       selectedRange = range;
///     });
///   },
/// )
/// ```
class DateRangeFilterWidget extends StatelessWidget {
  /// The currently selected date range, or null if no range is selected.
  final DateTimeRange? dateRange;

  /// Callback triggered when a new date range is selected.
  /// Called with null if the date range picker is dismissed without selection.
  final Function(DateTimeRange?) onChanged;

  /// Creates a date range filter widget.
  const DateRangeFilterWidget({
    super.key,
    required this.dateRange,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () async {
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          currentDate: DateTime.now(),
        );
        if (picked != null) {
          onChanged(picked);
        }
      },
      icon: const Icon(Icons.date_range),
      label: Text(
        dateRange == null
            ? context.l10n.selectDateRange
            : '${dateRange!.start.toString().split(' ')[0]} - ${dateRange!.end.toString().split(' ')[0]}',
      ),
    );
  }
}
