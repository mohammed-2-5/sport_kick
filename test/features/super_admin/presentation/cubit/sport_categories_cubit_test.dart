import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/sport_category_entity.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/create_sport_category_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/delete_sport_category_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_sport_categories_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/update_sport_category_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/sport_categories_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/sport_categories_state.dart';

// Mock Classes
class MockGetAllSportCategoriesUseCase extends Mock
    implements GetAllSportCategoriesUseCase {}

class MockCreateSportCategoryUseCase extends Mock
    implements CreateSportCategoryUseCase {}

class MockUpdateSportCategoryUseCase extends Mock
    implements UpdateSportCategoryUseCase {}

class MockDeleteSportCategoryUseCase extends Mock
    implements DeleteSportCategoryUseCase {}

void main() {
  late SportCategoriesCubit cubit;
  late MockGetAllSportCategoriesUseCase mockGetAllUseCase;
  late MockCreateSportCategoryUseCase mockCreateUseCase;
  late MockUpdateSportCategoryUseCase mockUpdateUseCase;
  late MockDeleteSportCategoryUseCase mockDeleteUseCase;

  // Test data
  final now = DateTime.now();
  late List<SportCategoryEntity> tCategories;
  late SportCategoryEntity tNewCategory;

  setUp(() {
    mockGetAllUseCase = MockGetAllSportCategoriesUseCase();
    mockCreateUseCase = MockCreateSportCategoryUseCase();
    mockUpdateUseCase = MockUpdateSportCategoryUseCase();
    mockDeleteUseCase = MockDeleteSportCategoryUseCase();

    tCategories = [
      SportCategoryEntity(
        id: 'cat-1',
        name: 'Football',
        icon: '⚽',
        description: 'Association football',
        isActive: true,
        displayOrder: 1,
        createdAt: now,
      ),
      SportCategoryEntity(
        id: 'cat-2',
        name: 'Basketball',
        icon: '🏀',
        description: 'Basketball sport',
        isActive: true,
        displayOrder: 2,
        createdAt: now,
      ),
      SportCategoryEntity(
        id: 'cat-3',
        name: 'Tennis',
        icon: '🎾',
        description: 'Racquet sport',
        isActive: true,
        displayOrder: 3,
        createdAt: now,
      ),
    ];

    tNewCategory = SportCategoryEntity(
      id: 'cat-4',
      name: 'Volleyball',
      icon: '🏐',
      description: 'Team sport',
      isActive: true,
      displayOrder: 4,
      createdAt: now,
    );

    cubit = SportCategoriesCubit(
      getAllSportCategoriesUseCase: mockGetAllUseCase,
      createSportCategoryUseCase: mockCreateUseCase,
      updateSportCategoryUseCase: mockUpdateUseCase,
      deleteSportCategoryUseCase: mockDeleteUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('SportCategoriesCubit -', () {
    test('initial state should be SportCategoriesInitial', () {
      expect(cubit.state, equals(const SportCategoriesInitial()));
    });

    group('loadCategories -', () {
      blocTest<SportCategoriesCubit, SportCategoriesState>(
        'should emit [Loading, Loaded] when successful',
        build: () {
          when(
            () => mockGetAllUseCase(),
          ).thenAnswer((_) async => Right(tCategories));
          return cubit;
        },
        act: (cubit) => cubit.loadCategories(),
        expect: () => [
          const SportCategoriesLoading(),
          SportCategoriesLoaded(categories: tCategories),
        ],
        verify: (_) {
          verify(() => mockGetAllUseCase()).called(1);
        },
      );

      blocTest<SportCategoriesCubit, SportCategoriesState>(
        'should emit [Loading, Loaded] with empty list',
        build: () {
          when(
            () => mockGetAllUseCase(),
          ).thenAnswer((_) async => const Right([]));
          return cubit;
        },
        act: (cubit) => cubit.loadCategories(),
        expect: () => [
          const SportCategoriesLoading(),
          const SportCategoriesLoaded(categories: []),
        ],
      );

      blocTest<SportCategoriesCubit, SportCategoriesState>(
        'should emit [Loading, Error] when failure occurs',
        build: () {
          when(() => mockGetAllUseCase()).thenAnswer(
            (_) async => const Left(ServerFailure('Failed to load categories')),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadCategories(),
        expect: () => [
          const SportCategoriesLoading(),
          const SportCategoriesError(message: 'Failed to load categories'),
        ],
      );

      blocTest<SportCategoriesCubit, SportCategoriesState>(
        'should emit Error on network failure',
        build: () {
          when(() => mockGetAllUseCase()).thenAnswer(
            (_) async => const Left(NetworkFailure('No internet connection')),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadCategories(),
        expect: () => [
          const SportCategoriesLoading(),
          const SportCategoriesError(message: 'No internet connection'),
        ],
      );
    });

    group('createCategory -', () {
      blocTest<SportCategoriesCubit, SportCategoriesState>(
        'should reload categories and emit Success after create',
        build: () {
          when(
            () => mockCreateUseCase(
              name: 'Volleyball',
              icon: '🏐',
              description: 'Team sport',
            ),
          ).thenAnswer((_) async => Right(tNewCategory));
          when(
            () => mockGetAllUseCase(),
          ).thenAnswer((_) async => Right([...tCategories, tNewCategory]));
          return cubit;
        },
        act: (cubit) => cubit.createCategory(
          name: 'Volleyball',
          icon: '🏐',
          description: 'Team sport',
        ),
        expect: () => [
          const SportCategoriesLoading(),
          SportCategoriesLoaded(categories: [...tCategories, tNewCategory]),
          isA<SportCategoryOperationSuccess>().having(
            (s) => s.updatedCategories.length,
            'categories count',
            4,
          ),
        ],
      );

      blocTest<SportCategoriesCubit, SportCategoriesState>(
        'should emit Error when create fails',
        build: () {
          when(
            () => mockCreateUseCase(
              name: any(named: 'name'),
              icon: any(named: 'icon'),
              description: any(named: 'description'),
            ),
          ).thenAnswer(
            (_) async => const Left(ServerFailure('Category already exists')),
          );
          return cubit;
        },
        act: (cubit) => cubit.createCategory(name: 'Football', icon: '⚽'),
        expect: () => [
          const SportCategoriesError(message: 'Category already exists'),
        ],
      );

      blocTest<SportCategoriesCubit, SportCategoriesState>(
        'should create category with only required fields',
        build: () {
          when(
            () => mockCreateUseCase(
              name: 'Swimming',
              icon: null,
              description: null,
            ),
          ).thenAnswer(
            (_) async => Right(
              SportCategoryEntity(
                id: 'cat-5',
                name: 'Swimming',
                createdAt: now,
              ),
            ),
          );
          when(
            () => mockGetAllUseCase(),
          ).thenAnswer((_) async => Right(tCategories));
          return cubit;
        },
        act: (cubit) => cubit.createCategory(name: 'Swimming'),
        expect: () => [
          const SportCategoriesLoading(),
          SportCategoriesLoaded(categories: tCategories),
          isA<SportCategoryOperationSuccess>(),
        ],
      );
    });

    group('updateCategory -', () {
      blocTest<SportCategoriesCubit, SportCategoriesState>(
        'should reload categories and emit Success after update',
        build: () {
          final updatedCategory = SportCategoryEntity(
            id: 'cat-1',
            name: 'Updated Football',
            icon: '⚽',
            description: 'Updated description',
            isActive: true,
            displayOrder: 1,
            createdAt: now,
          );
          when(
            () => mockUpdateUseCase(
              categoryId: 'cat-1',
              name: 'Updated Football',
              icon: null,
              description: 'Updated description',
            ),
          ).thenAnswer((_) async => Right(updatedCategory));
          when(() => mockGetAllUseCase()).thenAnswer(
            (_) async =>
                Right([updatedCategory, tCategories[1], tCategories[2]]),
          );
          return cubit;
        },
        act: (cubit) => cubit.updateCategory(
          categoryId: 'cat-1',
          name: 'Updated Football',
          description: 'Updated description',
        ),
        expect: () => [
          const SportCategoriesLoading(),
          isA<SportCategoriesLoaded>(),
          isA<SportCategoryOperationSuccess>(),
        ],
      );

      blocTest<SportCategoriesCubit, SportCategoriesState>(
        'should emit Error when update fails',
        build: () {
          when(
            () => mockUpdateUseCase(
              categoryId: any(named: 'categoryId'),
              name: any(named: 'name'),
              icon: any(named: 'icon'),
              description: any(named: 'description'),
            ),
          ).thenAnswer(
            (_) async => const Left(ServerFailure('Category not found')),
          );
          return cubit;
        },
        act: (cubit) =>
            cubit.updateCategory(categoryId: 'invalid-id', name: 'New Name'),
        expect: () => [
          const SportCategoriesError(message: 'Category not found'),
        ],
      );

      blocTest<SportCategoriesCubit, SportCategoriesState>(
        'should update only icon',
        build: () {
          when(
            () => mockUpdateUseCase(
              categoryId: 'cat-2',
              name: null,
              icon: '🏀️',
              description: null,
            ),
          ).thenAnswer((_) async => Right(tCategories[1]));
          when(
            () => mockGetAllUseCase(),
          ).thenAnswer((_) async => Right(tCategories));
          return cubit;
        },
        act: (cubit) => cubit.updateCategory(categoryId: 'cat-2', icon: '🏀️'),
        expect: () => [
          const SportCategoriesLoading(),
          SportCategoriesLoaded(categories: tCategories),
          isA<SportCategoryOperationSuccess>(),
        ],
      );
    });

    group('deleteCategory -', () {
      blocTest<SportCategoriesCubit, SportCategoriesState>(
        'should reload categories and emit Success after delete',
        build: () {
          when(
            () => mockDeleteUseCase(categoryId: 'cat-3'),
          ).thenAnswer((_) async => const Right(null));
          when(
            () => mockGetAllUseCase(),
          ).thenAnswer((_) async => Right([tCategories[0], tCategories[1]]));
          return cubit;
        },
        act: (cubit) => cubit.deleteCategory(categoryId: 'cat-3'),
        expect: () => [
          const SportCategoriesLoading(),
          SportCategoriesLoaded(categories: [tCategories[0], tCategories[1]]),
          isA<SportCategoryOperationSuccess>().having(
            (s) => s.updatedCategories.length,
            'categories count',
            2,
          ),
        ],
      );

      blocTest<SportCategoriesCubit, SportCategoriesState>(
        'should emit Error when delete fails',
        build: () {
          when(
            () => mockDeleteUseCase(categoryId: any(named: 'categoryId')),
          ).thenAnswer(
            (_) async =>
                const Left(ServerFailure('Cannot delete category with fields')),
          );
          return cubit;
        },
        act: (cubit) => cubit.deleteCategory(categoryId: 'cat-1'),
        expect: () => [
          const SportCategoriesError(
            message: 'Cannot delete category with fields',
          ),
        ],
      );
    });

    group('refresh -', () {
      blocTest<SportCategoriesCubit, SportCategoriesState>(
        'should reload categories',
        build: () {
          when(
            () => mockGetAllUseCase(),
          ).thenAnswer((_) async => Right(tCategories));
          return cubit;
        },
        seed: () => SportCategoriesLoaded(categories: [tCategories.first]),
        act: (cubit) => cubit.refresh(),
        expect: () => [
          const SportCategoriesLoading(),
          SportCategoriesLoaded(categories: tCategories),
        ],
      );
    });
  });

  group('SportCategoriesState -', () {
    group('SportCategoriesInitial -', () {
      test('props should be empty', () {
        const state = SportCategoriesInitial();
        expect(state.props, isEmpty);
      });
    });

    group('SportCategoriesLoading -', () {
      test('props should be empty', () {
        const state = SportCategoriesLoading();
        expect(state.props, isEmpty);
      });
    });

    group('SportCategoriesLoaded -', () {
      test('props should include categories', () {
        final state1 = SportCategoriesLoaded(categories: tCategories);
        final state2 = SportCategoriesLoaded(categories: tCategories);
        final state3 = SportCategoriesLoaded(categories: [tCategories.first]);

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });

      test('equality works with empty list', () {
        const state1 = SportCategoriesLoaded(categories: []);
        const state2 = SportCategoriesLoaded(categories: []);

        expect(state1, equals(state2));
      });
    });

    group('SportCategoriesError -', () {
      test('props should include message', () {
        const error1 = SportCategoriesError(message: 'Error 1');
        const error2 = SportCategoriesError(message: 'Error 1');
        const error3 = SportCategoriesError(message: 'Error 2');

        expect(error1, equals(error2));
        expect(error1, isNot(equals(error3)));
      });
    });

    group('SportCategoryOperationSuccess -', () {
      test('props should include message and updatedCategories', () {
        final success1 = SportCategoryOperationSuccess(
          message: 'Created',
          updatedCategories: tCategories,
        );
        final success2 = SportCategoryOperationSuccess(
          message: 'Created',
          updatedCategories: tCategories,
        );
        final success3 = SportCategoryOperationSuccess(
          message: 'Updated',
          updatedCategories: tCategories,
        );

        expect(success1, equals(success2));
        expect(success1, isNot(equals(success3)));
      });
    });
  });

  group('SportCategoryEntity -', () {
    test('equality works correctly', () {
      final cat1 = SportCategoryEntity(
        id: 'cat-1',
        name: 'Football',
        createdAt: now,
      );
      final cat2 = SportCategoryEntity(
        id: 'cat-1',
        name: 'Football',
        createdAt: now,
      );
      final cat3 = SportCategoryEntity(
        id: 'cat-2',
        name: 'Football',
        createdAt: now,
      );

      expect(cat1, equals(cat2));
      expect(cat1, isNot(equals(cat3)));
    });

    test('props includes all fields', () {
      final category = SportCategoryEntity(
        id: 'cat-1',
        name: 'Football',
        slug: 'FB',
        icon: '⚽',
        color: '#00FF00',
        description: 'Desc',
        isActive: true,
        displayOrder: 1,
        createdAt: now,
      );

      expect(category.props.length, equals(9));
    });
  });
}
