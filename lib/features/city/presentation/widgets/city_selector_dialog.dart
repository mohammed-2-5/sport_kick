import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/city/domain/entities/city_entity.dart';
import 'package:spo_kick/features/city/presentation/constants/city_constants.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_cubit.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_state.dart';
import 'package:spo_kick/features/city/presentation/widgets/city_list_item.dart';

/// City Selector Dialog
///
/// Dialog for changing the selected city.
class CitySelectorDialog extends StatefulWidget {
  const CitySelectorDialog({super.key});

  @override
  State<CitySelectorDialog> createState() => _CitySelectorDialogState();
}

class _CitySelectorDialogState extends State<CitySelectorDialog> {
  CityEntity? _selectedCity;

  @override
  void initState() {
    super.initState();
    context.read<CityCubit>().loadCities();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(CityConstants.changeCityText),
      content: SizedBox(
        width: double.maxFinite,
        child: BlocConsumer<CityCubit, CityState>(
          listener: _handleStateChanges,
          buildWhen: (previous, current) {
            // Only rebuild for states relevant to showing the city list
            return current is CitiesLoading ||
                current is CitiesLoaded ||
                current is CityError;
          },
          builder: (context, state) {
            if (state is CitiesLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (state is CityError) {
              return _buildErrorView(state.message);
            }

            if (state is CitiesLoaded) {
              return _buildCityList(state);
            }

            // Fallback - should not reach here due to buildWhen
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _selectedCity != null ? _onConfirm : null,
          child: const Text('Confirm'),
        ),
      ],
    );
  }

  Widget _buildCityList(CitiesLoaded state) {
    if (state.cities.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(CityConstants.noCitiesAvailable),
        ),
      );
    }

    // Set initial selection if not set
    if (_selectedCity == null && state.selectedCityId != null) {
      _selectedCity = state.cities.firstWhere(
        (city) => city.id == state.selectedCityId,
        orElse: () => state.cities.first,
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      itemCount: state.cities.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final city = state.cities[index];
        final isSelected = _selectedCity?.id == city.id;

        return CityListItem(
          city: city,
          isSelected: isSelected,
          onTap: () => _onCitySelected(city),
        );
      },
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.read<CityCubit>().loadCities(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _onCitySelected(CityEntity city) {
    setState(() {
      _selectedCity = city;
    });
  }

  void _onConfirm() {
    if (_selectedCity != null) {
      context.read<CityCubit>().saveCity(_selectedCity!);
    }
  }

  void _handleStateChanges(BuildContext context, CityState state) {
    if (state is CitySaved) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}
