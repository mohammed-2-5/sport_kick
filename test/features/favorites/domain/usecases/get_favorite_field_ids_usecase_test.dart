import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:spo_kick/features/favorites/domain/usecases/get_favorite_field_ids_usecase.dart';

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  late GetFavoriteFieldIdsUseCase useCase;
  late MockFavoritesRepository mockRepository;

  setUp(() {
    mockRepository = MockFavoritesRepository();
    useCase = GetFavoriteFieldIdsUseCase(mockRepository);
  });

  group('GetFavoriteFieldIdsUseCase', () {
    final tFavoriteIds = ['field-1', 'field-2', 'field-3'];

    group('successful retrieval', () {
      test('should return list of favorite IDs when call succeeds', () async {
        // Arrange
        when(
          () => mockRepository.getFavoriteFieldIds(),
        ).thenAnswer((_) async => Right(tFavoriteIds));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(Right(tFavoriteIds)));
        verify(() => mockRepository.getFavoriteFieldIds()).called(1);
      });

      test('should return empty list when no favorites exist', () async {
        // Arrange
        when(
          () => mockRepository.getFavoriteFieldIds(),
        ).thenAnswer((_) async => const Right([]));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should return Right'),
          (ids) => expect(ids, isEmpty),
        );
      });

      test('should return single favorite', () async {
        // Arrange
        when(
          () => mockRepository.getFavoriteFieldIds(),
        ).thenAnswer((_) async => const Right(['single-field']));

        // Act
        final result = await useCase();

        // Assert
        result.fold((_) => fail('Should return Right'), (ids) {
          expect(ids.length, 1);
          expect(ids.first, 'single-field');
        });
      });

      test('should return many favorites', () async {
        // Arrange
        final manyFavorites = List.generate(50, (i) => 'field-$i');
        when(
          () => mockRepository.getFavoriteFieldIds(),
        ).thenAnswer((_) async => Right(manyFavorites));

        // Act
        final result = await useCase();

        // Assert
        result.fold(
          (_) => fail('Should return Right'),
          (ids) => expect(ids.length, 50),
        );
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.getFavoriteFieldIds(),
        ).thenAnswer((_) async => Right(tFavoriteIds));

        // Act
        await useCase();

        // Assert
        verify(() => mockRepository.getFavoriteFieldIds()).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should return UUID format field IDs', () async {
        // Arrange
        final uuidFavorites = [
          '550e8400-e29b-41d4-a716-446655440000',
          '6ba7b810-9dad-11d1-80b4-00c04fd430c8',
        ];
        when(
          () => mockRepository.getFavoriteFieldIds(),
        ).thenAnswer((_) async => Right(uuidFavorites));

        // Act
        final result = await useCase();

        // Assert
        result.fold(
          (_) => fail('Should return Right'),
          (ids) => expect(ids, uuidFavorites),
        );
      });
    });

    group('failures', () {
      test('should return CacheFailure when cache fails', () async {
        // Arrange
        const tFailure = CacheFailure('Failed to get favorites');
        when(
          () => mockRepository.getFavoriteFieldIds(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure on server error', () async {
        // Arrange
        const tFailure = ServerFailure('Server error');
        when(
          () => mockRepository.getFavoriteFieldIds(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when not authenticated', () async {
        // Arrange
        const tFailure = AuthFailure('User not authenticated');
        when(
          () => mockRepository.getFavoriteFieldIds(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
