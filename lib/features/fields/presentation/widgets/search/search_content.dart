import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/search_cubit.dart';
import '../../cubit/search_state.dart';
import 'search_body.dart';

/// Search content using SearchCubit state.
class SearchContent extends StatelessWidget {
  final TextEditingController searchController;

  const SearchContent({super.key, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, searchState) {
        final history = searchState is SearchHistoryLoaded
            ? searchState.history
            : <String>[];

        return SearchBody(
          searchController: searchController,
          searchHistory: history,
          onHistoryTap: (query) {
            searchController.text = query;
            context.read<SearchCubit>().selectHistoryItem(query);
          },
          onHistoryRemove: (query) {
            context.read<SearchCubit>().removeFromHistory(query);
          },
          onClearHistory: () {
            context.read<SearchCubit>().clearHistory();
          },
        );
      },
    );
  }
}
