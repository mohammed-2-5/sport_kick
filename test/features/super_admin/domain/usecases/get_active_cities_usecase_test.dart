import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/entities/city_entity.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_active_cities_usecase.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late GetActiveCitiesUseCase useCase;
  late MockSuperAdminRepository mockRepository;

  setUp(() {
    mockRepository = MockSuperAdminRepository();
    useCase = GetActiveCitiesUseCase(mockRepository);
  });

  group('GetActiveCitiesUseCase', () {
    final tCities = [
      CityEntity(
        id: 'city-1',
        name: 'Cairo',
        isActive: true,
        fieldsCount: 10,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      CityEntity(
        id: 'city-2',
        name: 'Alexandria',
        isActive: true,
        fieldsCount: 5,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    test(
      'should return List<CityEntity> when repository call succeeds',
      () async {
        // Arrange
        when(
          () => mockRepository.getActiveCities(),
        ).thenAnswer((_) async => Right(tCities));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        expect(result.getOrElse(() => []), equals(tCities));
        verify(() => mockRepository.getActiveCities()).called(1);
      },
    );

    test('should return only active cities (is_active = true)', () async {
      // Arrange
      when(
        () => mockRepository.getActiveCities(),
      ).thenAnswer((_) async => Right(tCities));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isRight(), true);
      final cities = result.getOrElse(() => []);
      expect(cities.every((city) => city.isActive), true);
    });

    test('should return ServerFailure when repository call fails', () async {
      // Arrange
      const tFailure = ServerFailure('Failed to get active cities');
      when(
        () => mockRepository.getActiveCities(),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, equals(const Left(tFailure)));
    });

    test('should call repository.getActiveCities() exactly once', () async {
      // Arrange
      when(
        () => mockRepository.getActiveCities(),
      ).thenAnswer((_) async => Right(tCities));

      // Act
      await useCase();

      // Assert
      verify(() => mockRepository.getActiveCities()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
