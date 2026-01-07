import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/sport_category_entity.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/update_sport_category_usecase.dart';

class MockSuperAdminRepository extends Mock implements SuperAdminRepository {}

void main() {
  late UpdateSportCategoryUseCase useCase;
  late MockSuperAdminRepository mockRepository;

  setUp(() {
    mockRepository = MockSuperAdminRepository();
    useCase = UpdateSportCategoryUseCase(mockRepository);
  });

  group('UpdateSportCategoryUseCase', () {
    const tCategoryId = 'cat-123';
    final tNow = DateTime(2026, 1, 7);
    final tUpdatedCategory = SportCategoryEntity(
      id: tCategoryId,
      name: 'Updated Basketball',
      icon: '🏀',
      description: 'Updated description',
      createdAt: tNow,
    );

    group('successful update', () {
      test('should return updated category when update succeeds', () async {
        // Arrange
        when(
          () => mockRepository.updateSportCategory(
            categoryId: any(named: 'categoryId'),
            name: any(named: 'name'),
            icon: any(named: 'icon'),
            description: any(named: 'description'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedCategory));

        // Act
        final result = await useCase(
          categoryId: tCategoryId,
          name: 'Updated Basketball',
        );

        // Assert
        expect(result, equals(Right(tUpdatedCategory)));
      });

      test('should update only name when only name provided', () async {
        // Arrange
        when(
          () => mockRepository.updateSportCategory(
            categoryId: any(named: 'categoryId'),
            name: any(named: 'name'),
            icon: any(named: 'icon'),
            description: any(named: 'description'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedCategory));

        // Act
        await useCase(categoryId: tCategoryId, name: 'New Name');

        // Assert
        verify(
          () => mockRepository.updateSportCategory(
            categoryId: tCategoryId,
            name: 'New Name',
            icon: null,
            description: null,
          ),
        ).called(1);
      });

      test('should update icon only', () async {
        // Arrange
        when(
          () => mockRepository.updateSportCategory(
            categoryId: any(named: 'categoryId'),
            name: any(named: 'name'),
            icon: any(named: 'icon'),
            description: any(named: 'description'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedCategory));

        // Act
        await useCase(categoryId: tCategoryId, icon: '⚽');

        // Assert
        verify(
          () => mockRepository.updateSportCategory(
            categoryId: tCategoryId,
            name: null,
            icon: '⚽',
            description: null,
          ),
        ).called(1);
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.updateSportCategory(
            categoryId: any(named: 'categoryId'),
            name: any(named: 'name'),
            icon: any(named: 'icon'),
            description: any(named: 'description'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedCategory));

        // Act
        await useCase(categoryId: tCategoryId, name: 'Test');

        // Assert
        verify(
          () => mockRepository.updateSportCategory(
            categoryId: tCategoryId,
            name: 'Test',
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
        const tFailure = ServerFailure('Failed to update category');
        when(
          () => mockRepository.updateSportCategory(
            categoryId: any(named: 'categoryId'),
            name: any(named: 'name'),
            icon: any(named: 'icon'),
            description: any(named: 'description'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(categoryId: tCategoryId, name: 'Test');

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ValidationFailure when category not found', () async {
        // Arrange
        const tFailure = ValidationFailure('Category not found');
        when(
          () => mockRepository.updateSportCategory(
            categoryId: any(named: 'categoryId'),
            name: any(named: 'name'),
            icon: any(named: 'icon'),
            description: any(named: 'description'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(categoryId: 'invalid', name: 'Test');

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
