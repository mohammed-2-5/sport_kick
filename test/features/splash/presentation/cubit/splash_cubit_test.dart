import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:spo_kick/features/city/domain/usecases/get_selected_city_usecase.dart';
import 'package:spo_kick/features/onboarding/domain/usecases/check_onboarding_status_usecase.dart';
import 'package:spo_kick/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:spo_kick/features/splash/presentation/cubit/splash_state.dart';

class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

class MockCheckOnboardingStatusUseCase extends Mock
    implements CheckOnboardingStatusUseCase {}

class MockGetSelectedCityUseCase extends Mock
    implements GetSelectedCityUseCase {}

void main() {
  late SplashCubit cubit;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
  late MockCheckOnboardingStatusUseCase mockCheckOnboardingStatusUseCase;
  late MockGetSelectedCityUseCase mockGetSelectedCityUseCase;

  final tUser = UserEntity(
    id: '1',
    email: 'test@example.com',
    role: 'user',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  final tAdmin = UserEntity(
    id: '2',
    email: 'admin@example.com',
    role: 'admin',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  setUp(() {
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    mockCheckOnboardingStatusUseCase = MockCheckOnboardingStatusUseCase();
    mockGetSelectedCityUseCase = MockGetSelectedCityUseCase();
    cubit = SplashCubit(
      getCurrentUserUseCase: mockGetCurrentUserUseCase,
      checkOnboardingStatusUseCase: mockCheckOnboardingStatusUseCase,
      getSelectedCityUseCase: mockGetSelectedCityUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is SplashInitial', () {
    expect(cubit.state, const SplashInitial());
  });

  blocTest<SplashCubit, SplashState>(
    'emits [SplashLoading, SplashNavigateToOnboarding] when onboarding is NOT completed',
    build: () {
      when(
        () => mockCheckOnboardingStatusUseCase(),
      ).thenAnswer((_) async => false);
      return cubit;
    },
    act: (cubit) => cubit.initializeApp(),
    wait: const Duration(milliseconds: 2600), // Wait for delay
    expect: () => [const SplashLoading(), const SplashNavigateToOnboarding()],
  );

  blocTest<SplashCubit, SplashState>(
    'emits [SplashLoading, SplashNavigateToLogin] when onboarding completed but no user logged in',
    build: () {
      when(
        () => mockCheckOnboardingStatusUseCase(),
      ).thenAnswer((_) async => true);
      when(
        () => mockGetCurrentUserUseCase(),
      ).thenAnswer((_) async => const Right(null));
      return cubit;
    },
    act: (cubit) => cubit.initializeApp(),
    wait: const Duration(milliseconds: 2600),
    expect: () => [const SplashLoading(), const SplashNavigateToLogin()],
  );

  blocTest<SplashCubit, SplashState>(
    'emits [SplashLoading, SplashNavigateToCitySelection] when logged in user has no city selected',
    build: () {
      when(
        () => mockCheckOnboardingStatusUseCase(),
      ).thenAnswer((_) async => true);
      when(
        () => mockGetCurrentUserUseCase(),
      ).thenAnswer((_) async => Right(tUser));
      when(
        () => mockGetSelectedCityUseCase(),
      ).thenAnswer((_) async => const Right(null));
      return cubit;
    },
    act: (cubit) => cubit.initializeApp(),
    wait: const Duration(milliseconds: 2600),
    expect: () => [
      const SplashLoading(),
      const SplashNavigateToCitySelection(),
    ],
  );

  blocTest<SplashCubit, SplashState>(
    'emits [SplashLoading, SplashNavigateToHome] when logged in user has city selected',
    build: () {
      when(
        () => mockCheckOnboardingStatusUseCase(),
      ).thenAnswer((_) async => true);
      when(
        () => mockGetCurrentUserUseCase(),
      ).thenAnswer((_) async => Right(tUser));
      when(
        () => mockGetSelectedCityUseCase(),
      ).thenAnswer((_) async => const Right('city123'));
      return cubit;
    },
    act: (cubit) => cubit.initializeApp(),
    wait: const Duration(milliseconds: 2600),
    expect: () => [const SplashLoading(), const SplashNavigateToHome('user')],
  );

  blocTest<SplashCubit, SplashState>(
    'emits [SplashLoading, SplashNavigateToHome] when logged in as admin (skips city check)',
    build: () {
      when(
        () => mockCheckOnboardingStatusUseCase(),
      ).thenAnswer((_) async => true);
      when(
        () => mockGetCurrentUserUseCase(),
      ).thenAnswer((_) async => Right(tAdmin));
      return cubit;
    },
    act: (cubit) => cubit.initializeApp(),
    wait: const Duration(milliseconds: 2600),
    expect: () => [const SplashLoading(), const SplashNavigateToHome('admin')],
  );
}
