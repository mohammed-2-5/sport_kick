import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:spo_kick/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';

class MockOnboardingRepository extends Mock implements OnboardingRepository {}

void main() {
  late CompleteOnboardingUseCase useCase;
  late MockOnboardingRepository mockRepository;

  setUp(() {
    mockRepository = MockOnboardingRepository();
    useCase = CompleteOnboardingUseCase(mockRepository);
  });

  group('CompleteOnboardingUseCase', () {
    group('successful completion', () {
      test('should complete onboarding successfully', () async {
        // Arrange
        when(
          () => mockRepository.setOnboardingCompleted(),
        ).thenAnswer((_) async {});

        // Act
        await useCase();

        // Assert
        verify(() => mockRepository.setOnboardingCompleted()).called(1);
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.setOnboardingCompleted(),
        ).thenAnswer((_) async {});

        // Act
        await useCase();

        // Assert
        verify(() => mockRepository.setOnboardingCompleted()).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle multiple completions (idempotent)', () async {
        // Arrange
        when(
          () => mockRepository.setOnboardingCompleted(),
        ).thenAnswer((_) async {});

        // Act - call multiple times
        await useCase();
        await useCase();
        await useCase();

        // Assert
        verify(() => mockRepository.setOnboardingCompleted()).called(3);
      });

      test('should not throw exception on success', () async {
        // Arrange
        when(
          () => mockRepository.setOnboardingCompleted(),
        ).thenAnswer((_) async {});

        // Act & Assert
        expect(() => useCase(), returnsNormally);
      });
    });
  });
}
