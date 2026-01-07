import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_settings_entity.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/platform_settings_repository.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_platform_settings_usecase.dart';

class MockPlatformSettingsRepository extends Mock
    implements PlatformSettingsRepository {}

void main() {
  late GetPlatformSettingsUseCase useCase;
  late MockPlatformSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockPlatformSettingsRepository();
    useCase = GetPlatformSettingsUseCase(mockRepository);
  });

  group('GetPlatformSettingsUseCase', () {
    final tSettings = PlatformSettingsEntity.defaults().copyWith(
      updatedAt: DateTime(2026, 1, 7),
    );

    group('successful retrieval', () {
      test('should return platform settings when call succeeds', () async {
        // Arrange
        when(
          () => mockRepository.getPlatformSettings(),
        ).thenAnswer((_) async => Right(tSettings));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(Right(tSettings)));
        verify(() => mockRepository.getPlatformSettings()).called(1);
      });

      test('should return settings with all properties', () async {
        // Arrange
        when(
          () => mockRepository.getPlatformSettings(),
        ).thenAnswer((_) async => Right(tSettings));

        // Act
        final result = await useCase();

        // Assert
        result.fold((_) => fail('Should return Right'), (settings) {
          expect(settings.enforceOperatingHours, true);
          expect(settings.defaultOperatingHours.length, 7);
        });
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.getPlatformSettings(),
        ).thenAnswer((_) async => Right(tSettings));

        // Act
        await useCase();

        // Assert
        verify(() => mockRepository.getPlatformSettings()).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to get settings');
        when(
          () => mockRepository.getPlatformSettings(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when not authorized', () async {
        // Arrange
        const tFailure = AuthFailure(
          'Only super admin can view platform settings',
        );
        when(
          () => mockRepository.getPlatformSettings(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure on network error', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.getPlatformSettings(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
