import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/city/presentation/constants/city_constants.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_cubit.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_state.dart';
import 'package:spo_kick/features/city/presentation/widgets/city_selector_list.dart';
import 'package:spo_kick/features/city/presentation/widgets/city_selection_feedback.dart';
import 'package:spo_kick/features/city/presentation/widgets/city_selection_error_view.dart';
import 'package:spo_kick/features/city/presentation/widgets/city_selection_loading_view.dart';
import 'package:spo_kick/features/city/presentation/widgets/city_selection_saving_view.dart';

/// City Selector Dialog
///
/// Dialog for changing the selected city.
class CitySelectorDialog extends StatefulWidget {
  const CitySelectorDialog({super.key});

  @override
  State<CitySelectorDialog> createState() => _CitySelectorDialogState();
}

class _CitySelectorDialogState extends State<CitySelectorDialog> {
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      _initialized = true;
      context.read<CityCubit>().loadCities();
    }

    return AlertDialog(
      title: const Text(CityConstants.changeCityText),
      content: SizedBox(
        width: double.maxFinite,
        child: BlocConsumer<CityCubit, CityState>(
          listener: (context, state) {
            if (state is CitySaved) {
              Navigator.pop(context);
              CitySelectionFeedback.showSuccess(context, state.message);
            }
            if (state is CityError) {
              CitySelectionFeedback.showError(context, state.message);
            }
          },
          buildWhen: (previous, current) {
            // Only rebuild for states relevant to showing the city list
            return current is CitiesLoading ||
                current is CitiesLoaded ||
                current is CityError ||
                current is CitySaving ||
                current is CitySelected ||
                current is CitySaved;
          },
          builder: (context, state) {
            final cubit = context.read<CityCubit>();
            final cities = state is CitiesLoaded
                ? state.cities
                : cubit.cachedCities;
            final selectedCityId = cubit.selectedIdFromState(state);

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

            if (cities.isNotEmpty) {
              return CitySelectorList(
                cities: cities,
                selectedCityId: selectedCityId,
                onSelected: (city) => cubit.selectCity(city),
              );
            }

            // Fallback - should not reach here due to buildWhen
            return const CitySelectionLoadingView();
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        BlocBuilder<CityCubit, CityState>(
          builder: (context, state) {
            final cubit = context.read<CityCubit>();
            final selectedCityId = cubit.selectedIdFromState(state);
            return FilledButton(
              onPressed: selectedCityId != null
                  ? () => cubit.confirmSelection()
                  : null,
              child: const Text('Confirm'),
            );
          },
        ),
      ],
    );
  }
}
