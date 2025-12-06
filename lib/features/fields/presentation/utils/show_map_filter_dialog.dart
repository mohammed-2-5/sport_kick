import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/fields/presentation/cubit/map_cubit.dart';
import 'package:spo_kick/features/fields/presentation/widgets/map_filter_dialog.dart';

/// Shows the map filter dialog.
void showMapFilterDialog(BuildContext context) {
  final mapCubit = context.read<MapCubit>();

  showDialog(
    context: context,
    builder: (dialogContext) => MapFilterDialog(
      initialFilters: mapCubit.filters,
      onApply: (filters) {
        mapCubit.updateFilters(filters);
      },
    ),
  );
}
