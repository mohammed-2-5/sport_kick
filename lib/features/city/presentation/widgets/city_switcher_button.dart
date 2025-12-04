import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/city/domain/entities/city_entity.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_cubit.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_state.dart';
import 'package:spo_kick/features/city/presentation/widgets/city_selector_dialog.dart';

/// City Switcher Button
///
/// App bar button that displays current city and allows switching.
class CitySwitcherButton extends StatelessWidget {
  final CityEntity? currentCity;

  const CitySwitcherButton({this.currentCity, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CityCubit, CityState>(
      builder: (context, state) {
        final city = _getCurrentCity(state);

        return TextButton.icon(
          onPressed: () => _showCitySelector(context),
          icon: const Icon(Icons.location_on, color: Colors.white, size: 20),
          label: Text(
            city?.name ?? 'Select City',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        );
      },
    );
  }

  CityEntity? _getCurrentCity(CityState state) {
    if (state is CitySelected) {
      return state.city;
    }
    if (state is CitySaved) {
      return state.city;
    }
    if (state is CitiesLoaded && state.selectedCityId != null) {
      return state.cities.firstWhere(
        (city) => city.id == state.selectedCityId,
        orElse: () => state.cities.first,
      );
    }
    return currentCity;
  }

  void _showCitySelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<CityCubit>(),
        child: const CitySelectorDialog(),
      ),
    );
  }
}
