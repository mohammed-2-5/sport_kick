import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/utils/search_history.dart';
import 'package:spo_kick/features/fields/presentation/cubit/search_state.dart';

/// Cubit for managing search functionality.
///
/// Handles:
/// - Search history (load, add, remove, clear)
/// - Debounced search execution via callback
/// - City change handling via callback
///
/// Follows Single Responsibility Principle by focusing only on search history
/// and debouncing. Actual search execution is delegated via callbacks to avoid
/// cubit-to-cubit dependency.
class SearchCubit extends Cubit<SearchState> {
  final SearchHistoryService _historyService;
  final void Function(String query)? onSearch;
  final void Function(String cityId)? onCityChange;

  Timer? _debounceTimer;
  String _lastQuery = '';

  SearchCubit({
    this.onSearch,
    this.onCityChange,
    SearchHistoryService? historyService,
  }) : _historyService = historyService ?? SearchHistoryServiceImpl(),
       super(const SearchInitial());

  /// Load search history from storage.
  Future<void> loadHistory() async {
    final history = await _historyService.getHistory();
    emit(SearchHistoryLoaded(history: history));
  }

  /// Perform debounced search.
  ///
  /// Waits 500ms after last keystroke before searching.
  /// Delegates actual search execution to the provided callback.
  void search(String query) {
    _debounceTimer?.cancel();

    if (query.trim().isEmpty) return;

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isNotEmpty && query == _lastQuery) {
        onSearch?.call(query);
      }
    });

    _lastQuery = query;
  }

  /// Execute search immediately and save to history.
  ///
  /// Delegates actual search execution to the provided callback.
  Future<void> submitSearch(String query) async {
    if (query.trim().isEmpty) return;

    await _historyService.addToHistory(query);
    onSearch?.call(query);
    await loadHistory();
  }

  /// Handle history item tap - set query and search.
  ///
  /// Delegates actual search execution to the provided callback.
  Future<void> selectHistoryItem(String query) async {
    await _historyService.addToHistory(query);
    onSearch?.call(query);
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
  ///
  /// Delegates city change to the provided callback.
  void onCityChanged(String cityId) {
    onCityChange?.call(cityId);
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
