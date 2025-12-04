import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/city/domain/entities/city_entity.dart';
import 'package:spo_kick/features/city/presentation/constants/city_constants.dart';

/// City Card Widget
///
/// Displays a city option as a selectable card.
class CityCard extends StatelessWidget {
  final CityEntity city;
  final bool isSelected;
  final VoidCallback onTap;

  const CityCard({
    required this.city,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected
          ? CityConstants.selectedCardElevation
          : CityConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CityConstants.cardBorderRadius),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.transparent,
          width: 2.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(CityConstants.cardBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(CityConstants.cardPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_city,
                size: CityConstants.iconSize,
                color: isSelected ? AppColors.primary : AppColors.mediumGrey,
              ),
              const SizedBox(height: 12),
              Text(
                city.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              if (city.arabicName != null) ...[
                const SizedBox(height: 4),
                Text(
                  city.arabicName!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (city.fieldsCount != null && city.fieldsCount! > 0) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${city.fieldsCount} fields',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ],
              if (isSelected) ...[
                const SizedBox(height: 12),
                const Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: CityConstants.smallIconSize,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
