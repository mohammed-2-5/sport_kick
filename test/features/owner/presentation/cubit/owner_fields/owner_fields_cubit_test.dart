import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/domain/usecases/delete_field_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/get_owner_fields_usecase.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_fields/owner_fields_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_fields/owner_fields_state.dart';

// Mock Classes
class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

class MockGetOwnerFieldsUseCase extends Mock implements GetOwnerFieldsUseCase {}

class MockDeleteFieldUseCase extends Mock implements DeleteFieldUseCase {}

void main() {
  late OwnerFieldsCubit cubit;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
  late MockGetOwnerFieldsUseCase mockGetOwnerFieldsUseCase;
  late MockDeleteFieldUseCase mockDeleteFieldUseCase;

  // Test data
  final now = DateTime.now();
  const tOwnerId = 'owner-123';
  late UserEntity tUser;
  late List<FieldEntity> tFields;

  setUp(() {
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    mockGetOwnerFieldsUseCase = MockGetOwnerFieldsUseCase();
    mockDeleteFieldUseCase = MockDeleteFieldUseCase();

    tUser = UserEntity(
      id: tOwnerId,
      email: 'owner@test.com',
      fullName: 'Test Owner',
      createdAt: now,
      updatedAt: now,
    );

    tFields = [
      FieldEntity(
        id: 'field-1',
        name: 'Al-Ahly Stadium',
        sportCategoryId: 'sport-1',
        ownerId: tOwnerId,
        city: 'Cairo',
        address: '123 Stadium Street',
        pricePerHour: 200.0,
        currency: 'EGP',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      FieldEntity(
        id: 'field-2',
        name: 'Zamalek Field',
        sportCategoryId: 'sport-1',
        ownerId: tOwnerId,
        city: 'Cairo',
        address: '456 Field Road',
        pricePerHour: 300.0,
        currency: 'EGP',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      FieldEntity(
        id: 'field-3',
        name: 'Alexandria Arena',
        sportCategoryId: 'sport-2',
        ownerId: tOwnerId,
        city: 'Alexandria',
        address: '789 Arena Ave',
        pricePerHour: 250.0,
        currency: 'EGP',
        isActive: false,
        description: 'Under maintenance',
        createdAt: now,
        updatedAt: now,
      ),
    ];

    cubit = OwnerFieldsCubit(
      getCurrentUserUseCase: mockGetCurrentUserUseCase,
      getOwnerFieldsUseCase: mockGetOwnerFieldsUseCase,
      deleteFieldUseCase: mockDeleteFieldUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('OwnerFieldsCubit -', () {
    test('initial state should be OwnerFieldsLoading', () {
      expect(cubit.state, equals(const OwnerFieldsLoading()));
    });

    group('loadFields -', () {
      blocTest<OwnerFieldsCubit, OwnerFieldsState>(
        'should emit [Loading, Loaded] when successful',
        build: () {
          when(
            () => mockGetCurrentUserUseCase(),
          ).thenAnswer((_) async => Right(tUser));
          when(
            () => mockGetOwnerFieldsUseCase(ownerId: tOwnerId),
          ).thenAnswer((_) async => Right(tFields));
          return cubit;
        },
        act: (cubit) => cubit.loadFields(),
        expect: () => [
          const OwnerFieldsLoading(),
          OwnerFieldsLoaded(allFields: tFields),
        ],
      );

      blocTest<OwnerFieldsCubit, OwnerFieldsState>(
        'should emit [Loading, Error] when user not found',
        build: () {
          when(
            () => mockGetCurrentUserUseCase(),
          ).thenAnswer((_) async => const Right(null));
          return cubit;
        },
        act: (cubit) => cubit.loadFields(),
        expect: () => [
          const OwnerFieldsLoading(),
          const OwnerFieldsError('Unable to load owner data'),
        ],
      );

      blocTest<OwnerFieldsCubit, OwnerFieldsState>(
        'should emit [Loading, Error] when getCurrentUser fails',
        build: () {
          when(() => mockGetCurrentUserUseCase()).thenAnswer(
            (_) async => const Left(AuthFailure('Not authenticated')),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadFields(),
        expect: () => [
          const OwnerFieldsLoading(),
          const OwnerFieldsError('Unable to load owner data'),
        ],
      );

      blocTest<OwnerFieldsCubit, OwnerFieldsState>(
        'should emit [Loading, Error] when getOwnerFields fails',
        build: () {
          when(
            () => mockGetCurrentUserUseCase(),
          ).thenAnswer((_) async => Right(tUser));
          when(() => mockGetOwnerFieldsUseCase(ownerId: tOwnerId)).thenAnswer(
            (_) async => const Left(ServerFailure('Failed to load fields')),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadFields(),
        expect: () => [
          const OwnerFieldsLoading(),
          const OwnerFieldsError('Failed to load fields'),
        ],
      );

      blocTest<OwnerFieldsCubit, OwnerFieldsState>(
        'should emit Loaded with empty list',
        build: () {
          when(
            () => mockGetCurrentUserUseCase(),
          ).thenAnswer((_) async => Right(tUser));
          when(
            () => mockGetOwnerFieldsUseCase(ownerId: tOwnerId),
          ).thenAnswer((_) async => const Right([]));
          return cubit;
        },
        act: (cubit) => cubit.loadFields(),
        expect: () => [
          const OwnerFieldsLoading(),
          const OwnerFieldsLoaded(allFields: []),
        ],
      );
    });

    group('refresh -', () {
      blocTest<OwnerFieldsCubit, OwnerFieldsState>(
        'should set isRefreshing and then reload',
        build: () {
          when(
            () => mockGetCurrentUserUseCase(),
          ).thenAnswer((_) async => Right(tUser));
          when(
            () => mockGetOwnerFieldsUseCase(ownerId: tOwnerId),
          ).thenAnswer((_) async => Right(tFields));
          return cubit;
        },
        seed: () => OwnerFieldsLoaded(allFields: tFields),
        act: (cubit) => cubit.refresh(),
        expect: () => [
          OwnerFieldsLoaded(allFields: tFields, isRefreshing: true),
          const OwnerFieldsLoading(),
          OwnerFieldsLoaded(allFields: tFields),
        ],
      );
    });

    group('search -', () {
      blocTest<OwnerFieldsCubit, OwnerFieldsState>(
        'should update search query',
        build: () => cubit,
        seed: () => OwnerFieldsLoaded(allFields: tFields),
        act: (cubit) => cubit.search('Ahly'),
        expect: () => [
          OwnerFieldsLoaded(allFields: tFields, searchQuery: 'Ahly'),
        ],
      );

      blocTest<OwnerFieldsCubit, OwnerFieldsState>(
        'should not emit when not in Loaded state',
        build: () => cubit,
        act: (cubit) => cubit.search('Ahly'),
        expect: () => [], // No state changes
      );
    });

    group('clearSearch -', () {
      blocTest<OwnerFieldsCubit, OwnerFieldsState>(
        'should clear search query',
        build: () => cubit,
        seed: () => OwnerFieldsLoaded(allFields: tFields, searchQuery: 'Ahly'),
        act: (cubit) => cubit.clearSearch(),
        expect: () => [OwnerFieldsLoaded(allFields: tFields, searchQuery: '')],
      );
    });

    group('filterByStatus -', () {
      blocTest<OwnerFieldsCubit, OwnerFieldsState>(
        'should filter by active status',
        build: () => cubit,
        seed: () => OwnerFieldsLoaded(allFields: tFields),
        act: (cubit) => cubit.filterByStatus(true),
        expect: () => [
          OwnerFieldsLoaded(allFields: tFields, activeFilter: true),
        ],
      );

      blocTest<OwnerFieldsCubit, OwnerFieldsState>(
        'should filter by inactive status',
        build: () => cubit,
        seed: () => OwnerFieldsLoaded(allFields: tFields),
        act: (cubit) => cubit.filterByStatus(false),
        expect: () => [
          OwnerFieldsLoaded(allFields: tFields, activeFilter: false),
        ],
      );

      blocTest<OwnerFieldsCubit, OwnerFieldsState>(
        'should clear filter when null',
        build: () => cubit,
        seed: () => OwnerFieldsLoaded(allFields: tFields, activeFilter: true),
        act: (cubit) => cubit.filterByStatus(null),
        expect: () => [
          OwnerFieldsLoaded(allFields: tFields, activeFilter: null),
        ],
      );
    });

    group('deleteField -', () {
      blocTest<OwnerFieldsCubit, OwnerFieldsState>(
        'should reload fields after successful deletion',
        build: () {
          when(
            () => mockDeleteFieldUseCase('field-3'),
          ).thenAnswer((_) async => const Right(null));
          when(
            () => mockGetCurrentUserUseCase(),
          ).thenAnswer((_) async => Right(tUser));
          when(
            () => mockGetOwnerFieldsUseCase(ownerId: tOwnerId),
          ).thenAnswer((_) async => Right([tFields[0], tFields[1]]));
          return cubit;
        },
        seed: () => OwnerFieldsLoaded(allFields: tFields),
        act: (cubit) => cubit.deleteField('field-3'),
        expect: () => [
          const OwnerFieldsLoading(),
          OwnerFieldsLoaded(allFields: [tFields[0], tFields[1]]),
        ],
      );

      blocTest<OwnerFieldsCubit, OwnerFieldsState>(
        'should emit Error when deletion fails',
        build: () {
          when(() => mockDeleteFieldUseCase('field-1')).thenAnswer(
            (_) async =>
                const Left(ServerFailure('Cannot delete field with bookings')),
          );
          return cubit;
        },
        seed: () => OwnerFieldsLoaded(allFields: tFields),
        act: (cubit) => cubit.deleteField('field-1'),
        expect: () => [
          const OwnerFieldsError('Cannot delete field with bookings'),
        ],
      );
    });

    group('getStats -', () {
      test('should return correct stats when loaded', () {
        // Manually emit loaded state
        cubit.emit(OwnerFieldsLoaded(allFields: tFields));

        final stats = cubit.getStats();

        expect(stats['total'], equals(3));
        expect(stats['active'], equals(2));
        expect(stats['inactive'], equals(1));
      });

      test('should return zero stats when not loaded', () {
        final stats = cubit.getStats();

        expect(stats['total'], equals(0));
        expect(stats['active'], equals(0));
        expect(stats['inactive'], equals(0));
      });
    });
  });

  group('OwnerFieldsState -', () {
    group('OwnerFieldsLoading -', () {
      test('props should be empty', () {
        const state = OwnerFieldsLoading();
        expect(state.props, isEmpty);
      });
    });

    group('OwnerFieldsLoaded -', () {
      test('filteredFields should filter by active status', () {
        final state = OwnerFieldsLoaded(allFields: tFields, activeFilter: true);
        expect(state.filteredFields.length, equals(2));
        expect(state.filteredFields.every((f) => f.isActive), isTrue);
      });

      test('filteredFields should filter by inactive status', () {
        final state = OwnerFieldsLoaded(
          allFields: tFields,
          activeFilter: false,
        );
        expect(state.filteredFields.length, equals(1));
        expect(state.filteredFields.every((f) => !f.isActive), isTrue);
      });

      test('filteredFields should filter by search query', () {
        final state = OwnerFieldsLoaded(
          allFields: tFields,
          searchQuery: 'Ahly',
        );
        expect(state.filteredFields.length, equals(1));
        expect(state.filteredFields.first.name, contains('Ahly'));
      });

      test('filteredFields should search in city', () {
        final state = OwnerFieldsLoaded(
          allFields: tFields,
          searchQuery: 'Alexandria',
        );
        expect(state.filteredFields.length, equals(1));
        expect(state.filteredFields.first.city, equals('Alexandria'));
      });

      test('filteredFields should search in description', () {
        final state = OwnerFieldsLoaded(
          allFields: tFields,
          searchQuery: 'maintenance',
        );
        expect(state.filteredFields.length, equals(1));
        expect(state.filteredFields.first.description, contains('maintenance'));
      });

      test('filteredFields should combine filters', () {
        final state = OwnerFieldsLoaded(
          allFields: tFields,
          activeFilter: true,
          searchQuery: 'Cairo',
        );
        expect(state.filteredFields.length, equals(2));
      });

      test('activeCount should return correct count', () {
        final state = OwnerFieldsLoaded(allFields: tFields);
        expect(state.activeCount, equals(2));
      });

      test('inactiveCount should return correct count', () {
        final state = OwnerFieldsLoaded(allFields: tFields);
        expect(state.inactiveCount, equals(1));
      });

      test('copyWith should update fields correctly', () {
        final original = OwnerFieldsLoaded(allFields: tFields);
        final updated = original.copyWith(searchQuery: 'test');

        expect(updated.searchQuery, equals('test'));
        expect(updated.allFields, equals(tFields));
      });

      test('copyWith with clearFilter should set activeFilter to null', () {
        final original = OwnerFieldsLoaded(
          allFields: tFields,
          activeFilter: true,
        );
        final updated = original.copyWith(clearFilter: true);

        expect(updated.activeFilter, isNull);
      });

      test('props should include all fields', () {
        final state1 = OwnerFieldsLoaded(
          allFields: tFields,
          searchQuery: 'test',
          activeFilter: true,
          isRefreshing: false,
        );
        final state2 = OwnerFieldsLoaded(
          allFields: tFields,
          searchQuery: 'test',
          activeFilter: true,
          isRefreshing: false,
        );
        final state3 = OwnerFieldsLoaded(
          allFields: tFields,
          searchQuery: 'different',
          activeFilter: true,
          isRefreshing: false,
        );

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });
    });

    group('OwnerFieldsError -', () {
      test('props should include message', () {
        const error1 = OwnerFieldsError('Error 1');
        const error2 = OwnerFieldsError('Error 1');
        const error3 = OwnerFieldsError('Error 2');

        expect(error1, equals(error2));
        expect(error1, isNot(equals(error3)));
      });
    });
  });
}
