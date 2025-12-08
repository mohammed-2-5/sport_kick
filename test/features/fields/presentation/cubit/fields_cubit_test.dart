import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/sport_category_entity.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late FieldsCubit cubit;
  late MockGetAllFieldsUseCase mockGetAllFieldsUseCase;
  late MockGetFieldByIdUseCase mockGetFieldByIdUseCase;
  late MockGetFieldsByCategoryUseCase mockGetFieldsByCategoryUseCase;
  late MockGetFeaturedFieldsUseCase mockGetFeaturedFieldsUseCase;
  late MockGetSportCategoriesUseCase mockGetSportCategoriesUseCase;
  late MockSearchFieldsUseCase mockSearchFieldsUseCase;

  // Test data
  late List<FieldEntity> tFields;
  late List<SportCategoryEntity> tCategories;
  late FieldEntity tField;
  final now = DateTime.now();

  setUp(() {
    // Initialize mocks
    mockGetAllFieldsUseCase = MockGetAllFieldsUseCase();
    mockGetFieldByIdUseCase = MockGetFieldByIdUseCase();
    mockGetFieldsByCategoryUseCase = MockGetFieldsByCategoryUseCase();
    mockGetFeaturedFieldsUseCase = MockGetFeaturedFieldsUseCase();
    mockGetSportCategoriesUseCase = MockGetSportCategoriesUseCase();
    mockSearchFieldsUseCase = MockSearchFieldsUseCase();

    // Initialize test data
    tField = FieldEntity(
      id: 'field-1',
      name: 'Test Field',
      sportCategoryId: 'cat-1',
      ownerId: 'owner-1',
      city: 'Cairo',
      address: '123 Test St',
      pricePerHour: 150.0,
      currency: 'EGP',
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );

    tFields = [tField];

    tCategories = [
      SportCategoryEntity(
        id: 'cat-1',
        name: 'Football',
        icon: 'football.png',
        isActive: true,
        createdAt: now,
      ),
      SportCategoryEntity(
        id: 'cat-2',
        name: 'Basketball',
        icon: 'basketball.png',
        isActive: true,
        createdAt: now,
      ),
    ];

    // Create cubit
    cubit = FieldsCubit(
      getAllFieldsUseCase: mockGetAllFieldsUseCase,
      getFieldByIdUseCase: mockGetFieldByIdUseCase,
      getFieldsByCategoryUseCase: mockGetFieldsByCategoryUseCase,
      getFeaturedFieldsUseCase: mockGetFeaturedFieldsUseCase,
      getSportCategoriesUseCase: mockGetSportCategoriesUseCase,
      searchFieldsUseCase: mockSearchFieldsUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('FieldsCubit -', () {
    test('initial state should be FieldsInitial', () {
      expect(cubit.state, equals(const FieldsInitial()));
    });

    group('loadAllFields -', () {
      blocTest<FieldsCubit, FieldsState>(
        'should emit [Loading, Loaded] when successful',
        build: () {
          when(
            () => mockGetAllFieldsUseCase(),
          ).thenAnswer((_) async => Right(tFields));
          when(
            () => mockGetSportCategoriesUseCase(),
          ).thenAnswer((_) async => Right(tCategories));
          return cubit;
        },
        act: (cubit) => cubit.loadAllFields(),
        expect: () => [
          const FieldsLoading(),
          FieldsLoaded(fields: tFields, categories: tCategories),
        ],
      );
    });

    group('searchFields -', () {
      const tQuery = 'test';

      blocTest<FieldsCubit, FieldsState>(
        'should emit [Loaded] with searchQuery when already loaded',
        build: () => cubit,
        seed: () => FieldsLoaded(fields: tFields, categories: tCategories),
        act: (cubit) => cubit.searchFields(tQuery),
        expect: () => [
          FieldsLoaded(
            fields: tFields,
            categories: tCategories,
            searchQuery: tQuery,
          ),
        ],
      );
    });

    group('filterByCategory -', () {
      const tCategoryId = 'cat-1';

      blocTest<FieldsCubit, FieldsState>(
        'should emit [Loaded] with updated filterOptions',
        build: () => cubit,
        seed: () => FieldsLoaded(fields: tFields, categories: tCategories),
        act: (cubit) => cubit.filterByCategory(tCategoryId),
        expect: () => [
          FieldsLoaded(
            fields: tFields,
            categories: tCategories,
            filterOptions: const FieldFilterOptions(categoryId: tCategoryId),
          ),
        ],
      );
    });
  });
}
