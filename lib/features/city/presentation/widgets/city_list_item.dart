import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/city/domain/entities/city_entity.dart';
import 'package:spo_kick/features/city/presentation/widgets/city_subtitle_text.dart';

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
      subtitle: CitySubtitleText(city: city),
      secondary: Icon(
        Icons.location_city,
        color: isSelected ? AppColors.primary : AppColors.mediumGrey,
      ),
    );
  }
}
