import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/delete_city_usecase.dart';

class MockSuperAdminRepository extends Mock implements SuperAdminRepository {}

void main() {
  late DeleteCityUseCase useCase;
  late MockSuperAdminRepository mockRepository;

  setUp(() {
    mockRepository = MockSuperAdminRepository();
    useCase = DeleteCityUseCase(repository: mockRepository);
  });

  group('DeleteCityUseCase', () {
    const tCityId = 'city-123';

    group('soft delete', () {
      test('should return Right(void) when soft delete succeeds', () async {
        // Arrange
        when(
          () => mockRepository.deleteCity(
            cityId: any(named: 'cityId'),
            hardDelete: any(named: 'hardDelete'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(cityId: tCityId, hardDelete: false);

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.deleteCity(cityId: tCityId, hardDelete: false),
        ).called(1);
      });
    });

    group('hard delete', () {
      test('should return Right(void) when hard delete succeeds', () async {
        // Arrange
        when(
          () => mockRepository.deleteCity(
            cityId: any(named: 'cityId'),
            hardDelete: any(named: 'hardDelete'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(cityId: tCityId, hardDelete: true);

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.deleteCity(cityId: tCityId, hardDelete: true),
        ).called(1);
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to delete city');
        when(
          () => mockRepository.deleteCity(
            cityId: any(named: 'cityId'),
            hardDelete: any(named: 'hardDelete'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(cityId: tCityId, hardDelete: false);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ValidationFailure when city has fields', () async {
        // Arrange
        const tFailure = ValidationFailure(
          'Cannot delete city with existing fields',
        );
        when(
          () => mockRepository.deleteCity(
            cityId: any(named: 'cityId'),
            hardDelete: any(named: 'hardDelete'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(cityId: tCityId, hardDelete: true);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ValidationFailure when city not found', () async {
        // Arrange
        const tFailure = ValidationFailure('City not found');
        when(
          () => mockRepository.deleteCity(
            cityId: any(named: 'cityId'),
            hardDelete: any(named: 'hardDelete'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(cityId: 'invalid-city', hardDelete: false);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
