import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/all_fields/fields_list_search_bar.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/field_card.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/field_filter_sheet.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/fields_statistics_section.dart';
import 'package:spo_kick/features/super_admin/utils/field_filter_helper.dart';

/// All Fields Management Page
class AllFieldsPage extends StatelessWidget {
  const AllFieldsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SuperAdminCubit>()..loadAllFields(),
      child: const _AllFieldsView(),
    );
  }
}

class _AllFieldsView extends StatefulWidget {
  const _AllFieldsView();

  @override
  State<_AllFieldsView> createState() => _AllFieldsViewState();
}

class _AllFieldsViewState extends State<_AllFieldsView> {
  final _searchController = TextEditingController();
  Timer? _debounceTimer;
  String _searchQuery = '';

  String? _cityFilter;
  String? _sportFilter;
  String? _statusFilter;
  double? _minPrice;
  double? _maxPrice;

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() => _searchQuery = value);
    });
  }

  bool get _hasActiveFilters =>
      _cityFilter != null ||
      _sportFilter != null ||
      _statusFilter != null ||
      _minPrice != null ||
      _maxPrice != null;

  List<FieldEntity> _filterFields(List<FieldEntity> fields) {
    return FieldFilterHelper.filterFields(
      fields,
      searchQuery: _searchQuery,
      cityFilter: _cityFilter,
      sportFilter: _sportFilter,
      statusFilter: _statusFilter,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
    );
  }

  void _showFilterSheet(List<FieldEntity> allFields) {
    final cities = FieldFilterHelper.getUniqueCities(allFields);
    final sports = FieldFilterHelper.getUniqueSportTypes(allFields);
    final priceRange = FieldFilterHelper.getPriceRange(allFields);

    String? tempCity = _cityFilter;
    String? tempSport = _sportFilter;
    String? tempStatus = _statusFilter;
    double? tempMinPrice = _minPrice;
    double? tempMaxPrice = _maxPrice;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (c) => StatefulBuilder(
        builder: (_, setSheetState) => FieldFilterSheet(
          cityFilter: tempCity,
          sportFilter: tempSport,
          statusFilter: tempStatus,
          minPrice: tempMinPrice,
          maxPrice: tempMaxPrice,
          availableCities: cities,
          availableSports: sports,
          priceMin: priceRange.min,
          priceMax: priceRange.max,
          onCityChanged: (v) => setSheetState(() => tempCity = v),
          onSportChanged: (v) => setSheetState(() => tempSport = v),
          onStatusChanged: (v) => setSheetState(() => tempStatus = v),
          onPriceRangeChanged: (min, max) => setSheetState(() {
            tempMinPrice = min;
            tempMaxPrice = max;
          }),
          onApply: () {
            setState(() {
              _cityFilter = tempCity;
              _sportFilter = tempSport;
              _statusFilter = tempStatus;
              _minPrice = tempMinPrice;
              _maxPrice = tempMaxPrice;
            });
            Navigator.pop(context);
          },
          onReset: () {
            setState(() {
              _cityFilter = null;
              _sportFilter = null;
              _statusFilter = null;
              _minPrice = null;
              _maxPrice = null;
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Fields'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          BlocBuilder<SuperAdminCubit, SuperAdminState>(
            builder: (context, state) {
              if (state is AllFieldsLoaded) {
                return IconButton(
                  icon: Badge(
                    isLabelVisible: _hasActiveFilters,
                    child: const Icon(Icons.filter_list),
                  ),
                  onPressed: () =>
                      _showFilterSheet(state.fields.cast<FieldEntity>()),
                  tooltip: 'Filter',
                );
              }
              return const SizedBox.shrink();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<SuperAdminCubit>().loadAllFields(),
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
                    'Error loading fields',
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
                    onPressed: () =>
                        context.read<SuperAdminCubit>().loadAllFields(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is AllFieldsLoaded) {
            final allFields = state.fields.cast<FieldEntity>();
            final filteredFields = _filterFields(allFields);

            return RefreshIndicator(
              onRefresh: () async {
                context.read<SuperAdminCubit>().loadAllFields();
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: FieldsStatisticsSection(fields: allFields),
                  ),
                  SliverToBoxAdapter(
                    child: FieldsListSearchBar(
                      controller: _searchController,
                      searchQuery: _searchQuery,
                      onChanged: _onSearchChanged,
                      onClear: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        '${filteredFields.length} field${filteredFields.length != 1 ? 's' : ''} found',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                  if (filteredFields.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.sports_soccer_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No fields found',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try adjusting your search or filters',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: FieldCard(field: filteredFields[index]),
                          ),
                          childCount: filteredFields.length,
                        ),
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
