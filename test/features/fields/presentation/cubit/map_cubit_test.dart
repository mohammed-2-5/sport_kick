import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:spo_kick/features/fields/presentation/cubit/map_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/map_state.dart';

// Mock Geolocator Platform
class MockGeolocatorPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements GeolocatorPlatform {}

void main() {
  late MapCubit cubit;
  late MockGeolocatorPlatform mockGeolocator;

  setUpAll(() {
    registerFallbackValue(const LocationSettings());
  });

  setUp(() {
    mockGeolocator = MockGeolocatorPlatform();
    GeolocatorPlatform.instance = mockGeolocator;
    cubit = MapCubit();
  });

  tearDown(() {
    cubit.close();
  });

  group('MapCubit', () {
    test('initial state is MapInitial', () {
      expect(cubit.state, const MapInitial());
    });
  });

  group('getUserLocation', () {
    final position = Position(
      longitude: 30.0,
      latitude: 31.0,
      timestamp: DateTime.now(),
      accuracy: 10.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );

    blocTest<MapCubit, MapState>(
      'emits [Loading, Loaded] when location service enabled and permission granted',
      build: () {
        when(
          () => mockGeolocator.isLocationServiceEnabled(),
        ).thenAnswer((_) async => true);
        when(
          () => mockGeolocator.checkPermission(),
        ).thenAnswer((_) async => LocationPermission.whileInUse);
        when(
          () => mockGeolocator.getCurrentPosition(
            locationSettings: any(named: 'locationSettings'),
          ),
        ).thenAnswer((_) async => position);
        return cubit;
      },
      act: (cubit) => cubit.getUserLocation(),
      expect: () => [
        const MapLocationLoading(),
        isA<MapLocationLoaded>().having(
          (s) => s.userLocation!.latitude,
          'lat',
          31.0,
        ),
      ],
    );

    blocTest<MapCubit, MapState>(
      'emits [Loading, PermissionDenied] when permission denied',
      build: () {
        when(
          () => mockGeolocator.isLocationServiceEnabled(),
        ).thenAnswer((_) async => true);
        when(
          () => mockGeolocator.checkPermission(),
        ).thenAnswer((_) async => LocationPermission.denied);
        when(
          () => mockGeolocator.requestPermission(),
        ).thenAnswer((_) async => LocationPermission.denied);
        return cubit;
      },
      act: (cubit) => cubit.getUserLocation(),
      expect: () => [
        const MapLocationLoading(),
        isA<MapLocationPermissionDenied>(),
      ],
    );
  });

  group('Filters', () {
    blocTest<MapCubit, MapState>(
      'setVerifiedOnly updates filters',
      build: () => cubit,
      act: (cubit) => cubit.setVerifiedOnly(true),
      expect: () => [
        isA<MapFiltersApplied>().having(
          (s) => s.filters.verifiedOnly,
          'verifiedOnly',
          true,
        ),
      ],
    );

    blocTest<MapCubit, MapState>(
      'setMinRating updates filters',
      build: () => cubit,
      act: (cubit) => cubit.setMinRating(4.5),
      expect: () => [
        isA<MapFiltersApplied>().having(
          (s) => s.filters.minRating,
          'minRating',
          4.5,
        ),
      ],
    );

    blocTest<MapCubit, MapState>(
      'setMaxPrice updates filters',
      build: () => cubit,
      act: (cubit) => cubit.setMaxPrice(200),
      expect: () => [
        isA<MapFiltersApplied>().having(
          (s) => s.filters.maxPrice,
          'maxPrice',
          200,
        ),
      ],
    );

    blocTest<MapCubit, MapState>(
      'setSurfaceType updates filters',
      build: () => cubit,
      act: (cubit) => cubit.setSurfaceType('Grass'),
      expect: () => [
        isA<MapFiltersApplied>().having(
          (s) => s.filters.surfaceType,
          'surfaceType',
          'Grass',
        ),
      ],
    );

    blocTest<MapCubit, MapState>(
      'setSortByDistance updates filters',
      build: () => cubit,
      act: (cubit) => cubit.setSortByDistance(true),
      expect: () => [
        isA<MapFiltersApplied>().having(
          (s) => s.filters.sortByDistance,
          'sortByDistance',
          true,
        ),
      ],
    );

    blocTest<MapCubit, MapState>(
      'clearFilters resets filters',
      build: () => cubit,
      seed: () =>
          MapFiltersApplied(filters: const MapFilters(verifiedOnly: true)),
      act: (cubit) => cubit.clearFilters(),
      expect: () => [
        isA<MapFiltersApplied>().having(
          (s) => s.filters,
          'filters',
          const MapFilters(),
        ),
      ],
    );
  });

  group('reset', () {
    blocTest<MapCubit, MapState>(
      'resets to initial state',
      build: () => cubit,
      seed: () => const MapLocationLoading(),
      act: (cubit) => cubit.reset(),
      expect: () => [const MapInitial()],
    );
  });
}
