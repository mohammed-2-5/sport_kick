import 'package:flutter_test/flutter_test.dart';
import 'package:spo_kick/features/favorites/presentation/cubit/favorites_state.dart';

void main() {
  group('FavoritesState -', () {
    group('FavoritesListLoaded -', () {
      test('isEmpty should return true when favoriteFieldIds is empty', () {
        const state = FavoritesListLoaded(favoriteFieldIds: []);

        expect(state.isEmpty, isTrue);
      });

      test(
        'isEmpty should return false when favoriteFieldIds is not empty',
        () {
          const state = FavoritesListLoaded(favoriteFieldIds: ['field-1']);

          expect(state.isEmpty, isFalse);
        },
      );

      test('count should return correct number of favorites', () {
        const state = FavoritesListLoaded(
          favoriteFieldIds: ['field-1', 'field-2', 'field-3'],
        );

        expect(state.count, equals(3));
      });

      test('isFavorite should return true for favorited field', () {
        const state = FavoritesListLoaded(
          favoriteFieldIds: ['field-1', 'field-2'],
        );

        expect(state.isFavorite('field-1'), isTrue);
        expect(state.isFavorite('field-2'), isTrue);
      });

      test('isFavorite should return false for non-favorited field', () {
        const state = FavoritesListLoaded(favoriteFieldIds: ['field-1']);

        expect(state.isFavorite('field-99'), isFalse);
      });

      group('filterFavorites -', () {
        test('should filter list to only include favorites', () {
          const state = FavoritesListLoaded(favoriteFieldIds: ['1', '3']);

          final items = [
            _TestItem('1', 'Item 1'),
            _TestItem('2', 'Item 2'),
            _TestItem('3', 'Item 3'),
            _TestItem('4', 'Item 4'),
          ];

          final filtered = state.filterFavorites(items, (item) => item.id);

          expect(filtered.length, equals(2));
          expect(filtered[0].id, equals('1'));
          expect(filtered[1].id, equals('3'));
        });

        test('should return empty list when no favorites match', () {
          const state = FavoritesListLoaded(favoriteFieldIds: ['99']);

          final items = [_TestItem('1', 'Item 1'), _TestItem('2', 'Item 2')];

          final filtered = state.filterFavorites(items, (item) => item.id);

          expect(filtered, isEmpty);
        });

        test('should return empty list when favorites is empty', () {
          const state = FavoritesListLoaded(favoriteFieldIds: []);

          final items = [_TestItem('1', 'Item 1')];

          final filtered = state.filterFavorites(items, (item) => item.id);

          expect(filtered, isEmpty);
        });

        test('should work with different getter functions', () {
          const state = FavoritesListLoaded(
            favoriteFieldIds: ['name-A', 'name-B'],
          );

          final items = [
            _TestItem('1', 'name-A'),
            _TestItem('2', 'name-B'),
            _TestItem('3', 'name-C'),
          ];

          // Filter by name instead of id
          final filtered = state.filterFavorites(items, (item) => item.name);

          expect(filtered.length, equals(2));
          expect(filtered[0].name, equals('name-A'));
          expect(filtered[1].name, equals('name-B'));
        });
      });
    });

    group('FavoriteToggled -', () {
      test('props should include fieldId and isFavorite', () {
        const state = FavoriteToggled(fieldId: 'field-1', isFavorite: true);

        expect(state.props, contains('field-1'));
        expect(state.props, contains(true));
      });
    });

    group('FavoritesError -', () {
      test('props should include message', () {
        const state = FavoritesError(message: 'Test error');

        expect(state.props, contains('Test error'));
      });
    });
  });
}

/// Test item class for filterFavorites tests.
class _TestItem {
  final String id;
  final String name;

  _TestItem(this.id, this.name);
}
