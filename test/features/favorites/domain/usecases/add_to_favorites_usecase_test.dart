import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:spo_kick/features/favorites/domain/usecases/add_to_favorites_usecase.dart';

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  late AddToFavoritesUseCase useCase;
  late MockFavoritesRepository mockRepository;

  setUp(() {
    mockRepository = MockFavoritesRepository();
    useCase = AddToFavoritesUseCase(mockRepository);
  });

  group('AddToFavoritesUseCase', () {
    const tFieldId = 'field-123';

    group('successful add', () {
      test('should return Right(void) when add succeeds', () async {
        // Arrange
        when(
          () => mockRepository.addToFavorites(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(tFieldId);

        // Assert
        expect(result.isRight(), true);
        verify(() => mockRepository.addToFavorites(tFieldId)).called(1);
      });

      test('should handle different field IDs', () async {
        final fieldIds = ['field-1', 'field-2', 'field-3'];

        for (final fieldId in fieldIds) {
          // Arrange
          when(
            () => mockRepository.addToFavorites(any()),
          ).thenAnswer((_) async => const Right(null));

          // Act
          final result = await useCase(fieldId);

          // Assert
          expect(result.isRight(), true);
        }
      });

      test('should handle UUID format field IDs', () async {
        // Arrange
        const uuidFieldId = '550e8400-e29b-41d4-a716-446655440000';
        when(
          () => mockRepository.addToFavorites(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(uuidFieldId);

        // Assert
        expect(result.isRight(), true);
        verify(() => mockRepository.addToFavorites(uuidFieldId)).called(1);
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.addToFavorites(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await useCase(tFieldId);

        // Assert
        verify(() => mockRepository.addToFavorites(tFieldId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should succeed when field already favorited (no-op)', () async {
        // Arrange
        when(
          () => mockRepository.addToFavorites(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act - add twice
        await useCase(tFieldId);
        await useCase(tFieldId);

        // Assert
        verify(() => mockRepository.addToFavorites(tFieldId)).called(2);
      });
    });

    group('failures', () {
      test('should return CacheFailure when cache fails', () async {
        // Arrange
        const tFailure = CacheFailure('Failed to save favorite');
        when(
          () => mockRepository.addToFavorites(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tFieldId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure on server error', () async {
        // Arrange
        const tFailure = ServerFailure('Server error');
        when(
          () => mockRepository.addToFavorites(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tFieldId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when not authenticated', () async {
        // Arrange
        const tFailure = AuthFailure('User not authenticated');
        when(
          () => mockRepository.addToFavorites(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tFieldId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
