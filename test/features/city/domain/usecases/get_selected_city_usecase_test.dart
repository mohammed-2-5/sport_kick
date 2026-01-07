import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/city/domain/repositories/city_repository.dart';
import 'package:spo_kick/features/city/domain/usecases/get_selected_city_usecase.dart';

class MockCityRepository extends Mock implements CityRepository {}

void main() {
  late GetSelectedCityUseCase useCase;
  late MockCityRepository mockRepository;

  setUp(() {
    mockRepository = MockCityRepository();
    useCase = GetSelectedCityUseCase(mockRepository);
  });

  group('GetSelectedCityUseCase', () {
    const tCityId = 'city-123';

    group('successful retrieval', () {
      test('should return city ID when selection exists', () async {
        // Arrange
        when(
          () => mockRepository.getSelectedCityId(),
        ).thenAnswer((_) async => const Right(tCityId));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Right(tCityId)));
        verify(() => mockRepository.getSelectedCityId()).called(1);
      });

      test('should return null when no city selected', () async {
        // Arrange
        when(
          () => mockRepository.getSelectedCityId(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should return Right'),
          (cityId) => expect(cityId, isNull),
        );
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.getSelectedCityId(),
        ).thenAnswer((_) async => const Right(tCityId));

        // Act
        await useCase();

        // Assert
        verify(() => mockRepository.getSelectedCityId()).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should return different city IDs', () async {
        final cityIds = ['city-1', 'city-2', 'city-3'];

        for (final cityId in cityIds) {
          // Arrange
          when(
            () => mockRepository.getSelectedCityId(),
          ).thenAnswer((_) async => Right(cityId));

          // Act
          final result = await useCase();

          // Assert
          result.fold(
            (_) => fail('Should return Right'),
            (id) => expect(id, cityId),
          );
        }
      });

      test('should return UUID format city IDs', () async {
        // Arrange
        const uuidCityId = '550e8400-e29b-41d4-a716-446655440000';
        when(
          () => mockRepository.getSelectedCityId(),
        ).thenAnswer((_) async => const Right(uuidCityId));

        // Act
        final result = await useCase();

        // Assert
        result.fold(
          (_) => fail('Should return Right'),
          (cityId) => expect(cityId, uuidCityId),
        );
      });
    });

    group('failures', () {
      test('should return CacheFailure when cache fails', () async {
        // Arrange
        const tFailure = CacheFailure('Failed to get selected city');
        when(
          () => mockRepository.getSelectedCityId(),
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
          () => mockRepository.getSelectedCityId(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
