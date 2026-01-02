import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';
import 'package:spo_kick/features/settings/domain/usecases/get_user_preferences_usecase.dart';
import 'package:spo_kick/features/settings/domain/usecases/reset_preferences_usecase.dart';
import 'package:spo_kick/features/settings/domain/usecases/update_user_preferences_usecase.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_state.dart';

class MockGetUserPreferencesUseCase extends Mock
    implements GetUserPreferencesUseCase {}

class MockUpdateUserPreferencesUseCase extends Mock
    implements UpdateUserPreferencesUseCase {}

class MockResetPreferencesUseCase extends Mock
    implements ResetPreferencesUseCase {}

void main() {
  late SettingsCubit cubit;
  late MockGetUserPreferencesUseCase mockGetUserPreferences;
  late MockUpdateUserPreferencesUseCase mockUpdateUserPreferences;
  late MockResetPreferencesUseCase mockResetPreferences;

  const tUserId = 'user-1';
  const tPreferences = UserPreferencesEntity(
    userId: tUserId,
    language: 'en',
    themeMode: AppThemeMode.system,
    pushNotificationsEnabled: true,
    bookingConfirmationNotifications: true,
    bookingReminderNotifications: true,
    bookingStatusNotifications: true,
    fieldOwnerMessagesNotifications: true,
    showProfilePicture: true,
    showPhoneNumber: true,
    showEmail: true,
  );

  setUp(() {
    mockGetUserPreferences = MockGetUserPreferencesUseCase();
    mockUpdateUserPreferences = MockUpdateUserPreferencesUseCase();
    mockResetPreferences = MockResetPreferencesUseCase();
    cubit = SettingsCubit(
      getUserPreferences: mockGetUserPreferences,
      updateUserPreferences: mockUpdateUserPreferences,
      resetPreferences: mockResetPreferences,
    );
    registerFallbackValue(tPreferences);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state should be SettingsInitial', () {
    expect(cubit.state, const SettingsInitial());
  });

  group('loadPreferences', () {
    blocTest<SettingsCubit, SettingsState>(
      'emits [SettingsLoading, SettingsLoaded] when successful',
      build: () {
        when(
          () => mockGetUserPreferences(any()),
        ).thenAnswer((_) async => const Right(tPreferences));
        return cubit;
      },
      act: (cubit) => cubit.loadPreferences(tUserId),
      expect: () => [
        const SettingsLoading(),
        const SettingsLoaded(tPreferences),
      ],
      verify: (_) {
        verify(() => mockGetUserPreferences(tUserId)).called(1);
      },
    );

    blocTest<SettingsCubit, SettingsState>(
      'emits [SettingsLoading, SettingsError] when failed',
      build: () {
        when(
          () => mockGetUserPreferences(any()),
        ).thenAnswer((_) async => const Left(ServerFailure('Error')));
        return cubit;
      },
      act: (cubit) => cubit.loadPreferences(tUserId),
      expect: () => [const SettingsLoading(), const SettingsError('Error')],
    );
  });

  group('updatePreference', () {
    final tUpdatedPreferences = tPreferences.copyWith(language: 'ar');

    blocTest<SettingsCubit, SettingsState>(
      'emits [SettingsUpdating, SettingsUpdated] when successful',
      build: () {
        when(
          () => mockUpdateUserPreferences(any()),
        ).thenAnswer((_) async => Right(tUpdatedPreferences));
        return cubit;
      },
      act: (cubit) => cubit.updatePreference(tPreferences, tUpdatedPreferences),
      expect: () => [
        const SettingsUpdating(tPreferences),
        SettingsUpdated(tUpdatedPreferences, 'Settings updated successfully'),
      ],
      verify: (_) {
        verify(() => mockUpdateUserPreferences(tUpdatedPreferences)).called(1);
      },
    );
  });
}
