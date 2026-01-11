import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/usecases/logout_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/settings/super_admin_settings_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/settings/super_admin_settings_state.dart';

// Mock Use Cases
class MockLogoutUseCase extends Mock implements LogoutUseCase {}

void main() {
  late SuperAdminSettingsCubit cubit;
  late MockLogoutUseCase mockLogout;

  setUp(() {
    mockLogout = MockLogoutUseCase();
    cubit = SuperAdminSettingsCubit(logoutUseCase: mockLogout);
  });

  tearDown(() {
    cubit.close();
  });

  group('SuperAdminSettingsCubit', () {
    test('initial state is SuperAdminSettingsLoaded with defaults', () {
      expect(cubit.state, isA<SuperAdminSettingsLoaded>());
      final state = cubit.state as SuperAdminSettingsLoaded;
      expect(state.maintenanceMode, false);
      expect(state.allowNewRegistrations, true);
      expect(state.requireEmailVerification, true);
    });
  });

  group('platform configuration', () {
    blocTest<SuperAdminSettingsCubit, SuperAdminSettingsState>(
      'toggleMaintenanceMode updates state',
      build: () => cubit,
      act: (cubit) => cubit.toggleMaintenanceMode(true),
      expect: () => [
        isA<SuperAdminSettingsLoaded>()
            .having((s) => s.maintenanceMode, 'maintenanceMode', true)
            .having((s) => s.savingSection, 'savingSection', 'platform'),
      ],
    );

    blocTest<SuperAdminSettingsCubit, SuperAdminSettingsState>(
      'toggleAllowRegistrations updates state',
      build: () => cubit,
      act: (cubit) => cubit.toggleAllowRegistrations(false),
      expect: () => [
        isA<SuperAdminSettingsLoaded>().having(
          (s) => s.allowNewRegistrations,
          'allowNewRegistrations',
          false,
        ),
      ],
    );

    blocTest<SuperAdminSettingsCubit, SuperAdminSettingsState>(
      'toggleEmailVerification updates state',
      build: () => cubit,
      act: (cubit) => cubit.toggleEmailVerification(false),
      expect: () => [
        isA<SuperAdminSettingsLoaded>().having(
          (s) => s.requireEmailVerification,
          'requireEmailVerification',
          false,
        ),
      ],
    );
  });

  group('notification settings', () {
    blocTest<SuperAdminSettingsCubit, SuperAdminSettingsState>(
      'toggleEmailNotifications updates state',
      build: () => cubit,
      act: (cubit) => cubit.toggleEmailNotifications(false),
      expect: () => [
        isA<SuperAdminSettingsLoaded>()
            .having((s) => s.emailNotifications, 'emailNotifications', false)
            .having((s) => s.savingSection, 'savingSection', 'notifications'),
      ],
    );
  });

  group('security settings', () {
    blocTest<SuperAdminSettingsCubit, SuperAdminSettingsState>(
      'toggleTwoFactorAuth updates state',
      build: () => cubit,
      act: (cubit) => cubit.toggleTwoFactorAuth(true),
      expect: () => [
        isA<SuperAdminSettingsLoaded>()
            .having((s) => s.twoFactorAuth, 'twoFactorAuth', true)
            .having((s) => s.savingSection, 'savingSection', 'security'),
      ],
    );

    blocTest<SuperAdminSettingsCubit, SuperAdminSettingsState>(
      'toggleLogFailedLogins updates state',
      build: () => cubit,
      act: (cubit) => cubit.toggleLogFailedLogins(false),
      expect: () => [
        isA<SuperAdminSettingsLoaded>().having(
          (s) => s.logFailedLogins,
          'logFailedLogins',
          false,
        ),
      ],
    );

    blocTest<SuperAdminSettingsCubit, SuperAdminSettingsState>(
      'updateSessionTimeout updates state',
      build: () => cubit,
      act: (cubit) => cubit.updateSessionTimeout(60),
      expect: () => [
        isA<SuperAdminSettingsLoaded>().having(
          (s) => s.sessionTimeout,
          'sessionTimeout',
          60,
        ),
      ],
    );
  });

  group('logout dialog', () {
    blocTest<SuperAdminSettingsCubit, SuperAdminSettingsState>(
      'showLogoutDialog sets dialog to visible',
      build: () => cubit,
      act: (cubit) => cubit.showLogoutDialog(),
      expect: () => [
        isA<SuperAdminSettingsLoaded>().having(
          (s) => s.showLogoutDialog,
          'showLogoutDialog',
          true,
        ),
      ],
    );

    blocTest<SuperAdminSettingsCubit, SuperAdminSettingsState>(
      'hideLogoutDialog hides dialog',
      build: () => cubit,
      seed: () => const SuperAdminSettingsLoaded(showLogoutDialog: true),
      act: (cubit) => cubit.hideLogoutDialog(),
      expect: () => [
        isA<SuperAdminSettingsLoaded>().having(
          (s) => s.showLogoutDialog,
          'showLogoutDialog',
          false,
        ),
      ],
    );
  });

  group('logout', () {
    blocTest<SuperAdminSettingsCubit, SuperAdminSettingsState>(
      'emits LoggedOut on successful logout',
      build: () {
        when(() => mockLogout()).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.logout(),
      expect: () => [
        isA<SuperAdminSettingsLoaded>()
            .having((s) => s.isLoggingOut, 'isLoggingOut', true)
            .having((s) => s.showLogoutDialog, 'showLogoutDialog', false),
        const SuperAdminLoggedOut(),
      ],
    );

    blocTest<SuperAdminSettingsCubit, SuperAdminSettingsState>(
      'emits Error on failed logout',
      build: () {
        when(
          () => mockLogout(),
        ).thenAnswer((_) async => const Left(ServerFailure('Logout failed')));
        return cubit;
      },
      act: (cubit) => cubit.logout(),
      expect: () => [
        isA<SuperAdminSettingsLoaded>(),
        isA<SuperAdminSettingsError>().having(
          (s) => s.message,
          'message',
          'Logout failed',
        ),
      ],
    );
  });

  group('getters', () {
    test('appVersion returns version string', () {
      expect(cubit.appVersion, '1.0.0');
    });

    test('buildNumber returns build number', () {
      expect(cubit.buildNumber, '100');
    });
  });
}
