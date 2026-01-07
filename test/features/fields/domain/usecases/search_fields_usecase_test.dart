import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/repositories/field_repository.dart';
import 'package:spo_kick/features/fields/domain/usecases/search_fields_usecase.dart';

class MockFieldRepository extends Mock implements FieldRepository {}

void main() {
  late SearchFieldsUseCase useCase;
  late MockFieldRepository mockRepository;

  setUp(() {
    mockRepository = MockFieldRepository();
    useCase = SearchFieldsUseCase(mockRepository);
  });

  group('SearchFieldsUseCase', () {
    final tNow = DateTime(2026, 1, 1);
    final tFields = <FieldEntity>[
      FieldEntity(
        id: 'field-1',
        sportCategoryId: 'football',
        name: 'Stadium Cairo',
        address: 'Downtown Cairo',
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

    group('successful search', () {
      test('should return matching fields when search succeeds', () async {
        // Arrange
        const query = 'Stadium';
        when(
          () =>
              mockRepository.searchFields(any(), cityId: any(named: 'cityId')),
        ).thenAnswer((_) async => Right(tFields));

        // Act
        final result = await useCase(query);

        // Assert
        expect(result, equals(Right(tFields)));
        verify(
          () => mockRepository.searchFields(query, cityId: null),
        ).called(1);
      });

      test('should return fields filtered by city', () async {
        // Arrange
        const query = 'Stadium';
        const cityId = 'city-123';
        when(
          () =>
              mockRepository.searchFields(any(), cityId: any(named: 'cityId')),
        ).thenAnswer((_) async => Right(tFields));

        // Act
        final result = await useCase(query, cityId: cityId);

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.searchFields(query, cityId: cityId),
        ).called(1);
      });

      test('should return empty list when no matches found', () async {
        // Arrange
        when(
          () =>
              mockRepository.searchFields(any(), cityId: any(named: 'cityId')),
        ).thenAnswer((_) async => const Right([]));

        // Act
        final result = await useCase('nonexistent');

        // Assert
        result.fold(
          (_) => fail('Should return Right'),
          (fields) => expect(fields, isEmpty),
        );
      });

      test('should trim whitespace from query', () async {
        // Arrange
        when(
          () =>
              mockRepository.searchFields(any(), cityId: any(named: 'cityId')),
        ).thenAnswer((_) async => Right(tFields));

        // Act
        final result = await useCase('  Stadium  ');

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.searchFields('Stadium', cityId: null),
        ).called(1);
      });

      test('should handle Arabic search queries', () async {
        // Arrange
        const arabicQuery = 'ملعب';
        when(
          () =>
              mockRepository.searchFields(any(), cityId: any(named: 'cityId')),
        ).thenAnswer((_) async => Right(tFields));

        // Act
        final result = await useCase(arabicQuery);

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.searchFields(arabicQuery, cityId: null),
        ).called(1);
      });
    });

    group('validation failures', () {
      test('should return ValidationFailure for empty query', () async {
        // Act
        final result = await useCase('');

        // Assert
        expect(
          result,
          equals(const Left(ValidationFailure('Search query cannot be empty'))),
        );
        verifyNever(
          () =>
              mockRepository.searchFields(any(), cityId: any(named: 'cityId')),
        );
      });

      test(
        'should return ValidationFailure for whitespace-only query',
        () async {
          // Act
          final result = await useCase('   ');

          // Assert
          expect(
            result,
            equals(
              const Left(ValidationFailure('Search query cannot be empty')),
            ),
          );
        },
      );

      test(
        'should return ValidationFailure for single character query',
        () async {
          // Act
          final result = await useCase('a');

          // Assert
          expect(
            result,
            equals(
              const Left(
                ValidationFailure('Search query must be at least 2 characters'),
              ),
            ),
          );
        },
      );
    });

    group('repository failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Search failed');
        when(
          () =>
              mockRepository.searchFields(any(), cityId: any(named: 'cityId')),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase('stadium');

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure on network error', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () =>
              mockRepository.searchFields(any(), cityId: any(named: 'cityId')),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase('stadium');

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
