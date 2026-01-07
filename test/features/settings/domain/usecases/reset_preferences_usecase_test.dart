import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';
import 'package:spo_kick/features/settings/domain/repositories/settings_repository.dart';
import 'package:spo_kick/features/settings/domain/usecases/reset_preferences_usecase.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late ResetPreferencesUseCase useCase;
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = ResetPreferencesUseCase(mockRepository);
  });

  group('ResetPreferencesUseCase', () {
    const tUserId = 'user-123';
    const tDefaultPreferences = UserPreferencesEntity(
      userId: tUserId,
      pushNotificationsEnabled: true,
      bookingConfirmationNotifications: true,
      bookingReminderNotifications: true,
      bookingStatusNotifications: true,
      fieldOwnerMessagesNotifications: true,
      themeMode: AppThemeMode.system,
      language: 'en',
      showProfilePicture: true,
      showPhoneNumber: false,
      showEmail: false,
    );

    group('successful reset', () {
      test('should return default preferences when reset succeeds', () async {
        // Arrange
        when(
          () => mockRepository.resetToDefaults(any()),
        ).thenAnswer((_) async => const Right(tDefaultPreferences));

        // Act
        final result = await useCase(tUserId);

        // Assert
        expect(result, equals(const Right(tDefaultPreferences)));
        verify(() => mockRepository.resetToDefaults(tUserId)).called(1);
      });

      test('should reset all notifications to enabled', () async {
        // Arrange
        when(
          () => mockRepository.resetToDefaults(any()),
        ).thenAnswer((_) async => const Right(tDefaultPreferences));

        // Act
        final result = await useCase(tUserId);

        // Assert
        result.fold((_) => fail('Should return Right'), (prefs) {
          expect(prefs.pushNotificationsEnabled, true);
          expect(prefs.bookingConfirmationNotifications, true);
          expect(prefs.bookingReminderNotifications, true);
          expect(prefs.bookingStatusNotifications, true);
          expect(prefs.fieldOwnerMessagesNotifications, true);
        });
      });

      test('should reset theme to system', () async {
        // Arrange
        when(
          () => mockRepository.resetToDefaults(any()),
        ).thenAnswer((_) async => const Right(tDefaultPreferences));

        // Act
        final result = await useCase(tUserId);

        // Assert
        result.fold(
          (_) => fail('Should return Right'),
          (prefs) => expect(prefs.themeMode, AppThemeMode.system),
        );
      });

      test('should reset language to English', () async {
        // Arrange
        when(
          () => mockRepository.resetToDefaults(any()),
        ).thenAnswer((_) async => const Right(tDefaultPreferences));

        // Act
        final result = await useCase(tUserId);

        // Assert
        result.fold(
          (_) => fail('Should return Right'),
          (prefs) => expect(prefs.language, 'en'),
        );
      });

      test('should reset privacy settings to defaults', () async {
        // Arrange
        when(
          () => mockRepository.resetToDefaults(any()),
        ).thenAnswer((_) async => const Right(tDefaultPreferences));

        // Act
        final result = await useCase(tUserId);

        // Assert
        result.fold((_) => fail('Should return Right'), (prefs) {
          expect(prefs.showProfilePicture, true);
          expect(prefs.showPhoneNumber, false);
          expect(prefs.showEmail, false);
        });
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.resetToDefaults(any()),
        ).thenAnswer((_) async => const Right(tDefaultPreferences));

        // Act
        await useCase(tUserId);

        // Assert
        verify(() => mockRepository.resetToDefaults(tUserId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to reset preferences');
        when(
          () => mockRepository.resetToDefaults(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tUserId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ValidationFailure when user not found', () async {
        // Arrange
        const tFailure = ValidationFailure('User not found');
        when(
          () => mockRepository.resetToDefaults(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase('invalid-user');

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure on network error', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.resetToDefaults(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tUserId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
