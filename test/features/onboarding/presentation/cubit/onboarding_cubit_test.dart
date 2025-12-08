import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:spo_kick/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:spo_kick/features/onboarding/presentation/cubit/onboarding_state.dart';

class MockCompleteOnboardingUseCase extends Mock
    implements CompleteOnboardingUseCase {}

void main() {
  late OnboardingCubit cubit;
  late MockCompleteOnboardingUseCase mockCompleteOnboardingUseCase;

  setUp(() {
    mockCompleteOnboardingUseCase = MockCompleteOnboardingUseCase();
    cubit = OnboardingCubit(
      completeOnboardingUseCase: mockCompleteOnboardingUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is OnboardingInitial', () {
    expect(cubit.state, const OnboardingInitial());
  });

  blocTest<OnboardingCubit, OnboardingState>(
    'emits [OnboardingPageChanged] when pageChanged is called',
    build: () => cubit,
    act: (cubit) => cubit.pageChanged(1),
    expect: () => [const OnboardingPageChanged(1)],
  );

  blocTest<OnboardingCubit, OnboardingState>(
    'emits [OnboardingCompleted] when completeOnboarding is called',
    build: () {
      when(() => mockCompleteOnboardingUseCase()).thenAnswer((_) async {});
      return cubit;
    },
    act: (cubit) => cubit.completeOnboarding(),
    expect: () => [const OnboardingCompleted()],
    verify: (_) {
      verify(() => mockCompleteOnboardingUseCase()).called(1);
    },
  );
}
