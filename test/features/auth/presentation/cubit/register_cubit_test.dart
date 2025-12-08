import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spo_kick/features/auth/presentation/cubit/register_cubit.dart';

void main() {
  group('RegisterCubit', () {
    late RegisterCubit registerCubit;

    setUp(() {
      registerCubit = RegisterCubit();
    });

    tearDown(() {
      registerCubit.close();
    });

    test('initial state is correct', () {
      expect(registerCubit.state, const RegisterState());
    });

    blocTest<RegisterCubit, RegisterState>(
      'toggles password visibility',
      build: () => registerCubit,
      act: (cubit) => cubit.togglePasswordVisibility(),
      expect: () => [const RegisterState(isPasswordVisible: true)],
    );

    blocTest<RegisterCubit, RegisterState>(
      'toggles confirm password visibility',
      build: () => registerCubit,
      act: (cubit) => cubit.toggleConfirmPasswordVisibility(),
      expect: () => [const RegisterState(isConfirmPasswordVisible: true)],
    );
  });
}
