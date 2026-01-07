import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';
import 'package:spo_kick/features/settings/domain/repositories/settings_repository.dart';
import 'package:spo_kick/features/settings/domain/usecases/update_user_preferences_usecase.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late UpdateUserPreferencesUseCase useCase;
  late MockSettingsRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(const UserPreferencesEntity(userId: 'fallback'));
  });

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = UpdateUserPreferencesUseCase(mockRepository);
  });

  group('UpdateUserPreferencesUseCase', () {
    const tUserId = 'user-123';
    const tPreferences = UserPreferencesEntity(
      userId: tUserId,
      pushNotificationsEnabled: false,
      bookingConfirmationNotifications: true,
      bookingReminderNotifications: false,
      bookingStatusNotifications: true,
      fieldOwnerMessagesNotifications: false,
      themeMode: AppThemeMode.dark,
      language: 'ar',
      showProfilePicture: false,
      showPhoneNumber: true,
      showEmail: true,
    );

    group('successful update', () {
      test('should return updated preferences when update succeeds', () async {
        // Arrange
        when(
          () => mockRepository.updateUserPreferences(any()),
        ).thenAnswer((_) async => const Right(tPreferences));

        // Act
        final result = await useCase(tPreferences);

        // Assert
        expect(result, equals(const Right(tPreferences)));
      });

      test('should update notification preferences', () async {
        // Arrange
        when(
          () => mockRepository.updateUserPreferences(any()),
        ).thenAnswer((_) async => const Right(tPreferences));

        // Act
        final result = await useCase(tPreferences);

        // Assert
        result.fold((_) => fail('Should return Right'), (prefs) {
          expect(prefs.pushNotificationsEnabled, false);
          expect(prefs.bookingReminderNotifications, false);
        });
      });

      test('should update theme mode', () async {
        // Arrange
        when(
          () => mockRepository.updateUserPreferences(any()),
        ).thenAnswer((_) async => const Right(tPreferences));

        // Act
        final result = await useCase(tPreferences);

        // Assert
        result.fold(
          (_) => fail('Should return Right'),
          (prefs) => expect(prefs.themeMode, AppThemeMode.dark),
        );
      });

      test('should update language', () async {
        // Arrange
        when(
          () => mockRepository.updateUserPreferences(any()),
        ).thenAnswer((_) async => const Right(tPreferences));

        // Act
        final result = await useCase(tPreferences);

        // Assert
        result.fold(
          (_) => fail('Should return Right'),
          (prefs) => expect(prefs.language, 'ar'),
        );
      });

      test('should update privacy settings', () async {
        // Arrange
        when(
          () => mockRepository.updateUserPreferences(any()),
        ).thenAnswer((_) async => const Right(tPreferences));

        // Act
        final result = await useCase(tPreferences);

        // Assert
        result.fold((_) => fail('Should return Right'), (prefs) {
          expect(prefs.showProfilePicture, false);
          expect(prefs.showPhoneNumber, true);
          expect(prefs.showEmail, true);
        });
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.updateUserPreferences(any()),
        ).thenAnswer((_) async => const Right(tPreferences));

        // Act
        await useCase(tPreferences);

        // Assert
        verify(
          () => mockRepository.updateUserPreferences(tPreferences),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to update preferences');
        when(
          () => mockRepository.updateUserPreferences(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tPreferences);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ValidationFailure for invalid preferences', () async {
        // Arrange
        const tFailure = ValidationFailure('Invalid preferences');
        when(
          () => mockRepository.updateUserPreferences(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tPreferences);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure on network error', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.updateUserPreferences(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tPreferences);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
