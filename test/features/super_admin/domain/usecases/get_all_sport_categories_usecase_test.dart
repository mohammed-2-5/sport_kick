import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/sport_category_entity.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_sport_categories_usecase.dart';

class MockSuperAdminRepository extends Mock implements SuperAdminRepository {}

void main() {
  late GetAllSportCategoriesUseCase useCase;
  late MockSuperAdminRepository mockRepository;

  setUp(() {
    mockRepository = MockSuperAdminRepository();
    useCase = GetAllSportCategoriesUseCase(mockRepository);
  });

  group('GetAllSportCategoriesUseCase', () {
    final tNow = DateTime(2026, 1, 7);
    final tCategories = <SportCategoryEntity>[
      SportCategoryEntity(
        id: 'cat-1',
        name: 'Football',
        icon: '⚽',
        description: 'Football fields',
        createdAt: tNow,
      ),
      SportCategoryEntity(
        id: 'cat-2',
        name: 'Basketball',
        icon: '🏀',
        description: 'Basketball courts',
        createdAt: tNow,
      ),
      SportCategoryEntity(
        id: 'cat-3',
        name: 'Tennis',
        icon: '🎾',
        createdAt: tNow,
      ),
    ];

    group('successful retrieval', () {
      test('should return list of categories when call succeeds', () async {
        // Arrange
        when(
          () => mockRepository.getAllSportCategories(),
        ).thenAnswer((_) async => Right(tCategories));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(Right(tCategories)));
        verify(() => mockRepository.getAllSportCategories()).called(1);
      });

      test('should return empty list when no categories exist', () async {
        // Arrange
        when(
          () => mockRepository.getAllSportCategories(),
        ).thenAnswer((_) async => const Right(<SportCategoryEntity>[]));

        // Act
        final result = await useCase();

        // Assert
        result.fold(
          (_) => fail('Should return Right'),
          (categories) => expect(categories, isEmpty),
        );
      });

      test('should return categories with all properties', () async {
        // Arrange
        when(
          () => mockRepository.getAllSportCategories(),
        ).thenAnswer((_) async => Right(tCategories));

        // Act
        final result = await useCase();

        // Assert
        result.fold((_) => fail('Should return Right'), (categories) {
          expect(categories.length, 3);
          expect(categories[0].name, 'Football');
          expect(categories[0].icon, '⚽');
          expect(categories[1].name, 'Basketball');
        });
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.getAllSportCategories(),
        ).thenAnswer((_) async => Right(tCategories));

        // Act
        await useCase();

        // Assert
        verify(() => mockRepository.getAllSportCategories()).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to get categories');
        when(
          () => mockRepository.getAllSportCategories(),
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
          () => mockRepository.getAllSportCategories(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
