import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/fields/domain/entities/sport_category_entity.dart';

/// Premium card for displaying a sport category.
///
/// Shows category icon, name, description with edit/delete actions.
class PremiumSportCategoryCard extends StatelessWidget {
  final SportCategoryEntity category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PremiumSportCategoryCard({
    required this.category,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.goldAccent.withValues(alpha: 0.2),
                        AppColors.goldAccent.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _getIcon(),
                    color: AppColors.goldAccent,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (category.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          category.description!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                // Actions
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_rounded),
                      color: AppColors.accentCyan,
                      iconSize: 20,
                    ),
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_rounded),
                      color: Colors.red,
                      iconSize: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIcon() {
    final iconName = category.icon?.toLowerCase() ?? '';

    if (iconName.contains('soccer') || iconName.contains('football')) {
      return Icons.sports_soccer_rounded;
    } else if (iconName.contains('basketball')) {
      return Icons.sports_basketball_rounded;
    } else if (iconName.contains('tennis')) {
      return Icons.sports_tennis_rounded;
    } else if (iconName.contains('volleyball')) {
      return Icons.sports_volleyball_rounded;
    }

    return Icons.sports_rounded;
  }
}
