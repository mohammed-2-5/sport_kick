import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/fields/domain/entities/sport_category_entity.dart';

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
    _selectedIcon = widget.category?.icon ?? _iconOptions.first['value'];
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
              isEditing ? 'Edit Category' : 'Create Category',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),

            // Name field
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Category Name',
                hintText: 'e.g., Football, Basketball',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Icon selector
            const Text(
              'Icon',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
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
                          ? AppColors.goldAccent.withValues(alpha: 0.2)
                          : AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.goldAccent
                            : AppColors.divider,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      option['icon'],
                      color: isSelected
                          ? AppColors.goldAccent
                          : AppColors.textSecondary,
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
                labelText: 'Description (Optional)',
                hintText: 'Brief description...',
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
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.goldAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(isEditing ? 'Update' : 'Create'),
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
        const SnackBar(content: Text('Please enter a category name')),
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
