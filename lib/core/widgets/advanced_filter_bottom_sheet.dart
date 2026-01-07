import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/filters/models/filter_group.dart';

// Re-export for backward compatibility
export 'package:spo_kick/core/widgets/filters/models/filter_group.dart';
export 'package:spo_kick/core/widgets/filters/models/filter_option.dart';
export 'package:spo_kick/core/widgets/filters/date_range_filter_widget.dart';
export 'package:spo_kick/core/widgets/filters/dropdown_filter_widget.dart';
export 'package:spo_kick/core/widgets/filters/chip_filter_widget.dart';

/// Reusable advanced filter bottom sheet widget.
///
/// Displays a bottom sheet with customizable filter groups. Each filter group
/// contains a title and a filter widget. Provides apply and reset buttons.
///
/// Example:
/// ```dart
/// showModalBottomSheet(
///   context: context,
///   builder: (context) => AdvancedFilterBottomSheet(
///     filterGroups: [
///       FilterGroup(
///         title: 'Status',
///         widget: DropdownFilterWidget(...),
///       ),
///       FilterGroup(
///         title: 'Date Range',
///         widget: DateRangeFilterWidget(...),
///       ),
///     ],
///     onApply: () { ... },
///     onReset: () { ... },
///   ),
/// )
/// ```
class AdvancedFilterBottomSheet extends StatefulWidget {
  /// List of filter groups to display in the sheet.
  final List<FilterGroup> filterGroups;

  /// Callback triggered when the apply button is pressed.
  final VoidCallback onApply;

  /// Callback triggered when the reset button is pressed.
  final VoidCallback onReset;

  /// Creates an advanced filter bottom sheet.
  const AdvancedFilterBottomSheet({
    super.key,
    required this.filterGroups,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<AdvancedFilterBottomSheet> createState() =>
      _AdvancedFilterBottomSheetState();
}

class _AdvancedFilterBottomSheetState extends State<AdvancedFilterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.advancedFilters,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.filterGroups.map((group) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _buildFilterGroup(group),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    widget.onReset();
                    Navigator.pop(context);
                  },
                  child: Text(context.l10n.reset),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply();
                    Navigator.pop(context);
                  },
                  child: Text(context.l10n.applyFilters),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterGroup(FilterGroup group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          group.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        group.widget,
      ],
    );
  }
}
