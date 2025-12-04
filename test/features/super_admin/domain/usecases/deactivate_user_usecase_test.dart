import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/deactivate_user_usecase.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late DeactivateUserUseCase useCase;
  late MockSuperAdminRepository mockRepository;

  setUp(() {
    mockRepository = MockSuperAdminRepository();
    useCase = DeactivateUserUseCase(mockRepository);
  });

  group('DeactivateUserUseCase', () {
    const tUserId = 'user-123';

    test('should return void when deactivation succeeds', () async {
      // Arrange
      when(
        () => mockRepository.deactivateUser(tUserId),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(userId: tUserId);

      // Assert
      expect(result, equals(const Right(null)));
      verify(() => mockRepository.deactivateUser(tUserId)).called(1);
    });

    test('should return NotFoundFailure when user not found', () async {
      // Arrange
      const tFailure = NotFoundFailure('User not found');
      when(
        () => mockRepository.deactivateUser(tUserId),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(userId: tUserId);

      // Assert
      expect(result, equals(const Left(tFailure)));
    });

    test('should return ServerFailure when repository call fails', () async {
      // Arrange
      const tFailure = ServerFailure('Failed to deactivate user');
      when(
        () => mockRepository.deactivateUser(tUserId),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(userId: tUserId);

      // Assert
      expect(result, equals(const Left(tFailure)));
    });

    test(
      'should call repository.deactivateUser() with correct userId',
      () async {
        // Arrange
        when(
          () => mockRepository.deactivateUser(tUserId),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await useCase(userId: tUserId);

        // Assert
        verify(() => mockRepository.deactivateUser(tUserId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
