import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/advanced_filter_bottom_sheet.dart';

/// User filter bottom sheet widget
class UserFilterSheet extends StatelessWidget {
  final String? statusFilter;
  final DateTimeRange? dateRange;
  final Function(String?) onStatusChanged;
  final Function(DateTimeRange?) onDateRangeChanged;
  final VoidCallback onApply;
  final VoidCallback onReset;

  const UserFilterSheet({
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
          title: 'Join Date',
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
