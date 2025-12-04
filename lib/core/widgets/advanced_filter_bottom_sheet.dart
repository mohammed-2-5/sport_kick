import 'package:flutter/material.dart';

/// Reusable advanced filter bottom sheet
class AdvancedFilterBottomSheet extends StatefulWidget {
  final List<FilterGroup> filterGroups;
  final VoidCallback onApply;
  final VoidCallback onReset;

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
              const Text(
                'Advanced Filters',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  child: const Text('Reset'),
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
                  child: const Text('Apply Filters'),
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

/// Filter group model
class FilterGroup {
  final String title;
  final Widget widget;

  FilterGroup({required this.title, required this.widget});
}

/// Date range picker widget
class DateRangeFilterWidget extends StatelessWidget {
  final DateTimeRange? dateRange;
  final Function(DateTimeRange?) onChanged;

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
            ? 'Select Date Range'
            : '${dateRange!.start.toString().split(' ')[0]} - ${dateRange!.end.toString().split(' ')[0]}',
      ),
    );
  }
}

/// Dropdown filter widget
class DropdownFilterWidget extends StatelessWidget {
  final String? value;
  final List<FilterOption> options;
  final Function(String?) onChanged;
  final String hint;

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

/// Filter option model
class FilterOption {
  final String value;
  final String label;

  FilterOption({required this.value, required this.label});
}

/// Multi-select chip filter widget
class ChipFilterWidget extends StatelessWidget {
  final List<String> selectedValues;
  final List<FilterOption> options;
  final Function(List<String>) onChanged;

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
