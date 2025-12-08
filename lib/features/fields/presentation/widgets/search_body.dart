import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/core/widgets/premium/empty_states.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/features/fields/presentation/widgets/search_results_list.dart';
import 'package:spo_kick/features/fields/presentation/widgets/search_tips.dart';

/// Body content for search page based on state.
///
/// Displays loading, error, results, or tips depending on state.
class SearchBody extends StatelessWidget {
  final TextEditingController searchController;
  final List<String> searchHistory;
  final ValueChanged<String> onHistoryTap;
  final ValueChanged<String> onHistoryRemove;
  final VoidCallback onClearHistory;

  const SearchBody({
    super.key,
    required this.searchController,
    required this.searchHistory,
    required this.onHistoryTap,
    required this.onHistoryRemove,
    required this.onClearHistory,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldsCubit, FieldsState>(
      builder: (context, state) {
        if (state is FieldsLoading) {
          return const LoadingIndicator.inline(message: 'Searching fields...');
        }

        if (state is FieldsError) {
          return EmptyStates.error(
            message: state.message,
            onRetry: () {
              if (searchController.text.isNotEmpty) {
                context.read<FieldsCubit>().searchFields(searchController.text);
              }
            },
          );
        }

        if (state is FieldsLoaded) {
          if (state.searchQuery != null && state.searchQuery!.isNotEmpty) {
            final results = state.filteredFields;
            if (results.isEmpty) {
              return EmptyStates.noResults(
                onClear: () => searchController.clear(),
              );
            }
            return SearchResultsList(
              query: state.searchQuery!,
              results: results,
            );
          }
        }

        // Initial state or no search query - show search tips
        return SearchTips(
          searchHistory: searchHistory,
          onHistoryTap: onHistoryTap,
          onHistoryRemove: onHistoryRemove,
          onClearHistory: onClearHistory,
        );
      },
    );
  }
}
