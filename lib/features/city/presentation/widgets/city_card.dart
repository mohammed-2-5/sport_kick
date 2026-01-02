import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/city/domain/entities/city_entity.dart';
import 'package:spo_kick/features/city/presentation/constants/city_constants.dart';

/// City Card Widget
///
/// Displays a city option as a selectable card.
/// Theme-aware: adapts to light/dark mode.
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: isSelected
          ? CityConstants.selectedCardElevation
          : CityConstants.cardElevation,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CityConstants.cardBorderRadius),
        side: BorderSide(
          color: isSelected ? colorScheme.primary : Colors.transparent,
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
                color: isSelected ? colorScheme.primary : colorScheme.outline,
              ),
              const SizedBox(height: 12),
              Text(
                city.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              if (city.arabicName != null) ...[
                const SizedBox(height: 4),
                Text(
                  city.arabicName!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
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
                        ? colorScheme.primary.withValues(alpha: 0.1)
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    context.l10n.fieldsCount(city.fieldsCount!),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ],
              if (isSelected) ...[
                const SizedBox(height: 12),
                Icon(
                  Icons.check_circle,
                  color: colorScheme.primary,
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
