import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/advanced_filter_bottom_sheet.dart';

/// Admin filter bottom sheet widget
class AdminFilterSheet extends StatelessWidget {
  final String? statusFilter;
  final DateTimeRange? dateRange;
  final Function(String?) onStatusChanged;
  final Function(DateTimeRange?) onDateRangeChanged;
  final VoidCallback onApply;
  final VoidCallback onReset;

  const AdminFilterSheet({
    super.key,
    required this.statusFilter,
    required this.dateRange,
    required this.onStatusChanged,
    required this.onDateRangeChanged,
    required this.onApply,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return AdvancedFilterBottomSheet(
      filterGroups: [
        FilterGroup(
          title: 'Account Status',
          widget: DropdownFilterWidget(
            value: statusFilter,
            hint: 'All Statuses',
            options: [
              FilterOption(value: 'all', label: 'All'),
              FilterOption(value: 'active', label: 'Active'),
              FilterOption(value: 'inactive', label: 'Inactive'),
            ],
            onChanged: onStatusChanged,
          ),
        ),
        FilterGroup(
          title: 'Creation Date',
          widget: DateRangeFilterWidget(
            dateRange: dateRange,
            onChanged: onDateRangeChanged,
          ),
        ),
      ],
      onApply: onApply,
      onReset: onReset,
    );
  }
}
