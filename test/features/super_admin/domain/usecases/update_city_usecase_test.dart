import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/entities/city_entity.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/update_city_usecase.dart';

class MockSuperAdminRepository extends Mock implements SuperAdminRepository {}

void main() {
  late UpdateCityUseCase useCase;
  late MockSuperAdminRepository mockRepository;

  setUp(() {
    mockRepository = MockSuperAdminRepository();
    useCase = UpdateCityUseCase(repository: mockRepository);
  });

  group('UpdateCityUseCase', () {
    const tCityId = 'city-123';
    final tNow = DateTime(2026, 1, 7);
    final tUpdatedCity = CityEntity(
      id: tCityId,
      name: 'Updated City Name',
      isActive: true,
      fieldsCount: 10,
      createdAt: tNow,
      updatedAt: tNow,
    );

    group('successful update', () {
      test('should return updated city when update succeeds', () async {
        // Arrange
        when(
          () => mockRepository.updateCity(
            cityId: any(named: 'cityId'),
            name: any(named: 'name'),
            isActive: any(named: 'isActive'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedCity));

        // Act
        final result = await useCase(
          cityId: tCityId,
          name: 'Updated City Name',
        );

        // Assert
        expect(result, equals(Right(tUpdatedCity)));
      });

      test('should update only name when only name provided', () async {
        // Arrange
        when(
          () => mockRepository.updateCity(
            cityId: any(named: 'cityId'),
            name: any(named: 'name'),
            isActive: any(named: 'isActive'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedCity));

        // Act
        final result = await useCase(cityId: tCityId, name: 'New Name');

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.updateCity(
            cityId: tCityId,
            name: 'New Name',
            isActive: null,
          ),
        ).called(1);
      });

      test('should update only isActive when only isActive provided', () async {
        // Arrange
        final deactivatedCity = CityEntity(
          id: tCityId,
          name: 'City',
          isActive: false,
          fieldsCount: 5,
          createdAt: tNow,
          updatedAt: tNow,
        );

        when(
          () => mockRepository.updateCity(
            cityId: any(named: 'cityId'),
            name: any(named: 'name'),
            isActive: any(named: 'isActive'),
          ),
        ).thenAnswer((_) async => Right(deactivatedCity));

        // Act
        final result = await useCase(cityId: tCityId, isActive: false);

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.updateCity(
            cityId: tCityId,
            name: null,
            isActive: false,
          ),
        ).called(1);
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.updateCity(
            cityId: any(named: 'cityId'),
            name: any(named: 'name'),
            isActive: any(named: 'isActive'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedCity));

        // Act
        await useCase(cityId: tCityId, name: 'Test');

        // Assert
        verify(
          () => mockRepository.updateCity(
            cityId: tCityId,
            name: 'Test',
            isActive: null,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to update city');
        when(
          () => mockRepository.updateCity(
            cityId: any(named: 'cityId'),
            name: any(named: 'name'),
            isActive: any(named: 'isActive'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(cityId: tCityId, name: 'Test');

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ValidationFailure when city not found', () async {
        // Arrange
        const tFailure = ValidationFailure('City not found');
        when(
          () => mockRepository.updateCity(
            cityId: any(named: 'cityId'),
            name: any(named: 'name'),
            isActive: any(named: 'isActive'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(cityId: 'invalid-city', name: 'Test');

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
