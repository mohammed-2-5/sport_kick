import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/fields/presentation/constants/search_constants.dart';
import 'package:spo_kick/features/fields/presentation/utils/facility_localizer.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Amenities Filter Widget
///
/// Multi-select chips for filtering by amenities.
class AmenitiesFilter extends StatelessWidget {
  final List<String> selectedAmenities;
  final ValueChanged<List<String>> onChanged;

  const AmenitiesFilter({
    required this.selectedAmenities,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.amenities,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: SearchConstants.chipSpacing,
          runSpacing: SearchConstants.chipSpacing,
          children: SearchConstants.commonAmenities.map((amenity) {
            final isSelected = selectedAmenities.contains(amenity);
            final label = FacilityLocalizer.localize(context, amenity);
            return FilterChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (selected) {
                final updated = List<String>.from(selectedAmenities);
                if (selected) {
                  updated.add(amenity);
                } else {
                  updated.remove(amenity);
                }
                onChanged(updated);
              },
              selectedColor: AppColors.primary.withValues(alpha: 0.2),
              checkmarkColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
