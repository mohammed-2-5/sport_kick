import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/advanced_filter_bottom_sheet.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

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
          title: context.l10n.accountStatus,
          widget: DropdownFilterWidget(
            value: statusFilter,
            hint: 'All Statuses',
            options: [
              FilterOption(value: context.l10n.all2, label: context.l10n.all),
              FilterOption(
                value: context.l10n.active2,
                label: context.l10n.active,
              ),
              FilterOption(
                value: context.l10n.inactive2,
                label: context.l10n.inactive,
              ),
            ],
            onChanged: onStatusChanged,
          ),
        ),
        FilterGroup(
          title: context.l10n.joinDate,
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
