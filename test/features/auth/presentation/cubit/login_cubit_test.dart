import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spo_kick/features/auth/presentation/cubit/login_cubit.dart';

void main() {
  group('LoginCubit', () {
    late LoginCubit loginCubit;

    setUp(() {
      loginCubit = LoginCubit();
    });

    tearDown(() {
      loginCubit.close();
    });

    test('initial state is correct', () {
      expect(loginCubit.state, const LoginState());
    });

    blocTest<LoginCubit, LoginState>(
      'emits [isPasswordVisible: true] when togglePasswordVisibility is called',
      build: () => loginCubit,
      act: (cubit) => cubit.togglePasswordVisibility(),
      expect: () => [const LoginState(isPasswordVisible: true)],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [loginMode: admin] when changeLoginMode is called',
      build: () => loginCubit,
      act: (cubit) => cubit.changeLoginMode('admin'),
      expect: () => [const LoginState(loginMode: 'admin')],
    );

    blocTest<LoginCubit, LoginState>(
      'emits updated validity when valid',
      build: () => loginCubit,
      act: (cubit) {
        cubit.updateEmailValidity(false);
        cubit.updatePasswordValidity(false);
      },
      expect: () => [
        const LoginState(isEmailValid: false),
        const LoginState(isEmailValid: false, isPasswordValid: false),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'toggles rememberMe',
      build: () => loginCubit,
      act: (cubit) => cubit.toggleRememberMe(),
      expect: () => [const LoginState(rememberMe: true)],
    );
  });
}
