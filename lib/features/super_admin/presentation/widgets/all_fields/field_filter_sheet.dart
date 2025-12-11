import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/advanced_filter_bottom_sheet.dart';

/// Field filter bottom sheet widget
///
/// Provides advanced filtering options for fields including:
/// - City filter
/// - Sport category filter
/// - Status filter (active/inactive)
/// - Price range filter
class FieldFilterSheet extends StatelessWidget {
  final String? cityFilter;
  final String? sportFilter;
  final String? statusFilter;
  final double? minPrice;
  final double? maxPrice;
  final List<String> availableCities;
  final List<String> availableSports;
  final double priceMin;
  final double priceMax;
  final Function(String?) onCityChanged;
  final Function(String?) onSportChanged;
  final Function(String?) onStatusChanged;
  final Function(double?, double?) onPriceRangeChanged;
  final VoidCallback onApply;
  final VoidCallback onReset;

  const FieldFilterSheet({
    super.key,
    required this.cityFilter,
    required this.sportFilter,
    required this.statusFilter,
    required this.minPrice,
    required this.maxPrice,
    required this.availableCities,
    required this.availableSports,
    required this.priceMin,
    required this.priceMax,
    required this.onCityChanged,
    required this.onSportChanged,
    required this.onStatusChanged,
    required this.onPriceRangeChanged,
    required this.onApply,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return AdvancedFilterBottomSheet(
      filterGroups: [
        // City Filter
        FilterGroup(
          title: 'City',
          widget: DropdownFilterWidget(
            value: cityFilter,
            hint: 'All Cities',
            options: [
              FilterOption(value: 'all', label: 'All Cities'),
              ...availableCities.map(
                (city) => FilterOption(value: city, label: city),
              ),
            ],
            onChanged: onCityChanged,
          ),
        ),
        // Sport Category Filter
        FilterGroup(
          title: 'Sport Category',
          widget: DropdownFilterWidget(
            value: sportFilter,
            hint: 'All Sports',
            options: [
              FilterOption(value: 'all', label: 'All Sports'),
              ...availableSports.map(
                (sport) => FilterOption(value: sport, label: sport),
              ),
            ],
            onChanged: onSportChanged,
          ),
        ),
        // Status Filter
        FilterGroup(
          title: 'Status',
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
        // Price Range Filter
        FilterGroup(
          title: 'Price Range',
          widget: _PriceRangeWidget(
            minPrice: minPrice ?? priceMin,
            maxPrice: maxPrice ?? priceMax,
            rangeMin: priceMin,
            rangeMax: priceMax,
            onChanged: onPriceRangeChanged,
          ),
        ),
      ],
      onApply: onApply,
      onReset: onReset,
    );
  }
}

/// Custom price range filter widget
class _PriceRangeWidget extends StatefulWidget {
  final double minPrice;
  final double maxPrice;
  final double rangeMin;
  final double rangeMax;
  final Function(double?, double?) onChanged;

  const _PriceRangeWidget({
    required this.minPrice,
    required this.maxPrice,
    required this.rangeMin,
    required this.rangeMax,
    required this.onChanged,
  });

  @override
  State<_PriceRangeWidget> createState() => _PriceRangeWidgetState();
}

class _PriceRangeWidgetState extends State<_PriceRangeWidget> {
  late RangeValues _currentRange;

  @override
  void initState() {
    super.initState();
    _currentRange = RangeValues(widget.minPrice, widget.maxPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_currentRange.start.toStringAsFixed(0)} EGP/hr',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '${_currentRange.end.toStringAsFixed(0)} EGP/hr',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        RangeSlider(
          values: _currentRange,
          min: widget.rangeMin,
          max: widget.rangeMax,
          divisions: ((widget.rangeMax - widget.rangeMin) / 10).round(),
          labels: RangeLabels(
            '${_currentRange.start.toStringAsFixed(0)} EGP',
            '${_currentRange.end.toStringAsFixed(0)} EGP',
          ),
          onChanged: (values) {
            setState(() {
              _currentRange = values;
            });
            widget.onChanged(values.start, values.end);
          },
        ),
      ],
    );
  }
}
