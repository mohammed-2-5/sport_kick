import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/features/fields/presentation/cubit/map_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/map_state.dart';
import 'package:spo_kick/features/fields/presentation/utils/show_map_filter_dialog.dart';
import 'package:spo_kick/features/fields/presentation/widgets/map_content.dart';
import 'package:spo_kick/features/fields/presentation/widgets/map_empty_state.dart';
import 'package:spo_kick/features/fields/presentation/widgets/map_error_state.dart';

/// Fields Map Page
///
/// Displays all available fields on an interactive map with markers.
/// Users can tap on markers to view field details and navigate to booking.
class FieldsMapPage extends StatefulWidget {
  const FieldsMapPage({super.key});

  @override
  State<FieldsMapPage> createState() => _FieldsMapPageState();
}

class _FieldsMapPageState extends State<FieldsMapPage> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fields Map'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          actions: [
            // Location button
            BlocBuilder<MapCubit, MapState>(
              builder: (context, state) {
                final isLoading = state is MapLocationLoading;
                return IconButton(
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.my_location),
                  onPressed: isLoading
                      ? null
                      : () => context.read<MapCubit>().getUserLocation(),
                  tooltip: 'My Location',
                );
              },
            ),
            // Filter button
            BlocBuilder<MapCubit, MapState>(
              builder: (context, state) {
                final hasFilters = context
                    .read<MapCubit>()
                    .filters
                    .hasActiveFilters;
                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () => showMapFilterDialog(context),
                      tooltip: 'Filter',
                    ),
                    if (hasFilters)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
        body: BlocListener<MapCubit, MapState>(
          listener: (context, state) {
            if (state is MapLocationLoaded) {
              // Center map on user location
              _mapController.move(state.userLocation, 14.0);
              SnackbarHelper.showSuccess(context, 'Centered on your location');
            } else if (state is MapLocationPermissionDenied) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  duration: const Duration(seconds: 3),
                  action: SnackBarAction(
                    label: 'Settings',
                    onPressed: () {
                      // Could open app settings here
                    },
                  ),
                ),
              );
            } else if (state is MapLocationError) {
              SnackbarHelper.showError(context, state.message);
            }
          },
          child: BlocBuilder<FieldsCubit, FieldsState>(
            builder: (context, state) {
              if (state is FieldsLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (state is FieldsError) {
                return MapErrorState(message: state.message);
              }

              if (state is FieldsLoaded) {
                return BlocBuilder<MapCubit, MapState>(
                  builder: (context, mapState) {
                    final filters = context.read<MapCubit>().filters;
                    var fieldsWithLocation = state.fields
                        .where((f) => f.hasLocation)
                        .toList();

                    // Apply filters
                    fieldsWithLocation = filters.applyTo(fieldsWithLocation);

                    if (fieldsWithLocation.isEmpty) {
                      return MapEmptyState(
                        hasFilters: filters.hasActiveFilters,
                      );
                    }

                    return MapContent(
                      fields: fieldsWithLocation,
                      mapController: _mapController,
                    );
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
