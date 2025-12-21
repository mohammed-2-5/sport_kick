import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/advanced_filter_bottom_sheet.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';

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
          title: context.l10n.city,
          widget: DropdownFilterWidget(
            value: cityFilter,
            hint: context.l10n.allCities,
            options: [
              FilterOption(value: 'all', label: context.l10n.allCities),
              ...availableCities.map(
                (city) => FilterOption(value: city, label: city),
              ),
            ],
            onChanged: onCityChanged,
          ),
        ),
        // Sport Category Filter
        FilterGroup(
          title: context.l10n.sportCategory,
          widget: DropdownFilterWidget(
            value: sportFilter,
            hint: context.l10n.allSports,
            options: [
              FilterOption(value: 'all', label: context.l10n.allSports),
              ...availableSports.map(
                (sport) => FilterOption(value: sport, label: sport),
              ),
            ],
            onChanged: onSportChanged,
          ),
        ),
        // Status Filter
        FilterGroup(
          title: context.l10n.bookingStatus,
          widget: DropdownFilterWidget(
            value: statusFilter,
            hint: context.l10n.allStatuses,
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
        // Price Range Filter
        FilterGroup(
          title: context.l10n.priceRange,
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
              '${LocaleFormatters.formatNumber(context, _currentRange.start, decimalDigits: 0)} ${context.l10n.currencyEgp}/${context.l10n.perHour}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '${LocaleFormatters.formatNumber(context, _currentRange.end, decimalDigits: 0)} ${context.l10n.currencyEgp}/${context.l10n.perHour}',
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
            LocaleFormatters.formatPrice(
              context,
              amount: _currentRange.start,
              currency: context.l10n.currencyEgp,
              decimalDigits: 0,
            ),
            LocaleFormatters.formatPrice(
              context,
              amount: _currentRange.end,
              currency: context.l10n.currencyEgp,
              decimalDigits: 0,
            ),
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
