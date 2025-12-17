import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';

/// Dropdown selector for switching between owner's fields.
class FieldSelectorDropdown extends StatelessWidget {
  final FieldEntity selectedField;
  final List<FieldEntity> fields;
  final ValueChanged<FieldEntity> onFieldSelected;

  const FieldSelectorDropdown({
    required this.selectedField,
    required this.fields,
    required this.onFieldSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedField.id,
          isExpanded: true,
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.navyDeep.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.navyDeep,
              size: 20,
            ),
          ),
          items: fields.map((field) {
            return DropdownMenuItem<String>(
              value: field.id,
              child: Row(
                children: [
                  // Field icon
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.accentCyan.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.sports_soccer_rounded,
                      color: AppColors.accentCyan,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Field name and location
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          field.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (field.city.isNotEmpty)
                          Text(
                            field.city,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.7,
                              ),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (fieldId) {
            if (fieldId == null) return;
            final field = fields.firstWhere((f) => f.id == fieldId);
            onFieldSelected(field);
          },
        ),
      ),
    );
  }
}
