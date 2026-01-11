import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spo_kick/features/home/presentation/cubit/navigation/navigation_cubit.dart';
import 'package:spo_kick/features/home/presentation/cubit/navigation/navigation_state.dart';

void main() {
  late NavigationCubit cubit;

  setUp(() {
    cubit = NavigationCubit();
  });

  tearDown(() {
    cubit.close();
  });

  group('NavigationCubit', () {
    test('initial state is NavigationActive(index=0)', () {
      expect(cubit.state, const NavigationActive());
      expect((cubit.state as NavigationActive).currentIndex, 0);
    });

    test('currentIndex getter returns correct index', () async {
      expect(cubit.currentIndex, 0);
      cubit.changeTab(1);
      expect(cubit.currentIndex, 1);
      await Future.delayed(const Duration(milliseconds: 500));
    });

    test('isNavigatingForward returns correct direction', () async {
      // Initial 0, prev 0 -> default true? logic says index > previousIndex. 0>0 is false.
      // Wait, initial previousIndex is 0.
      expect(cubit.isNavigatingForward, false); // 0 > 0 is false

      cubit.changeTab(1); // index 1, prev 0
      expect(cubit.isNavigatingForward, true); // 1 > 0 is true

      await Future.delayed(const Duration(milliseconds: 500));

      cubit.changeTab(0); // index 0, prev 1
      expect(cubit.isNavigatingForward, false); // 0 > 1 is false

      await Future.delayed(const Duration(milliseconds: 500));
    });
  });

  group('changeTab', () {
    blocTest<NavigationCubit, NavigationState>(
      'emits [animating true, animating false] when tab changes',
      build: () => cubit,
      act: (cubit) => cubit.changeTab(1),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        isA<NavigationActive>()
            .having((s) => s.currentIndex, 'index', 1)
            .having((s) => s.previousIndex, 'prev', 0)
            .having((s) => s.isAnimating, 'animating start', true),
        isA<NavigationActive>()
            .having((s) => s.currentIndex, 'index', 1)
            .having((s) => s.isAnimating, 'animating end', false),
      ],
    );

    blocTest<NavigationCubit, NavigationState>(
      'does nothing if index is same',
      build: () => cubit,
      act: (cubit) => cubit.changeTab(0),
      expect: () => [],
    );
  });

  group('helpers', () {
    blocTest<NavigationCubit, NavigationState>(
      'goToHome switches to index 0',
      build: () => cubit,
      seed: () => const NavigationActive(currentIndex: 1),
      act: (cubit) => cubit.goToHome(),
      wait: const Duration(milliseconds: 350),
      expect: () => [
        isA<NavigationActive>().having((s) => s.currentIndex, 'index', 0),
        isA<NavigationActive>().having(
          (s) => s.isAnimating,
          'animating',
          false,
        ),
      ],
    );

    blocTest<NavigationCubit, NavigationState>(
      'goToExplore switches to index 1',
      build: () => cubit,
      act: (cubit) => cubit.goToExplore(),
      wait: const Duration(milliseconds: 350),
      expect: () => [
        isA<NavigationActive>().having((s) => s.currentIndex, 'index', 1),
        isA<NavigationActive>().having(
          (s) => s.isAnimating,
          'animating',
          false,
        ),
      ],
    );

    blocTest<NavigationCubit, NavigationState>(
      'goToBookings switches to index 2',
      build: () => cubit,
      act: (cubit) => cubit.goToBookings(),
      wait: const Duration(milliseconds: 350),
      expect: () => [
        isA<NavigationActive>().having((s) => s.currentIndex, 'index', 2),
        isA<NavigationActive>().having(
          (s) => s.isAnimating,
          'animating',
          false,
        ),
      ],
    );

    blocTest<NavigationCubit, NavigationState>(
      'goToProfile switches to index 3',
      build: () => cubit,
      act: (cubit) => cubit.goToProfile(),
      wait: const Duration(milliseconds: 350),
      expect: () => [
        isA<NavigationActive>().having((s) => s.currentIndex, 'index', 3),
        isA<NavigationActive>().having(
          (s) => s.isAnimating,
          'animating',
          false,
        ),
      ],
    );
  });

  group('FAB visibility', () {
    blocTest<NavigationCubit, NavigationState>(
      'etFabVisibility updates showFab',
      build: () => cubit,
      act: (cubit) => cubit.setFabVisibility(false),
      expect: () => [
        isA<NavigationActive>().having((s) => s.showFab, 'showFab', false),
      ],
    );

    blocTest<NavigationCubit, NavigationState>(
      'toggleFab flips showFab',
      build: () => cubit,
      act: (cubit) => cubit.toggleFab(),
      expect: () => [
        isA<NavigationActive>().having((s) => s.showFab, 'showFab', false),
      ],
    );
  });
}
