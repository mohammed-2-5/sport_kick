import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/city/domain/entities/city_entity.dart';
import 'package:spo_kick/features/city/domain/repositories/city_repository.dart';
import 'package:spo_kick/features/city/domain/usecases/get_cities_usecase.dart';

class MockCityRepository extends Mock implements CityRepository {}

void main() {
  late GetCitiesUseCase useCase;
  late MockCityRepository mockRepository;

  setUp(() {
    mockRepository = MockCityRepository();
    useCase = GetCitiesUseCase(mockRepository);
  });

  group('GetCitiesUseCase', () {
    final tCities = [
      CityEntity(
        id: 'city-1',
        name: 'Cairo',
        arabicName: 'القاهرة',
        isActive: true,
        fieldsCount: 25,
        createdAt: DateTime(2026, 1, 1),
      ),
      CityEntity(
        id: 'city-2',
        name: 'Alexandria',
        arabicName: 'الإسكندرية',
        isActive: true,
        fieldsCount: 15,
        createdAt: DateTime(2026, 1, 2),
      ),
      CityEntity(
        id: 'city-3',
        name: 'Giza',
        arabicName: 'الجيزة',
        isActive: true,
        fieldsCount: 10,
        createdAt: DateTime(2026, 1, 3),
      ),
    ];

    group('successful retrieval', () {
      test('should return list of cities when call succeeds', () async {
        // Arrange
        when(
          () => mockRepository.getCities(),
        ).thenAnswer((_) async => Right(tCities));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(Right(tCities)));
        verify(() => mockRepository.getCities()).called(1);
      });

      test('should return empty list when no cities exist', () async {
        // Arrange
        when(
          () => mockRepository.getCities(),
        ).thenAnswer((_) async => const Right([]));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should return Right'),
          (cities) => expect(cities, isEmpty),
        );
      });

      test('should return only active cities', () async {
        // Arrange
        when(
          () => mockRepository.getCities(),
        ).thenAnswer((_) async => Right(tCities));

        // Act
        final result = await useCase();

        // Assert
        result.fold((_) => fail('Should return Right'), (cities) {
          for (final city in cities) {
            expect(city.isActive, true);
          }
        });
      });

      test('should return cities with Arabic names', () async {
        // Arrange
        when(
          () => mockRepository.getCities(),
        ).thenAnswer((_) async => Right(tCities));

        // Act
        final result = await useCase();

        // Assert
        result.fold((_) => fail('Should return Right'), (cities) {
          expect(cities[0].arabicName, 'القاهرة');
          expect(cities[1].arabicName, 'الإسكندرية');
        });
      });

      test('should return cities with field counts', () async {
        // Arrange
        when(
          () => mockRepository.getCities(),
        ).thenAnswer((_) async => Right(tCities));

        // Act
        final result = await useCase();

        // Assert
        result.fold((_) => fail('Should return Right'), (cities) {
          expect(cities[0].fieldsCount, 25);
          expect(cities[1].fieldsCount, 15);
        });
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.getCities(),
        ).thenAnswer((_) async => Right(tCities));

        // Act
        await useCase();

        // Assert
        verify(() => mockRepository.getCities()).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to fetch cities');
        when(
          () => mockRepository.getCities(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure on network error', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.getCities(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return CacheFailure on cache error', () async {
        // Arrange
        const tFailure = CacheFailure('Cache error');
        when(
          () => mockRepository.getCities(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
