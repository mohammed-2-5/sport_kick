import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_cubit.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_state.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/widgets/list/field_filters_dialog.dart';
import 'package:spo_kick/features/fields/presentation/widgets/list/fields_category_section.dart';
import 'package:spo_kick/features/fields/presentation/widgets/list/fields_list_body.dart';
import 'package:spo_kick/features/fields/presentation/widgets/list/fields_list_header.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fieldsCubit = context.read<FieldsCubit>();

    return BlocListener<CityCubit, CityState>(
      listener: (context, state) {
        if (state is CitySelected) {
          fieldsCubit.handleCityChange(state.city.id);
        } else if (state is CitySaved) {
          fieldsCubit.handleCityChange(state.city.id);
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            FieldsListHeader(
              searchController: _searchController,
              onFilter: () => _showFiltersDialog(context, fieldsCubit),
              onSearchChanged: (value) {
                if (value.isEmpty) {
                  fieldsCubit.clearSearch();
                } else {
                  fieldsCubit.searchFields(value);
                }
              },
            ),
            const SizedBox(height: 20),
            FieldsCategorySection(
              selectedCategoryId: fieldsCubit.selectedCategoryId,
              onCategorySelected: fieldsCubit.selectCategoryWithFeedback,
            ),
            Expanded(
              child: FieldsListBody(
                onClearSearch: () {
                  _searchController.clear();
                  fieldsCubit.clearSearch();
                },
                onClearCategory: () =>
                    fieldsCubit.selectCategoryWithFeedback(null),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFiltersDialog(BuildContext context, FieldsCubit fieldsCubit) {
    showDialog(
      context: context,
      builder: (_) => FieldFiltersDialog(
        currentFilters: fieldsCubit.getCurrentFilters(),
        categories: fieldsCubit.getCategoryNames(),
        onApplyFilters: (options) {
          fieldsCubit.applyFiltersWithFeedback(options);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.filtersApplied),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }
}
