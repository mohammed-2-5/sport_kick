import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/entities/day_hours_entity.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_settings_entity.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/platform_settings_repository.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/update_platform_settings_usecase.dart';

class MockPlatformSettingsRepository extends Mock
    implements PlatformSettingsRepository {}

// Fallback value for mocktail
class FakePlatformSettingsEntity extends Fake
    implements PlatformSettingsEntity {}

void main() {
  late MockPlatformSettingsRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakePlatformSettingsEntity());
  });

  setUp(() {
    mockRepository = MockPlatformSettingsRepository();
  });

  final tSettings = PlatformSettingsEntity(
    id: 'settings-1',
    defaultOperatingHours: const {
      DayOfWeek.monday: DayHoursEntity(openTime: '08:00', closeTime: '22:00'),
      DayOfWeek.tuesday: DayHoursEntity(openTime: '08:00', closeTime: '22:00'),
      DayOfWeek.wednesday: DayHoursEntity(
        openTime: '08:00',
        closeTime: '22:00',
      ),
      DayOfWeek.thursday: DayHoursEntity(openTime: '08:00', closeTime: '22:00'),
      DayOfWeek.friday: DayHoursEntity(openTime: '10:00', closeTime: '23:00'),
      DayOfWeek.saturday: DayHoursEntity(openTime: '09:00', closeTime: '23:00'),
      DayOfWeek.sunday: DayHoursEntity(openTime: '09:00', closeTime: '21:00'),
    },
    enforceOperatingHours: true,
    updatedAt: DateTime(2026, 1, 1),
    updatedBy: 'admin-123',
  );

  group('UpdatePlatformOperatingHoursUseCase -', () {
    late UpdatePlatformOperatingHoursUseCase useCase;

    setUp(() {
      useCase = UpdatePlatformOperatingHoursUseCase(mockRepository);
    });

    test(
      'should call repository updateOperatingHours with correct settings',
      () async {
        // Arrange
        when(
          () => mockRepository.updateOperatingHours(tSettings),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(tSettings);

        // Assert
        expect(result.isRight(), isTrue);
        verify(() => mockRepository.updateOperatingHours(tSettings)).called(1);
      },
    );

    test('should return Right(void) when repository succeeds', () async {
      // Arrange
      when(
        () => mockRepository.updateOperatingHours(any()),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(tSettings);

      // Assert
      expect(result, equals(const Right<Failure, void>(null)));
    });

    test('should return Left(ServerFailure) when repository fails', () async {
      // Arrange
      when(() => mockRepository.updateOperatingHours(any())).thenAnswer(
        (_) async => const Left(ServerFailure('Failed to update settings')),
      );

      // Act
      final result = await useCase(tSettings);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) =>
            expect(failure.message, equals('Failed to update settings')),
        (_) => fail('Should return Left'),
      );
    });

    test('should return Left(NetworkFailure) on network error', () async {
      // Arrange
      when(() => mockRepository.updateOperatingHours(any())).thenAnswer(
        (_) async => const Left(NetworkFailure('No internet connection')),
      );

      // Act
      final result = await useCase(tSettings);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Should return Left'),
      );
    });

    test('should pass settings with different operating hours', () async {
      // Arrange
      final customSettings = tSettings.copyWith(
        defaultOperatingHours: const {
          DayOfWeek.monday: DayHoursEntity(
            openTime: '06:00',
            closeTime: '00:00',
          ),
          DayOfWeek.tuesday: DayHoursEntity(isOpen: false),
        },
      );

      when(
        () => mockRepository.updateOperatingHours(customSettings),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(customSettings);

      // Assert
      expect(result.isRight(), isTrue);
      verify(
        () => mockRepository.updateOperatingHours(customSettings),
      ).called(1);
    });
  });

  group('UpdateEnforceOperatingHoursUseCase -', () {
    late UpdateEnforceOperatingHoursUseCase useCase;

    setUp(() {
      useCase = UpdateEnforceOperatingHoursUseCase(mockRepository);
    });

    test('should call repository with enforce = true', () async {
      // Arrange
      when(
        () => mockRepository.updateEnforceOperatingHours(true),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(true);

      // Assert
      expect(result.isRight(), isTrue);
      verify(() => mockRepository.updateEnforceOperatingHours(true)).called(1);
    });

    test('should call repository with enforce = false', () async {
      // Arrange
      when(
        () => mockRepository.updateEnforceOperatingHours(false),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(false);

      // Assert
      expect(result.isRight(), isTrue);
      verify(() => mockRepository.updateEnforceOperatingHours(false)).called(1);
    });

    test('should return Right(void) when repository succeeds', () async {
      // Arrange
      when(
        () => mockRepository.updateEnforceOperatingHours(any()),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(true);

      // Assert
      expect(result, equals(const Right<Failure, void>(null)));
    });

    test('should return Left(ServerFailure) when repository fails', () async {
      // Arrange
      when(
        () => mockRepository.updateEnforceOperatingHours(any()),
      ).thenAnswer((_) async => const Left(ServerFailure('Permission denied')));

      // Act
      final result = await useCase(true);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, equals('Permission denied')),
        (_) => fail('Should return Left'),
      );
    });

    test('should return Left(AuthFailure) when not authorized', () async {
      // Arrange
      when(() => mockRepository.updateEnforceOperatingHours(any())).thenAnswer(
        (_) async => const Left(AuthFailure('Admin access required')),
      );

      // Act
      final result = await useCase(false);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<AuthFailure>()),
        (_) => fail('Should return Left'),
      );
    });
  });

  group('PlatformSettingsEntity -', () {
    test('defaults factory creates correct default hours', () {
      final defaults = PlatformSettingsEntity.defaults();

      expect(defaults.id, equals('default'));
      expect(defaults.enforceOperatingHours, isTrue);
      expect(defaults.defaultOperatingHours.length, equals(7));
    });

    test('copyWith updates enforceOperatingHours', () {
      final updated = tSettings.copyWith(enforceOperatingHours: false);

      expect(updated.enforceOperatingHours, isFalse);
      expect(updated.id, equals(tSettings.id));
    });

    test('updateDayHours updates specific day', () {
      const newHours = DayHoursEntity(openTime: '07:00', closeTime: '23:00');
      final updated = tSettings.updateDayHours(DayOfWeek.monday, newHours);

      expect(updated.getHoursForDay(DayOfWeek.monday), equals(newHours));
      // Other days unchanged
      expect(
        updated.getHoursForDay(DayOfWeek.tuesday),
        equals(tSettings.getHoursForDay(DayOfWeek.tuesday)),
      );
    });

    test('getHoursForDay returns correct hours', () {
      final mondayHours = tSettings.getHoursForDay(DayOfWeek.monday);

      expect(mondayHours.openTime, equals('08:00'));
      expect(mondayHours.closeTime, equals('22:00'));
    });

    test('getHoursForDay returns default when day not found', () {
      const settings = PlatformSettingsEntity(
        id: 'test',
        defaultOperatingHours: {},
      );

      final hours = settings.getHoursForDay(DayOfWeek.monday);

      expect(hours, equals(const DayHoursEntity()));
    });

    test('equality works correctly', () {
      final settings1 = PlatformSettingsEntity(
        id: 'test',
        defaultOperatingHours: const {DayOfWeek.monday: DayHoursEntity()},
      );
      final settings2 = PlatformSettingsEntity(
        id: 'test',
        defaultOperatingHours: const {DayOfWeek.monday: DayHoursEntity()},
      );
      final settings3 = PlatformSettingsEntity(
        id: 'different',
        defaultOperatingHours: const {DayOfWeek.monday: DayHoursEntity()},
      );

      expect(settings1, equals(settings2));
      expect(settings1, isNot(equals(settings3)));
    });
  });

  group('DayOfWeek -', () {
    test('displayName capitalizes first letter', () {
      expect(DayOfWeek.monday.displayName, equals('Monday'));
      expect(DayOfWeek.friday.displayName, equals('Friday'));
    });

    test('shortName returns 3 uppercase letters', () {
      expect(DayOfWeek.monday.shortName, equals('MON'));
      expect(DayOfWeek.wednesday.shortName, equals('WED'));
      expect(DayOfWeek.sunday.shortName, equals('SUN'));
    });
  });
}
