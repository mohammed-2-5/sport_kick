import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/entities/city_entity.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/create_city_usecase.dart';

class MockSuperAdminRepository extends Mock implements SuperAdminRepository {}

void main() {
  late CreateCityUseCase useCase;
  late MockSuperAdminRepository mockRepository;

  setUp(() {
    mockRepository = MockSuperAdminRepository();
    useCase = CreateCityUseCase(repository: mockRepository);
  });

  group('CreateCityUseCase', () {
    const tCityName = 'Alexandria';
    final tNow = DateTime(2026, 1, 7);
    final tCity = CityEntity(
      id: 'city-123',
      name: tCityName,
      isActive: true,
      fieldsCount: 0,
      createdAt: tNow,
      updatedAt: tNow,
    );

    group('successful creation', () {
      test('should return city when creation succeeds', () async {
        // Arrange
        when(
          () => mockRepository.createCity(
            name: any(named: 'name'),
            isActive: any(named: 'isActive'),
          ),
        ).thenAnswer((_) async => Right(tCity));

        // Act
        final result = await useCase(name: tCityName);

        // Assert
        expect(result, equals(Right(tCity)));
        verify(
          () => mockRepository.createCity(name: tCityName, isActive: true),
        ).called(1);
      });

      test('should create inactive city when isActive is false', () async {
        // Arrange
        final inactiveCity = CityEntity(
          id: 'city-123',
          name: tCityName,
          isActive: false,
          fieldsCount: 0,
          createdAt: tNow,
          updatedAt: tNow,
        );

        when(
          () => mockRepository.createCity(
            name: any(named: 'name'),
            isActive: any(named: 'isActive'),
          ),
        ).thenAnswer((_) async => Right(inactiveCity));

        // Act
        final result = await useCase(name: tCityName, isActive: false);

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.createCity(name: tCityName, isActive: false),
        ).called(1);
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.createCity(
            name: any(named: 'name'),
            isActive: any(named: 'isActive'),
          ),
        ).thenAnswer((_) async => Right(tCity));

        // Act
        await useCase(name: tCityName);

        // Assert
        verify(
          () => mockRepository.createCity(name: tCityName, isActive: true),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to create city');
        when(
          () => mockRepository.createCity(
            name: any(named: 'name'),
            isActive: any(named: 'isActive'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(name: tCityName);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ValidationFailure for duplicate city name', () async {
        // Arrange
        const tFailure = ValidationFailure(
          'City with this name already exists',
        );
        when(
          () => mockRepository.createCity(
            name: any(named: 'name'),
            isActive: any(named: 'isActive'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(name: tCityName);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when not authorized', () async {
        // Arrange
        const tFailure = AuthFailure('Only super admin can create cities');
        when(
          () => mockRepository.createCity(
            name: any(named: 'name'),
            isActive: any(named: 'isActive'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(name: tCityName);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
