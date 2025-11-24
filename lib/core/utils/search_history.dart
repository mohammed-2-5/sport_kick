import 'package:shared_preferences/shared_preferences.dart';

/// Search history manager.
///
/// Manages user search history with persistence.
class SearchHistory {
  static const String _key = 'search_history';
  static const int _maxHistoryItems = 10;

  /// Get search history.
  static Future<List<String>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  /// Add search query to history.
  static Future<void> addToHistory(String query) async {
    if (query.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();

    // Remove if already exists (to move to top)
    history.remove(query);

    // Add to beginning
    history.insert(0, query);

    // Keep only max items
    if (history.length > _maxHistoryItems) {
      history.removeRange(_maxHistoryItems, history.length);
    }

    await prefs.setStringList(_key, history);
  }

  /// Remove specific query from history.
  static Future<void> removeFromHistory(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();

    history.remove(query);

    await prefs.setStringList(_key, history);
  }

  /// Clear all search history.
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
