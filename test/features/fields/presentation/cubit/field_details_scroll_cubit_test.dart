import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spo_kick/features/fields/presentation/cubit/field_details_scroll_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/field_details_scroll_state.dart';

void main() {
  late FieldDetailsScrollCubit cubit;

  setUp(() {
    cubit = FieldDetailsScrollCubit();
  });

  tearDown(() {
    cubit.close();
  });

  group('FieldDetailsScrollCubit', () {
    test('initial state is FieldDetailsScrollInitial', () {
      expect(cubit.state, const FieldDetailsScrollInitial());
    });
  });

  group('updateScroll', () {
    blocTest<FieldDetailsScrollCubit, FieldDetailsScrollState>(
      'state reflects low scroll offset (no header, no opacity)',
      build: () => cubit,
      act: (cubit) => cubit.updateScroll(100),
      expect: () => [
        const FieldDetailsScrollActive(
          scrollOffset: 100,
          showFloatingHeader: false,
          headerOpacity: 0.0,
        ),
      ],
    );

    blocTest<FieldDetailsScrollCubit, FieldDetailsScrollState>(
      'state reflects mid-fade scroll offset (no header, partial opacity)',
      build: () => cubit,
      act: (cubit) =>
          cubit.updateScroll(185), // (185-150)/(220-150) = 35/70 = 0.5
      expect: () => [
        const FieldDetailsScrollActive(
          scrollOffset: 185,
          showFloatingHeader: false,
          headerOpacity: 0.5,
        ),
      ],
    );

    blocTest<FieldDetailsScrollCubit, FieldDetailsScrollState>(
      'state shows header when threshold exceeded',
      build: () => cubit,
      act: (cubit) =>
          cubit.updateScroll(210), // > 200 (show), < 220 (partial opacity)
      expect: () => [
        isA<FieldDetailsScrollActive>()
            .having((s) => s.scrollOffset, 'offset', 210)
            .having((s) => s.showFloatingHeader, 'show', true)
            .having(
              (s) => s.headerOpacity,
              'opacity',
              moreOrLessEquals(0.857, epsilon: 0.001),
            ), // (210-150)/70 = 60/70 = 0.857
      ],
    );

    blocTest<FieldDetailsScrollCubit, FieldDetailsScrollState>(
      'state shows full opacity when fade end threshold exceeded',
      build: () => cubit,
      act: (cubit) => cubit.updateScroll(250),
      expect: () => [
        const FieldDetailsScrollActive(
          scrollOffset: 250,
          showFloatingHeader: true,
          headerOpacity: 1.0,
        ),
      ],
    );
  });

  group('reset', () {
    blocTest<FieldDetailsScrollCubit, FieldDetailsScrollState>(
      'resets to initial state',
      build: () => cubit,
      seed: () => const FieldDetailsScrollActive(
        scrollOffset: 200,
        showFloatingHeader: true,
        headerOpacity: 1.0,
      ),
      act: (cubit) => cubit.reset(),
      expect: () => [const FieldDetailsScrollInitial()],
    );
  });
}
