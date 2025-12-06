import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:spo_kick/features/fields/presentation/widgets/search_input_field.dart';
import 'package:spo_kick/features/fields/presentation/widgets/search_results_list.dart';
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
    setState(() => _searchHistory = history);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query, BuildContext context) {
    if (query.trim().isEmpty) return;

    // Debounce search - only search after user stops typing
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted &&
          context.mounted &&
          _searchController.text == query &&
          query.trim().isNotEmpty) {
        context.read<FieldsCubit>().searchFields(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cityState = context.read<CityCubit>().state;
    final initialCityId = CityHelper.getCurrentCityId(cityState);

    return BlocProvider(
      create: (context) {
        final cubit = sl<FieldsCubit>();
        if (initialCityId != null) {
          cubit.setCurrentCity(initialCityId);
        }
        return cubit;
      },
      child: BlocListener<CityCubit, CityState>(
        listener: (context, cityState) {
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
              Builder(
                builder: (context) => SearchInputField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onChanged: (query) {
                    setState(() {}); // Update UI for clear button
                    _performSearch(query, context);
                  },
                  onSubmitted: (query) async {
                    if (query.trim().isNotEmpty) {
                      await SearchHistory.addToHistory(query);
                      await _loadSearchHistory();
                      if (mounted && context.mounted) {
                        context.read<FieldsCubit>().searchFields(query);
                      }
                    }
                  },
                  onClear: () {
                    _searchController.clear();
                    _searchFocusNode.requestFocus();
                  },
                ),
              ),

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
                      return SearchResultsList(
                        query: state.query,
                        results: state.results,
                      );
                    }

                    // Initial state - show search tips
                    return SearchTips(
                      searchHistory: _searchHistory,
                      onHistoryTap: (query) async {
                        _searchController.text = query;
                        await SearchHistory.addToHistory(query);
                        await _loadSearchHistory();
                        if (mounted && context.mounted) {
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
}
