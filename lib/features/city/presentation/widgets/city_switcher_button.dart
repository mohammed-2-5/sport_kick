import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/city/domain/entities/city_entity.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_cubit.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_state.dart';
import 'package:spo_kick/features/city/presentation/widgets/city_selector_launcher.dart';

/// City Switcher Button
///
/// App bar button that displays current city and allows switching.
/// Theme-aware: uses onPrimary color for text/icons on primary background.
class CitySwitcherButton extends StatelessWidget {
  final CityEntity? currentCity;

  const CitySwitcherButton({this.currentCity, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<CityCubit, CityState>(
      builder: (context, state) {
        final city = context.read<CityCubit>().resolveCityFromState(state);

        return TextButton.icon(
          onPressed: () => CitySelectorLauncher.show(context),
          icon: Icon(Icons.location_on, color: colorScheme.onPrimary, size: 20),
          label: Text(
            city?.name ?? context.l10n.citySelectCity,
            style: TextStyle(
              color: colorScheme.onPrimary,
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
}
