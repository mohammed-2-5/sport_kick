import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/super_admin/domain/entities/city_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/cities/city_actions_sheet.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/cities/create_city_dialog.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/cities/delete_city_dialog.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/cities/edit_city_dialog.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/cities/premium_cities_stats_bar.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/cities/premium_city_card.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/cities/premium_city_filter_chips.dart';

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
        context.read<SuperAdminCubit>().createCity(
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
        context.read<SuperAdminCubit>().updateCity(
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
        context.read<SuperAdminCubit>().deleteCity(
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
        context.read<SuperAdminCubit>().updateCity(
          cityId: city.id,
          isActive: !city.isActive,
        );
      },
      onDelete: () => _showDeleteCityDialog(city),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SuperAdminCubit, SuperAdminState>(
      listener: (context, state) {
        if (state is SuperAdminError) {
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
          backgroundColor: AppColors.backgroundLight,
          body: _buildBody(context, state),
          floatingActionButton: state is CitiesLoaded
              ? FloatingActionButton.extended(
                  onPressed: _showCreateCityDialog,
                  backgroundColor: AppColors.navyDeep,
                  icon: const Icon(Icons.add_location_alt_rounded),
                  label: const Text('Add City'),
                )
              : null,
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, SuperAdminState state) {
    if (state is SuperAdminLoading) {
      return _LoadingView(message: state.message);
    }

    if (state is SuperAdminError) {
      return _ErrorView(
        message: state.message,
        onRetry: () => context.read<SuperAdminCubit>().loadCities(),
      );
    }

    if (state is CitiesLoaded) {
      return _buildLoadedContent(context, state.cities);
    }

    return const _LoadingView(message: 'Loading cities...');
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
        context.read<SuperAdminCubit>().loadCities();
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: CustomScrollView(
        slivers: [
          // Premium Header
          SliverToBoxAdapter(
            child: PremiumCurvedHeader(
              title: 'Cities',
              subtitle: 'Manage platform locations',
              showBackButton: true,
              actions: [
                _RefreshButton(
                  onTap: () => context.read<SuperAdminCubit>().loadCities(),
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
                            context.read<SuperAdminCubit>().updateCity(
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
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
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
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Colors.red,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navyDeep,
                foregroundColor: Colors.white,
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
                color: AppColors.accentCyan.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_city_rounded,
                color: AppColors.accentCyan.withValues(alpha: 0.6),
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No cities found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try adjusting your filters\nor add a new city',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
