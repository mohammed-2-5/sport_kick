import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spo_kick/core/utils/search_history.dart';

void main() {
  late SearchHistoryServiceImpl service;

  setUp(() async {
    // Setup mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    service = SearchHistoryServiceImpl();
  });

  group('SearchHistoryService Integration -', () {
    group('addToHistory -', () {
      test('should add query to history', () async {
        // Act
        await service.addToHistory('test query');

        // Assert
        final history = await service.getHistory();
        expect(history, contains('test query'));
      });

      test('should add query at the beginning', () async {
        // Arrange
        await service.addToHistory('first');
        await service.addToHistory('second');

        // Act
        final history = await service.getHistory();

        // Assert - most recent first
        expect(history.first, equals('second'));
        expect(history.last, equals('first'));
      });

      test('should move existing query to top', () async {
        // Arrange
        await service.addToHistory('first');
        await service.addToHistory('second');
        await service.addToHistory('third');

        // Act - add 'first' again
        await service.addToHistory('first');
        final history = await service.getHistory();

        // Assert - 'first' should now be at top
        expect(history.first, equals('first'));
        expect(history.length, equals(3)); // No duplicates
      });

      test('should not add empty query', () async {
        // Act
        await service.addToHistory('');
        await service.addToHistory('   ');

        // Assert
        final history = await service.getHistory();
        expect(history, isEmpty);
      });

      test('should limit history to 10 items', () async {
        // Act - add 12 items
        for (int i = 1; i <= 12; i++) {
          await service.addToHistory('query$i');
        }

        // Assert
        final history = await service.getHistory();
        expect(history.length, equals(10));
        expect(history.first, equals('query12')); // Most recent
        expect(history.last, equals('query3')); // Oldest kept
        expect(history, isNot(contains('query1'))); // Removed
        expect(history, isNot(contains('query2'))); // Removed
      });
    });

    group('getHistory -', () {
      test('should return empty list initially', () async {
        // Act
        final history = await service.getHistory();

        // Assert
        expect(history, isEmpty);
      });

      test('should return all history items', () async {
        // Arrange
        await service.addToHistory('query1');
        await service.addToHistory('query2');
        await service.addToHistory('query3');

        // Act
        final history = await service.getHistory();

        // Assert
        expect(history.length, equals(3));
      });
    });

    group('removeFromHistory -', () {
      test('should remove specific query', () async {
        // Arrange
        await service.addToHistory('query1');
        await service.addToHistory('query2');
        await service.addToHistory('query3');

        // Act
        await service.removeFromHistory('query2');
        final history = await service.getHistory();

        // Assert
        expect(history, isNot(contains('query2')));
        expect(history.length, equals(2));
      });

      test('should not fail when removing non-existent query', () async {
        // Act & Assert - should not throw
        await service.removeFromHistory('non-existent');
      });
    });

    group('clearHistory -', () {
      test('should clear all history', () async {
        // Arrange
        await service.addToHistory('query1');
        await service.addToHistory('query2');
        await service.addToHistory('query3');

        // Act
        await service.clearHistory();
        final history = await service.getHistory();

        // Assert
        expect(history, isEmpty);
      });
    });

    group('Data Persistence -', () {
      test('history should persist across service instances', () async {
        // Arrange
        await service.addToHistory('query1');
        await service.addToHistory('query2');

        // Create new service instance
        final newService = SearchHistoryServiceImpl();

        // Act
        final history = await newService.getHistory();

        // Assert
        expect(history.length, equals(2));
        expect(history, containsAll(['query1', 'query2']));
      });
    });
  });
}
