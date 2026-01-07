import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:spo_kick/features/onboarding/domain/usecases/check_onboarding_status_usecase.dart';

class MockOnboardingRepository extends Mock implements OnboardingRepository {}

void main() {
  late CheckOnboardingStatusUseCase useCase;
  late MockOnboardingRepository mockRepository;

  setUp(() {
    mockRepository = MockOnboardingRepository();
    useCase = CheckOnboardingStatusUseCase(mockRepository);
  });

  group('CheckOnboardingStatusUseCase', () {
    group('successful check', () {
      test('should return true when onboarding is completed', () async {
        // Arrange
        when(
          () => mockRepository.isOnboardingCompleted(),
        ).thenAnswer((_) async => true);

        // Act
        final result = await useCase();

        // Assert
        expect(result, true);
        verify(() => mockRepository.isOnboardingCompleted()).called(1);
      });

      test('should return false when onboarding is not completed', () async {
        // Arrange
        when(
          () => mockRepository.isOnboardingCompleted(),
        ).thenAnswer((_) async => false);

        // Act
        final result = await useCase();

        // Assert
        expect(result, false);
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.isOnboardingCompleted(),
        ).thenAnswer((_) async => true);

        // Act
        await useCase();

        // Assert
        verify(() => mockRepository.isOnboardingCompleted()).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should return consistent results', () async {
        // Arrange
        when(
          () => mockRepository.isOnboardingCompleted(),
        ).thenAnswer((_) async => true);

        // Act
        final result1 = await useCase();
        final result2 = await useCase();

        // Assert
        expect(result1, result2);
      });
    });
  });
}
