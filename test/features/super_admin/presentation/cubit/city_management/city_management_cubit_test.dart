import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/entities/city_entity.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/create_city_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/delete_city_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_active_cities_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/update_city_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/city_management/city_management_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/city_management/city_management_state.dart';

// Mock Use Cases
class MockGetActiveCitiesUseCase extends Mock
    implements GetActiveCitiesUseCase {}

class MockCreateCityUseCase extends Mock implements CreateCityUseCase {}

class MockUpdateCityUseCase extends Mock implements UpdateCityUseCase {}

class MockDeleteCityUseCase extends Mock implements DeleteCityUseCase {}

void main() {
  late CityManagementCubit cubit;
  late MockGetActiveCitiesUseCase mockGetCities;
  late MockCreateCityUseCase mockCreateCity;
  late MockUpdateCityUseCase mockUpdateCity;
  late MockDeleteCityUseCase mockDeleteCity;

  // Test data
  final now = DateTime.now();
  final testCity1 = CityEntity(
    id: 'city-1',
    name: 'Cairo',
    isActive: true,
    fieldsCount: 10,
    createdAt: now,
    updatedAt: now,
  );

  final testCity2 = CityEntity(
    id: 'city-2',
    name: 'Alexandria',
    isActive: true,
    fieldsCount: 5,
    createdAt: now,
    updatedAt: now,
  );

  final allCities = [testCity1, testCity2];

  setUp(() {
    mockGetCities = MockGetActiveCitiesUseCase();
    mockCreateCity = MockCreateCityUseCase();
    mockUpdateCity = MockUpdateCityUseCase();
    mockDeleteCity = MockDeleteCityUseCase();

    cubit = CityManagementCubit(
      getActiveCitiesUseCase: mockGetCities,
      createCityUseCase: mockCreateCity,
      updateCityUseCase: mockUpdateCity,
      deleteCityUseCase: mockDeleteCity,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('CityManagementCubit', () {
    test('initial state is CityManagementInitial', () {
      expect(cubit.state, const CityManagementInitial());
    });
  });

  group('loadCities', () {
    blocTest<CityManagementCubit, CityManagementState>(
      'emits [Loading, CitiesLoaded] when loading succeeds',
      build: () {
        when(() => mockGetCities()).thenAnswer((_) async => Right(allCities));
        return cubit;
      },
      act: (cubit) => cubit.loadCities(),
      expect: () => [
        isA<CityManagementLoading>(),
        isA<CitiesLoaded>().having((s) => s.cities.length, 'count', 2),
      ],
    );

    blocTest<CityManagementCubit, CityManagementState>(
      'emits [Loading, Error] when loading fails',
      build: () {
        when(
          () => mockGetCities(),
        ).thenAnswer((_) async => const Left(ServerFailure('Network error')));
        return cubit;
      },
      act: (cubit) => cubit.loadCities(),
      expect: () => [
        isA<CityManagementLoading>(),
        isA<CityManagementError>().having(
          (s) => s.message,
          'message',
          'Network error',
        ),
      ],
    );
  });

  group('createCity', () {
    blocTest<CityManagementCubit, CityManagementState>(
      'emits [Loading, CityCreated] and reloads on success',
      build: () {
        when(
          () => mockCreateCity(name: 'Minya', isActive: true),
        ).thenAnswer((_) async => Right(testCity1));
        when(() => mockGetCities()).thenAnswer((_) async => Right(allCities));
        return cubit;
      },
      act: (cubit) => cubit.createCity(name: 'Minya'),
      expect: () => [
        isA<CityManagementLoading>(),
        isA<CityCreated>(),
        isA<CityManagementLoading>(),
        isA<CitiesLoaded>(),
      ],
    );

    blocTest<CityManagementCubit, CityManagementState>(
      'emits Error when creation fails',
      build: () {
        when(
          () => mockCreateCity(name: 'Minya', isActive: true),
        ).thenAnswer((_) async => const Left(ServerFailure('City exists')));
        return cubit;
      },
      act: (cubit) => cubit.createCity(name: 'Minya'),
      expect: () => [
        isA<CityManagementLoading>(),
        isA<CityManagementError>().having(
          (s) => s.message,
          'message',
          'City exists',
        ),
      ],
    );
  });

  group('updateCity', () {
    blocTest<CityManagementCubit, CityManagementState>(
      'emits [Loading, CityUpdated] and reloads on success',
      build: () {
        when(
          () => mockUpdateCity(cityId: 'city-1', name: 'New Cairo'),
        ).thenAnswer((_) async => Right(testCity1));
        when(() => mockGetCities()).thenAnswer((_) async => Right(allCities));
        return cubit;
      },
      act: (cubit) => cubit.updateCity(cityId: 'city-1', name: 'New Cairo'),
      expect: () => [
        isA<CityManagementLoading>(),
        isA<CityUpdated>(),
        isA<CityManagementLoading>(),
        isA<CitiesLoaded>(),
      ],
    );

    blocTest<CityManagementCubit, CityManagementState>(
      'emits Error when update fails',
      build: () {
        when(
          () => mockUpdateCity(cityId: 'city-1', name: 'New Cairo'),
        ).thenAnswer((_) async => const Left(ServerFailure('Update failed')));
        return cubit;
      },
      act: (cubit) => cubit.updateCity(cityId: 'city-1', name: 'New Cairo'),
      expect: () => [
        isA<CityManagementLoading>(),
        isA<CityManagementError>().having(
          (s) => s.message,
          'message',
          'Update failed',
        ),
      ],
    );
  });

  group('deleteCity', () {
    blocTest<CityManagementCubit, CityManagementState>(
      'emits [Loading, CityDeleted] and reloads on success',
      build: () {
        when(
          () => mockDeleteCity(cityId: 'city-1', hardDelete: true),
        ).thenAnswer((_) async => const Right(null));
        when(() => mockGetCities()).thenAnswer((_) async => Right([testCity2]));
        return cubit;
      },
      act: (cubit) => cubit.deleteCity(cityId: 'city-1', hardDelete: true),
      expect: () => [
        isA<CityManagementLoading>(),
        isA<CityDeleted>(),
        isA<CityManagementLoading>(),
        isA<CitiesLoaded>().having((s) => s.cities.length, 'count', 1),
      ],
    );

    blocTest<CityManagementCubit, CityManagementState>(
      'emits Error when delete fails',
      build: () {
        when(
          () => mockDeleteCity(cityId: 'city-1', hardDelete: true),
        ).thenAnswer((_) async => const Left(ServerFailure('Delete failed')));
        return cubit;
      },
      act: (cubit) => cubit.deleteCity(cityId: 'city-1', hardDelete: true),
      expect: () => [
        isA<CityManagementLoading>(),
        isA<CityManagementError>().having(
          (s) => s.message,
          'message',
          'Delete failed',
        ),
      ],
    );
  });
}
