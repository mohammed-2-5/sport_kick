import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/fields/domain/entities/sport_category_entity.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Dialog for creating or editing a sport category.
class SportCategoryFormDialog extends StatefulWidget {
  final SportCategoryEntity? category;
  final Function(String name, String? icon, String? description) onSubmit;

  const SportCategoryFormDialog({
    this.category,
    required this.onSubmit,
    super.key,
  });

  static Future<void> show(
    BuildContext context, {
    SportCategoryEntity? category,
    required Function(String name, String? icon, String? description) onSubmit,
  }) {
    return showDialog(
      context: context,
      builder: (context) =>
          SportCategoryFormDialog(category: category, onSubmit: onSubmit),
    );
  }

  @override
  State<SportCategoryFormDialog> createState() =>
      _SportCategoryFormDialogState();
}

class _SportCategoryFormDialogState extends State<SportCategoryFormDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  String? _selectedIcon;

  final List<Map<String, dynamic>> _iconOptions = [
    {
      'name': 'Football',
      'icon': Icons.sports_soccer_rounded,
      'value': 'sports_soccer',
    },
    {
      'name': 'Basketball',
      'icon': Icons.sports_basketball_rounded,
      'value': 'sports_basketball',
    },
    {
      'name': 'Tennis',
      'icon': Icons.sports_tennis_rounded,
      'value': 'sports_tennis',
    },
    {
      'name': 'Volleyball',
      'icon': Icons.sports_volleyball_rounded,
      'value': 'sports_volleyball',
    },
    {'name': 'Generic', 'icon': Icons.sports_rounded, 'value': 'sports'},
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name);
    _descriptionController = TextEditingController(
      text: widget.category?.description,
    );
    _selectedIcon =
        widget.category?.icon ?? _iconOptions.first[context.l10n.value];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.category != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing
                  ? context.l10n.editCategory
                  : context.l10n.createCategory,
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),

            // Name field
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: context.l10n.categoryNameLabel,
                hintText: context.l10n.eGFootballBasketball,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Icon selector
            Text(
              context.l10n.iconField,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: _iconOptions.map((option) {
                final isSelected = _selectedIcon == option['value'];
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = option['value']),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(
                              context,
                            ).colorScheme.tertiary.withValues(alpha: 0.2)
                          : Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.tertiary
                            : Theme.of(context).colorScheme.outline,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      option['icon'],
                      color: isSelected
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Description field
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: context.l10n.descriptionOptional,
                hintText: context.l10n.briefDescription,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(context.l10n.cancel),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    foregroundColor: Theme.of(context).colorScheme.onTertiary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isEditing ? context.l10n.update : context.l10n.create,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.pleaseEnterACategoryName)),
      );
      return;
    }

    final description = _descriptionController.text.trim();

    widget.onSubmit(
      name,
      _selectedIcon,
      description.isEmpty ? null : description,
    );

    Navigator.pop(context);
  }
}
