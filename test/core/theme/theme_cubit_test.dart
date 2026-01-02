import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spo_kick/core/theme/theme_cubit.dart';
import 'package:spo_kick/core/theme/theme_state.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';

void main() {
  group('ThemeCubit', () {
    late ThemeCubit cubit;

    setUp(() {
      cubit = ThemeCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state should be system theme mode', () {
      expect(cubit.state.themeMode, ThemeMode.system);
      expect(cubit.state.appThemeMode, AppThemeMode.system);
    });

    group('setThemeMode', () {
      blocTest<ThemeCubit, ThemeState>(
        'emits dark theme when AppThemeMode.dark is set',
        build: () => ThemeCubit(),
        act: (cubit) => cubit.setThemeMode(AppThemeMode.dark),
        expect: () => [
          const ThemeState(
            themeMode: ThemeMode.dark,
            appThemeMode: AppThemeMode.dark,
          ),
        ],
      );

      blocTest<ThemeCubit, ThemeState>(
        'emits light theme when AppThemeMode.light is set',
        build: () => ThemeCubit(),
        act: (cubit) => cubit.setThemeMode(AppThemeMode.light),
        expect: () => [
          const ThemeState(
            themeMode: ThemeMode.light,
            appThemeMode: AppThemeMode.light,
          ),
        ],
      );

      blocTest<ThemeCubit, ThemeState>(
        'emits system theme when AppThemeMode.system is set',
        build: () => ThemeCubit(),
        seed: () => const ThemeState(
          themeMode: ThemeMode.dark,
          appThemeMode: AppThemeMode.dark,
        ),
        act: (cubit) => cubit.setThemeMode(AppThemeMode.system),
        expect: () => [
          const ThemeState(
            themeMode: ThemeMode.system,
            appThemeMode: AppThemeMode.system,
          ),
        ],
      );
    });

    group('toggleTheme', () {
      blocTest<ThemeCubit, ThemeState>(
        'toggles from system to light',
        build: () => ThemeCubit(),
        act: (cubit) => cubit.toggleTheme(),
        expect: () => [
          const ThemeState(
            themeMode: ThemeMode.light,
            appThemeMode: AppThemeMode.light,
          ),
        ],
      );

      blocTest<ThemeCubit, ThemeState>(
        'toggles from light to dark',
        build: () => ThemeCubit(),
        seed: () => const ThemeState(
          themeMode: ThemeMode.light,
          appThemeMode: AppThemeMode.light,
        ),
        act: (cubit) => cubit.toggleTheme(),
        expect: () => [
          const ThemeState(
            themeMode: ThemeMode.dark,
            appThemeMode: AppThemeMode.dark,
          ),
        ],
      );

      blocTest<ThemeCubit, ThemeState>(
        'toggles from dark to light',
        build: () => ThemeCubit(),
        seed: () => const ThemeState(
          themeMode: ThemeMode.dark,
          appThemeMode: AppThemeMode.dark,
        ),
        act: (cubit) => cubit.toggleTheme(),
        expect: () => [
          const ThemeState(
            themeMode: ThemeMode.light,
            appThemeMode: AppThemeMode.light,
          ),
        ],
      );
    });

    group('convenience methods', () {
      blocTest<ThemeCubit, ThemeState>(
        'setLightMode sets light theme',
        build: () => ThemeCubit(),
        act: (cubit) => cubit.setLightMode(),
        expect: () => [
          const ThemeState(
            themeMode: ThemeMode.light,
            appThemeMode: AppThemeMode.light,
          ),
        ],
      );

      blocTest<ThemeCubit, ThemeState>(
        'setDarkMode sets dark theme',
        build: () => ThemeCubit(),
        act: (cubit) => cubit.setDarkMode(),
        expect: () => [
          const ThemeState(
            themeMode: ThemeMode.dark,
            appThemeMode: AppThemeMode.dark,
          ),
        ],
      );

      blocTest<ThemeCubit, ThemeState>(
        'setSystemMode sets system theme',
        build: () => ThemeCubit(),
        seed: () => const ThemeState(
          themeMode: ThemeMode.dark,
          appThemeMode: AppThemeMode.dark,
        ),
        act: (cubit) => cubit.setSystemMode(),
        expect: () => [
          const ThemeState(
            themeMode: ThemeMode.system,
            appThemeMode: AppThemeMode.system,
          ),
        ],
      );
    });

    group('getters', () {
      test('isDarkMode returns true when theme is dark', () {
        cubit.setDarkMode();
        expect(cubit.isDarkMode, true);
        expect(cubit.isLightMode, false);
        expect(cubit.isSystemMode, false);
      });

      test('isLightMode returns true when theme is light', () {
        cubit.setLightMode();
        expect(cubit.isLightMode, true);
        expect(cubit.isDarkMode, false);
        expect(cubit.isSystemMode, false);
      });

      test('isSystemMode returns true when theme is system', () {
        cubit.setSystemMode();
        expect(cubit.isSystemMode, true);
        expect(cubit.isDarkMode, false);
        expect(cubit.isLightMode, false);
      });
    });
  });

  group('ThemeState', () {
    test('initial state has correct values', () {
      const state = ThemeState.initial();
      expect(state.themeMode, ThemeMode.system);
      expect(state.appThemeMode, AppThemeMode.system);
    });

    test('fromPreference creates correct state for each mode', () {
      final lightState = ThemeState.fromPreference(AppThemeMode.light);
      expect(lightState.themeMode, ThemeMode.light);
      expect(lightState.appThemeMode, AppThemeMode.light);

      final darkState = ThemeState.fromPreference(AppThemeMode.dark);
      expect(darkState.themeMode, ThemeMode.dark);
      expect(darkState.appThemeMode, AppThemeMode.dark);

      final systemState = ThemeState.fromPreference(AppThemeMode.system);
      expect(systemState.themeMode, ThemeMode.system);
      expect(systemState.appThemeMode, AppThemeMode.system);
    });

    test('copyWith creates new state with updated values', () {
      const original = ThemeState(
        themeMode: ThemeMode.light,
        appThemeMode: AppThemeMode.light,
      );

      final updated = original.copyWith(
        themeMode: ThemeMode.dark,
        appThemeMode: AppThemeMode.dark,
      );

      expect(updated.themeMode, ThemeMode.dark);
      expect(updated.appThemeMode, AppThemeMode.dark);
      expect(original.themeMode, ThemeMode.light); // Original unchanged
    });

    test('props includes all properties', () {
      const state = ThemeState(
        themeMode: ThemeMode.dark,
        appThemeMode: AppThemeMode.dark,
      );

      expect(state.props, [ThemeMode.dark, AppThemeMode.dark]);
    });
  });
}
