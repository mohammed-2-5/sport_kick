import 'package:shared_preferences/shared_preferences.dart';

/// Interface for search history operations.
///
/// Allows for mocking in tests.
abstract class SearchHistoryService {
  Future<List<String>> getHistory();
  Future<void> addToHistory(String query);
  Future<void> removeFromHistory(String query);
  Future<void> clearHistory();
}

/// Default implementation using SharedPreferences.
class SearchHistoryServiceImpl implements SearchHistoryService {
  static const String _key = 'search_history';
  static const int _maxHistoryItems = 10;

  @override
  Future<List<String>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  @override
  Future<void> addToHistory(String query) async {
    if (query.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();

    history.remove(query);
    history.insert(0, query);

    if (history.length > _maxHistoryItems) {
      history.removeRange(_maxHistoryItems, history.length);
    }

    await prefs.setStringList(_key, history);
  }

  @override
  Future<void> removeFromHistory(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();
    history.remove(query);
    await prefs.setStringList(_key, history);
  }

  @override
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

/// Static helper for legacy support.
class SearchHistory {
  static final SearchHistoryService _service = SearchHistoryServiceImpl();

  static Future<List<String>> getHistory() => _service.getHistory();
  static Future<void> addToHistory(String query) =>
      _service.addToHistory(query);
  static Future<void> removeFromHistory(String query) =>
      _service.removeFromHistory(query);
  static Future<void> clearHistory() => _service.clearHistory();
}
