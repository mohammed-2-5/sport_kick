import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/features/city/domain/entities/city_entity.dart';
import 'package:spo_kick/features/city/presentation/widgets/premium/premium_city_card.dart';

/// Premium city grid with staggered animations.
///
/// Features:
/// - Responsive grid layout
/// - Staggered entrance animations
/// - Proper spacing
class PremiumCityGrid extends StatelessWidget {
  final List<CityEntity> cities;
  final String? selectedCityId;
  final ValueChanged<CityEntity> onCitySelected;

  const PremiumCityGrid({
    super.key,
    required this.cities,
    this.selectedCityId,
    required this.onCitySelected,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

    return AnimationLimiter(
      child: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: cities.length,
        itemBuilder: (context, index) {
          final city = cities[index];
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 375),
            columnCount: crossAxisCount,
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: PremiumCityCard(
                  city: city,
                  isSelected: city.id == selectedCityId,
                  onTap: () => onCitySelected(city),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
