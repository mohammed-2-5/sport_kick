import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:spo_kick/features/favorites/domain/usecases/is_favorite_usecase.dart';

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  late IsFavoriteUseCase useCase;
  late MockFavoritesRepository mockRepository;

  setUp(() {
    mockRepository = MockFavoritesRepository();
    useCase = IsFavoriteUseCase(mockRepository);
  });

  group('IsFavoriteUseCase', () {
    const tFieldId = 'field-123';

    group('successful check', () {
      test('should return true when field is favorited', () async {
        // Arrange
        when(
          () => mockRepository.isFavorite(any()),
        ).thenAnswer((_) async => const Right(true));

        // Act
        final result = await useCase(tFieldId);

        // Assert
        expect(result, equals(const Right(true)));
        verify(() => mockRepository.isFavorite(tFieldId)).called(1);
      });

      test('should return false when field is not favorited', () async {
        // Arrange
        when(
          () => mockRepository.isFavorite(any()),
        ).thenAnswer((_) async => const Right(false));

        // Act
        final result = await useCase(tFieldId);

        // Assert
        expect(result, equals(const Right(false)));
      });

      test('should handle different field IDs', () async {
        final fieldIds = ['field-1', 'field-2', 'field-3'];

        for (final fieldId in fieldIds) {
          // Arrange
          when(
            () => mockRepository.isFavorite(any()),
          ).thenAnswer((_) async => const Right(true));

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
          () => mockRepository.isFavorite(any()),
        ).thenAnswer((_) async => const Right(true));

        // Act
        final result = await useCase(uuidFieldId);

        // Assert
        expect(result.isRight(), true);
        verify(() => mockRepository.isFavorite(uuidFieldId)).called(1);
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.isFavorite(any()),
        ).thenAnswer((_) async => const Right(true));

        // Act
        await useCase(tFieldId);

        // Assert
        verify(() => mockRepository.isFavorite(tFieldId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should return consistent results for same field', () async {
        // Arrange
        when(
          () => mockRepository.isFavorite(any()),
        ).thenAnswer((_) async => const Right(true));

        // Act
        final result1 = await useCase(tFieldId);
        final result2 = await useCase(tFieldId);

        // Assert
        result1.fold(
          (_) => fail('Should return Right'),
          (isFav1) => result2.fold(
            (_) => fail('Should return Right'),
            (isFav2) => expect(isFav1, isFav2),
          ),
        );
      });
    });

    group('failures', () {
      test('should return CacheFailure when cache fails', () async {
        // Arrange
        const tFailure = CacheFailure('Failed to check favorite status');
        when(
          () => mockRepository.isFavorite(any()),
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
          () => mockRepository.isFavorite(any()),
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
          () => mockRepository.isFavorite(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tFieldId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
