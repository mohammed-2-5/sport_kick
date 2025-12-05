import 'package:flutter/material.dart';
import 'package:spo_kick/features/city/domain/entities/city_entity.dart';
import 'package:spo_kick/features/city/presentation/constants/city_constants.dart';
import 'package:spo_kick/features/city/presentation/widgets/city_list_item.dart';

class CitySelectorList extends StatelessWidget {
  final List<CityEntity> cities;
  final String? selectedCityId;
  final ValueChanged<CityEntity> onSelected;

  const CitySelectorList({
    super.key,
    required this.cities,
    required this.selectedCityId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (cities.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(CityConstants.noCitiesAvailable),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      itemCount: cities.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final city = cities[index];
        final isSelected = selectedCityId == city.id;

        return CityListItem(
          city: city,
          isSelected: isSelected,
          onTap: () => onSelected(city),
        );
      },
    );
  }
}
