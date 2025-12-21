import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/fields/presentation/utils/facility_localizer.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Premium filter bottom sheet with glassmorphism.
///
/// Features:
/// - Glass background with blur
/// - Price range slider
/// - Amenities selection
/// - Sort options
/// - Apply/Reset buttons
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.filtersTitle,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _currentPriceRange = RangeValues(
                        widget.minPrice,
                        widget.maxPrice,
                      );
                      _currentAmenities.clear();
                      _currentSort = 'recommended';
                    });
                  },
                  child: Text(
                    context.l10n.reset,
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.accentCyan,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Range
                  _SectionTitle(title: context.l10n.priceRange),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${LocaleFormatters.formatNumber(context, _currentPriceRange.start)} ${context.l10n.perHour}',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.accentCyan,
                        ),
                      ),
                      Text(
                        '${LocaleFormatters.formatNumber(context, _currentPriceRange.end)} ${context.l10n.perHour}',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.accentCyan,
                        ),
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: _currentPriceRange,
                    min: widget.minPrice,
                    max: widget.maxPrice,
                    activeColor: AppColors.accentCyan,
                    inactiveColor: AppColors.accentCyan.withValues(alpha: 0.2),
                    onChanged: (values) {
                      setState(() {
                        _currentPriceRange = values;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Sort By
                  _SectionTitle(title: context.l10n.sortBy),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _SortChip(
                        label: context.l10n.sortRelevance,
                        value: context.l10n.recommended,
                        currentSort: _currentSort,
                        onTap: (value) => setState(() => _currentSort = value),
                      ),
                      _SortChip(
                        label: context.l10n.sortPriceLowToHigh,
                        value: context.l10n.priceAsc,
                        currentSort: _currentSort,
                        onTap: (value) => setState(() => _currentSort = value),
                      ),
                      _SortChip(
                        label: context.l10n.sortPriceHighToLow,
                        value: context.l10n.priceDesc,
                        currentSort: _currentSort,
                        onTap: (value) => setState(() => _currentSort = value),
                      ),
                      _SortChip(
                        label: context.l10n.sortRating,
                        value: context.l10n.ratingField,
                        currentSort: _currentSort,
                        onTap: (value) => setState(() => _currentSort = value),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Amenities
                  _SectionTitle(title: context.l10n.amenities),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: widget.availableAmenities
                        .map(
                          (amenity) => _AmenityChip(
                            label: FacilityLocalizer.localize(context, amenity),
                            isSelected: _currentAmenities.contains(amenity),
                            onTap: () {
                              setState(() {
                                if (_currentAmenities.contains(amenity)) {
                                  _currentAmenities.remove(amenity);
                                } else {
                                  _currentAmenities.add(amenity);
                                }
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Action Buttons
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
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
                onPressed: () {
                  widget.onPriceRangeChanged(_currentPriceRange);
                  widget.onAmenitiesChanged(_currentAmenities);
                  widget.onSortChanged(_currentSort);
                  widget.onApply();
                  Navigator.pop(context);
                },
                fullWidth: true,
                icon: Icons.check,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Section title.
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.titleMedium.copyWith(
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
    );
  }
}

/// Sort chip.
class _SortChip extends StatelessWidget {
  final String label;
  final String value;
  final String currentSort;
  final ValueChanged<String> onTap;

  const _SortChip({
    required this.label,
    required this.value,
    required this.currentSort,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentSort == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentCyan : AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected
                ? AppColors.accentCyan
                : AppColors.textSecondary.withValues(alpha: 0.2),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

/// Amenity chip.
class _AmenityChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AmenityChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accentCyan.withValues(alpha: 0.1)
              : AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.accentCyan
                : AppColors.textSecondary.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              const Icon(
                Icons.check_circle,
                size: 16,
                color: AppColors.accentCyan,
              ),
            if (isSelected) const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? AppColors.accentCyan
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
