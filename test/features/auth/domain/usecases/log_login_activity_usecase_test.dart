import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/login_activity_entity.dart';
import 'package:spo_kick/features/auth/domain/repositories/login_activity_repository.dart';
import 'package:spo_kick/features/auth/domain/usecases/log_login_activity_usecase.dart';

class MockLoginActivityRepository extends Mock
    implements LoginActivityRepository {}

void main() {
  late LogLoginActivityUseCase useCase;
  late MockLoginActivityRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(LoginStatus.success);
  });

  setUp(() {
    mockRepository = MockLoginActivityRepository();
    useCase = LogLoginActivityUseCase(mockRepository);
  });

  group('LogLoginActivityUseCase', () {
    const tUserId = 'user-123';
    const tStatus = LoginStatus.success;
    const tIpAddress = '192.168.1.1';
    const tLocation = 'Cairo, Egypt';

    group('successful logging', () {
      test(
        'should return Right(void) when logging succeeds with all parameters',
        () async {
          // Arrange
          when(
            () => mockRepository.logLoginActivity(
              userId: any(named: 'userId'),
              status: any(named: 'status'),
              ipAddress: any(named: 'ipAddress'),
              location: any(named: 'location'),
            ),
          ).thenAnswer((_) async => const Right(null));

          // Act
          final result = await useCase(
            userId: tUserId,
            status: tStatus,
            ipAddress: tIpAddress,
            location: tLocation,
          );

          // Assert
          expect(result.isRight(), true);
          verify(
            () => mockRepository.logLoginActivity(
              userId: tUserId,
              status: tStatus,
              ipAddress: tIpAddress,
              location: tLocation,
            ),
          ).called(1);
        },
      );

      test('should succeed with only required parameters', () async {
        // Arrange
        when(
          () => mockRepository.logLoginActivity(
            userId: any(named: 'userId'),
            status: any(named: 'status'),
            ipAddress: any(named: 'ipAddress'),
            location: any(named: 'location'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(userId: tUserId, status: tStatus);

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.logLoginActivity(
            userId: tUserId,
            status: tStatus,
            ipAddress: null,
            location: null,
          ),
        ).called(1);
      });

      test('should log successful login status', () async {
        // Arrange
        when(
          () => mockRepository.logLoginActivity(
            userId: any(named: 'userId'),
            status: any(named: 'status'),
            ipAddress: any(named: 'ipAddress'),
            location: any(named: 'location'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(
          userId: tUserId,
          status: LoginStatus.success,
        );

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.logLoginActivity(
            userId: tUserId,
            status: LoginStatus.success,
            ipAddress: null,
            location: null,
          ),
        ).called(1);
      });

      test('should log failed login status', () async {
        // Arrange
        when(
          () => mockRepository.logLoginActivity(
            userId: any(named: 'userId'),
            status: any(named: 'status'),
            ipAddress: any(named: 'ipAddress'),
            location: any(named: 'location'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(
          userId: tUserId,
          status: LoginStatus.failed,
          ipAddress: tIpAddress,
        );

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.logLoginActivity(
            userId: tUserId,
            status: LoginStatus.failed,
            ipAddress: tIpAddress,
            location: null,
          ),
        ).called(1);
      });

      test('should log blocked login status', () async {
        // Arrange
        when(
          () => mockRepository.logLoginActivity(
            userId: any(named: 'userId'),
            status: any(named: 'status'),
            ipAddress: any(named: 'ipAddress'),
            location: any(named: 'location'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(
          userId: tUserId,
          status: LoginStatus.blocked,
          ipAddress: tIpAddress,
        );

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.logLoginActivity(
            userId: tUserId,
            status: LoginStatus.blocked,
            ipAddress: tIpAddress,
            location: null,
          ),
        ).called(1);
      });

      test('should log with IPv4 address', () async {
        // Arrange
        const ipv4 = '192.168.1.100';
        when(
          () => mockRepository.logLoginActivity(
            userId: any(named: 'userId'),
            status: any(named: 'status'),
            ipAddress: any(named: 'ipAddress'),
            location: any(named: 'location'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(
          userId: tUserId,
          status: tStatus,
          ipAddress: ipv4,
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should log with IPv6 address', () async {
        // Arrange
        const ipv6 = '2001:0db8:85a3:0000:0000:8a2e:0370:7334';
        when(
          () => mockRepository.logLoginActivity(
            userId: any(named: 'userId'),
            status: any(named: 'status'),
            ipAddress: any(named: 'ipAddress'),
            location: any(named: 'location'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(
          userId: tUserId,
          status: tStatus,
          ipAddress: ipv6,
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should log with location containing city and country', () async {
        // Arrange
        const location = 'New York, United States';
        when(
          () => mockRepository.logLoginActivity(
            userId: any(named: 'userId'),
            status: any(named: 'status'),
            ipAddress: any(named: 'ipAddress'),
            location: any(named: 'location'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(
          userId: tUserId,
          status: tStatus,
          location: location,
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should log with location containing special characters', () async {
        // Arrange
        const location = 'São Paulo, Brazil';
        when(
          () => mockRepository.logLoginActivity(
            userId: any(named: 'userId'),
            status: any(named: 'status'),
            ipAddress: any(named: 'ipAddress'),
            location: any(named: 'location'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(
          userId: tUserId,
          status: tStatus,
          location: location,
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should log with Arabic location', () async {
        // Arrange
        const location = 'القاهرة، مصر';
        when(
          () => mockRepository.logLoginActivity(
            userId: any(named: 'userId'),
            status: any(named: 'status'),
            ipAddress: any(named: 'ipAddress'),
            location: any(named: 'location'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(
          userId: tUserId,
          status: tStatus,
          location: location,
        );

        // Assert
        expect(result.isRight(), true);
      });
    });

    group('repository failures', () {
      test('should return ServerFailure when repository call fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to log login activity');
        when(
          () => mockRepository.logLoginActivity(
            userId: any(named: 'userId'),
            status: any(named: 'status'),
            ipAddress: any(named: 'ipAddress'),
            location: any(named: 'location'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(userId: tUserId, status: tStatus);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure when network error occurs', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.logLoginActivity(
            userId: any(named: 'userId'),
            status: any(named: 'status'),
            ipAddress: any(named: 'ipAddress'),
            location: any(named: 'location'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(userId: tUserId, status: tStatus);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ValidationFailure when userId is invalid', () async {
        // Arrange
        const tFailure = ValidationFailure('Invalid user ID');
        when(
          () => mockRepository.logLoginActivity(
            userId: any(named: 'userId'),
            status: any(named: 'status'),
            ipAddress: any(named: 'ipAddress'),
            location: any(named: 'location'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(userId: '', status: tStatus);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure when database insert fails', () async {
        // Arrange
        const tFailure = ServerFailure('Database error');
        when(
          () => mockRepository.logLoginActivity(
            userId: any(named: 'userId'),
            status: any(named: 'status'),
            ipAddress: any(named: 'ipAddress'),
            location: any(named: 'location'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(userId: tUserId, status: tStatus);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });

    group('edge cases', () {
      test('should call repository only once', () async {
        // Arrange
        when(
          () => mockRepository.logLoginActivity(
            userId: any(named: 'userId'),
            status: any(named: 'status'),
            ipAddress: any(named: 'ipAddress'),
            location: any(named: 'location'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await useCase(
          userId: tUserId,
          status: tStatus,
          ipAddress: tIpAddress,
          location: tLocation,
        );

        // Assert
        verify(
          () => mockRepository.logLoginActivity(
            userId: tUserId,
            status: tStatus,
            ipAddress: tIpAddress,
            location: tLocation,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle userId with special characters', () async {
        // Arrange
        const specialUserId = 'user-123-abc_def@xyz';
        when(
          () => mockRepository.logLoginActivity(
            userId: any(named: 'userId'),
            status: any(named: 'status'),
            ipAddress: any(named: 'ipAddress'),
            location: any(named: 'location'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(userId: specialUserId, status: tStatus);

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle very long userId', () async {
        // Arrange
        final longUserId = 'user-' * 50; // 250 characters
        when(
          () => mockRepository.logLoginActivity(
            userId: any(named: 'userId'),
            status: any(named: 'status'),
            ipAddress: any(named: 'ipAddress'),
            location: any(named: 'location'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(userId: longUserId, status: tStatus);

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle very long location string', () async {
        // Arrange
        const longLocation =
            'Very Long City Name With Multiple Words, Very Long Country Name';
        when(
          () => mockRepository.logLoginActivity(
            userId: any(named: 'userId'),
            status: any(named: 'status'),
            ipAddress: any(named: 'ipAddress'),
            location: any(named: 'location'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(
          userId: tUserId,
          status: tStatus,
          location: longLocation,
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle localhost IP address', () async {
        // Arrange
        const localhostIp = '127.0.0.1';
        when(
          () => mockRepository.logLoginActivity(
            userId: any(named: 'userId'),
            status: any(named: 'status'),
            ipAddress: any(named: 'ipAddress'),
            location: any(named: 'location'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(
          userId: tUserId,
          status: tStatus,
          ipAddress: localhostIp,
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle unknown location', () async {
        // Arrange
        const unknownLocation = 'Unknown';
        when(
          () => mockRepository.logLoginActivity(
            userId: any(named: 'userId'),
            status: any(named: 'status'),
            ipAddress: any(named: 'ipAddress'),
            location: any(named: 'location'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(
          userId: tUserId,
          status: tStatus,
          location: unknownLocation,
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle null ipAddress', () async {
        // Arrange
        when(
          () => mockRepository.logLoginActivity(
            userId: any(named: 'userId'),
            status: any(named: 'status'),
            ipAddress: any(named: 'ipAddress'),
            location: any(named: 'location'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(
          userId: tUserId,
          status: tStatus,
          ipAddress: null,
          location: tLocation,
        );

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.logLoginActivity(
            userId: tUserId,
            status: tStatus,
            ipAddress: null,
            location: tLocation,
          ),
        ).called(1);
      });

      test('should handle null location', () async {
        // Arrange
        when(
          () => mockRepository.logLoginActivity(
            userId: any(named: 'userId'),
            status: any(named: 'status'),
            ipAddress: any(named: 'ipAddress'),
            location: any(named: 'location'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(
          userId: tUserId,
          status: tStatus,
          ipAddress: tIpAddress,
          location: null,
        );

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.logLoginActivity(
            userId: tUserId,
            status: tStatus,
            ipAddress: tIpAddress,
            location: null,
          ),
        ).called(1);
      });

      test('should handle both null ipAddress and location', () async {
        // Arrange
        when(
          () => mockRepository.logLoginActivity(
            userId: any(named: 'userId'),
            status: any(named: 'status'),
            ipAddress: any(named: 'ipAddress'),
            location: any(named: 'location'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(userId: tUserId, status: tStatus);

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.logLoginActivity(
            userId: tUserId,
            status: tStatus,
            ipAddress: null,
            location: null,
          ),
        ).called(1);
      });

      test('should handle concurrent logging for different users', () async {
        // Arrange
        when(
          () => mockRepository.logLoginActivity(
            userId: any(named: 'userId'),
            status: any(named: 'status'),
            ipAddress: any(named: 'ipAddress'),
            location: any(named: 'location'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final results = await Future.wait([
          useCase(userId: 'user-1', status: LoginStatus.success),
          useCase(userId: 'user-2', status: LoginStatus.failed),
          useCase(userId: 'user-3', status: LoginStatus.blocked),
        ]);

        // Assert
        for (final result in results) {
          expect(result.isRight(), true);
        }
        verify(
          () => mockRepository.logLoginActivity(
            userId: any(named: 'userId'),
            status: any(named: 'status'),
            ipAddress: any(named: 'ipAddress'),
            location: any(named: 'location'),
          ),
        ).called(3);
      });

      test('should handle rapid consecutive logs for same user', () async {
        // Arrange
        when(
          () => mockRepository.logLoginActivity(
            userId: any(named: 'userId'),
            status: any(named: 'status'),
            ipAddress: any(named: 'ipAddress'),
            location: any(named: 'location'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final results = await Future.wait([
          useCase(userId: tUserId, status: LoginStatus.failed),
          useCase(userId: tUserId, status: LoginStatus.failed),
          useCase(userId: tUserId, status: LoginStatus.success),
        ]);

        // Assert
        for (final result in results) {
          expect(result.isRight(), true);
        }
      });

      test('should handle empty string location', () async {
        // Arrange
        when(
          () => mockRepository.logLoginActivity(
            userId: any(named: 'userId'),
            status: any(named: 'status'),
            ipAddress: any(named: 'ipAddress'),
            location: any(named: 'location'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(
          userId: tUserId,
          status: tStatus,
          location: '',
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle empty string ipAddress', () async {
        // Arrange
        when(
          () => mockRepository.logLoginActivity(
            userId: any(named: 'userId'),
            status: any(named: 'status'),
            ipAddress: any(named: 'ipAddress'),
            location: any(named: 'location'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(
          userId: tUserId,
          status: tStatus,
          ipAddress: '',
        );

        // Assert
        expect(result.isRight(), true);
      });
    });
  });
}
