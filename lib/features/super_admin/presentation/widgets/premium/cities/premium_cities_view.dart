import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/super_admin/domain/entities/city_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/city_management/city_management_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/city_management/city_management_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/cities/city_actions_sheet.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/cities/create_city_dialog.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/cities/delete_city_dialog.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/cities/edit_city_dialog.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/cities/premium_cities_stats_bar.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/cities/premium_city_card.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/cities/premium_city_filter_chips.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium cities management view.
///
/// Features:
/// - Premium curved header with gold accents
/// - Animated stats bar with scroll
/// - Filter chips with count badges
/// - Staggered city cards list
/// - Pull-to-refresh
/// - FAB for creating new cities
/// - CRUD operations via dialogs
/// - Empty state with illustration
/// - Error state with retry
class PremiumCitiesView extends StatefulWidget {
  const PremiumCitiesView({super.key});

  @override
  State<PremiumCitiesView> createState() => _PremiumCitiesViewState();
}

class _PremiumCitiesViewState extends State<PremiumCitiesView> {
  String _filterStatus = 'all';

  List<CityEntity> _filterCities(List<CityEntity> cities) {
    if (_filterStatus == 'active') {
      return cities.where((city) => city.isActive).toList();
    } else if (_filterStatus == 'inactive') {
      return cities.where((city) => !city.isActive).toList();
    }
    return cities;
  }

  void _showCreateCityDialog() {
    CreateCityDialog.show(
      context: context,
      onSubmit: (name, isActive) {
        context.read<CityManagementCubit>().createCity(
          name: name,
          isActive: isActive,
        );
      },
    );
  }

  void _showEditCityDialog(CityEntity city) {
    EditCityDialog.show(
      context: context,
      city: city,
      onSubmit: (name, isActive) {
        context.read<CityManagementCubit>().updateCity(
          cityId: city.id,
          name: name != city.name ? name : null,
          isActive: isActive != city.isActive ? isActive : null,
        );
      },
    );
  }

  void _showDeleteCityDialog(CityEntity city) {
    DeleteCityDialog.show(
      context: context,
      city: city,
      onConfirm: (hardDelete) {
        context.read<CityManagementCubit>().deleteCity(
          cityId: city.id,
          hardDelete: hardDelete,
        );
      },
    );
  }

  void _showCityActions(CityEntity city) {
    CityActionsSheet.show(
      context: context,
      city: city,
      onEdit: () => _showEditCityDialog(city),
      onToggleStatus: () {
        context.read<CityManagementCubit>().updateCity(
          cityId: city.id,
          isActive: !city.isActive,
        );
      },
      onDelete: () => _showDeleteCityDialog(city),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CityManagementCubit, CityManagementState>(
      listener: (context, state) {
        if (state is CityManagementError) {
          SnackbarHelper.showError(context, state.message);
        } else if (state is CityCreated) {
          SnackbarHelper.showSuccess(context, state.successMessage);
        } else if (state is CityUpdated) {
          SnackbarHelper.showSuccess(context, state.successMessage);
        } else if (state is CityDeleted) {
          SnackbarHelper.showSuccess(context, state.successMessage);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: _buildBody(context, state),
          floatingActionButton: state is CitiesLoaded
              ? FloatingActionButton.extended(
                  onPressed: _showCreateCityDialog,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  icon: const Icon(Icons.add_location_alt_rounded),
                  label: Text(context.l10n.addCity),
                )
              : null,
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, CityManagementState state) {
    if (state is CityManagementLoading) {
      return _LoadingView(message: state.message);
    }

    if (state is CityManagementError) {
      return _ErrorView(
        message: state.message,
        onRetry: () => context.read<CityManagementCubit>().loadCities(),
      );
    }

    if (state is CitiesLoaded) {
      return _buildLoadedContent(context, state.cities);
    }

    return _LoadingView(message: context.l10n.cityLoading);
  }

  Widget _buildLoadedContent(BuildContext context, List<CityEntity> cities) {
    final filteredCities = _filterCities(cities);
    final activeCount = cities.where((c) => c.isActive).length;
    final inactiveCount = cities.length - activeCount;
    final totalFields = cities.fold<int>(
      0,
      (sum, city) => sum + city.fieldsCount,
    );

    return RefreshIndicator(
      color: AppColors.goldAccent,
      onRefresh: () async {
        context.read<CityManagementCubit>().loadCities();
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: CustomScrollView(
        slivers: [
          // Premium Header
          SliverToBoxAdapter(
            child: PremiumCurvedHeader(
              title: context.l10n.cities,
              subtitle: context.l10n.managePlatformLocations,
              showBackButton: true,
              actions: [
                _RefreshButton(
                  onTap: () => context.read<CityManagementCubit>().loadCities(),
                ),
              ],
            ),
          ),

          // Stats Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: PremiumCitiesStatsBar(
                totalCities: cities.length,
                activeCities: activeCount,
                inactiveCities: inactiveCount,
                totalFields: totalFields,
              ),
            ),
          ),

          // Filter Chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 16),
              child: PremiumCityFilterChips(
                selectedFilter: _filterStatus,
                allCount: cities.length,
                activeCount: activeCount,
                inactiveCount: inactiveCount,
                onFilterChanged: (filter) {
                  setState(() => _filterStatus = filter);
                },
              ),
            ),
          ),

          // Cities List
          if (filteredCities.isEmpty)
            const SliverFillRemaining(child: _EmptyState())
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final city = filteredCities[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 400),
                    child: SlideAnimation(
                      verticalOffset: 50,
                      child: FadeInAnimation(
                        child: PremiumCityCard(
                          name: city.name,
                          fieldsCount: city.fieldsCount,
                          isActive: city.isActive,
                          onTap: () => _showCityActions(city),
                          onEdit: () => _showEditCityDialog(city),
                          onToggleStatus: () {
                            context.read<CityManagementCubit>().updateCity(
                              cityId: city.id,
                              isActive: !city.isActive,
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }, childCount: filteredCities.length),
              ),
            ),

          // Bottom padding for FAB
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

/// Refresh button for the header.
class _RefreshButton extends StatelessWidget {
  final VoidCallback onTap;

  const _RefreshButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassHighlight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.refresh_rounded,
          color: AppColors.textOnNavy,
          size: 22,
        ),
        onPressed: onTap,
      ),
    );
  }
}

/// Loading view with premium spinner.
class _LoadingView extends StatelessWidget {
  final String message;

  const _LoadingView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppColors.goldAccent,
            strokeWidth: 3,
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: AppTextStyles.labelLarge.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Error view with retry button.
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: colorScheme.error,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.oopsSomethingWentWrong,
              style: AppTextStyles.titleMedium.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.l10n.tryAgain),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty state when no cities match filter.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_city_rounded,
                color: colorScheme.primary.withValues(alpha: 0.6),
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.noCitiesFound,
              style: AppTextStyles.titleMedium.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.tryAdjustingYourFiltersNorAdd,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
