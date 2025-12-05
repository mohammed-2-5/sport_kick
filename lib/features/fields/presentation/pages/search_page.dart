import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/utils/search_history.dart';
import 'package:spo_kick/core/widgets/app_error_widget.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_cubit.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_state.dart';
import 'package:spo_kick/features/city/presentation/widgets/city_switcher_button.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/features/fields/presentation/utils/city_helper.dart';
import 'package:spo_kick/features/fields/presentation/widgets/field_card.dart';
import 'package:spo_kick/features/fields/presentation/widgets/search_empty_results.dart';
import 'package:spo_kick/features/fields/presentation/widgets/search_tips.dart';

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
      if (mounted &&
          _searchController.text == query &&
          query.trim().isNotEmpty) {
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
    final initialCityId = CityHelper.getCurrentCityId(cityState);

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
                    return SearchTips(
                      searchHistory: _searchHistory,
                      onHistoryTap: (query) async {
                        _searchController.text = query;
                        await SearchHistory.addToHistory(query);
                        await _loadSearchHistory();
                        if (mounted) {
                          context.read<FieldsCubit>().searchFields(query);
                        }
                      },
                      onHistoryRemove: (query) async {
                        await SearchHistory.removeFromHistory(query);
                        await _loadSearchHistory();
                      },
                      onClearHistory: () async {
                        await SearchHistory.clearHistory();
                        await _loadSearchHistory();
                      },
                    );
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
      return SearchEmptyResults(query: state.query);
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
                    'fieldDetails',
                    pathParameters: {'fieldId': field.id},
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
