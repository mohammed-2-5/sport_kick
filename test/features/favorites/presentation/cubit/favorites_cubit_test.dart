import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/favorites/domain/usecases/add_to_favorites_usecase.dart';
import 'package:spo_kick/features/favorites/domain/usecases/get_favorite_field_ids_usecase.dart';
import 'package:spo_kick/features/favorites/domain/usecases/is_favorite_usecase.dart';
import 'package:spo_kick/features/favorites/domain/usecases/remove_from_favorites_usecase.dart';
import 'package:spo_kick/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:spo_kick/features/favorites/presentation/cubit/favorites_state.dart';

// Mock Classes
class MockIsFavoriteUseCase extends Mock implements IsFavoriteUseCase {}

class MockAddToFavoritesUseCase extends Mock implements AddToFavoritesUseCase {}

class MockRemoveFromFavoritesUseCase extends Mock
    implements RemoveFromFavoritesUseCase {}

class MockGetFavoriteFieldIdsUseCase extends Mock
    implements GetFavoriteFieldIdsUseCase {}

void main() {
  late FavoritesCubit cubit;
  late MockIsFavoriteUseCase mockIsFavoriteUseCase;
  late MockAddToFavoritesUseCase mockAddToFavoritesUseCase;
  late MockRemoveFromFavoritesUseCase mockRemoveFromFavoritesUseCase;
  late MockGetFavoriteFieldIdsUseCase mockGetFavoriteFieldIdsUseCase;

  // Test data
  const tFieldId = 'field-123';
  const tFieldId2 = 'field-456';
  const tFavoriteFieldIds = ['field-123', 'field-456', 'field-789'];

  setUp(() {
    mockIsFavoriteUseCase = MockIsFavoriteUseCase();
    mockAddToFavoritesUseCase = MockAddToFavoritesUseCase();
    mockRemoveFromFavoritesUseCase = MockRemoveFromFavoritesUseCase();
    mockGetFavoriteFieldIdsUseCase = MockGetFavoriteFieldIdsUseCase();

    cubit = FavoritesCubit(
      isFavoriteUseCase: mockIsFavoriteUseCase,
      addToFavoritesUseCase: mockAddToFavoritesUseCase,
      removeFromFavoritesUseCase: mockRemoveFromFavoritesUseCase,
      getFavoriteFieldIdsUseCase: mockGetFavoriteFieldIdsUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('FavoritesCubit -', () {
    test('initial state should be FavoritesInitial', () {
      expect(cubit.state, equals(const FavoritesInitial()));
    });

    group('checkIsFavorite -', () {
      blocTest<FavoritesCubit, FavoritesState>(
        'should emit [Loading, StatusLoaded(true)] when field is favorited',
        build: () {
          when(
            () => mockIsFavoriteUseCase(tFieldId),
          ).thenAnswer((_) async => const Right(true));
          return cubit;
        },
        act: (cubit) => cubit.checkIsFavorite(tFieldId),
        expect: () => [
          const FavoritesLoading(),
          const FavoriteStatusLoaded(fieldId: tFieldId, isFavorite: true),
        ],
        verify: (_) {
          verify(() => mockIsFavoriteUseCase(tFieldId)).called(1);
        },
      );

      blocTest<FavoritesCubit, FavoritesState>(
        'should emit [Loading, StatusLoaded(false)] when field is not favorited',
        build: () {
          when(
            () => mockIsFavoriteUseCase(tFieldId2),
          ).thenAnswer((_) async => const Right(false));
          return cubit;
        },
        act: (cubit) => cubit.checkIsFavorite(tFieldId2),
        expect: () => [
          const FavoritesLoading(),
          const FavoriteStatusLoaded(fieldId: tFieldId2, isFavorite: false),
        ],
      );

      blocTest<FavoritesCubit, FavoritesState>(
        'should emit [Loading, Error] when check fails',
        build: () {
          when(() => mockIsFavoriteUseCase(tFieldId)).thenAnswer(
            (_) async =>
                const Left(ServerFailure('Failed to check favorite status')),
          );
          return cubit;
        },
        act: (cubit) => cubit.checkIsFavorite(tFieldId),
        expect: () => [
          const FavoritesLoading(),
          const FavoritesError(message: 'Failed to check favorite status'),
        ],
      );

      blocTest<FavoritesCubit, FavoritesState>(
        'should emit Error when network failure occurs',
        build: () {
          when(() => mockIsFavoriteUseCase(tFieldId)).thenAnswer(
            (_) async => const Left(NetworkFailure('No internet connection')),
          );
          return cubit;
        },
        act: (cubit) => cubit.checkIsFavorite(tFieldId),
        expect: () => [
          const FavoritesLoading(),
          const FavoritesError(message: 'No internet connection'),
        ],
      );
    });

    group('toggleFavorite -', () {
      blocTest<FavoritesCubit, FavoritesState>(
        'should remove favorite when currentStatus is true',
        build: () {
          when(
            () => mockRemoveFromFavoritesUseCase(tFieldId),
          ).thenAnswer((_) async => const Right(null));
          return cubit;
        },
        act: (cubit) => cubit.toggleFavorite(tFieldId, true),
        expect: () => [
          const FavoriteToggled(fieldId: tFieldId, isFavorite: false),
        ],
        verify: (_) {
          verify(() => mockRemoveFromFavoritesUseCase(tFieldId)).called(1);
          verifyNever(() => mockAddToFavoritesUseCase(any()));
        },
      );

      blocTest<FavoritesCubit, FavoritesState>(
        'should add favorite when currentStatus is false',
        build: () {
          when(
            () => mockAddToFavoritesUseCase(tFieldId),
          ).thenAnswer((_) async => const Right(null));
          return cubit;
        },
        act: (cubit) => cubit.toggleFavorite(tFieldId, false),
        expect: () => [
          const FavoriteToggled(fieldId: tFieldId, isFavorite: true),
        ],
        verify: (_) {
          verify(() => mockAddToFavoritesUseCase(tFieldId)).called(1);
          verifyNever(() => mockRemoveFromFavoritesUseCase(any()));
        },
      );

      blocTest<FavoritesCubit, FavoritesState>(
        'should emit Error when remove fails',
        build: () {
          when(() => mockRemoveFromFavoritesUseCase(tFieldId)).thenAnswer(
            (_) async =>
                const Left(ServerFailure('Failed to remove from favorites')),
          );
          return cubit;
        },
        act: (cubit) => cubit.toggleFavorite(tFieldId, true),
        expect: () => [
          const FavoritesError(message: 'Failed to remove from favorites'),
        ],
      );

      blocTest<FavoritesCubit, FavoritesState>(
        'should emit Error when add fails',
        build: () {
          when(() => mockAddToFavoritesUseCase(tFieldId)).thenAnswer(
            (_) async =>
                const Left(ServerFailure('Failed to add to favorites')),
          );
          return cubit;
        },
        act: (cubit) => cubit.toggleFavorite(tFieldId, false),
        expect: () => [
          const FavoritesError(message: 'Failed to add to favorites'),
        ],
      );
    });

    group('loadFavorites -', () {
      blocTest<FavoritesCubit, FavoritesState>(
        'should emit [Loading, ListLoaded] when successful',
        build: () {
          when(
            () => mockGetFavoriteFieldIdsUseCase(),
          ).thenAnswer((_) async => const Right(tFavoriteFieldIds));
          return cubit;
        },
        act: (cubit) => cubit.loadFavorites(),
        expect: () => [
          const FavoritesLoading(),
          const FavoritesListLoaded(favoriteFieldIds: tFavoriteFieldIds),
        ],
        verify: (_) {
          verify(() => mockGetFavoriteFieldIdsUseCase()).called(1);
        },
      );

      blocTest<FavoritesCubit, FavoritesState>(
        'should emit [Loading, ListLoaded(empty)] when no favorites',
        build: () {
          when(
            () => mockGetFavoriteFieldIdsUseCase(),
          ).thenAnswer((_) async => const Right([]));
          return cubit;
        },
        act: (cubit) => cubit.loadFavorites(),
        expect: () => [
          const FavoritesLoading(),
          const FavoritesListLoaded(favoriteFieldIds: []),
        ],
      );

      blocTest<FavoritesCubit, FavoritesState>(
        'should emit [Loading, Error] when loading fails',
        build: () {
          when(() => mockGetFavoriteFieldIdsUseCase()).thenAnswer(
            (_) async => const Left(ServerFailure('Failed to load favorites')),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadFavorites(),
        expect: () => [
          const FavoritesLoading(),
          const FavoritesError(message: 'Failed to load favorites'),
        ],
      );
    });

    group('addFavorite -', () {
      blocTest<FavoritesCubit, FavoritesState>(
        'should emit Toggled(true) when add succeeds',
        build: () {
          when(
            () => mockAddToFavoritesUseCase(tFieldId),
          ).thenAnswer((_) async => const Right(null));
          return cubit;
        },
        act: (cubit) => cubit.addFavorite(tFieldId),
        expect: () => [
          const FavoriteToggled(fieldId: tFieldId, isFavorite: true),
        ],
      );

      blocTest<FavoritesCubit, FavoritesState>(
        'should emit Error when add fails',
        build: () {
          when(() => mockAddToFavoritesUseCase(tFieldId)).thenAnswer(
            (_) async =>
                const Left(ServerFailure('Failed to add to favorites')),
          );
          return cubit;
        },
        act: (cubit) => cubit.addFavorite(tFieldId),
        expect: () => [
          const FavoritesError(message: 'Failed to add to favorites'),
        ],
      );
    });

    group('removeFavorite -', () {
      blocTest<FavoritesCubit, FavoritesState>(
        'should emit Toggled(false) when remove succeeds',
        build: () {
          when(
            () => mockRemoveFromFavoritesUseCase(tFieldId),
          ).thenAnswer((_) async => const Right(null));
          return cubit;
        },
        act: (cubit) => cubit.removeFavorite(tFieldId),
        expect: () => [
          const FavoriteToggled(fieldId: tFieldId, isFavorite: false),
        ],
      );

      blocTest<FavoritesCubit, FavoritesState>(
        'should emit Error when remove fails',
        build: () {
          when(() => mockRemoveFromFavoritesUseCase(tFieldId)).thenAnswer(
            (_) async =>
                const Left(ServerFailure('Failed to remove from favorites')),
          );
          return cubit;
        },
        act: (cubit) => cubit.removeFavorite(tFieldId),
        expect: () => [
          const FavoritesError(message: 'Failed to remove from favorites'),
        ],
      );
    });
  });

  group('FavoritesState -', () {
    group('FavoritesInitial -', () {
      test('props should be empty', () {
        const state = FavoritesInitial();
        expect(state.props, isEmpty);
      });
    });

    group('FavoritesLoading -', () {
      test('props should be empty', () {
        const state = FavoritesLoading();
        expect(state.props, isEmpty);
      });
    });

    group('FavoriteStatusLoaded -', () {
      test('props should include fieldId and isFavorite', () {
        const state1 = FavoriteStatusLoaded(
          fieldId: 'field-1',
          isFavorite: true,
        );
        const state2 = FavoriteStatusLoaded(
          fieldId: 'field-1',
          isFavorite: true,
        );
        const state3 = FavoriteStatusLoaded(
          fieldId: 'field-1',
          isFavorite: false,
        );

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });
    });

    group('FavoritesListLoaded -', () {
      test('isFavorite returns true for favorited field', () {
        const state = FavoritesListLoaded(favoriteFieldIds: tFavoriteFieldIds);

        expect(state.isFavorite('field-123'), isTrue);
        expect(state.isFavorite('field-456'), isTrue);
        expect(state.isFavorite('field-999'), isFalse);
      });

      test('count returns correct count', () {
        const state = FavoritesListLoaded(favoriteFieldIds: tFavoriteFieldIds);
        expect(state.count, equals(3));
      });

      test('isEmpty returns correct value', () {
        const emptyState = FavoritesListLoaded(favoriteFieldIds: []);
        const populatedState = FavoritesListLoaded(
          favoriteFieldIds: tFavoriteFieldIds,
        );

        expect(emptyState.isEmpty, isTrue);
        expect(populatedState.isEmpty, isFalse);
      });

      test('filterFavorites filters list correctly', () {
        const state = FavoritesListLoaded(favoriteFieldIds: ['id-1', 'id-3']);

        final allItems = [
          {'id': 'id-1', 'name': 'Field 1'},
          {'id': 'id-2', 'name': 'Field 2'},
          {'id': 'id-3', 'name': 'Field 3'},
          {'id': 'id-4', 'name': 'Field 4'},
        ];

        final filtered = state.filterFavorites<Map<String, String>>(
          allItems,
          (item) => item['id']!,
        );

        expect(filtered.length, equals(2));
        expect(filtered[0]['id'], equals('id-1'));
        expect(filtered[1]['id'], equals('id-3'));
      });

      test('props includes favoriteFieldIds', () {
        const state1 = FavoritesListLoaded(favoriteFieldIds: ['a', 'b']);
        const state2 = FavoritesListLoaded(favoriteFieldIds: ['a', 'b']);
        const state3 = FavoritesListLoaded(favoriteFieldIds: ['a', 'c']);

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });
    });

    group('FavoriteToggled -', () {
      test('props should include fieldId and isFavorite', () {
        const state1 = FavoriteToggled(fieldId: 'field-1', isFavorite: true);
        const state2 = FavoriteToggled(fieldId: 'field-1', isFavorite: true);
        const state3 = FavoriteToggled(fieldId: 'field-2', isFavorite: true);
        const state4 = FavoriteToggled(fieldId: 'field-1', isFavorite: false);

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
        expect(state1, isNot(equals(state4)));
      });
    });

    group('FavoritesError -', () {
      test('props should include message', () {
        const error1 = FavoritesError(message: 'Error 1');
        const error2 = FavoritesError(message: 'Error 1');
        const error3 = FavoritesError(message: 'Error 2');

        expect(error1, equals(error2));
        expect(error1, isNot(equals(error3)));
      });
    });
  });
}
