import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/delete_sport_category_usecase.dart';

class MockSuperAdminRepository extends Mock implements SuperAdminRepository {}

void main() {
  late DeleteSportCategoryUseCase useCase;
  late MockSuperAdminRepository mockRepository;

  setUp(() {
    mockRepository = MockSuperAdminRepository();
    useCase = DeleteSportCategoryUseCase(mockRepository);
  });

  group('DeleteSportCategoryUseCase', () {
    const tCategoryId = 'cat-123';

    group('successful deletion', () {
      test('should return Right(void) when deletion succeeds', () async {
        // Arrange
        when(
          () => mockRepository.deleteSportCategory(
            categoryId: any(named: 'categoryId'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(categoryId: tCategoryId);

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.deleteSportCategory(categoryId: tCategoryId),
        ).called(1);
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.deleteSportCategory(
            categoryId: any(named: 'categoryId'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await useCase(categoryId: tCategoryId);

        // Assert
        verify(
          () => mockRepository.deleteSportCategory(categoryId: tCategoryId),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to delete category');
        when(
          () => mockRepository.deleteSportCategory(
            categoryId: any(named: 'categoryId'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(categoryId: tCategoryId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test(
        'should return ValidationFailure when fields use category',
        () async {
          // Arrange
          const tFailure = ValidationFailure(
            'Cannot delete category with existing fields',
          );
          when(
            () => mockRepository.deleteSportCategory(
              categoryId: any(named: 'categoryId'),
            ),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(categoryId: tCategoryId);

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );

      test('should return ValidationFailure when category not found', () async {
        // Arrange
        const tFailure = ValidationFailure('Category not found');
        when(
          () => mockRepository.deleteSportCategory(
            categoryId: any(named: 'categoryId'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(categoryId: 'invalid');

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when not authorized', () async {
        // Arrange
        const tFailure = AuthFailure('Only super admin can delete categories');
        when(
          () => mockRepository.deleteSportCategory(
            categoryId: any(named: 'categoryId'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(categoryId: tCategoryId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
