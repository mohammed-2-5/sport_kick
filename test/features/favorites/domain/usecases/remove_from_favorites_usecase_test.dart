import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:spo_kick/features/favorites/domain/usecases/remove_from_favorites_usecase.dart';

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  late RemoveFromFavoritesUseCase useCase;
  late MockFavoritesRepository mockRepository;

  setUp(() {
    mockRepository = MockFavoritesRepository();
    useCase = RemoveFromFavoritesUseCase(mockRepository);
  });

  group('RemoveFromFavoritesUseCase', () {
    const tFieldId = 'field-123';

    group('successful removal', () {
      test('should return Right(void) when removal succeeds', () async {
        // Arrange
        when(
          () => mockRepository.removeFromFavorites(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(tFieldId);

        // Assert
        expect(result.isRight(), true);
        verify(() => mockRepository.removeFromFavorites(tFieldId)).called(1);
      });

      test('should handle different field IDs', () async {
        final fieldIds = ['field-1', 'field-2', 'field-3'];

        for (final fieldId in fieldIds) {
          // Arrange
          when(
            () => mockRepository.removeFromFavorites(any()),
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
          () => mockRepository.removeFromFavorites(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(uuidFieldId);

        // Assert
        expect(result.isRight(), true);
        verify(() => mockRepository.removeFromFavorites(uuidFieldId)).called(1);
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.removeFromFavorites(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await useCase(tFieldId);

        // Assert
        verify(() => mockRepository.removeFromFavorites(tFieldId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should succeed when field not in favorites (no-op)', () async {
        // Arrange
        when(
          () => mockRepository.removeFromFavorites(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase('non-favorited-field');

        // Assert
        expect(result.isRight(), true);
      });
    });

    group('failures', () {
      test('should return CacheFailure when cache fails', () async {
        // Arrange
        const tFailure = CacheFailure('Failed to remove favorite');
        when(
          () => mockRepository.removeFromFavorites(any()),
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
          () => mockRepository.removeFromFavorites(any()),
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
          () => mockRepository.removeFromFavorites(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tFieldId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
