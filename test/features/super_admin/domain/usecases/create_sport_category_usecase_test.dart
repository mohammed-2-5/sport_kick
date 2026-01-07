import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/sport_category_entity.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/create_sport_category_usecase.dart';

class MockSuperAdminRepository extends Mock implements SuperAdminRepository {}

void main() {
  late CreateSportCategoryUseCase useCase;
  late MockSuperAdminRepository mockRepository;

  setUp(() {
    mockRepository = MockSuperAdminRepository();
    useCase = CreateSportCategoryUseCase(mockRepository);
  });

  group('CreateSportCategoryUseCase', () {
    final tNow = DateTime(2026, 1, 7);
    final tCategory = SportCategoryEntity(
      id: 'cat-123',
      name: 'Basketball',
      icon: '🏀',
      description: 'Basketball courts',
      createdAt: tNow,
    );

    group('successful creation', () {
      test('should return category when creation succeeds', () async {
        // Arrange
        when(
          () => mockRepository.createSportCategory(
            name: any(named: 'name'),
            icon: any(named: 'icon'),
            description: any(named: 'description'),
          ),
        ).thenAnswer((_) async => Right(tCategory));

        // Act
        final result = await useCase(
          name: 'Basketball',
          icon: '🏀',
          description: 'Basketball courts',
        );

        // Assert
        expect(result, equals(Right(tCategory)));
      });

      test('should create category without icon and description', () async {
        // Arrange
        final basicCategory = SportCategoryEntity(
          id: 'cat-123',
          name: 'Tennis',
          createdAt: tNow,
        );

        when(
          () => mockRepository.createSportCategory(
            name: any(named: 'name'),
            icon: any(named: 'icon'),
            description: any(named: 'description'),
          ),
        ).thenAnswer((_) async => Right(basicCategory));

        // Act
        final result = await useCase(name: 'Tennis');

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.createSportCategory(
            name: 'Tennis',
            icon: null,
            description: null,
          ),
        ).called(1);
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.createSportCategory(
            name: any(named: 'name'),
            icon: any(named: 'icon'),
            description: any(named: 'description'),
          ),
        ).thenAnswer((_) async => Right(tCategory));

        // Act
        await useCase(name: 'Basketball');

        // Assert
        verify(
          () => mockRepository.createSportCategory(
            name: 'Basketball',
            icon: null,
            description: null,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to create sport category');
        when(
          () => mockRepository.createSportCategory(
            name: any(named: 'name'),
            icon: any(named: 'icon'),
            description: any(named: 'description'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(name: 'Basketball');

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ValidationFailure for duplicate name', () async {
        // Arrange
        const tFailure = ValidationFailure('Sport category already exists');
        when(
          () => mockRepository.createSportCategory(
            name: any(named: 'name'),
            icon: any(named: 'icon'),
            description: any(named: 'description'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(name: 'Football');

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when not authorized', () async {
        // Arrange
        const tFailure = AuthFailure('Only super admin can create categories');
        when(
          () => mockRepository.createSportCategory(
            name: any(named: 'name'),
            icon: any(named: 'icon'),
            description: any(named: 'description'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(name: 'Basketball');

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
