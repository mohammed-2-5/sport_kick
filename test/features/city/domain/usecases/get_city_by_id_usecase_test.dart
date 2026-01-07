import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/city/domain/entities/city_entity.dart';
import 'package:spo_kick/features/city/domain/repositories/city_repository.dart';
import 'package:spo_kick/features/city/domain/usecases/get_city_by_id_usecase.dart';

class MockCityRepository extends Mock implements CityRepository {}

void main() {
  late GetCityByIdUseCase useCase;
  late MockCityRepository mockRepository;

  setUp(() {
    mockRepository = MockCityRepository();
    useCase = GetCityByIdUseCase(mockRepository);
  });

  group('GetCityByIdUseCase', () {
    const tCityId = 'city-123';
    final tCity = CityEntity(
      id: tCityId,
      name: 'Cairo',
      arabicName: 'القاهرة',
      isActive: true,
      fieldsCount: 25,
      createdAt: DateTime(2026, 1, 1),
    );

    group('successful retrieval', () {
      test('should return city when call succeeds', () async {
        // Arrange
        when(
          () => mockRepository.getCityById(any()),
        ).thenAnswer((_) async => Right(tCity));

        // Act
        final result = await useCase(tCityId);

        // Assert
        expect(result, equals(Right(tCity)));
        verify(() => mockRepository.getCityById(tCityId)).called(1);
      });

      test('should return city with all properties', () async {
        // Arrange
        when(
          () => mockRepository.getCityById(any()),
        ).thenAnswer((_) async => Right(tCity));

        // Act
        final result = await useCase(tCityId);

        // Assert
        result.fold((_) => fail('Should return Right'), (city) {
          expect(city.id, tCityId);
          expect(city.name, 'Cairo');
          expect(city.arabicName, 'القاهرة');
          expect(city.isActive, true);
          expect(city.fieldsCount, 25);
        });
      });

      test('should handle different city IDs', () async {
        final cityIds = ['city-1', 'city-2', 'city-3'];

        for (final cityId in cityIds) {
          // Arrange
          when(
            () => mockRepository.getCityById(any()),
          ).thenAnswer((_) async => Right(tCity.copyWith(id: cityId)));

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
          () => mockRepository.getCityById(any()),
        ).thenAnswer((_) async => Right(tCity.copyWith(id: uuidCityId)));

        // Act
        final result = await useCase(uuidCityId);

        // Assert
        expect(result.isRight(), true);
        verify(() => mockRepository.getCityById(uuidCityId)).called(1);
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.getCityById(any()),
        ).thenAnswer((_) async => Right(tCity));

        // Act
        await useCase(tCityId);

        // Assert
        verify(() => mockRepository.getCityById(tCityId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to fetch city');
        when(
          () => mockRepository.getCityById(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tCityId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ValidationFailure when city not found', () async {
        // Arrange
        const tFailure = ValidationFailure('City not found');
        when(
          () => mockRepository.getCityById(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase('non-existent-city');

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure on network error', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.getCityById(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tCityId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
