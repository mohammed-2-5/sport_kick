import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spo_kick/features/auth/presentation/cubit/admin_login_cubit.dart';

void main() {
  late AdminLoginCubit cubit;

  setUp(() {
    cubit = AdminLoginCubit();
  });

  tearDown(() {
    cubit.close();
  });

  group('AdminLoginCubit -', () {
    test('initial state should have isPasswordVisible = false', () {
      expect(cubit.state.isPasswordVisible, isFalse);
    });

    group('togglePasswordVisibility -', () {
      blocTest<AdminLoginCubit, AdminLoginState>(
        'should toggle password visibility from false to true',
        build: () => cubit,
        act: (cubit) => cubit.togglePasswordVisibility(),
        expect: () => [const AdminLoginState(isPasswordVisible: true)],
      );

      blocTest<AdminLoginCubit, AdminLoginState>(
        'should toggle password visibility from true to false',
        build: () => cubit,
        seed: () => const AdminLoginState(isPasswordVisible: true),
        act: (cubit) => cubit.togglePasswordVisibility(),
        expect: () => [const AdminLoginState(isPasswordVisible: false)],
      );

      blocTest<AdminLoginCubit, AdminLoginState>(
        'should toggle multiple times',
        build: () => cubit,
        act: (cubit) {
          cubit.togglePasswordVisibility(); // true
          cubit.togglePasswordVisibility(); // false
          cubit.togglePasswordVisibility(); // true
        },
        expect: () => [
          const AdminLoginState(isPasswordVisible: true),
          const AdminLoginState(isPasswordVisible: false),
          const AdminLoginState(isPasswordVisible: true),
        ],
      );
    });
  });

  group('AdminLoginState -', () {
    test('default state should have isPasswordVisible = false', () {
      const state = AdminLoginState();
      expect(state.isPasswordVisible, isFalse);
    });

    test('copyWith should update isPasswordVisible', () {
      const original = AdminLoginState(isPasswordVisible: false);
      final updated = original.copyWith(isPasswordVisible: true);

      expect(updated.isPasswordVisible, isTrue);
    });

    test('copyWith should keep value when null passed', () {
      const original = AdminLoginState(isPasswordVisible: true);
      final updated = original.copyWith();

      expect(updated.isPasswordVisible, isTrue);
    });

    test('props should include isPasswordVisible', () {
      const state1 = AdminLoginState(isPasswordVisible: true);
      const state2 = AdminLoginState(isPasswordVisible: true);
      const state3 = AdminLoginState(isPasswordVisible: false);

      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });

    test('equality works correctly', () {
      const stateA = AdminLoginState(isPasswordVisible: true);
      const stateB = AdminLoginState(isPasswordVisible: true);
      const stateC = AdminLoginState(isPasswordVisible: false);

      expect(stateA == stateB, isTrue);
      expect(stateA == stateC, isFalse);
    });

    test('hashCode is consistent with equality', () {
      const stateA = AdminLoginState(isPasswordVisible: true);
      const stateB = AdminLoginState(isPasswordVisible: true);

      expect(stateA.hashCode, equals(stateB.hashCode));
    });
  });
}
