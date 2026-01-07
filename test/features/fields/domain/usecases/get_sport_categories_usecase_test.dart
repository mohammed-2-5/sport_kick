import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/sport_category_entity.dart';
import 'package:spo_kick/features/fields/domain/repositories/field_repository.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_sport_categories_usecase.dart';

class MockFieldRepository extends Mock implements FieldRepository {}

void main() {
  late GetSportCategoriesUseCase useCase;
  late MockFieldRepository mockRepository;

  setUp(() {
    mockRepository = MockFieldRepository();
    useCase = GetSportCategoriesUseCase(mockRepository);
  });

  group('GetSportCategoriesUseCase', () {
    final tNow = DateTime(2026, 1, 1);
    final tCategories = <SportCategoryEntity>[
      SportCategoryEntity(
        id: 'football',
        name: 'Football',
        slug: 'FB',
        icon: '⚽',
        isActive: true,
        createdAt: tNow,
      ),
      SportCategoryEntity(
        id: 'basketball',
        name: 'Basketball',
        slug: 'BB',
        icon: '🏀',
        isActive: true,
        createdAt: tNow,
      ),
      SportCategoryEntity(
        id: 'tennis',
        name: 'Tennis',
        slug: 'TN',
        icon: '🎾',
        isActive: true,
        createdAt: tNow,
      ),
    ];

    group('successful retrieval', () {
      test('should return sport categories when call succeeds', () async {
        // Arrange
        when(
          () => mockRepository.getSportCategories(),
        ).thenAnswer((_) async => Right(tCategories));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(Right(tCategories)));
        verify(() => mockRepository.getSportCategories()).called(1);
      });

      test('should return empty list when no categories exist', () async {
        // Arrange
        when(
          () => mockRepository.getSportCategories(),
        ).thenAnswer((_) async => const Right([]));

        // Act
        final result = await useCase();

        // Assert
        result.fold(
          (_) => fail('Should return Right'),
          (categories) => expect(categories, isEmpty),
        );
      });

      test('should return categories with icons', () async {
        // Arrange
        when(
          () => mockRepository.getSportCategories(),
        ).thenAnswer((_) async => Right(tCategories));

        // Act
        final result = await useCase();

        // Assert
        result.fold((_) => fail('Should return Right'), (categories) {
          expect(categories[0].icon, '⚽');
          expect(categories[1].icon, '🏀');
        });
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.getSportCategories(),
        ).thenAnswer((_) async => Right(tCategories));

        // Act
        await useCase();

        // Assert
        verify(() => mockRepository.getSportCategories()).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should return only active categories', () async {
        // Arrange
        when(
          () => mockRepository.getSportCategories(),
        ).thenAnswer((_) async => Right(tCategories));

        // Act
        final result = await useCase();

        // Assert
        result.fold((_) => fail('Should return Right'), (categories) {
          for (final category in categories) {
            expect(category.isActive, true);
          }
        });
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to fetch sport categories');
        when(
          () => mockRepository.getSportCategories(),
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
          () => mockRepository.getSportCategories(),
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
          () => mockRepository.getSportCategories(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
