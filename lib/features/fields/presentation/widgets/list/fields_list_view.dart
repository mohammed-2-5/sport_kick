import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_cubit.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_state.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/features/fields/presentation/widgets/list/field_filters_dialog.dart';
import 'package:spo_kick/features/fields/presentation/widgets/list/fields_category_section.dart';
import 'package:spo_kick/features/fields/presentation/widgets/list/fields_list_body.dart';
import 'package:spo_kick/features/fields/presentation/widgets/list/fields_list_header.dart';

/// Main view widget for the fields list page.
///
/// Displays:
/// - Premium curved header with search bar
/// - Category filter chips
/// - List of fields with animations
class FieldsListView extends StatefulWidget {
  final String? initialCategoryId;

  const FieldsListView({super.key, this.initialCategoryId});

  @override
  State<FieldsListView> createState() => _FieldsListViewState();
}

class _FieldsListViewState extends State<FieldsListView> {
  final _searchController = TextEditingController();
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.initialCategoryId;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CityCubit, CityState>(
      listener: (context, state) => _handleCityChange(context, state),
      child: Scaffold(
        backgroundColor: AppColors.lightBackground,
        body: Column(
          children: [
            FieldsListHeader(
              searchController: _searchController,
              onFilter: () => _showFiltersDialog(context),
              onSearchChanged: (value) => _handleSearch(context, value),
            ),
            const SizedBox(height: 20),
            FieldsCategorySection(
              selectedCategoryId: _selectedCategoryId,
              onCategorySelected: (id) => _handleCategoryChange(context, id),
            ),
            Expanded(
              child: FieldsListBody(
                onClearSearch: () => _clearSearch(context),
                onClearCategory: () =>
                    setState(() => _selectedCategoryId = null),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCityChange(BuildContext context, CityState state) {
    if (state is CitySelected) {
      context.read<FieldsCubit>().setCurrentCity(state.city.id);
    } else if (state is CitySaved) {
      context.read<FieldsCubit>().setCurrentCity(state.city.id);
    }
  }

  void _handleSearch(BuildContext context, String value) {
    if (value.isEmpty) {
      context.read<FieldsCubit>().clearFilters();
    } else {
      context.read<FieldsCubit>().searchFields(value);
    }
  }

  void _handleCategoryChange(BuildContext context, String? categoryId) {
    setState(() => _selectedCategoryId = categoryId);
    context.read<FieldsCubit>().filterByCategory(categoryId);
  }

  void _clearSearch(BuildContext context) {
    _searchController.clear();
    context.read<FieldsCubit>().clearFilters();
  }

  void _showFiltersDialog(BuildContext context) {
    // Get current filters from cubit state if possible
    final state = context.read<FieldsCubit>().state;
    FieldFilterOptions? currentFilters;
    List<String> categoryNames = const [];
    if (state is FieldsLoaded) {
      currentFilters = state.filterOptions;
      categoryNames = state.categories.map((cat) => cat.name).toList();
    }

    showDialog(
      context: context,
      builder: (_) => FieldFiltersDialog(
        currentFilters: currentFilters,
        categories: categoryNames,
        onApplyFilters: (options) {
          context.read<FieldsCubit>().applyFilters(options);

          // Update local category selection to match
          if (options.categoryId != _selectedCategoryId) {
            setState(() => _selectedCategoryId = options.categoryId);
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Filters applied!'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }
}
