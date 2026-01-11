import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_settings/owner_settings_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_settings/owner_settings_state.dart';

void main() {
  late OwnerSettingsCubit cubit;

  setUp(() {
    cubit = OwnerSettingsCubit();
  });

  tearDown(() {
    cubit.close();
  });

  group('OwnerSettingsCubit', () {
    test('initial state is correct', () {
      expect(cubit.state, const OwnerSettingsState());
      expect(cubit.state.emailNotifications, true);
      expect(cubit.state.pushNotifications, true);
      expect(cubit.state.bookingNotifications, true);
      expect(cubit.state.instantNotifications, true);
      expect(cubit.state.autoApproveBookings, false);
    });
  });

  group('toggleEmailNotifications', () {
    blocTest<OwnerSettingsCubit, OwnerSettingsState>(
      'toggles email notifications',
      build: () => cubit,
      act: (cubit) => cubit.toggleEmailNotifications(false),
      expect: () => [
        isA<OwnerSettingsState>().having(
          (s) => s.emailNotifications,
          'emailNotifications',
          false,
        ),
      ],
    );
  });

  group('togglePushNotifications', () {
    blocTest<OwnerSettingsCubit, OwnerSettingsState>(
      'toggles push notifications',
      build: () => cubit,
      act: (cubit) => cubit.togglePushNotifications(false),
      expect: () => [
        isA<OwnerSettingsState>().having(
          (s) => s.pushNotifications,
          'pushNotifications',
          false,
        ),
      ],
    );
  });

  group('toggleBookingNotifications', () {
    blocTest<OwnerSettingsCubit, OwnerSettingsState>(
      'toggles booking notifications',
      build: () => cubit,
      act: (cubit) => cubit.toggleBookingNotifications(false),
      expect: () => [
        isA<OwnerSettingsState>().having(
          (s) => s.bookingNotifications,
          'bookingNotifications',
          false,
        ),
      ],
    );
  });

  group('toggleInstantNotifications', () {
    blocTest<OwnerSettingsCubit, OwnerSettingsState>(
      'toggles instant notifications',
      build: () => cubit,
      act: (cubit) => cubit.toggleInstantNotifications(false),
      expect: () => [
        isA<OwnerSettingsState>().having(
          (s) => s.instantNotifications,
          'instantNotifications',
          false,
        ),
      ],
    );
  });

  group('toggleAutoApproveBookings', () {
    blocTest<OwnerSettingsCubit, OwnerSettingsState>(
      'toggles auto approve bookings',
      build: () => cubit,
      act: (cubit) => cubit.toggleAutoApproveBookings(true),
      expect: () => [
        isA<OwnerSettingsState>().having(
          (s) => s.autoApproveBookings,
          'autoApproveBookings',
          true,
        ),
      ],
    );
  });
}
