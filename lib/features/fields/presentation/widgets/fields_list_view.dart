import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/app_error_widget.dart';
import 'package:spo_kick/core/widgets/empty_state_widget.dart';
import 'package:spo_kick/core/widgets/shimmer_loading.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_cubit.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_state.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/features/fields/presentation/widgets/category_filters.dart';
import 'package:spo_kick/features/fields/presentation/widgets/field_card.dart';
import 'package:spo_kick/features/fields/presentation/widgets/field_filters_dialog.dart';
import 'package:spo_kick/features/fields/presentation/widgets/fields_list_header.dart';
import 'package:spo_kick/features/fields/presentation/widgets/fields_search_bar.dart';

/// Main view widget for the fields list page.
///
/// Displays:
/// - Custom header with search bar
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
      listener: (context, cityState) {
        // Update fields when city changes
        if (cityState is CitySelected) {
          context.read<FieldsCubit>().setCurrentCity(cityState.city.id);
        } else if (cityState is CitySaved) {
          context.read<FieldsCubit>().setCurrentCity(cityState.city.id);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.lightBackground,
        body: Stack(
          children: [
            Column(
              children: [
                // Custom Header
                FieldsListHeader(
                  searchBar: FieldsSearchBar(
                    controller: _searchController,
                    onClear: () {
                      _searchController.clear();
                      context.read<FieldsCubit>().clearFilters();
                      setState(() {});
                    },
                    onFilter: _showFiltersDialog,
                    onChanged: (value) {
                      setState(() {});
                      if (value.isEmpty) {
                        context.read<FieldsCubit>().clearFilters();
                      }
                    },
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        context.read<FieldsCubit>().searchFields(value);
                      }
                    },
                  ),
                ),

                // Category Filters
                const SizedBox(height: 20),
                BlocBuilder<FieldsCubit, FieldsState>(
                  builder: (context, state) {
                    if (state is! FieldsLoaded) {
                      return const SizedBox.shrink();
                    }
                    return CategoryFilters(
                      categories: state.categories,
                      selectedCategoryId: _selectedCategoryId,
                      onCategorySelected: (categoryId) {
                        setState(() => _selectedCategoryId = categoryId);
                        context.read<FieldsCubit>().filterByCategory(
                          categoryId,
                        );
                      },
                    );
                  },
                ),

                // Fields List
                Expanded(
                  child: BlocBuilder<FieldsCubit, FieldsState>(
                    builder: (context, state) {
                      if (state is FieldsLoading) {
                        return const FieldsListShimmer(itemCount: 5);
                      }

                      if (state is FieldsError) {
                        return AppErrorWidget(
                          message: state.message,
                          onRetry: () {
                            context.read<FieldsCubit>().loadAllFields();
                          },
                        );
                      }

                      if (state is FieldsEmpty) {
                        return EmptyStateWidget.fields(
                          actionText: 'Refresh',
                          onAction: () {
                            context.read<FieldsCubit>().refresh();
                          },
                        );
                      }

                      if (state is FieldsSearchResults) {
                        if (state.isEmpty) {
                          return EmptyStateWidget.searchResults(
                            actionText: 'Clear Search',
                            onAction: () {
                              _searchController.clear();
                              context.read<FieldsCubit>().clearFilters();
                            },
                          );
                        }
                        return _buildFieldsList(state.results);
                      }

                      if (state is FieldsLoaded) {
                        final fields = state.filteredFields;

                        if (fields.isEmpty) {
                          return EmptyStateWidget.fields(
                            message: 'No fields found in this city',
                            actionText: 'Clear Filters',
                            onAction: () {
                              setState(() => _selectedCategoryId = null);
                              _searchController.clear();
                              context.read<FieldsCubit>().clearFilters();
                            },
                          );
                        }

                        return _buildFieldsList(fields);
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFiltersDialog() {
    showDialog(
      context: context,
      builder: (context) => FieldFiltersDialog(
        selectedCategoryId: _selectedCategoryId,
        categories: const [], // Will be populated from state
        onApplyFilters: (filters) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Filters applied! Feature fully connected soon.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  Widget _buildFieldsList(List fields) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<FieldsCubit>().refresh();
      },
      child: AnimationLimiter(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          itemCount: fields.length,
          itemBuilder: (context, index) {
            final field = fields[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: FieldCard(
                    field: field,
                    onTap: () {
                      context.pushNamed(
                        'fieldDetails',
                        pathParameters: {'fieldId': field.id},
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
