import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/routes/app_router.dart';
import 'package:spo_kick/core/widgets/app_error_widget.dart';
import 'package:spo_kick/core/widgets/empty_state_widget.dart';
import 'package:spo_kick/core/widgets/shimmer_loading.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/features/fields/presentation/widgets/field_card.dart';
import 'package:spo_kick/features/fields/presentation/widgets/field_filters_dialog.dart';

/// Fields list page - browse and search sports fields.
///
/// Features:
/// - Filter by sport category
/// - Search fields
/// - Pull to refresh
/// - Navigate to field details
class FieldsListPage extends StatelessWidget {
  const FieldsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FieldsCubit>()..loadAllFields(),
      child: const _FieldsListView(),
    );
  }
}

class _FieldsListView extends StatefulWidget {
  const _FieldsListView();

  @override
  State<_FieldsListView> createState() => _FieldsListViewState();
}

class _FieldsListViewState extends State<_FieldsListView> {
  final _searchController = TextEditingController();
  String? _selectedCategoryId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppGradients.primary,
          ),
        ),
        title: const Text(
          'Browse Fields',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              context.pushNamed(AppRouter.search);
            },
            tooltip: 'Search',
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              context.pushNamed(AppRouter.favorites);
            },
            tooltip: 'Favorites',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          _buildSearchBar(),

          // Category Filters
          _buildCategoryFilters(),

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
    );
  }

  void _showFiltersDialog() {
    showDialog(
      context: context,
      builder: (context) => FieldFiltersDialog(
        selectedCategoryId: _selectedCategoryId,
        categories: const [], // Will be populated from state
        onApplyFilters: (filters) {
          // Apply filters logic will be implemented
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

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search fields, cities...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<FieldsCubit>().clearFilters();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.surfaceVariant,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
            vertical: 12,
          ),
        ),
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
          const SizedBox(width: 12),
          // Filter Button
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.tune, color: Colors.white),
              onPressed: _showFiltersDialog,
              tooltip: 'Advanced Filters',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return BlocBuilder<FieldsCubit, FieldsState>(
      builder: (context, state) {
        if (state is! FieldsLoaded) {
          return const SizedBox.shrink();
        }

        final categories = state.categories;

        if (categories.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: categories.length + 1, // +1 for "All" chip
            itemBuilder: (context, index) {
              if (index == 0) {
                // "All" chip
                return _buildCategoryChip(
                  label: 'All',
                  icon: '🏟️',
                  isSelected: _selectedCategoryId == null,
                  onTap: () {
                    setState(() => _selectedCategoryId = null);
                    context.read<FieldsCubit>().filterByCategory(null);
                  },
                );
              }

              final category = categories[index - 1];
              return _buildCategoryChip(
                label: category.name,
                icon: category.icon ?? '⚽',
                isSelected: _selectedCategoryId == category.id,
                onTap: () {
                  setState(() => _selectedCategoryId = category.id);
                  context.read<FieldsCubit>().filterByCategory(category.id);
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required String icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 6),
            Text(label),
          ],
        ),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: Colors.white,
        selectedColor: AppColors.primary.withValues(alpha: 0.15),
        checkmarkColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected
                ? AppColors.primary
                : AppColors.outline.withValues(alpha: 0.3),
          ),
        ),
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
          padding: const EdgeInsets.all(16),
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
                      Navigator.pushNamed(
                        context,
                        AppRouter.fieldDetails,
                        arguments: field.id,
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
