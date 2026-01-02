import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/core/network/network_info.dart';
import 'package:spo_kick/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:spo_kick/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:spo_kick/features/settings/data/models/user_preferences_model.dart';
import 'package:spo_kick/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';

class MockSettingsRemoteDataSource extends Mock
    implements SettingsRemoteDataSource {}

class MockSettingsLocalDataSource extends Mock
    implements SettingsLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late SettingsRepositoryImpl repository;
  late MockSettingsRemoteDataSource mockRemoteDataSource;
  late MockSettingsLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  const tUserId = 'user-123';
  const tPreferencesModel = UserPreferencesModel(
    userId: tUserId,
    themeMode: AppThemeMode.system,
    language: 'en',
    pushNotificationsEnabled: true,
    bookingConfirmationNotifications: true,
    bookingReminderNotifications: true,
    bookingStatusNotifications: true,
    fieldOwnerMessagesNotifications: true,
    showProfilePicture: true,
    showPhoneNumber: false,
    showEmail: false,
  );

  setUp(() {
    mockRemoteDataSource = MockSettingsRemoteDataSource();
    mockLocalDataSource = MockSettingsLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = SettingsRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
    registerFallbackValue(tPreferencesModel);
  });

  group('getUserPreferences', () {
    group('when online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('returns remote data and caches locally when successful', () async {
        // Arrange
        when(
          () => mockRemoteDataSource.getOrCreatePreferences(tUserId),
        ).thenAnswer((_) async => tPreferencesModel);
        when(
          () => mockLocalDataSource.cachePreferences(any()),
        ).thenAnswer((_) async {});

        // Act
        final result = await repository.getUserPreferences(tUserId);

        // Assert
        expect(result, const Right(tPreferencesModel));
        verify(
          () => mockRemoteDataSource.getOrCreatePreferences(tUserId),
        ).called(1);
        verify(
          () => mockLocalDataSource.cachePreferences(tPreferencesModel),
        ).called(1);
      });

      test('falls back to cache when remote fails', () async {
        // Arrange
        when(
          () => mockRemoteDataSource.getOrCreatePreferences(tUserId),
        ).thenThrow(const ServerException('Error'));
        when(
          () => mockLocalDataSource.getCachedPreferences(tUserId),
        ).thenAnswer((_) async => tPreferencesModel);

        // Act
        final result = await repository.getUserPreferences(tUserId);

        // Assert
        expect(result, const Right(tPreferencesModel));
        verify(
          () => mockLocalDataSource.getCachedPreferences(tUserId),
        ).called(1);
      });
    });

    group('when offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('returns cached data when available', () async {
        // Arrange
        when(
          () => mockLocalDataSource.getCachedPreferences(tUserId),
        ).thenAnswer((_) async => tPreferencesModel);

        // Act
        final result = await repository.getUserPreferences(tUserId);

        // Assert
        expect(result, const Right(tPreferencesModel));
        verifyNever(() => mockRemoteDataSource.getOrCreatePreferences(any()));
      });

      test('returns defaults when no cached data', () async {
        // Arrange
        when(
          () => mockLocalDataSource.getCachedPreferences(tUserId),
        ).thenThrow(const CacheException('Not found'));
        when(
          () => mockLocalDataSource.cachePreferences(any()),
        ).thenAnswer((_) async {});

        // Act
        final result = await repository.getUserPreferences(tUserId);

        // Assert
        result.fold((failure) => fail('Should not fail'), (prefs) {
          expect(prefs.userId, tUserId);
          expect(prefs.themeMode, AppThemeMode.system);
        });
      });
    });
  });

  group('updateUserPreferences', () {
    test('updates local cache and syncs to remote when online', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockLocalDataSource.cachePreferences(any()),
      ).thenAnswer((_) async {});
      when(
        () => mockRemoteDataSource.updatePreferences(any()),
      ).thenAnswer((_) async => tPreferencesModel);

      // Act
      final result = await repository.updateUserPreferences(tPreferencesModel);

      // Assert
      expect(result, const Right(tPreferencesModel));
      verify(
        () => mockLocalDataSource.cachePreferences(tPreferencesModel),
      ).called(2); // Once optimistic, once after remote
      verify(
        () => mockRemoteDataSource.updatePreferences(tPreferencesModel),
      ).called(1);
    });

    test('updates local cache only when offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(
        () => mockLocalDataSource.cachePreferences(any()),
      ).thenAnswer((_) async {});

      // Act
      final result = await repository.updateUserPreferences(tPreferencesModel);

      // Assert
      expect(result, const Right(tPreferencesModel));
      verifyNever(() => mockRemoteDataSource.updatePreferences(any()));
    });
  });

  group('resetToDefaults', () {
    test('resets local and remote when online', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockLocalDataSource.cachePreferences(any()),
      ).thenAnswer((_) async {});
      when(
        () => mockRemoteDataSource.deletePreferences(tUserId),
      ).thenAnswer((_) async {});
      when(
        () => mockRemoteDataSource.updatePreferences(any()),
      ).thenAnswer((_) async => tPreferencesModel);

      // Act
      final result = await repository.resetToDefaults(tUserId);

      // Assert
      result.fold(
        (failure) => fail('Should not fail'),
        (prefs) => expect(prefs.userId, tUserId),
      );
      verify(() => mockRemoteDataSource.deletePreferences(tUserId)).called(1);
    });
  });

  group('clearCache', () {
    test('clears local cache successfully', () async {
      // Arrange
      when(() => mockLocalDataSource.clearCache()).thenAnswer((_) async {});

      // Act
      final result = await repository.clearCache();

      // Assert
      expect(result, const Right(null));
      verify(() => mockLocalDataSource.clearCache()).called(1);
    });

    test('returns failure when cache clear fails', () async {
      // Arrange
      when(
        () => mockLocalDataSource.clearCache(),
      ).thenThrow(const CacheException('Clear failed'));

      // Act
      final result = await repository.clearCache();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Should fail'),
      );
    });
  });
}
