import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spo_kick/features/auth/presentation/cubit/forgot_password_cubit.dart';

void main() {
  group('ForgotPasswordCubit', () {
    late ForgotPasswordCubit forgotPasswordCubit;

    setUp(() {
      forgotPasswordCubit = ForgotPasswordCubit();
    });

    tearDown(() {
      forgotPasswordCubit.close();
    });

    test('initial state is correct', () {
      expect(forgotPasswordCubit.state, const ForgotPasswordState());
    });

    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'updateEmail emits new email',
      build: () => forgotPasswordCubit,
      act: (cubit) => cubit.updateEmail('test@test.com'),
      expect: () => [const ForgotPasswordState(email: 'test@test.com')],
    );

    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'markEmailSent emits isEmailSent: true',
      build: () => forgotPasswordCubit,
      act: (cubit) => cubit.markEmailSent(),
      expect: () => [const ForgotPasswordState(isEmailSent: true)],
    );

    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'resetState emits initial state',
      build: () => forgotPasswordCubit,
      seed: () => const ForgotPasswordState(isEmailSent: true, email: 'a'),
      act: (cubit) => cubit.resetState(),
      expect: () => [const ForgotPasswordState()],
    );
  });
}
