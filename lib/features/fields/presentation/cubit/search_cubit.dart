import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/utils/search_history.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/search_state.dart';

/// Cubit for managing search functionality.
///
/// Handles:
/// - Search history (load, add, remove, clear)
/// - Debounced search execution
/// - City change handling for search context
class SearchCubit extends Cubit<SearchState> {
  final FieldsCubit fieldsCubit;
  final SearchHistoryService _historyService;
  Timer? _debounceTimer;
  String _lastQuery = '';

  SearchCubit({required this.fieldsCubit, SearchHistoryService? historyService})
    : _historyService = historyService ?? SearchHistoryServiceImpl(),
      super(const SearchInitial());

  /// Load search history from storage.
  Future<void> loadHistory() async {
    final history = await _historyService.getHistory();
    emit(SearchHistoryLoaded(history: history));
  }

  /// Perform debounced search.
  ///
  /// Waits 500ms after last keystroke before searching.
  void search(String query) {
    _debounceTimer?.cancel();

    if (query.trim().isEmpty) return;

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isNotEmpty && query == _lastQuery) {
        fieldsCubit.searchFields(query);
      }
    });

    _lastQuery = query;
  }

  /// Execute search immediately and save to history.
  Future<void> submitSearch(String query) async {
    if (query.trim().isEmpty) return;

    await _historyService.addToHistory(query);
    fieldsCubit.searchFields(query);
    await loadHistory();
  }

  /// Handle history item tap - set query and search.
  Future<void> selectHistoryItem(String query) async {
    await _historyService.addToHistory(query);
    fieldsCubit.searchFields(query);
    await loadHistory();
  }

  /// Remove item from search history.
  Future<void> removeFromHistory(String query) async {
    await _historyService.removeFromHistory(query);
    await loadHistory();
  }

  /// Clear all search history.
  Future<void> clearHistory() async {
    await _historyService.clearHistory();
    await loadHistory();
  }

  /// Handle city change - update search context.
  void onCityChanged(String cityId) {
    fieldsCubit.setCurrentCity(cityId);
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
