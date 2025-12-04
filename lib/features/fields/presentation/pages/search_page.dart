import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/routes/app_router.dart';
import 'package:spo_kick/core/utils/search_history.dart';
import 'package:spo_kick/core/widgets/app_error_widget.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_cubit.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_state.dart';
import 'package:spo_kick/features/city/presentation/widgets/city_switcher_button.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/features/fields/presentation/widgets/field_card.dart';

/// Search page for finding fields by name, city, or address.
///
/// Features:
/// - Real-time search as user types
/// - Search history
/// - Recent searches
/// - Clear search functionality
/// - Empty state with helpful message
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<String> _searchHistory = [];

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
    // Auto-focus search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  Future<void> _loadSearchHistory() async {
    final history = await SearchHistory.getHistory();
    setState(() {
      _searchHistory = history;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query, BuildContext context) {
    if (query.trim().isEmpty) {
      return;
    }
    // Debounce search - only search after user stops typing
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && _searchController.text == query && query.trim().isNotEmpty) {
        context.read<FieldsCubit>().searchFields(query);
      }
    });
  }

  void _clearSearch(BuildContext context) {
    _searchController.clear();
    _searchFocusNode.requestFocus();
  }

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
        // Set the initial city if available
        if (initialCityId != null) {
          cubit.setCurrentCity(initialCityId);
        }
        return cubit;
      },
      child: BlocListener<CityCubit, CityState>(
        listener: (context, cityState) {
          // Update fields when city changes
          if (cityState is CitySelected) {
            context.read<FieldsCubit>().setCurrentCity(cityState.city.id);
          } else if (cityState is CitySaved) {
            context.read<FieldsCubit>().setCurrentCity(cityState.city.id);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: const Padding(
              padding: EdgeInsets.only(left: 4.0),
              child: CitySwitcherButton(),
            ),
            leadingWidth: 140,
            title: const Text('Search Fields'),
            elevation: 0,
          ),
        body: Column(
          children: [
            // Search Bar
            _buildSearchBar(),

            // Search Results
            Expanded(
              child: BlocBuilder<FieldsCubit, FieldsState>(
                builder: (context, state) {
                  if (state is FieldsLoading) {
                    return const LoadingIndicator.inline(
                      message: 'Searching fields...',
                    );
                  }

                  if (state is FieldsError) {
                    return AppErrorWidget(
                      message: state.message,
                      onRetry: () {
                        if (_searchController.text.isNotEmpty) {
                          context.read<FieldsCubit>().searchFields(
                                _searchController.text,
                              );
                        }
                      },
                    );
                  }

                  if (state is FieldsSearchResults) {
                    return _buildSearchResults(context, state);
                  }

                  // Initial state - show search tips
                  return _buildSearchTips();
                },
              ),
            ),
          ],
        ),
        ),
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
      child: BlocBuilder<FieldsCubit, FieldsState>(
        builder: (context, state) {
          return TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            decoration: InputDecoration(
              hintText: 'Search by name, city, or address...',
              prefixIcon: const Icon(Icons.search, color: AppColors.primary),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => _clearSearch(context),
                    )
                  : null,
              filled: true,
              fillColor: AppColors.surfaceVariant,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            textInputAction: TextInputAction.search,
            onChanged: (query) {
              setState(() {}); // Update UI to show/hide clear button
              _onSearchChanged(query, context);
            },
            onSubmitted: (query) async {
              if (query.trim().isNotEmpty) {
                await SearchHistory.addToHistory(query);
                await _loadSearchHistory();
                if (mounted) {
                  context.read<FieldsCubit>().searchFields(query);
                }
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context, FieldsSearchResults state) {
    if (state.results.isEmpty) {
      return _buildEmptyResults(state.query);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '${state.results.length} result${state.results.length == 1 ? '' : 's'} for "${state.query}"',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),

        // Results list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.results.length,
            itemBuilder: (context, index) {
              final field = state.results[index];
              return FieldCard(
                field: field,
                onTap: () {
                  context.pushNamed(
                    AppRouter.fieldDetails,
                    arguments: field.id,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyResults(String query) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No fields found for "$query"',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Try searching with different keywords',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchTips() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search History
          if (_searchHistory.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Searches',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await SearchHistory.clearHistory();
                    await _loadSearchHistory();
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ..._searchHistory.map((query) => ListTile(
                  leading: const Icon(Icons.history, color: AppColors.textSecondary),
                  title: Text(query),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () async {
                      await SearchHistory.removeFromHistory(query);
                      await _loadSearchHistory();
                    },
                  ),
                  onTap: () async {
                    _searchController.text = query;
                    await SearchHistory.addToHistory(query);
                    await _loadSearchHistory();
                    if (mounted) {
                      context.read<FieldsCubit>().searchFields(query);
                    }
                  },
                )),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
          ],

          // Search Tips
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.search,
                  size: 64,
                  color: AppColors.primary.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Search for fields',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Find fields by name, city, or address',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSearchTip(
            Icons.sports_soccer,
            'Field Name',
            'e.g., "Cairo Stadium", "Zamalek Arena"',
          ),
          const SizedBox(height: 16),
          _buildSearchTip(
            Icons.location_city,
            'City',
            'e.g., "Cairo", "Alexandria", "Giza"',
          ),
          const SizedBox(height: 16),
          _buildSearchTip(
            Icons.location_on,
            'Address',
            'e.g., "Nasr City", "Zamalek"',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTip(IconData icon, String title, String example) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryLight.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  example,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
