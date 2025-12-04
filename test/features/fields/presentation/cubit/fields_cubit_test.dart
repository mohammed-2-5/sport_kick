import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
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
        verify: (_) {
          verify(() => mockGetAllFieldsUseCase()).called(1);
          verify(() => mockGetSportCategoriesUseCase()).called(1);
        },
      );

      blocTest<FieldsCubit, FieldsState>(
        'should emit [Loading, Empty] when fields list is empty',
        build: () {
          when(
            () => mockGetAllFieldsUseCase(),
          ).thenAnswer((_) async => const Right([]));
          when(
            () => mockGetSportCategoriesUseCase(),
          ).thenAnswer((_) async => Right(tCategories));
          return cubit;
        },
        act: (cubit) => cubit.loadAllFields(),
        expect: () => [const FieldsLoading(), const FieldsEmpty()],
      );

      blocTest<FieldsCubit, FieldsState>(
        'should emit [Loading, Error] when fields loading fails',
        build: () {
          when(
            () => mockGetAllFieldsUseCase(),
          ).thenAnswer((_) async => const Left(ServerFailure('Server error')));
          when(
            () => mockGetSportCategoriesUseCase(),
          ).thenAnswer((_) async => Right(tCategories));
          return cubit;
        },
        act: (cubit) => cubit.loadAllFields(),
        expect: () => [
          const FieldsLoading(),
          const FieldsError('Server error'),
        ],
      );
    });

    group('loadFeaturedFields -', () {
      blocTest<FieldsCubit, FieldsState>(
        'should emit [Loading, Loaded] when successful',
        build: () {
          when(
            () => mockGetFeaturedFieldsUseCase(),
          ).thenAnswer((_) async => Right(tFields));
          when(
            () => mockGetSportCategoriesUseCase(),
          ).thenAnswer((_) async => Right(tCategories));
          return cubit;
        },
        act: (cubit) => cubit.loadFeaturedFields(),
        expect: () => [
          const FieldsLoading(),
          FieldsLoaded(fields: tFields, categories: tCategories),
        ],
      );
    });

    group('loadFieldDetails -', () {
      const tFieldId = 'field-1';

      blocTest<FieldsCubit, FieldsState>(
        'should emit [Loading, DetailsLoaded] when successful',
        build: () {
          when(
            () => mockGetFieldByIdUseCase(tFieldId),
          ).thenAnswer((_) async => Right(tField));
          when(
            () => mockGetSportCategoriesUseCase(),
          ).thenAnswer((_) async => Right(tCategories));
          return cubit;
        },
        act: (cubit) => cubit.loadFieldDetails(tFieldId),
        expect: () => [
          const FieldsLoading(),
          FieldDetailsLoaded(field: tField, category: tCategories.first),
        ],
      );

      blocTest<FieldsCubit, FieldsState>(
        'should emit [Loading, Error] when failure occurs',
        build: () {
          when(
            () => mockGetFieldByIdUseCase(tFieldId),
          ).thenAnswer((_) async => const Left(ServerFailure('Not found')));
          return cubit;
        },
        act: (cubit) => cubit.loadFieldDetails(tFieldId),
        expect: () => [const FieldsLoading(), const FieldsError('Not found')],
      );
    });

    group('searchFields -', () {
      const tQuery = 'test';

      blocTest<FieldsCubit, FieldsState>(
        'should emit [Loading, SearchResults] when successful',
        build: () {
          when(
            () => mockSearchFieldsUseCase(tQuery),
          ).thenAnswer((_) async => Right(tFields));
          return cubit;
        },
        act: (cubit) => cubit.searchFields(tQuery),
        expect: () => [
          const FieldsLoading(),
          FieldsSearchResults(results: tFields, query: tQuery),
        ],
      );

      blocTest<FieldsCubit, FieldsState>(
        'should reload all fields when query is empty',
        build: () {
          when(
            () => mockGetAllFieldsUseCase(),
          ).thenAnswer((_) async => Right(tFields));
          when(
            () => mockGetSportCategoriesUseCase(),
          ).thenAnswer((_) async => Right(tCategories));
          return cubit;
        },
        act: (cubit) => cubit.searchFields(''),
        expect: () => [
          const FieldsLoading(),
          FieldsLoaded(fields: tFields, categories: tCategories),
        ],
      );
    });

    group('filterByCategory -', () {
      const tCategoryId = 'cat-1';

      blocTest<FieldsCubit, FieldsState>(
        'should emit [Loading, Loaded] with filtered fields',
        build: () {
          when(
            () => mockGetFieldsByCategoryUseCase(tCategoryId),
          ).thenAnswer((_) async => Right(tFields));
          return cubit;
        },
        seed: () => FieldsLoaded(fields: tFields, categories: tCategories),
        act: (cubit) => cubit.filterByCategory(tCategoryId),
        expect: () => [
          FieldsLoaded(
            fields: tFields,
            categories: tCategories,
            selectedCategoryId: tCategoryId,
          ),
        ],
      );

      blocTest<FieldsCubit, FieldsState>(
        'should clear filter when categoryId is null',
        build: () => cubit,
        seed: () => FieldsLoaded(
          fields: tFields,
          categories: tCategories,
          selectedCategoryId: tCategoryId,
        ),
        act: (cubit) => cubit.filterByCategory(null),
        expect: () => [
          FieldsLoaded(
            fields: tFields,
            categories: tCategories,
            selectedCategoryId: null,
          ),
        ],
      );
    });
  });
}
