import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/fields/presentation/utils/facility_localizer.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';
import 'package:spo_kick/features/fields/presentation/widgets/shared/amenity_chip.dart';
import 'package:spo_kick/features/fields/presentation/widgets/shared/filter_section_title.dart';
import 'package:spo_kick/features/fields/presentation/widgets/shared/sort_chip.dart';

/// Premium filter bottom sheet with glassmorphism.
class PremiumFilterSheet extends StatefulWidget {
  final double minPrice;
  final double maxPrice;
  final RangeValues priceRange;
  final List<String> selectedAmenities;
  final List<String> availableAmenities;
  final String sortBy;
  final ValueChanged<RangeValues> onPriceRangeChanged;
  final ValueChanged<List<String>> onAmenitiesChanged;
  final ValueChanged<String> onSortChanged;
  final VoidCallback onApply;
  final VoidCallback onReset;

  const PremiumFilterSheet({
    super.key,
    required this.minPrice,
    required this.maxPrice,
    required this.priceRange,
    required this.selectedAmenities,
    required this.availableAmenities,
    required this.sortBy,
    required this.onPriceRangeChanged,
    required this.onAmenitiesChanged,
    required this.onSortChanged,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<PremiumFilterSheet> createState() => _PremiumFilterSheetState();
}

class _PremiumFilterSheetState extends State<PremiumFilterSheet> {
  late RangeValues _currentPriceRange;
  late List<String> _currentAmenities;
  late String _currentSort;

  @override
  void initState() {
    super.initState();
    _currentPriceRange = widget.priceRange;
    _currentAmenities = List.from(widget.selectedAmenities);
    _currentSort = widget.sortBy;
  }

  void _resetFilters() {
    setState(() {
      _currentPriceRange = RangeValues(widget.minPrice, widget.maxPrice);
      _currentAmenities.clear();
      _currentSort = 'recommended';
    });
  }

  void _applyFilters() {
    widget.onPriceRangeChanged(_currentPriceRange);
    widget.onAmenitiesChanged(_currentAmenities);
    widget.onSortChanged(_currentSort);
    widget.onApply();
    Navigator.pop(context);
  }

  void _toggleAmenity(String amenity) {
    setState(() {
      if (_currentAmenities.contains(amenity)) {
        _currentAmenities.remove(amenity);
      } else {
        _currentAmenities.add(amenity);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SheetHandle(colorScheme: colorScheme),
          _SheetHeader(colorScheme: colorScheme, onReset: _resetFilters),
          Expanded(
            child: _SheetContent(
              colorScheme: colorScheme,
              priceRange: _currentPriceRange,
              minPrice: widget.minPrice,
              maxPrice: widget.maxPrice,
              currentSort: _currentSort,
              currentAmenities: _currentAmenities,
              availableAmenities: widget.availableAmenities,
              onPriceChanged: (values) =>
                  setState(() => _currentPriceRange = values),
              onSortChanged: (value) => setState(() => _currentSort = value),
              onAmenityToggle: _toggleAmenity,
            ),
          ),
          _SheetActions(colorScheme: colorScheme, onApply: _applyFilters),
        ],
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  final ColorScheme colorScheme;

  const _SheetHandle({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: colorScheme.outline.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  final ColorScheme colorScheme;
  final VoidCallback onReset;

  const _SheetHeader({required this.colorScheme, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            context.l10n.filtersTitle,
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
          TextButton(
            onPressed: onReset,
            child: Text(
              context.l10n.reset,
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetContent extends StatelessWidget {
  final ColorScheme colorScheme;
  final RangeValues priceRange;
  final double minPrice;
  final double maxPrice;
  final String currentSort;
  final List<String> currentAmenities;
  final List<String> availableAmenities;
  final ValueChanged<RangeValues> onPriceChanged;
  final ValueChanged<String> onSortChanged;
  final ValueChanged<String> onAmenityToggle;

  const _SheetContent({
    required this.colorScheme,
    required this.priceRange,
    required this.minPrice,
    required this.maxPrice,
    required this.currentSort,
    required this.currentAmenities,
    required this.availableAmenities,
    required this.onPriceChanged,
    required this.onSortChanged,
    required this.onAmenityToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilterSectionTitle(title: context.l10n.priceRange),
          const SizedBox(height: 12),
          _PriceRangeSection(
            colorScheme: colorScheme,
            priceRange: priceRange,
            minPrice: minPrice,
            maxPrice: maxPrice,
            onChanged: onPriceChanged,
          ),
          const SizedBox(height: 24),
          FilterSectionTitle(title: context.l10n.sortBy),
          const SizedBox(height: 12),
          _SortSection(currentSort: currentSort, onSortChanged: onSortChanged),
          const SizedBox(height: 24),
          FilterSectionTitle(title: context.l10n.amenities),
          const SizedBox(height: 12),
          _AmenitiesSection(
            availableAmenities: availableAmenities,
            currentAmenities: currentAmenities,
            onAmenityToggle: onAmenityToggle,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _PriceRangeSection extends StatelessWidget {
  final ColorScheme colorScheme;
  final RangeValues priceRange;
  final double minPrice;
  final double maxPrice;
  final ValueChanged<RangeValues> onChanged;

  const _PriceRangeSection({
    required this.colorScheme,
    required this.priceRange,
    required this.minPrice,
    required this.maxPrice,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${LocaleFormatters.formatNumber(context, priceRange.start)} ${context.l10n.perHour}',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
            ),
            Text(
              '${LocaleFormatters.formatNumber(context, priceRange.end)} ${context.l10n.perHour}',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
        RangeSlider(
          values: priceRange,
          min: minPrice,
          max: maxPrice,
          activeColor: colorScheme.primary,
          inactiveColor: colorScheme.primary.withValues(alpha: 0.2),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _SortSection extends StatelessWidget {
  final String currentSort;
  final ValueChanged<String> onSortChanged;

  const _SortSection({required this.currentSort, required this.onSortChanged});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        SortChip(
          label: context.l10n.sortRelevance,
          value: context.l10n.recommended,
          currentSort: currentSort,
          onTap: onSortChanged,
        ),
        SortChip(
          label: context.l10n.sortPriceLowToHigh,
          value: context.l10n.priceAsc,
          currentSort: currentSort,
          onTap: onSortChanged,
        ),
        SortChip(
          label: context.l10n.sortPriceHighToLow,
          value: context.l10n.priceDesc,
          currentSort: currentSort,
          onTap: onSortChanged,
        ),
        SortChip(
          label: context.l10n.sortRating,
          value: context.l10n.ratingField,
          currentSort: currentSort,
          onTap: onSortChanged,
        ),
      ],
    );
  }
}

class _AmenitiesSection extends StatelessWidget {
  final List<String> availableAmenities;
  final List<String> currentAmenities;
  final ValueChanged<String> onAmenityToggle;

  const _AmenitiesSection({
    required this.availableAmenities,
    required this.currentAmenities,
    required this.onAmenityToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: availableAmenities
          .map(
            (amenity) => AmenityChip(
              label: FacilityLocalizer.localize(context, amenity),
              isSelected: currentAmenities.contains(amenity),
              onTap: () => onAmenityToggle(amenity),
            ),
          )
          .toList(),
    );
  }
}

class _SheetActions extends StatelessWidget {
  final ColorScheme colorScheme;
  final VoidCallback onApply;

  const _SheetActions({required this.colorScheme, required this.onApply});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: PremiumButton(
          label: context.l10n.applyFilters,
          onPressed: onApply,
          fullWidth: true,
          icon: Icons.check,
        ),
      ),
    );
  }
}
