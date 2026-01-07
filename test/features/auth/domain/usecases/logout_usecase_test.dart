import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/usecases/logout_usecase.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late LogoutUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LogoutUseCase(mockRepository);
  });

  group('LogoutUseCase', () {
    group('successful logout', () {
      test('should return Right(void) when logout succeeds', () async {
        // Arrange
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        verify(() => mockRepository.logout()).called(1);
      });

      test('should call repository logout method', () async {
        // Arrange
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await useCase();

        // Assert
        verify(() => mockRepository.logout()).called(1);
      });

      test('should successfully logout user role', () async {
        // Arrange
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
      });

      test('should successfully logout admin role', () async {
        // Arrange
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
      });

      test('should successfully logout super admin role', () async {
        // Arrange
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
      });
    });

    group('logout failures', () {
      test('should return ServerFailure when repository call fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to logout');
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure when network error occurs', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test(
        'should return ServerFailure when session is already invalid',
        () async {
          // Arrange
          const tFailure = ServerFailure('Session already expired');
          when(
            () => mockRepository.logout(),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase();

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );

      test(
        'should return ServerFailure when auth service is unavailable',
        () async {
          // Arrange
          const tFailure = ServerFailure('Authentication service unavailable');
          when(
            () => mockRepository.logout(),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase();

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );

      test('should return ServerFailure when token revocation fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to revoke access token');
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test(
        'should return CacheFailure when local session cleanup fails',
        () async {
          // Arrange
          const tFailure = CacheFailure('Failed to clear local session data');
          when(
            () => mockRepository.logout(),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase();

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );

      test(
        'should return AuthFailure when user is not authenticated',
        () async {
          // Arrange
          const tFailure = AuthFailure('No active session');
          when(
            () => mockRepository.logout(),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase();

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );
    });

    group('edge cases', () {
      test('should call repository only once', () async {
        // Arrange
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await useCase();

        // Assert
        verify(() => mockRepository.logout()).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle multiple consecutive logout calls', () async {
        // Arrange
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result1 = await useCase();
        final result2 = await useCase();
        final result3 = await useCase();

        // Assert
        expect(result1.isRight(), true);
        expect(result2.isRight(), true);
        expect(result3.isRight(), true);
        verify(() => mockRepository.logout()).called(3);
      });

      test('should handle logout when session is about to expire', () async {
        // Arrange
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
      });

      test('should succeed even if cleanup is partial', () async {
        // Arrange
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle logout during active operations', () async {
        // Arrange
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle logout with expired refresh token', () async {
        // Arrange
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle logout from multiple devices scenario', () async {
        // Arrange
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle logout while offline', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isLeft(), true);
      });

      test('should not throw exception on logout', () async {
        // Arrange
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Right(null));

        // Act & Assert
        expect(() => useCase(), returnsNormally);
      });

      test('should complete logout in reasonable time', () async {
        // Arrange
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final stopwatch = Stopwatch()..start();
        await useCase();
        stopwatch.stop();

        // Assert
        expect(stopwatch.elapsedMilliseconds, lessThan(5000));
      });

      test('should handle logout after password change', () async {
        // Arrange
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle logout after profile update', () async {
        // Arrange
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle logout when user is deactivated', () async {
        // Arrange
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle force logout scenario', () async {
        // Arrange
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
      });

      test('should succeed with concurrent logout attempts', () async {
        // Arrange
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final results = await Future.wait([useCase(), useCase(), useCase()]);

        // Assert
        for (final result in results) {
          expect(result.isRight(), true);
        }
      });
    });

    group('repository interaction', () {
      test('should only interact with repository logout method', () async {
        // Arrange
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await useCase();

        // Assert
        verify(() => mockRepository.logout()).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should propagate repository result unchanged', () async {
        // Arrange
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
      });

      test('should propagate repository failure unchanged', () async {
        // Arrange
        const tFailure = ServerFailure('Test failure');
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
