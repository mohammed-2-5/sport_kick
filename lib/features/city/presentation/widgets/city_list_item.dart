import 'package:flutter/material.dart';
import 'package:spo_kick/features/city/domain/entities/city_entity.dart';
import 'package:spo_kick/features/city/presentation/widgets/city_subtitle_text.dart';

/// City List Item Widget
///
/// Displays a city as a list item with radio button.
/// Theme-aware: adapts to light/dark mode.
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
    final colorScheme = Theme.of(context).colorScheme;

    return RadioListTile<bool>(
      value: true,
      // ignore: deprecated_member_use
      groupValue: isSelected,
      // ignore: deprecated_member_use
      onChanged: (_) => onTap(),
      activeColor: colorScheme.primary,
      title: Text(
        city.name,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: CitySubtitleText(city: city),
      secondary: Icon(
        Icons.location_city,
        color: isSelected ? colorScheme.primary : colorScheme.outline,
      ),
    );
  }
}
