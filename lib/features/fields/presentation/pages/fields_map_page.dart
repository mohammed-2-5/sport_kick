import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/features/fields/presentation/cubit/map_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/map_state.dart';
import 'package:spo_kick/features/fields/presentation/utils/show_map_filter_dialog.dart';
import 'package:spo_kick/features/fields/presentation/widgets/map/map_content.dart';
import 'package:spo_kick/features/fields/presentation/widgets/map/map_empty_state.dart';
import 'package:spo_kick/features/fields/presentation/widgets/map/map_error_state.dart';

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
        body: Column(
          children: [
            PremiumCurvedHeader(
              title: context.l10n.fieldsMapTitle,
              subtitle: context.l10n.fieldsMapSubtitle,
              showBackButton: true,
              height: 160,
              actions: [
                // Location button
                BlocBuilder<MapCubit, MapState>(
                  builder: (context, state) {
                    final isLoading = state is MapLocationLoading;
                    return Container(
                      margin: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: AppColors.glassHighlight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.textOnNavy,
                                ),
                              )
                            : const Icon(
                                Icons.my_location,
                                color: AppColors.textOnNavy,
                              ),
                        onPressed: isLoading
                            ? null
                            : () => context.read<MapCubit>().getUserLocation(),
                        tooltip: context.l10n.myLocation,
                      ),
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
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            color: AppColors.glassHighlight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.filter_list,
                              color: AppColors.textOnNavy,
                            ),
                            onPressed: () => showMapFilterDialog(context),
                            tooltip: context.l10n.filterFields,
                          ),
                        ),
                        if (hasFilters)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.secondary,
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
            Expanded(
              child: BlocListener<MapCubit, MapState>(
                listener: (context, state) {
                  if (state is MapLocationLoaded) {
                    // Center map on user location
                    _mapController.move(state.userLocation, 14.0);
                    SnackbarHelper.showSuccess(
                      context,
                      context.l10n.mapCenteredOnLocation,
                    );
                  } else if (state is MapLocationPermissionDenied) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        duration: const Duration(seconds: 3),
                        action: SnackBarAction(
                          label: context.l10n.settings,
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
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
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
                          fieldsWithLocation = filters.applyTo(
                            fieldsWithLocation,
                          );

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
          ],
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
