import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_shadows.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Facilities selector for field form
class FieldFacilitiesSelector extends StatelessWidget {
  final List<String> selectedFacilities;
  final List<String> availableFacilities;
  final ValueChanged<List<String>> onChanged;

  const FieldFacilitiesSelector({
    required this.selectedFacilities,
    required this.availableFacilities,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.selectAvailableFacilities,
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: availableFacilities.map((facility) {
              final isSelected = selectedFacilities.contains(facility);
              return FilterChip(
                label: Text(facility),
                selected: isSelected,
                onSelected: (selected) {
                  final newFacilities = List<String>.from(selectedFacilities);
                  if (selected) {
                    newFacilities.add(facility);
                  } else {
                    newFacilities.remove(facility);
                  }
                  onChanged(newFacilities);
                },
                selectedColor: AppColors.primary.withValues(alpha: 0.2),
                checkmarkColor: AppColors.primary,
                labelStyle: AppTextStyles.labelMedium.copyWith(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
