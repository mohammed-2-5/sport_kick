import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/city/domain/entities/city_entity.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_cubit.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_state.dart';

class CityDropdownWidget extends StatelessWidget {
  const CityDropdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CityCubit, CityState>(
      builder: (context, state) {
        // If cities are loading or not loaded, show nothing or loading
        if (state is CitiesLoading) {
          return const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        }

        List<CityEntity> cities = [];
        CityEntity? selectedCity;

        if (state is CitiesLoaded) {
          cities = state.cities;
          if (state.selectedCityId != null) {
            try {
              selectedCity = cities.firstWhere(
                (c) => c.id == state.selectedCityId,
              );
            } catch (_) {
              if (cities.isNotEmpty) selectedCity = cities.first;
            }
          } else if (cities.isNotEmpty) {
            selectedCity = cities.first;
          }
        } else if (state is CitySelected) {
          selectedCity = state.city;
          if (cities.isEmpty) {
            context.read<CityCubit>().loadCities();
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on, color: Colors.white70, size: 16),
                const SizedBox(width: 4),
                Text(
                  selectedCity.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            );
          }
        }

        // If we still don't have cities, try to load them
        if (cities.isEmpty) {
          context.read<CityCubit>().loadCities();
          return const SizedBox.shrink();
        }

        return DropdownButtonHideUnderline(
          child: DropdownButton<CityEntity>(
            value: selectedCity,
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white70,
              size: 20,
            ),
            dropdownColor: AppColors.primary,
            isDense: true,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            onChanged: (CityEntity? newValue) {
              if (newValue != null) {
                context.read<CityCubit>().saveCity(newValue);
              }
            },
            selectedItemBuilder: (BuildContext context) {
              return cities.map<Widget>((CityEntity city) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white70,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      city.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                );
              }).toList();
            },
            items: cities.map<DropdownMenuItem<CityEntity>>((CityEntity city) {
              return DropdownMenuItem<CityEntity>(
                value: city,
                child: Text(city.name),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
