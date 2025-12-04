import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/widgets/app_error_widget.dart';
import 'package:spo_kick/core/widgets/empty_state_widget.dart';
import 'package:spo_kick/core/widgets/shimmer_loading.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_cubit.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_state.dart';
import 'package:spo_kick/features/home/presentation/widgets/city_dropdown_widget.dart';
import 'package:spo_kick/features/home/presentation/widgets/curved_header_clipper.dart';
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
  final String? categoryId;

  const FieldsListPage({super.key, this.categoryId});

  @override
  Widget build(BuildContext context) {
    // Get the current city if available
    final cityState = context.read<CityCubit>().state;
    String? initialCityId;

    if (cityState is CitySelected) {
      initialCityId = cityState.city.id;
    } else if (cityState is CitySaved) {
      initialCityId = cityState.city.id;
    } else if (cityState is CitiesLoaded && cityState.selectedCityId != null) {
      initialCityId = cityState.selectedCityId;
    }

    return BlocProvider(
      create: (context) {
        final cubit = sl<FieldsCubit>();

        debugPrint(
          '📋 [FIELDS LIST PAGE] Initializing with categoryId: $categoryId, cityId: $initialCityId',
        );

        // Load fields first, then apply category filter
        if (initialCityId != null) {
          cubit.setCurrentCity(initialCityId).then((_) {
            if (categoryId != null) {
              debugPrint(
                '🔍 [FIELDS LIST PAGE] Applying category filter: $categoryId',
              );
              cubit.filterByCategory(categoryId);
            }
          });
        } else {
          cubit.loadAllFields().then((_) {
            if (categoryId != null) {
              debugPrint(
                '🔍 [FIELDS LIST PAGE] Applying category filter: $categoryId',
              );
              cubit.filterByCategory(categoryId);
            }
          });
        }

        return cubit;
      },
      child: _FieldsListView(initialCategoryId: categoryId),
    );
  }
}

class _FieldsListView extends StatefulWidget {
  final String? initialCategoryId;

  const _FieldsListView({this.initialCategoryId});

  @override
  State<_FieldsListView> createState() => _FieldsListViewState();
}

class _FieldsListViewState extends State<_FieldsListView> {
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
                _buildCustomHeader(),

                // Category Filters
                const SizedBox(height: 20),
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

  Widget _buildCustomHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Curved Background
        ClipPath(
          clipper: CurvedHeaderClipper(),
          child: Container(
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A1F3A), // Deep Navy
                  Color(0xFF2C3E50), // Lighter Navy
                ],
              ),
            ),
          ),
        ),

        // Content
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Top Row: Back, City, Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const CityDropdownWidget(),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            context.pushNamed('favorites');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Title
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    'Browse Fields',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 40), // Space for search bar
              ],
            ),
          ),
        ),

        // Floating Search Bar
        Positioned(bottom: -25, left: 24, right: 24, child: _buildSearchBar()),
      ],
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

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search fields, cities...',
          hintStyle: TextStyle(
            color: AppColors.lightTextSecondary.withValues(alpha: 0.6),
            fontSize: 15,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.lightAccent,
            size: 24,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    context.read<FieldsCubit>().clearFilters();
                  },
                ),
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.tune,
                    color: AppColors.lightTextSecondary,
                    size: 20,
                  ),
                  onPressed: _showFiltersDialog,
                ),
              ),
            ],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
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
            padding: const EdgeInsets.symmetric(horizontal: 24),
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
      padding: const EdgeInsets.only(right: 12),
      child: FilterChip(
        label: Row(
          children: [
            Icon(
              _getIconForCategory(icon),
              size: 16,
              color: isSelected ? AppColors.primary : AppColors.textPrimary,
            ),
            const SizedBox(width: 6),
            Text(label),
          ],
        ),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: Colors.white,
        selectedColor: AppColors.primary.withValues(alpha: 0.1),
        checkmarkColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          fontSize: 14,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected
                ? AppColors.primary
                : AppColors.outline.withValues(alpha: 0.2),
          ),
        ),
        elevation: isSelected ? 0 : 2,
        shadowColor: Colors.black.withValues(alpha: 0.05),
      ),
    );
  }

  IconData _getIconForCategory(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'sports_soccer':
      case 'football':
      case 'soccer':
        return Icons.sports_soccer;
      case 'sports_basketball':
      case 'basketball':
        return Icons.sports_basketball;
      case 'sports_tennis':
      case 'tennis':
        return Icons.sports_tennis;
      case 'sports_volleyball':
      case 'volleyball':
        return Icons.sports_volleyball;
      case 'sports_cricket':
      case 'cricket':
        return Icons.sports_cricket;
      case 'sports_rugby':
      case 'rugby':
        return Icons.sports_rugby;
      case 'sports_golf':
      case 'golf':
        return Icons.sports_golf;
      case 'pool':
      case 'billiards':
        return Icons.pool;
      case 'fitness_center':
      case 'gym':
        return Icons.fitness_center;
      default:
        return Icons.sports;
    }
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
