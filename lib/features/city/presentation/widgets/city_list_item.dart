import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/city/domain/entities/city_entity.dart';

/// City List Item Widget
///
/// Displays a city as a list item with radio button.
class CityListItem extends StatelessWidget {
  final CityEntity city;
  final bool isSelected;
  final VoidCallback onTap;

  const CityListItem({
    required this.city,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<bool>(
      value: true,
      groupValue: isSelected,
      onChanged: (_) => onTap(),
      activeColor: AppColors.primary,
      title: Text(
        city.name,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: _buildSubtitle(context),
      secondary: Icon(
        Icons.location_city,
        color: isSelected ? AppColors.primary : AppColors.mediumGrey,
      ),
    );
  }

  Widget? _buildSubtitle(BuildContext context) {
    final subtitleParts = <String>[];

    if (city.arabicName != null) {
      subtitleParts.add(city.arabicName!);
    }

    if (city.fieldsCount != null && city.fieldsCount! > 0) {
      subtitleParts.add('${city.fieldsCount} fields');
    }

    if (subtitleParts.isEmpty) {
      return null;
    }

    return Text(
      subtitleParts.join(' • '),
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
    );
  }
}
