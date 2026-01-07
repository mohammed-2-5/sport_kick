import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/repositories/field_repository.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_fields_by_category_usecase.dart';

class MockFieldRepository extends Mock implements FieldRepository {}

void main() {
  late GetFieldsByCategoryUseCase useCase;
  late MockFieldRepository mockRepository;

  setUp(() {
    mockRepository = MockFieldRepository();
    useCase = GetFieldsByCategoryUseCase(mockRepository);
  });

  group('GetFieldsByCategoryUseCase', () {
    const tCategoryId = 'football';
    final tNow = DateTime(2026, 1, 1);
    final tFields = <FieldEntity>[
      FieldEntity(
        id: 'field-1',
        sportCategoryId: tCategoryId,
        name: 'Football Stadium A',
        address: 'Downtown',
        city: 'Cairo',
        pricePerHour: 100.0,
        currency: 'EGP',
        isIndoor: false,
        images: const ['image.jpg'],
        isActive: true,
        isVerified: true,
        facilities: const [],
        totalBookings: 10,
        createdAt: tNow,
        updatedAt: tNow,
      ),
    ];

    group('successful retrieval', () {
      test('should return fields when call succeeds', () async {
        // Arrange
        when(
          () => mockRepository.getFieldsByCategory(
            any(),
            cityId: any(named: 'cityId'),
          ),
        ).thenAnswer((_) async => Right(tFields));

        // Act
        final result = await useCase(tCategoryId);

        // Assert
        expect(result, equals(Right(tFields)));
        verify(
          () => mockRepository.getFieldsByCategory(tCategoryId, cityId: null),
        ).called(1);
      });

      test('should return fields filtered by city', () async {
        // Arrange
        const cityId = 'city-123';
        when(
          () => mockRepository.getFieldsByCategory(
            any(),
            cityId: any(named: 'cityId'),
          ),
        ).thenAnswer((_) async => Right(tFields));

        // Act
        final result = await useCase(tCategoryId, cityId: cityId);

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.getFieldsByCategory(tCategoryId, cityId: cityId),
        ).called(1);
      });

      test('should return empty list when no fields in category', () async {
        // Arrange
        when(
          () => mockRepository.getFieldsByCategory(
            any(),
            cityId: any(named: 'cityId'),
          ),
        ).thenAnswer((_) async => const Right([]));

        // Act
        final result = await useCase('tennis');

        // Assert
        result.fold(
          (_) => fail('Should return Right'),
          (fields) => expect(fields, isEmpty),
        );
      });

      test('should handle various category IDs', () async {
        final categoryIds = ['football', 'basketball', 'tennis', 'padel'];

        for (final categoryId in categoryIds) {
          // Arrange
          when(
            () => mockRepository.getFieldsByCategory(
              any(),
              cityId: any(named: 'cityId'),
            ),
          ).thenAnswer((_) async => Right(tFields));

          // Act
          final result = await useCase(categoryId);

          // Assert
          expect(result.isRight(), true);
        }
      });
    });

    group('validation failures', () {
      test(
        'should return ValidationFailure when category ID is empty',
        () async {
          // Act
          final result = await useCase('');

          // Assert
          expect(
            result,
            equals(
              const Left(ValidationFailure('Category ID cannot be empty')),
            ),
          );
          verifyNever(
            () => mockRepository.getFieldsByCategory(
              any(),
              cityId: any(named: 'cityId'),
            ),
          );
        },
      );
    });

    group('repository failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to fetch fields by category');
        when(
          () => mockRepository.getFieldsByCategory(
            any(),
            cityId: any(named: 'cityId'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tCategoryId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ValidationFailure when category not found', () async {
        // Arrange
        const tFailure = ValidationFailure('Category not found');
        when(
          () => mockRepository.getFieldsByCategory(
            any(),
            cityId: any(named: 'cityId'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase('invalid-category');

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure on network error', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.getFieldsByCategory(
            any(),
            cityId: any(named: 'cityId'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tCategoryId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
