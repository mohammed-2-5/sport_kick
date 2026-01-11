import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/search_filters_entity.dart';
import 'package:spo_kick/features/fields/domain/repositories/field_repository.dart';
import 'package:spo_kick/features/fields/domain/usecases/advanced_search_fields_usecase.dart';

class MockFieldRepository extends Mock implements FieldRepository {}

void main() {
  late AdvancedSearchFieldsUseCase useCase;
  late MockFieldRepository mockRepository;

  setUp(() {
    mockRepository = MockFieldRepository();
    useCase = AdvancedSearchFieldsUseCase(mockRepository);
  });

  final tNow = DateTime(2026, 1, 1);

  // Test data - multiple fields for sorting/filtering tests
  final tFields = <FieldEntity>[
    FieldEntity(
      id: 'field-1',
      sportCategoryId: 'football',
      name: 'Al-Ahly Stadium',
      address: 'Nasr City, Cairo',
      city: 'Cairo',
      pricePerHour: 200.0,
      currency: 'EGP',
      isActive: true,
      averageRating: 4.5,
      totalBookings: 100,
      createdAt: tNow,
      updatedAt: tNow,
    ),
    FieldEntity(
      id: 'field-2',
      sportCategoryId: 'football',
      name: 'Zamalek Field',
      address: 'Mohandessin, Cairo',
      city: 'Cairo',
      pricePerHour: 150.0,
      currency: 'EGP',
      isActive: true,
      averageRating: 4.8,
      totalBookings: 50,
      createdAt: tNow.add(const Duration(days: 1)),
      updatedAt: tNow.add(const Duration(days: 1)),
    ),
    FieldEntity(
      id: 'field-3',
      sportCategoryId: 'basketball',
      name: 'Alexandria Arena',
      address: 'Sporting, Alexandria',
      description: 'Premium basketball court',
      city: 'Alexandria',
      pricePerHour: 300.0,
      currency: 'EGP',
      isActive: true,
      averageRating: 4.2,
      totalBookings: 200,
      createdAt: tNow.add(const Duration(days: 2)),
      updatedAt: tNow.add(const Duration(days: 2)),
    ),
  ];

  group('AdvancedSearchFieldsUseCase -', () {
    group('basic filtering -', () {
      test(
        'should return fields when repository succeeds with no filters',
        () async {
          // Arrange
          const filters = SearchFiltersEntity();
          when(
            () => mockRepository.filterFields(
              categoryId: any(named: 'categoryId'),
              city: any(named: 'city'),
              cityId: any(named: 'cityId'),
              minPrice: any(named: 'minPrice'),
              maxPrice: any(named: 'maxPrice'),
              amenities: any(named: 'amenities'),
            ),
          ).thenAnswer((_) async => Right(tFields));

          // Act
          final result = await useCase(filters);

          // Assert
          expect(result.isRight(), isTrue);
          result.fold(
            (l) => fail('Should return Right'),
            (r) => expect(r.length, equals(3)),
          );
          verify(
            () => mockRepository.filterFields(
              categoryId: null,
              city: null,
              cityId: null,
              minPrice: null,
              maxPrice: null,
              amenities: null,
            ),
          ).called(1);
        },
      );

      test('should pass category filter to repository', () async {
        // Arrange
        const filters = SearchFiltersEntity(categoryId: 'football');
        when(
          () => mockRepository.filterFields(
            categoryId: 'football',
            city: any(named: 'city'),
            cityId: any(named: 'cityId'),
            minPrice: any(named: 'minPrice'),
            maxPrice: any(named: 'maxPrice'),
            amenities: any(named: 'amenities'),
          ),
        ).thenAnswer((_) async => Right([tFields[0], tFields[1]]));

        // Act
        final result = await useCase(filters);

        // Assert
        expect(result.isRight(), isTrue);
        verify(
          () => mockRepository.filterFields(
            categoryId: 'football',
            city: null,
            cityId: null,
            minPrice: null,
            maxPrice: null,
            amenities: null,
          ),
        ).called(1);
      });

      test('should pass city filter to repository', () async {
        // Arrange
        const filters = SearchFiltersEntity(city: 'Cairo');
        when(
          () => mockRepository.filterFields(
            categoryId: any(named: 'categoryId'),
            city: 'Cairo',
            cityId: any(named: 'cityId'),
            minPrice: any(named: 'minPrice'),
            maxPrice: any(named: 'maxPrice'),
            amenities: any(named: 'amenities'),
          ),
        ).thenAnswer((_) async => Right([tFields[0], tFields[1]]));

        // Act
        final result = await useCase(filters);

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('should pass price range filters to repository', () async {
        // Arrange
        const filters = SearchFiltersEntity(minPrice: 100, maxPrice: 250);
        when(
          () => mockRepository.filterFields(
            categoryId: any(named: 'categoryId'),
            city: any(named: 'city'),
            cityId: any(named: 'cityId'),
            minPrice: 100.0,
            maxPrice: 250.0,
            amenities: any(named: 'amenities'),
          ),
        ).thenAnswer((_) async => Right([tFields[0], tFields[1]]));

        // Act
        final result = await useCase(filters);

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('should pass amenities filter to repository', () async {
        // Arrange
        const filters = SearchFiltersEntity(amenities: ['parking', 'wifi']);
        when(
          () => mockRepository.filterFields(
            categoryId: any(named: 'categoryId'),
            city: any(named: 'city'),
            cityId: any(named: 'cityId'),
            minPrice: any(named: 'minPrice'),
            maxPrice: any(named: 'maxPrice'),
            amenities: ['parking', 'wifi'],
          ),
        ).thenAnswer((_) async => Right(tFields));

        // Act
        final result = await useCase(filters);

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('should return failure when repository fails', () async {
        // Arrange
        const filters = SearchFiltersEntity();
        when(
          () => mockRepository.filterFields(
            categoryId: any(named: 'categoryId'),
            city: any(named: 'city'),
            cityId: any(named: 'cityId'),
            minPrice: any(named: 'minPrice'),
            maxPrice: any(named: 'maxPrice'),
            amenities: any(named: 'amenities'),
          ),
        ).thenAnswer((_) async => const Left(ServerFailure('Database error')));

        // Act
        final result = await useCase(filters);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (l) => expect(l.message, equals('Database error')),
          (r) => fail('Should return Left'),
        );
      });
    });

    group('text search filtering -', () {
      test('should filter by query in field name', () async {
        // Arrange
        const filters = SearchFiltersEntity(query: 'Ahly');
        when(
          () => mockRepository.filterFields(
            categoryId: any(named: 'categoryId'),
            city: any(named: 'city'),
            cityId: any(named: 'cityId'),
            minPrice: any(named: 'minPrice'),
            maxPrice: any(named: 'maxPrice'),
            amenities: any(named: 'amenities'),
          ),
        ).thenAnswer((_) async => Right(tFields));

        // Act
        final result = await useCase(filters);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold((l) => fail('Should return Right'), (r) {
          expect(r.length, equals(1));
          expect(r.first.name, contains('Ahly'));
        });
      });

      test('should filter by query in address', () async {
        // Arrange
        const filters = SearchFiltersEntity(query: 'Mohandessin');
        when(
          () => mockRepository.filterFields(
            categoryId: any(named: 'categoryId'),
            city: any(named: 'city'),
            cityId: any(named: 'cityId'),
            minPrice: any(named: 'minPrice'),
            maxPrice: any(named: 'maxPrice'),
            amenities: any(named: 'amenities'),
          ),
        ).thenAnswer((_) async => Right(tFields));

        // Act
        final result = await useCase(filters);

        // Assert
        result.fold((l) => fail('Should return Right'), (r) {
          expect(r.length, equals(1));
          expect(r.first.address, contains('Mohandessin'));
        });
      });

      test('should filter by query in description', () async {
        // Arrange
        const filters = SearchFiltersEntity(query: 'basketball');
        when(
          () => mockRepository.filterFields(
            categoryId: any(named: 'categoryId'),
            city: any(named: 'city'),
            cityId: any(named: 'cityId'),
            minPrice: any(named: 'minPrice'),
            maxPrice: any(named: 'maxPrice'),
            amenities: any(named: 'amenities'),
          ),
        ).thenAnswer((_) async => Right(tFields));

        // Act
        final result = await useCase(filters);

        // Assert
        result.fold((l) => fail('Should return Right'), (r) {
          expect(r.length, equals(1));
          expect(r.first.description, contains('basketball'));
        });
      });

      test('should be case insensitive in search', () async {
        // Arrange
        const filters = SearchFiltersEntity(query: 'STADIUM');
        when(
          () => mockRepository.filterFields(
            categoryId: any(named: 'categoryId'),
            city: any(named: 'city'),
            cityId: any(named: 'cityId'),
            minPrice: any(named: 'minPrice'),
            maxPrice: any(named: 'maxPrice'),
            amenities: any(named: 'amenities'),
          ),
        ).thenAnswer((_) async => Right(tFields));

        // Act
        final result = await useCase(filters);

        // Assert
        result.fold(
          (l) => fail('Should return Right'),
          (r) => expect(r.length, equals(1)),
        );
      });

      test('should return empty list when no matches found', () async {
        // Arrange
        const filters = SearchFiltersEntity(query: 'NonExistent');
        when(
          () => mockRepository.filterFields(
            categoryId: any(named: 'categoryId'),
            city: any(named: 'city'),
            cityId: any(named: 'cityId'),
            minPrice: any(named: 'minPrice'),
            maxPrice: any(named: 'maxPrice'),
            amenities: any(named: 'amenities'),
          ),
        ).thenAnswer((_) async => Right(tFields));

        // Act
        final result = await useCase(filters);

        // Assert
        result.fold(
          (l) => fail('Should return Right'),
          (r) => expect(r, isEmpty),
        );
      });

      test('should ignore empty query string', () async {
        // Arrange
        const filters = SearchFiltersEntity(query: '   ');
        when(
          () => mockRepository.filterFields(
            categoryId: any(named: 'categoryId'),
            city: any(named: 'city'),
            cityId: any(named: 'cityId'),
            minPrice: any(named: 'minPrice'),
            maxPrice: any(named: 'maxPrice'),
            amenities: any(named: 'amenities'),
          ),
        ).thenAnswer((_) async => Right(tFields));

        // Act
        final result = await useCase(filters);

        // Assert
        result.fold(
          (l) => fail('Should return Right'),
          (r) => expect(r.length, equals(3)), // All fields returned
        );
      });
    });

    group('sorting -', () {
      test('should sort by price low to high', () async {
        // Arrange
        const filters = SearchFiltersEntity(
          sortBy: SearchSortBy.priceLowToHigh,
        );
        when(
          () => mockRepository.filterFields(
            categoryId: any(named: 'categoryId'),
            city: any(named: 'city'),
            cityId: any(named: 'cityId'),
            minPrice: any(named: 'minPrice'),
            maxPrice: any(named: 'maxPrice'),
            amenities: any(named: 'amenities'),
          ),
        ).thenAnswer((_) async => Right(tFields));

        // Act
        final result = await useCase(filters);

        // Assert
        result.fold((l) => fail('Should return Right'), (r) {
          expect(r[0].pricePerHour, equals(150.0)); // Zamalek
          expect(r[1].pricePerHour, equals(200.0)); // Al-Ahly
          expect(r[2].pricePerHour, equals(300.0)); // Alexandria
        });
      });

      test('should sort by price high to low', () async {
        // Arrange
        const filters = SearchFiltersEntity(
          sortBy: SearchSortBy.priceHighToLow,
        );
        when(
          () => mockRepository.filterFields(
            categoryId: any(named: 'categoryId'),
            city: any(named: 'city'),
            cityId: any(named: 'cityId'),
            minPrice: any(named: 'minPrice'),
            maxPrice: any(named: 'maxPrice'),
            amenities: any(named: 'amenities'),
          ),
        ).thenAnswer((_) async => Right(tFields));

        // Act
        final result = await useCase(filters);

        // Assert
        result.fold((l) => fail('Should return Right'), (r) {
          expect(r[0].pricePerHour, equals(300.0)); // Alexandria
          expect(r[1].pricePerHour, equals(200.0)); // Al-Ahly
          expect(r[2].pricePerHour, equals(150.0)); // Zamalek
        });
      });

      test('should sort by rating (highest first)', () async {
        // Arrange
        const filters = SearchFiltersEntity(sortBy: SearchSortBy.rating);
        when(
          () => mockRepository.filterFields(
            categoryId: any(named: 'categoryId'),
            city: any(named: 'city'),
            cityId: any(named: 'cityId'),
            minPrice: any(named: 'minPrice'),
            maxPrice: any(named: 'maxPrice'),
            amenities: any(named: 'amenities'),
          ),
        ).thenAnswer((_) async => Right(tFields));

        // Act
        final result = await useCase(filters);

        // Assert
        result.fold((l) => fail('Should return Right'), (r) {
          expect(r[0].averageRating, equals(4.8)); // Zamalek
          expect(r[1].averageRating, equals(4.5)); // Al-Ahly
          expect(r[2].averageRating, equals(4.2)); // Alexandria
        });
      });

      test('should sort by newest (most recent first)', () async {
        // Arrange
        const filters = SearchFiltersEntity(sortBy: SearchSortBy.newest);
        when(
          () => mockRepository.filterFields(
            categoryId: any(named: 'categoryId'),
            city: any(named: 'city'),
            cityId: any(named: 'cityId'),
            minPrice: any(named: 'minPrice'),
            maxPrice: any(named: 'maxPrice'),
            amenities: any(named: 'amenities'),
          ),
        ).thenAnswer((_) async => Right(tFields));

        // Act
        final result = await useCase(filters);

        // Assert
        result.fold((l) => fail('Should return Right'), (r) {
          expect(r[0].id, equals('field-3')); // Alexandria (newest)
          expect(r[1].id, equals('field-2')); // Zamalek
          expect(r[2].id, equals('field-1')); // Al-Ahly (oldest)
        });
      });

      test('should sort by popular (most bookings first)', () async {
        // Arrange
        const filters = SearchFiltersEntity(sortBy: SearchSortBy.popular);
        when(
          () => mockRepository.filterFields(
            categoryId: any(named: 'categoryId'),
            city: any(named: 'city'),
            cityId: any(named: 'cityId'),
            minPrice: any(named: 'minPrice'),
            maxPrice: any(named: 'maxPrice'),
            amenities: any(named: 'amenities'),
          ),
        ).thenAnswer((_) async => Right(tFields));

        // Act
        final result = await useCase(filters);

        // Assert
        result.fold((l) => fail('Should return Right'), (r) {
          expect(r[0].totalBookings, equals(200)); // Alexandria
          expect(r[1].totalBookings, equals(100)); // Al-Ahly
          expect(r[2].totalBookings, equals(50)); // Zamalek
        });
      });

      test('should keep original order for relevance sort', () async {
        // Arrange
        const filters = SearchFiltersEntity(sortBy: SearchSortBy.relevance);
        when(
          () => mockRepository.filterFields(
            categoryId: any(named: 'categoryId'),
            city: any(named: 'city'),
            cityId: any(named: 'cityId'),
            minPrice: any(named: 'minPrice'),
            maxPrice: any(named: 'maxPrice'),
            amenities: any(named: 'amenities'),
          ),
        ).thenAnswer((_) async => Right(tFields));

        // Act
        final result = await useCase(filters);

        // Assert
        result.fold((l) => fail('Should return Right'), (r) {
          expect(r[0].id, equals('field-1')); // Original order
          expect(r[1].id, equals('field-2'));
          expect(r[2].id, equals('field-3'));
        });
      });
    });

    group('combined filters and sorting -', () {
      test('should apply both text search and sorting', () async {
        // Arrange
        const filters = SearchFiltersEntity(
          query: 'Cairo',
          sortBy: SearchSortBy.priceLowToHigh,
        );
        when(
          () => mockRepository.filterFields(
            categoryId: any(named: 'categoryId'),
            city: any(named: 'city'),
            cityId: any(named: 'cityId'),
            minPrice: any(named: 'minPrice'),
            maxPrice: any(named: 'maxPrice'),
            amenities: any(named: 'amenities'),
          ),
        ).thenAnswer((_) async => Right(tFields));

        // Act
        final result = await useCase(filters);

        // Assert
        result.fold((l) => fail('Should return Right'), (r) {
          // Only Cairo fields, sorted by price
          expect(r.length, equals(2));
          expect(r[0].pricePerHour, equals(150.0)); // Zamalek (cheaper)
          expect(r[1].pricePerHour, equals(200.0)); // Al-Ahly
        });
      });
    });
  });

  group('SearchFiltersEntity -', () {
    test('hasActiveFilters returns false when no filters', () {
      const filters = SearchFiltersEntity();
      expect(filters.hasActiveFilters, isFalse);
    });

    test('hasActiveFilters returns true with category filter', () {
      const filters = SearchFiltersEntity(categoryId: 'football');
      expect(filters.hasActiveFilters, isTrue);
    });

    test('hasActiveFilters returns true with price filter', () {
      const filters = SearchFiltersEntity(minPrice: 100);
      expect(filters.hasActiveFilters, isTrue);
    });

    test('activeFilterCount counts correctly', () {
      const filters = SearchFiltersEntity(
        categoryId: 'football',
        city: 'Cairo',
        minPrice: 100,
        amenities: ['wifi'],
      );
      expect(filters.activeFilterCount, equals(4));
    });

    test('copyWith updates values correctly', () {
      const original = SearchFiltersEntity(categoryId: 'football');
      final updated = original.copyWith(city: 'Cairo');

      expect(updated.categoryId, equals('football'));
      expect(updated.city, equals('Cairo'));
    });

    test('copyWith with clearCategory removes category', () {
      const original = SearchFiltersEntity(categoryId: 'football');
      final updated = original.copyWith(clearCategory: true);

      expect(updated.categoryId, isNull);
    });

    test('clearAll removes all filters', () {
      const original = SearchFiltersEntity(
        categoryId: 'football',
        city: 'Cairo',
        minPrice: 100,
      );
      final cleared = original.clearAll();

      expect(cleared.categoryId, isNull);
      expect(cleared.city, isNull);
      expect(cleared.minPrice, isNull);
    });

    test('equality works correctly', () {
      const filters1 = SearchFiltersEntity(categoryId: 'football');
      const filters2 = SearchFiltersEntity(categoryId: 'football');
      const filters3 = SearchFiltersEntity(categoryId: 'basketball');

      expect(filters1, equals(filters2));
      expect(filters1, isNot(equals(filters3)));
    });
  });
}
