import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/advanced_filter_bottom_sheet.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';

/// Booking filter bottom sheet widget
///
/// Provides advanced filtering options for bookings including:
/// - Status filter (pending, confirmed, canceled, completed)
/// - Date range filter
/// - Field name filter
class BookingFilterSheet extends StatelessWidget {
  final BookingStatus? statusFilter;
  final DateTimeRange? dateRange;
  final String? fieldFilter;
  final List<String> availableFields;
  final Function(BookingStatus?) onStatusChanged;
  final Function(DateTimeRange?) onDateRangeChanged;
  final Function(String?) onFieldChanged;
  final VoidCallback onApply;
  final VoidCallback onReset;

  const BookingFilterSheet({
    super.key,
    required this.statusFilter,
    required this.dateRange,
    required this.fieldFilter,
    required this.availableFields,
    required this.onStatusChanged,
    required this.onDateRangeChanged,
    required this.onFieldChanged,
    required this.onApply,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return AdvancedFilterBottomSheet(
      filterGroups: [
        // Status Filter
        FilterGroup(
          title: 'Booking Status',
          widget: DropdownFilterWidget(
            value: statusFilter?.name,
            hint: 'All Statuses',
            options: [
              FilterOption(value: 'all', label: 'All'),
              FilterOption(
                value: BookingStatus.pending.name,
                label: BookingStatus.pending.displayName,
              ),
              FilterOption(
                value: BookingStatus.confirmed.name,
                label: BookingStatus.confirmed.displayName,
              ),
              FilterOption(
                value: BookingStatus.canceled.name,
                label: BookingStatus.canceled.displayName,
              ),
              FilterOption(
                value: BookingStatus.completed.name,
                label: BookingStatus.completed.displayName,
              ),
            ],
            onChanged: (value) {
              if (value == null || value == 'all') {
                onStatusChanged(null);
              } else {
                onStatusChanged(
                  BookingStatus.values.firstWhere(
                    (status) => status.name == value,
                  ),
                );
              }
            },
          ),
        ),
        // Date Range Filter
        FilterGroup(
          title: 'Booking Date',
          widget: DateRangeFilterWidget(
            dateRange: dateRange,
            onChanged: onDateRangeChanged,
          ),
        ),
        // Field Filter
        FilterGroup(
          title: 'Field',
          widget: DropdownFilterWidget(
            value: fieldFilter,
            hint: 'All Fields',
            options: [
              FilterOption(value: 'all', label: 'All Fields'),
              ...availableFields
                  .map((field) => FilterOption(value: field, label: field)),
            ],
            onChanged: onFieldChanged,
          ),
        ),
      ],
      onApply: onApply,
      onReset: onReset,
    );
  }
}
