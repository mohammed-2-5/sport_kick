import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// A choice chip widget for filter dialogs.
///
/// Displays a selectable option with optional icon.
class FilterChoiceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;
  final IconData? icon;

  const FilterChoiceChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelected,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.primaryLight.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.primaryLight.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : AppColors.primary,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Section title widget for filter dialogs.
class FilterSectionTitle extends StatelessWidget {
  final String title;

  const FilterSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}

/// Price range filter section.
class PriceRangeFilter extends StatelessWidget {
  final RangeValues priceRange;
  final ValueChanged<RangeValues> onChanged;
  final double min;
  final double max;

  const PriceRangeFilter({
    super.key,
    required this.priceRange,
    required this.onChanged,
    this.min = 0,
    this.max = 500,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FilterSectionTitle(title: 'Price Range (per hour)'),
        const SizedBox(height: 8),
        RangeSlider(
          values: priceRange,
          min: min,
          max: max,
          divisions: 10,
          labels: RangeLabels(
            '${priceRange.start.round()} EGP',
            '${priceRange.end.round()} EGP',
          ),
          activeColor: AppColors.primary,
          onChanged: onChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${priceRange.start.round()} EGP',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '${priceRange.end.round()} EGP',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Rating filter section.
class RatingFilter extends StatelessWidget {
  final double minRating;
  final ValueChanged<double> onChanged;

  const RatingFilter({
    super.key,
    required this.minRating,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FilterSectionTitle(title: 'Minimum Rating'),
        const SizedBox(height: 8),
        Slider(
          value: minRating,
          min: 0,
          max: 5,
          divisions: 10,
          label: minRating == 0 ? 'Any' : '${minRating.toStringAsFixed(1)} ⭐',
          activeColor: AppColors.warning,
          onChanged: onChanged,
        ),
        Center(
          child: Text(
            minRating == 0
                ? 'Any rating'
                : '${minRating.toStringAsFixed(1)} stars and above',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Location type filter (indoor/outdoor).
class LocationTypeFilter extends StatelessWidget {
  final String? selectedType;
  final ValueChanged<String?> onChanged;

  const LocationTypeFilter({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FilterSectionTitle(title: 'Location Type'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: FilterChoiceChip(
                label: 'Any',
                isSelected: selectedType == null,
                onSelected: () => onChanged(null),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilterChoiceChip(
                label: 'Indoor',
                icon: Icons.home,
                isSelected: selectedType == 'indoor',
                onSelected: () => onChanged('indoor'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilterChoiceChip(
                label: 'Outdoor',
                icon: Icons.wb_sunny,
                isSelected: selectedType == 'outdoor',
                onSelected: () => onChanged('outdoor'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Verification filter section.
class VerificationFilter extends StatelessWidget {
  final bool verifiedOnly;
  final ValueChanged<bool> onChanged;

  const VerificationFilter({
    super.key,
    required this.verifiedOnly,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FilterSectionTitle(title: 'Verification'),
        const SizedBox(height: 8),
        CheckboxListTile(
          value: verifiedOnly,
          onChanged: (value) => onChanged(value ?? false),
          title: const Text('Show verified fields only'),
          subtitle: const Text(
            'Verified fields are confirmed by our team',
            style: TextStyle(fontSize: 12),
          ),
          activeColor: AppColors.success,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ],
    );
  }
}
