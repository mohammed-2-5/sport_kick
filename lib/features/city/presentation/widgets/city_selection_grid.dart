import 'package:flutter/material.dart';
import 'package:spo_kick/features/city/domain/entities/city_entity.dart';
import 'package:spo_kick/features/city/presentation/constants/city_constants.dart';
import 'package:spo_kick/features/city/presentation/widgets/city_card.dart';

class CitySelectionGrid extends StatelessWidget {
  final List<CityEntity> cities;
  final String? selectedCityId;
  final ValueChanged<CityEntity> onCitySelected;

  const CitySelectionGrid({
    super.key,
    required this.cities,
    required this.selectedCityId,
    required this.onCitySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(CityConstants.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            CityConstants.citySelectionSubtitle,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.black54),
          ),
          const SizedBox(height: CityConstants.sectionSpacing),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = _calculateCrossAxisCount(
                constraints.maxWidth,
              );
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: CityConstants.cardSpacing,
                  mainAxisSpacing: CityConstants.cardSpacing,
                  childAspectRatio: 0.9,
                ),
                itemCount: cities.length,
                itemBuilder: (context, index) {
                  final city = cities[index];
                  final isSelected = selectedCityId == city.id;

                  return CityCard(
                    city: city,
                    isSelected: isSelected,
                    onTap: () => onCitySelected(city),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  int _calculateCrossAxisCount(double width) {
    if (width > 900) return 4; // Desktop
    if (width > 600) return 3; // Tablet
    if (width > 400) return 2; // Standard phone
    return 2; // Small phone (minimum 2 columns)
  }
}
