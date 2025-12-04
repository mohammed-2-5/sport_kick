import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/all_fields/fields_list_body.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/all_fields/fields_list_error_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/all_fields/fields_list_loading_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/field_filter_sheet.dart';
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
            return FieldsListLoadingState(message: state.message);
          }

          if (state is SuperAdminError) {
            return FieldsListErrorState(
              message: state.message,
              onRetry: () => context.read<SuperAdminCubit>().loadAllFields(),
            );
          }

          if (state is AllFieldsLoaded) {
            final allFields = state.fields.cast<FieldEntity>();
            final filteredFields = _filterFields(allFields);

            return FieldsListBody(
              allFields: allFields,
              filteredFields: filteredFields,
              searchController: _searchController,
              searchQuery: _searchQuery,
              hasFilters: _hasActiveFilters || _searchQuery.isNotEmpty,
              onSearchChanged: _onSearchChanged,
              onClearSearch: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
