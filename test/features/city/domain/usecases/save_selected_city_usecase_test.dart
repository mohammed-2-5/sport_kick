import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/city/domain/repositories/city_repository.dart';
import 'package:spo_kick/features/city/domain/usecases/save_selected_city_usecase.dart';

class MockCityRepository extends Mock implements CityRepository {}

void main() {
  late SaveSelectedCityUseCase useCase;
  late MockCityRepository mockRepository;

  setUp(() {
    mockRepository = MockCityRepository();
    useCase = SaveSelectedCityUseCase(mockRepository);
  });

  group('SaveSelectedCityUseCase', () {
    const tCityId = 'city-123';

    group('successful save', () {
      test('should return Right(void) when save succeeds', () async {
        // Arrange
        when(
          () => mockRepository.saveSelectedCity(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(tCityId);

        // Assert
        expect(result.isRight(), true);
        verify(() => mockRepository.saveSelectedCity(tCityId)).called(1);
      });

      test('should save different city IDs', () async {
        final cityIds = ['city-1', 'city-2', 'city-3'];

        for (final cityId in cityIds) {
          // Arrange
          when(
            () => mockRepository.saveSelectedCity(any()),
          ).thenAnswer((_) async => const Right(null));

          // Act
          final result = await useCase(cityId);

          // Assert
          expect(result.isRight(), true);
        }
      });

      test('should handle UUID format city IDs', () async {
        // Arrange
        const uuidCityId = '550e8400-e29b-41d4-a716-446655440000';
        when(
          () => mockRepository.saveSelectedCity(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(uuidCityId);

        // Assert
        expect(result.isRight(), true);
        verify(() => mockRepository.saveSelectedCity(uuidCityId)).called(1);
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.saveSelectedCity(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await useCase(tCityId);

        // Assert
        verify(() => mockRepository.saveSelectedCity(tCityId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should overwrite previous selection', () async {
        // Arrange
        when(
          () => mockRepository.saveSelectedCity(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act - save first city
        await useCase('city-1');
        // Act - save second city (overwrites)
        await useCase('city-2');

        // Assert
        verify(() => mockRepository.saveSelectedCity('city-1')).called(1);
        verify(() => mockRepository.saveSelectedCity('city-2')).called(1);
      });
    });

    group('failures', () {
      test('should return CacheFailure when save fails', () async {
        // Arrange
        const tFailure = CacheFailure('Failed to save selected city');
        when(
          () => mockRepository.saveSelectedCity(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tCityId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ValidationFailure for invalid city ID', () async {
        // Arrange
        const tFailure = ValidationFailure('Invalid city ID');
        when(
          () => mockRepository.saveSelectedCity(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase('invalid-id');

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure on server error', () async {
        // Arrange
        const tFailure = ServerFailure('Server error');
        when(
          () => mockRepository.saveSelectedCity(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tCityId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
