import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/super_admin/domain/entities/city_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/cities/cities_empty_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/cities/cities_stats_card.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/cities/city_card.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/cities/city_filter_chips.dart';

/// Cities Management Page
///
/// Displays all cities in the platform.
class CitiesPage extends StatelessWidget {
  const CitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SuperAdminCubit>()..loadCities(),
      child: const _CitiesView(),
    );
  }
}

class _CitiesView extends StatefulWidget {
  const _CitiesView();

  @override
  State<_CitiesView> createState() => _CitiesViewState();
}

class _CitiesViewState extends State<_CitiesView> {
  String _filterStatus = 'all'; // all, active, inactive

  List<CityEntity> _filterCities(List<CityEntity> cities) {
    if (_filterStatus == 'active') {
      return cities.where((city) => city.isActive).toList();
    } else if (_filterStatus == 'inactive') {
      return cities.where((city) => !city.isActive).toList();
    }
    return cities;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cities Management'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<SuperAdminCubit>().loadCities();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocConsumer<SuperAdminCubit, SuperAdminState>(
        listener: (context, state) {
          if (state is SuperAdminError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is SuperAdminLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }

          if (state is SuperAdminError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading cities',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<SuperAdminCubit>().loadCities();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is CitiesLoaded) {
            final allCities = state.cities;
            final filteredCities = _filterCities(allCities);
            final activeCount = allCities.where((c) => c.isActive).length;
            final inactiveCount = allCities.length - activeCount;
            final totalFields = allCities.fold<int>(
              0,
              (sum, city) => sum + city.fieldsCount,
            );

            return RefreshIndicator(
              onRefresh: () async {
                context.read<SuperAdminCubit>().loadCities();
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: Column(
                children: [
                  CitiesStatsCard(
                    totalCities: allCities.length,
                    totalFields: totalFields,
                  ),
                  CityFilterChips(
                    selectedFilter: _filterStatus,
                    allCount: allCities.length,
                    activeCount: activeCount,
                    inactiveCount: inactiveCount,
                    onFilterChanged: (value) {
                      setState(() => _filterStatus = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: filteredCities.isEmpty
                        ? const CitiesEmptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: filteredCities.length,
                            itemBuilder: (context, index) {
                              final city = filteredCities[index];
                              return CityCard(city: city);
                            },
                          ),
                  ),
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
