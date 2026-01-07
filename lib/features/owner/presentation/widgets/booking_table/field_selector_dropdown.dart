import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedField.id,
          isExpanded: true,
          dropdownColor: colorScheme.surface,
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: colorScheme.primary,
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
                      color: colorScheme.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.sports_soccer_rounded,
                      color: colorScheme.secondary,
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
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (field.city.isNotEmpty)
                          Text(
                            field.city,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: colorScheme.onSurfaceVariant.withValues(
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
