import 'dart:ui';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spo_kick/core/localization/app_locale_cubit.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late AppLocaleCubit cubit;
  late MockSharedPreferences mockPrefs;
  const prefsKey = 'app_locale';

  setUp(() {
    mockPrefs = MockSharedPreferences();
    cubit = AppLocaleCubit(mockPrefs);
  });

  tearDown(() {
    cubit.close();
  });

  group('AppLocaleCubit', () {
    test('initial state is English (en)', () {
      expect(cubit.state, const Locale('en'));
    });

    group('loadSavedLocale', () {
      blocTest<AppLocaleCubit, Locale>(
        'emits stored locale when preference exists and is supported',
        build: () {
          when(() => mockPrefs.getString(prefsKey)).thenReturn('ar');
          return cubit;
        },
        act: (cubit) => cubit.loadSavedLocale(),
        expect: () => [const Locale('ar')],
      );

      blocTest<AppLocaleCubit, Locale>(
        'does not emit when preference is null',
        build: () {
          when(() => mockPrefs.getString(prefsKey)).thenReturn(null);
          return cubit;
        },
        act: (cubit) => cubit.loadSavedLocale(),
        expect: () => [],
      );

      blocTest<AppLocaleCubit, Locale>(
        'does not emit when preference is unsupported',
        build: () {
          when(() => mockPrefs.getString(prefsKey)).thenReturn('fr');
          return cubit;
        },
        act: (cubit) => cubit.loadSavedLocale(),
        expect: () => [],
      );
    });

    group('setLocale', () {
      blocTest<AppLocaleCubit, Locale>(
        'emits new locale and saves to prefs when supported',
        build: () {
          when(
            () => mockPrefs.setString(prefsKey, 'ar'),
          ).thenAnswer((_) async => true);
          return cubit;
        },
        act: (cubit) => cubit.setLocale('ar'),
        expect: () => [const Locale('ar')],
        verify: (_) {
          verify(() => mockPrefs.setString(prefsKey, 'ar')).called(1);
        },
      );

      blocTest<AppLocaleCubit, Locale>(
        'does not emit or save when locale is unsupported',
        build: () => cubit,
        act: (cubit) => cubit.setLocale('fr'),
        expect: () => [],
        verify: (_) {
          verifyNever(() => mockPrefs.setString(any(), any()));
        },
      );
    });
  });
}
