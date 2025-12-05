import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/city/domain/entities/city_entity.dart';
import 'package:spo_kick/features/city/presentation/constants/city_constants.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_cubit.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_state.dart';
import 'package:spo_kick/features/city/presentation/widgets/city_selection_continue_button.dart';
import 'package:spo_kick/features/city/presentation/widgets/city_selection_empty_view.dart';
import 'package:spo_kick/features/city/presentation/widgets/city_selection_error_view.dart';
import 'package:spo_kick/features/city/presentation/widgets/city_selection_grid.dart';
import 'package:spo_kick/features/city/presentation/widgets/city_selection_loading_view.dart';
import 'package:spo_kick/features/city/presentation/widgets/city_selection_saving_view.dart';

/// City Selection Page
///
/// Displays available cities for user selection on first launch.
/// Shows cities in a responsive grid layout.
class CitySelectionPage extends StatelessWidget {
  const CitySelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(CityConstants.citySelectionTitle),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<CityCubit, CityState>(
        listener: (context, state) {
          if (state is CitySaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
            context.goNamed('home');
          }
          if (state is CityError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<CityCubit>();
          final cities = _resolveCities(state, cubit);
          final selectedCityId = _resolveSelectedCityId(state, cubit);

          if (state is CitiesLoading) {
            return const CitySelectionLoadingView();
          }

          if (state is CityError && cubit.cachedCities.isEmpty) {
            return CitySelectionErrorView(
              message: state.message,
              onRetry: cubit.loadCities,
            );
          }

          if (state is CitySaving) {
            return const CitySelectionSavingView();
          }

          if (cities.isEmpty) {
            return const CitySelectionEmptyView();
          }

          return CitySelectionGrid(
            cities: cities,
            selectedCityId: selectedCityId,
            onCitySelected: cubit.selectCity,
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<CityCubit, CityState>(
        builder: (context, state) {
          final cubit = context.read<CityCubit>();
          final selectedCityId = _resolveSelectedCityId(state, cubit);
          return CitySelectionContinueButton(
            isEnabled: selectedCityId != null,
            onContinue: cubit.confirmSelection,
          );
        },
      ),
    );
  }

  List<CityEntity> _resolveCities(CityState state, CityCubit cubit) {
    if (state is CitiesLoaded) return state.cities;
    return cubit.cachedCities;
  }

  String? _resolveSelectedCityId(CityState state, CityCubit cubit) {
    if (state is CitiesLoaded) return state.selectedCityId;
    if (state is CitySelected) return state.city.id;
    if (state is CitySaving) return state.city.id;
    if (state is CitySaved) return state.city.id;
    return cubit.selectedCity?.id;
  }
}
