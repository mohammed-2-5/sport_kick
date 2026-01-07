import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/city/domain/repositories/city_repository.dart';
import 'package:spo_kick/features/city/domain/usecases/clear_selected_city_usecase.dart';

class MockCityRepository extends Mock implements CityRepository {}

void main() {
  late ClearSelectedCityUseCase useCase;
  late MockCityRepository mockRepository;

  setUp(() {
    mockRepository = MockCityRepository();
    useCase = ClearSelectedCityUseCase(mockRepository);
  });

  group('ClearSelectedCityUseCase', () {
    group('successful clear', () {
      test('should return Right(void) when clear succeeds', () async {
        // Arrange
        when(
          () => mockRepository.clearSelectedCity(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        verify(() => mockRepository.clearSelectedCity()).called(1);
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.clearSelectedCity(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await useCase();

        // Assert
        verify(() => mockRepository.clearSelectedCity()).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should succeed even when no city was selected', () async {
        // Arrange
        when(
          () => mockRepository.clearSelectedCity(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
      });

      test('should allow multiple clears', () async {
        // Arrange
        when(
          () => mockRepository.clearSelectedCity(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await useCase();
        await useCase();
        await useCase();

        // Assert
        verify(() => mockRepository.clearSelectedCity()).called(3);
      });
    });

    group('failures', () {
      test('should return CacheFailure when clear fails', () async {
        // Arrange
        const tFailure = CacheFailure('Failed to clear selected city');
        when(
          () => mockRepository.clearSelectedCity(),
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
          () => mockRepository.clearSelectedCity(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
