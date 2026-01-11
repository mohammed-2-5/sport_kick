import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/domain/usecases/delete_field_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/get_owner_fields_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/update_field_usecase.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_fields/owner_fields_crud_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_fields/owner_fields_crud_state.dart';

// Mock Classes
class MockGetOwnerFieldsUseCase extends Mock implements GetOwnerFieldsUseCase {}

class MockUpdateFieldUseCase extends Mock implements UpdateFieldUseCase {}

class MockDeleteFieldUseCase extends Mock implements DeleteFieldUseCase {}

void main() {
  late OwnerFieldsCrudCubit cubit;
  late MockGetOwnerFieldsUseCase mockGetOwnerFieldsUseCase;
  late MockUpdateFieldUseCase mockUpdateFieldUseCase;
  late MockDeleteFieldUseCase mockDeleteFieldUseCase;

  // Test data
  final now = DateTime.now();
  const tOwnerId = 'owner-123';
  const tFieldId = 'field-456';
  late List<FieldEntity> tFields;
  late FieldEntity tField;

  setUp(() {
    mockGetOwnerFieldsUseCase = MockGetOwnerFieldsUseCase();
    mockUpdateFieldUseCase = MockUpdateFieldUseCase();
    mockDeleteFieldUseCase = MockDeleteFieldUseCase();

    tField = FieldEntity(
      id: tFieldId,
      name: 'Al-Ahly Stadium',
      sportCategoryId: 'sport-1',
      ownerId: tOwnerId,
      city: 'Cairo',
      address: '123 Stadium Street',
      pricePerHour: 200.0,
      currency: 'EGP',
      isActive: true,
      isIndoor: false,
      capacity: 10,
      surfaceType: 'Grass',
      facilities: ['parking', 'lighting'],
      createdAt: now,
      updatedAt: now,
    );

    tFields = [
      tField,
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
    ];

    cubit = OwnerFieldsCrudCubit(
      getOwnerFieldsUseCase: mockGetOwnerFieldsUseCase,
      updateFieldUseCase: mockUpdateFieldUseCase,
      deleteFieldUseCase: mockDeleteFieldUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('OwnerFieldsCrudCubit -', () {
    test('initial state should be OwnerFieldsCrudInitial', () {
      expect(cubit.state, equals(const OwnerFieldsCrudInitial()));
    });

    group('loadOwnerFields -', () {
      blocTest<OwnerFieldsCrudCubit, OwnerFieldsCrudState>(
        'should emit [Loading, Loaded] when successful',
        build: () {
          when(
            () => mockGetOwnerFieldsUseCase(ownerId: tOwnerId),
          ).thenAnswer((_) async => Right(tFields));
          return cubit;
        },
        act: (cubit) => cubit.loadOwnerFields(tOwnerId),
        expect: () => [
          const OwnerFieldsCrudLoading(message: 'Loading your fields...'),
          OwnerFieldsCrudLoaded(tFields),
        ],
        verify: (_) {
          verify(() => mockGetOwnerFieldsUseCase(ownerId: tOwnerId)).called(1);
        },
      );

      blocTest<OwnerFieldsCrudCubit, OwnerFieldsCrudState>(
        'should emit [Loading, Loaded] with empty list',
        build: () {
          when(
            () => mockGetOwnerFieldsUseCase(ownerId: tOwnerId),
          ).thenAnswer((_) async => const Right([]));
          return cubit;
        },
        act: (cubit) => cubit.loadOwnerFields(tOwnerId),
        expect: () => [
          const OwnerFieldsCrudLoading(message: 'Loading your fields...'),
          const OwnerFieldsCrudLoaded([]),
        ],
      );

      blocTest<OwnerFieldsCrudCubit, OwnerFieldsCrudState>(
        'should emit [Loading, Error] when failure occurs',
        build: () {
          when(() => mockGetOwnerFieldsUseCase(ownerId: tOwnerId)).thenAnswer(
            (_) async => const Left(ServerFailure('Failed to load fields')),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadOwnerFields(tOwnerId),
        expect: () => [
          const OwnerFieldsCrudLoading(message: 'Loading your fields...'),
          const OwnerFieldsCrudError('Failed to load fields'),
        ],
      );
    });

    group('updateField -', () {
      final tUpdates = {'name': 'Updated Stadium', 'pricePerHour': 250.0};
      final tUpdatedField = FieldEntity(
        id: tFieldId,
        name: 'Updated Stadium',
        sportCategoryId: 'sport-1',
        ownerId: tOwnerId,
        city: 'Cairo',
        address: '123 Stadium Street',
        pricePerHour: 250.0,
        currency: 'EGP',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );

      blocTest<OwnerFieldsCrudCubit, OwnerFieldsCrudState>(
        'should emit [Loading, FieldUpdated] when successful',
        build: () {
          when(
            () => mockUpdateFieldUseCase(fieldId: tFieldId, updates: tUpdates),
          ).thenAnswer((_) async => Right(tUpdatedField));
          return cubit;
        },
        act: (cubit) => cubit.updateField(tFieldId, tUpdates),
        expect: () => [
          const OwnerFieldsCrudLoading(message: 'Updating field...'),
          FieldUpdated(tUpdatedField),
        ],
        verify: (_) {
          verify(
            () => mockUpdateFieldUseCase(fieldId: tFieldId, updates: tUpdates),
          ).called(1);
        },
      );

      blocTest<OwnerFieldsCrudCubit, OwnerFieldsCrudState>(
        'should emit [Loading, Error] when update fails',
        build: () {
          when(
            () => mockUpdateFieldUseCase(fieldId: tFieldId, updates: tUpdates),
          ).thenAnswer((_) async => const Left(ServerFailure('Update failed')));
          return cubit;
        },
        act: (cubit) => cubit.updateField(tFieldId, tUpdates),
        expect: () => [
          const OwnerFieldsCrudLoading(message: 'Updating field...'),
          const OwnerFieldsCrudError('Update failed'),
        ],
      );
    });

    group('deleteField -', () {
      blocTest<OwnerFieldsCrudCubit, OwnerFieldsCrudState>(
        'should emit [Loading, FieldDeleted] when successful',
        build: () {
          when(
            () => mockDeleteFieldUseCase(tFieldId),
          ).thenAnswer((_) async => const Right(null));
          return cubit;
        },
        act: (cubit) => cubit.deleteField(tFieldId),
        expect: () => [
          const OwnerFieldsCrudLoading(message: 'Deleting field...'),
          const FieldDeleted(tFieldId),
        ],
        verify: (_) {
          verify(() => mockDeleteFieldUseCase(tFieldId)).called(1);
        },
      );

      blocTest<OwnerFieldsCrudCubit, OwnerFieldsCrudState>(
        'should emit [Loading, Error] when delete fails',
        build: () {
          when(() => mockDeleteFieldUseCase(tFieldId)).thenAnswer(
            (_) async =>
                const Left(ServerFailure('Cannot delete field with bookings')),
          );
          return cubit;
        },
        act: (cubit) => cubit.deleteField(tFieldId),
        expect: () => [
          const OwnerFieldsCrudLoading(message: 'Deleting field...'),
          const OwnerFieldsCrudError('Cannot delete field with bookings'),
        ],
      );
    });

    group('initializeFieldForm -', () {
      blocTest<OwnerFieldsCrudCubit, OwnerFieldsCrudState>(
        'should emit FieldFormInitialized with form data when field provided',
        build: () => cubit,
        act: (cubit) => cubit.initializeFieldForm(tField),
        expect: () => [
          isA<FieldFormInitialized>()
              .having(
                (s) => s.formData['name'],
                'name',
                equals('Al-Ahly Stadium'),
              )
              .having(
                (s) => s.formData['address'],
                'address',
                equals('123 Stadium Street'),
              )
              .having((s) => s.formData['city'], 'city', equals('Cairo'))
              .having(
                (s) => s.formData['pricePerHour'],
                'pricePerHour',
                equals('200.0'),
              ),
        ],
      );

      blocTest<OwnerFieldsCrudCubit, OwnerFieldsCrudState>(
        'should emit Initial when field is null',
        build: () => cubit,
        act: (cubit) => cubit.initializeFieldForm(null),
        expect: () => [const OwnerFieldsCrudInitial()],
      );

      test('should map capacity to owner size format', () {
        final fieldWithCapacity = FieldEntity(
          id: tFieldId,
          name: 'Al-Ahly Stadium',
          sportCategoryId: 'sport-1',
          ownerId: tOwnerId,
          city: 'Cairo',
          address: '123 Stadium Street',
          pricePerHour: 200.0,
          currency: 'EGP',
          isActive: true,
          capacity: 10,
          createdAt: now,
          updatedAt: now,
        );
        cubit.initializeFieldForm(fieldWithCapacity);

        expect(cubit.state, isA<FieldFormInitialized>());
        final formState = cubit.state as FieldFormInitialized;
        expect(formState.formData['size'], isNotNull);
      });

      test('should convert isIndoor to type string', () {
        final indoorField = FieldEntity(
          id: tFieldId,
          name: 'Al-Ahly Stadium',
          sportCategoryId: 'sport-1',
          ownerId: tOwnerId,
          city: 'Cairo',
          address: '123 Stadium Street',
          pricePerHour: 200.0,
          currency: 'EGP',
          isActive: true,
          isIndoor: true,
          createdAt: now,
          updatedAt: now,
        );
        cubit.initializeFieldForm(indoorField);

        expect(cubit.state, isA<FieldFormInitialized>());
        final formState = cubit.state as FieldFormInitialized;
        expect(formState.formData['type'], equals('Indoor'));
      });

      test('should copy facilities list', () {
        cubit.initializeFieldForm(tField);

        expect(cubit.state, isA<FieldFormInitialized>());
        final formState = cubit.state as FieldFormInitialized;
        expect(
          formState.formData['facilities'],
          equals(['parking', 'lighting']),
        );
      });
    });

    group('submitFieldUpdate -', () {
      final tFormData = {
        'name': 'Updated Stadium',
        'description': 'Great field',
        'address': '789 New Address',
        'city': 'Cairo',
        'pricePerHour': '300.0',
        'size': '7v7',
        'surface': 'Artificial',
        'type': 'Indoor',
        'facilities': ['wifi', 'parking'],
      };

      blocTest<OwnerFieldsCrudCubit, OwnerFieldsCrudState>(
        'should emit [Loading, FieldUpdated] when successful',
        build: () {
          when(
            () => mockUpdateFieldUseCase(
              fieldId: tFieldId,
              updates: any(named: 'updates'),
            ),
          ).thenAnswer((_) async => Right(tField));
          return cubit;
        },
        act: (cubit) => cubit.submitFieldUpdate(tFieldId, tFormData),
        expect: () => [
          const OwnerFieldsCrudLoading(message: 'Updating field...'),
          FieldUpdated(tField),
        ],
      );

      blocTest<OwnerFieldsCrudCubit, OwnerFieldsCrudState>(
        'should emit [Loading, Error] when submission fails',
        build: () {
          when(
            () => mockUpdateFieldUseCase(
              fieldId: tFieldId,
              updates: any(named: 'updates'),
            ),
          ).thenAnswer(
            (_) async => const Left(ServerFailure('Validation error')),
          );
          return cubit;
        },
        act: (cubit) => cubit.submitFieldUpdate(tFieldId, tFormData),
        expect: () => [
          const OwnerFieldsCrudLoading(message: 'Updating field...'),
          const OwnerFieldsCrudError('Validation error'),
        ],
      );
    });

    group('reset -', () {
      blocTest<OwnerFieldsCrudCubit, OwnerFieldsCrudState>(
        'should emit Initial when resetting from Loaded',
        build: () => cubit,
        seed: () => OwnerFieldsCrudLoaded(tFields),
        act: (cubit) => cubit.reset(),
        expect: () => [const OwnerFieldsCrudInitial()],
      );

      blocTest<OwnerFieldsCrudCubit, OwnerFieldsCrudState>(
        'should emit Initial when resetting from Error',
        build: () => cubit,
        seed: () => const OwnerFieldsCrudError('Some error'),
        act: (cubit) => cubit.reset(),
        expect: () => [const OwnerFieldsCrudInitial()],
      );
    });
  });

  group('OwnerFieldsCrudState -', () {
    group('OwnerFieldsCrudInitial -', () {
      test('props should be empty', () {
        const state = OwnerFieldsCrudInitial();
        expect(state.props, isEmpty);
      });
    });

    group('OwnerFieldsCrudLoading -', () {
      test('props should include message', () {
        const state1 = OwnerFieldsCrudLoading(message: 'Loading...');
        const state2 = OwnerFieldsCrudLoading(message: 'Loading...');
        const state3 = OwnerFieldsCrudLoading(message: 'Different');

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });

      test('default message is Loading...', () {
        const state = OwnerFieldsCrudLoading();
        expect(state.message, equals('Loading...'));
      });
    });

    group('OwnerFieldsCrudError -', () {
      test('props should include message', () {
        const error1 = OwnerFieldsCrudError('Error 1');
        const error2 = OwnerFieldsCrudError('Error 1');
        const error3 = OwnerFieldsCrudError('Error 2');

        expect(error1, equals(error2));
        expect(error1, isNot(equals(error3)));
      });
    });

    group('OwnerFieldsCrudLoaded -', () {
      test('props should include fields', () {
        final state1 = OwnerFieldsCrudLoaded(tFields);
        final state2 = OwnerFieldsCrudLoaded(tFields);

        expect(state1, equals(state2));
      });

      test('equality works with empty list', () {
        const state1 = OwnerFieldsCrudLoaded([]);
        const state2 = OwnerFieldsCrudLoaded([]);

        expect(state1, equals(state2));
      });
    });

    group('FieldUpdated -', () {
      test('props should include field', () {
        final state1 = FieldUpdated(tField);
        final state2 = FieldUpdated(tField);

        expect(state1, equals(state2));
      });
    });

    group('FieldDeleted -', () {
      test('props should include fieldId', () {
        const state1 = FieldDeleted('field-1');
        const state2 = FieldDeleted('field-1');
        const state3 = FieldDeleted('field-2');

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });
    });

    group('FieldFormInitialized -', () {
      test('props should include formData', () {
        const formData = {'name': 'Test', 'price': 100};
        const state1 = FieldFormInitialized(formData);
        const state2 = FieldFormInitialized(formData);
        const state3 = FieldFormInitialized({'name': 'Different'});

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });
    });
  });
}
