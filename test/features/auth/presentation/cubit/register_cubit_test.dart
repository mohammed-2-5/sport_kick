import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/register_cubit.dart';

class MockAuthCubit extends Mock implements AuthCubit {}

void main() {
  group('RegisterCubit', () {
    late RegisterCubit registerCubit;
    late MockAuthCubit mockAuthCubit;

    setUp(() {
      mockAuthCubit = MockAuthCubit();
      registerCubit = RegisterCubit(authCubit: mockAuthCubit);
    });

    tearDown(() {
      registerCubit.close();
    });

    test('initial state is correct', () {
      expect(registerCubit.state, const RegisterState());
    });

    blocTest<RegisterCubit, RegisterState>(
      'toggles password visibility',
      build: () => RegisterCubit(authCubit: mockAuthCubit),
      act: (cubit) => cubit.togglePasswordVisibility(),
      expect: () => [const RegisterState(isPasswordVisible: true)],
    );

    blocTest<RegisterCubit, RegisterState>(
      'toggles confirm password visibility',
      build: () => RegisterCubit(authCubit: mockAuthCubit),
      act: (cubit) => cubit.toggleConfirmPasswordVisibility(),
      expect: () => [const RegisterState(isConfirmPasswordVisible: true)],
    );
  });
}
