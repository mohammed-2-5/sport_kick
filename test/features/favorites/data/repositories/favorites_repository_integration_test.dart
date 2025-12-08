import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spo_kick/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:spo_kick/features/favorites/data/repositories/favorites_repository_impl.dart';

void main() {
  late FavoritesRepositoryImpl repository;
  late FavoritesLocalDataSourceImpl localDataSource;

  setUp(() async {
    // Setup mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();

    localDataSource = FavoritesLocalDataSourceImpl(
      sharedPreferences: sharedPreferences,
    );
    repository = FavoritesRepositoryImpl(localDataSource: localDataSource);
  });

  group('FavoritesRepository Integration -', () {
    group('addToFavorites -', () {
      test('should successfully add a field to favorites', () async {
        // Act
        final result = await repository.addToFavorites('field-1');

        // Assert
        expect(result.isRight(), isTrue);

        // Verify it was persisted
        final favorites = await repository.getFavoriteFieldIds();
        favorites.fold(
          (failure) => fail('Should not fail'),
          (ids) => expect(ids, contains('field-1')),
        );
      });

      test('should not duplicate if field already exists', () async {
        // Arrange
        await repository.addToFavorites('field-1');
        await repository.addToFavorites('field-1');

        // Act
        final favorites = await repository.getFavoriteFieldIds();

        // Assert
        favorites.fold((failure) => fail('Should not fail'), (ids) {
          expect(ids.length, equals(1));
          expect(ids, contains('field-1'));
        });
      });

      test('should add multiple different fields', () async {
        // Act
        await repository.addToFavorites('field-1');
        await repository.addToFavorites('field-2');
        await repository.addToFavorites('field-3');

        // Assert
        final favorites = await repository.getFavoriteFieldIds();
        favorites.fold((failure) => fail('Should not fail'), (ids) {
          expect(ids.length, equals(3));
          expect(ids, containsAll(['field-1', 'field-2', 'field-3']));
        });
      });
    });

    group('removeFromFavorites -', () {
      test('should successfully remove a field from favorites', () async {
        // Arrange
        await repository.addToFavorites('field-1');
        await repository.addToFavorites('field-2');

        // Act
        final result = await repository.removeFromFavorites('field-1');

        // Assert
        expect(result.isRight(), isTrue);

        final favorites = await repository.getFavoriteFieldIds();
        favorites.fold((failure) => fail('Should not fail'), (ids) {
          expect(ids, isNot(contains('field-1')));
          expect(ids, contains('field-2'));
        });
      });

      test('should not fail when removing non-existent field', () async {
        // Act
        final result = await repository.removeFromFavorites('non-existent');

        // Assert
        expect(result.isRight(), isTrue);
      });
    });

    group('isFavorite -', () {
      test('should return true for favorited field', () async {
        // Arrange
        await repository.addToFavorites('field-1');

        // Act
        final result = await repository.isFavorite('field-1');

        // Assert
        result.fold(
          (failure) => fail('Should not fail'),
          (isFavorite) => expect(isFavorite, isTrue),
        );
      });

      test('should return false for non-favorited field', () async {
        // Act
        final result = await repository.isFavorite('field-99');

        // Assert
        result.fold(
          (failure) => fail('Should not fail'),
          (isFavorite) => expect(isFavorite, isFalse),
        );
      });
    });

    group('getFavoriteFieldIds -', () {
      test('should return empty list initially', () async {
        // Act
        final result = await repository.getFavoriteFieldIds();

        // Assert
        result.fold(
          (failure) => fail('Should not fail'),
          (ids) => expect(ids, isEmpty),
        );
      });

      test('should return all favorited field IDs', () async {
        // Arrange
        await repository.addToFavorites('field-1');
        await repository.addToFavorites('field-2');

        // Act
        final result = await repository.getFavoriteFieldIds();

        // Assert
        result.fold((failure) => fail('Should not fail'), (ids) {
          expect(ids.length, equals(2));
          expect(ids, containsAll(['field-1', 'field-2']));
        });
      });
    });

    group('clearAllFavorites -', () {
      test('should remove all favorites', () async {
        // Arrange
        await repository.addToFavorites('field-1');
        await repository.addToFavorites('field-2');
        await repository.addToFavorites('field-3');

        // Act
        final result = await repository.clearAllFavorites();

        // Assert
        expect(result.isRight(), isTrue);

        final favorites = await repository.getFavoriteFieldIds();
        favorites.fold(
          (failure) => fail('Should not fail'),
          (ids) => expect(ids, isEmpty),
        );
      });
    });

    group('Data Persistence -', () {
      test('favorites should persist across repository instances', () async {
        // Arrange - Add favorites with first instance
        await repository.addToFavorites('field-1');
        await repository.addToFavorites('field-2');

        // Create new repository instance (simulating app restart)
        final sharedPreferences = await SharedPreferences.getInstance();
        final newDataSource = FavoritesLocalDataSourceImpl(
          sharedPreferences: sharedPreferences,
        );
        final newRepository = FavoritesRepositoryImpl(
          localDataSource: newDataSource,
        );

        // Act
        final result = await newRepository.getFavoriteFieldIds();

        // Assert
        result.fold((failure) => fail('Should not fail'), (ids) {
          expect(ids.length, equals(2));
          expect(ids, containsAll(['field-1', 'field-2']));
        });
      });
    });
  });
}
