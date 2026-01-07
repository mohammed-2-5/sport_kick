import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/login_activity_entity.dart';
import 'package:spo_kick/features/auth/domain/repositories/login_activity_repository.dart';
import 'package:spo_kick/features/auth/domain/usecases/get_login_activity_usecase.dart';

class MockLoginActivityRepository extends Mock
    implements LoginActivityRepository {}

void main() {
  late GetLoginActivityUseCase getLoginActivityUseCase;
  late GetAllLoginActivityUseCase getAllLoginActivityUseCase;
  late MockLoginActivityRepository mockRepository;

  setUp(() {
    mockRepository = MockLoginActivityRepository();
    getLoginActivityUseCase = GetLoginActivityUseCase(mockRepository);
    getAllLoginActivityUseCase = GetAllLoginActivityUseCase(mockRepository);
  });

  group('GetLoginActivityUseCase', () {
    const tUserId = 'user-123';
    const tLimit = 20;
    const tOffset = 0;

    final tLoginActivities = [
      LoginActivityEntity(
        id: 'activity-1',
        userId: tUserId,
        timestamp: DateTime(2024, 1, 15, 10, 30),
        ipAddress: '192.168.1.1',
        deviceType: DeviceType.mobile,
        deviceName: 'iPhone 14',
        location: 'Cairo, Egypt',
        status: LoginStatus.success,
        userAgent: 'Mozilla/5.0',
        isCurrentSession: true,
      ),
      LoginActivityEntity(
        id: 'activity-2',
        userId: tUserId,
        timestamp: DateTime(2024, 1, 14, 15, 20),
        ipAddress: '192.168.1.2',
        deviceType: DeviceType.web,
        deviceName: 'Chrome on Windows',
        location: 'Alexandria, Egypt',
        status: LoginStatus.success,
        isCurrentSession: false,
      ),
    ];

    group('successful retrieval', () {
      test(
        'should return list of LoginActivityEntity when call succeeds',
        () async {
          // Arrange
          when(
            () => mockRepository.getLoginActivity(
              any(),
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
            ),
          ).thenAnswer((_) async => Right(tLoginActivities));

          // Act
          final result = await getLoginActivityUseCase(tUserId);

          // Assert
          expect(result.isRight(), true);
          result.fold((_) => fail('Should return Right'), (activities) {
            expect(activities, equals(tLoginActivities));
            expect(activities.length, 2);
          });
          verify(
            () => mockRepository.getLoginActivity(
              tUserId,
              limit: tLimit,
              offset: tOffset,
            ),
          ).called(1);
        },
      );

      test('should return empty list when user has no login history', () async {
        // Arrange
        when(
          () => mockRepository.getLoginActivity(
            any(),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenAnswer((_) async => const Right([]));

        // Act
        final result = await getLoginActivityUseCase(tUserId);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should return Right'),
          (activities) => expect(activities, isEmpty),
        );
      });

      test('should use custom limit when provided', () async {
        // Arrange
        const customLimit = 50;
        when(
          () => mockRepository.getLoginActivity(
            any(),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenAnswer((_) async => Right(tLoginActivities));

        // Act
        final result = await getLoginActivityUseCase(
          tUserId,
          limit: customLimit,
        );

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.getLoginActivity(
            tUserId,
            limit: customLimit,
            offset: tOffset,
          ),
        ).called(1);
      });

      test('should use custom offset when provided', () async {
        // Arrange
        const customOffset = 40;
        when(
          () => mockRepository.getLoginActivity(
            any(),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenAnswer((_) async => Right(tLoginActivities));

        // Act
        final result = await getLoginActivityUseCase(
          tUserId,
          offset: customOffset,
        );

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.getLoginActivity(
            tUserId,
            limit: tLimit,
            offset: customOffset,
          ),
        ).called(1);
      });

      test('should use custom limit and offset when both provided', () async {
        // Arrange
        const customLimit = 100;
        const customOffset = 50;
        when(
          () => mockRepository.getLoginActivity(
            any(),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenAnswer((_) async => Right(tLoginActivities));

        // Act
        final result = await getLoginActivityUseCase(
          tUserId,
          limit: customLimit,
          offset: customOffset,
        );

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.getLoginActivity(
            tUserId,
            limit: customLimit,
            offset: customOffset,
          ),
        ).called(1);
      });

      test('should handle activities with different statuses', () async {
        // Arrange
        final mixedStatusActivities = [
          LoginActivityEntity(
            id: 'activity-1',
            userId: tUserId,
            timestamp: DateTime(2024, 1, 15),
            status: LoginStatus.success,
          ),
          LoginActivityEntity(
            id: 'activity-2',
            userId: tUserId,
            timestamp: DateTime(2024, 1, 14),
            status: LoginStatus.failed,
          ),
          LoginActivityEntity(
            id: 'activity-3',
            userId: tUserId,
            timestamp: DateTime(2024, 1, 13),
            status: LoginStatus.blocked,
          ),
        ];

        when(
          () => mockRepository.getLoginActivity(
            any(),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenAnswer((_) async => Right(mixedStatusActivities));

        // Act
        final result = await getLoginActivityUseCase(tUserId);

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return Right'), (activities) {
          expect(activities.length, 3);
          expect(activities[0].status, LoginStatus.success);
          expect(activities[1].status, LoginStatus.failed);
          expect(activities[2].status, LoginStatus.blocked);
        });
      });

      test('should handle activities with different device types', () async {
        // Arrange
        final mixedDeviceActivities = [
          LoginActivityEntity(
            id: 'activity-1',
            userId: tUserId,
            timestamp: DateTime(2024, 1, 15),
            deviceType: DeviceType.mobile,
          ),
          LoginActivityEntity(
            id: 'activity-2',
            userId: tUserId,
            timestamp: DateTime(2024, 1, 14),
            deviceType: DeviceType.web,
          ),
          LoginActivityEntity(
            id: 'activity-3',
            userId: tUserId,
            timestamp: DateTime(2024, 1, 13),
            deviceType: DeviceType.desktop,
          ),
        ];

        when(
          () => mockRepository.getLoginActivity(
            any(),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenAnswer((_) async => Right(mixedDeviceActivities));

        // Act
        final result = await getLoginActivityUseCase(tUserId);

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return Right'), (activities) {
          expect(activities.length, 3);
          expect(activities[0].deviceType, DeviceType.mobile);
          expect(activities[1].deviceType, DeviceType.web);
          expect(activities[2].deviceType, DeviceType.desktop);
        });
      });
    });

    group('repository failures', () {
      test('should return ServerFailure when repository call fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to fetch login activity');
        when(
          () => mockRepository.getLoginActivity(
            any(),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await getLoginActivityUseCase(tUserId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure when network error occurs', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.getLoginActivity(
            any(),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await getLoginActivityUseCase(tUserId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when user is unauthorized', () async {
        // Arrange
        const tFailure = AuthFailure('Unauthorized access');
        when(
          () => mockRepository.getLoginActivity(
            any(),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await getLoginActivityUseCase(tUserId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });

    group('edge cases', () {
      test('should call repository only once', () async {
        // Arrange
        when(
          () => mockRepository.getLoginActivity(
            any(),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenAnswer((_) async => Right(tLoginActivities));

        // Act
        await getLoginActivityUseCase(tUserId);

        // Assert
        verify(
          () => mockRepository.getLoginActivity(
            tUserId,
            limit: tLimit,
            offset: tOffset,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle very large limit value', () async {
        // Arrange
        const largeLimit = 10000;
        when(
          () => mockRepository.getLoginActivity(
            any(),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenAnswer((_) async => Right(tLoginActivities));

        // Act
        final result = await getLoginActivityUseCase(
          tUserId,
          limit: largeLimit,
        );

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.getLoginActivity(
            tUserId,
            limit: largeLimit,
            offset: tOffset,
          ),
        ).called(1);
      });

      test('should handle very large offset value', () async {
        // Arrange
        const largeOffset = 100000;
        when(
          () => mockRepository.getLoginActivity(
            any(),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenAnswer((_) async => Right(tLoginActivities));

        // Act
        final result = await getLoginActivityUseCase(
          tUserId,
          offset: largeOffset,
        );

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.getLoginActivity(
            tUserId,
            limit: tLimit,
            offset: largeOffset,
          ),
        ).called(1);
      });

      test('should handle userId with special characters', () async {
        // Arrange
        const specialUserId = 'user-123-abc_def@xyz';
        when(
          () => mockRepository.getLoginActivity(
            any(),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenAnswer((_) async => Right(tLoginActivities));

        // Act
        final result = await getLoginActivityUseCase(specialUserId);

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.getLoginActivity(
            specialUserId,
            limit: tLimit,
            offset: tOffset,
          ),
        ).called(1);
      });
    });
  });

  group('GetAllLoginActivityUseCase', () {
    const tLimit = 50;
    const tOffset = 0;

    final tAllLoginActivities = [
      LoginActivityEntity(
        id: 'activity-1',
        userId: 'user-1',
        timestamp: DateTime(2024, 1, 15, 10, 30),
        status: LoginStatus.success,
        userName: 'John Doe',
        userEmail: 'john@example.com',
        userRole: 'user',
      ),
      LoginActivityEntity(
        id: 'activity-2',
        userId: 'user-2',
        timestamp: DateTime(2024, 1, 14, 15, 20),
        status: LoginStatus.failed,
        userName: 'Jane Smith',
        userEmail: 'jane@example.com',
        userRole: 'admin',
      ),
      LoginActivityEntity(
        id: 'activity-3',
        userId: 'user-3',
        timestamp: DateTime(2024, 1, 13, 9, 15),
        status: LoginStatus.blocked,
        userName: 'Bob Johnson',
        userEmail: 'bob@example.com',
        userRole: 'user',
      ),
    ];

    group('successful retrieval', () {
      test(
        'should return list of all LoginActivityEntity when call succeeds',
        () async {
          // Arrange
          when(
            () => mockRepository.getAllLoginActivity(
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
              statusFilter: any(named: 'statusFilter'),
            ),
          ).thenAnswer((_) async => Right(tAllLoginActivities));

          // Act
          final result = await getAllLoginActivityUseCase();

          // Assert
          expect(result.isRight(), true);
          result.fold((_) => fail('Should return Right'), (activities) {
            expect(activities, equals(tAllLoginActivities));
            expect(activities.length, 3);
          });
          verify(
            () => mockRepository.getAllLoginActivity(
              limit: tLimit,
              offset: tOffset,
              statusFilter: null,
            ),
          ).called(1);
        },
      );

      test('should return empty list when no login activity exists', () async {
        // Arrange
        when(
          () => mockRepository.getAllLoginActivity(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            statusFilter: any(named: 'statusFilter'),
          ),
        ).thenAnswer((_) async => const Right([]));

        // Act
        final result = await getAllLoginActivityUseCase();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should return Right'),
          (activities) => expect(activities, isEmpty),
        );
      });

      test('should use custom limit when provided', () async {
        // Arrange
        const customLimit = 100;
        when(
          () => mockRepository.getAllLoginActivity(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            statusFilter: any(named: 'statusFilter'),
          ),
        ).thenAnswer((_) async => Right(tAllLoginActivities));

        // Act
        final result = await getAllLoginActivityUseCase(limit: customLimit);

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.getAllLoginActivity(
            limit: customLimit,
            offset: tOffset,
            statusFilter: null,
          ),
        ).called(1);
      });

      test('should use custom offset when provided', () async {
        // Arrange
        const customOffset = 25;
        when(
          () => mockRepository.getAllLoginActivity(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            statusFilter: any(named: 'statusFilter'),
          ),
        ).thenAnswer((_) async => Right(tAllLoginActivities));

        // Act
        final result = await getAllLoginActivityUseCase(offset: customOffset);

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.getAllLoginActivity(
            limit: tLimit,
            offset: customOffset,
            statusFilter: null,
          ),
        ).called(1);
      });

      test('should filter by status when statusFilter is provided', () async {
        // Arrange
        const statusFilter = 'success';
        final successActivities = [tAllLoginActivities[0]];

        when(
          () => mockRepository.getAllLoginActivity(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            statusFilter: any(named: 'statusFilter'),
          ),
        ).thenAnswer((_) async => Right(successActivities));

        // Act
        final result = await getAllLoginActivityUseCase(
          statusFilter: statusFilter,
        );

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return Right'), (activities) {
          expect(activities.length, 1);
          expect(activities[0].status, LoginStatus.success);
        });
        verify(
          () => mockRepository.getAllLoginActivity(
            limit: tLimit,
            offset: tOffset,
            statusFilter: statusFilter,
          ),
        ).called(1);
      });

      test('should filter by failed status', () async {
        // Arrange
        const statusFilter = 'failed';
        final failedActivities = [tAllLoginActivities[1]];

        when(
          () => mockRepository.getAllLoginActivity(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            statusFilter: any(named: 'statusFilter'),
          ),
        ).thenAnswer((_) async => Right(failedActivities));

        // Act
        final result = await getAllLoginActivityUseCase(
          statusFilter: statusFilter,
        );

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return Right'), (activities) {
          expect(activities.length, 1);
          expect(activities[0].status, LoginStatus.failed);
        });
      });

      test('should filter by blocked status', () async {
        // Arrange
        const statusFilter = 'blocked';
        final blockedActivities = [tAllLoginActivities[2]];

        when(
          () => mockRepository.getAllLoginActivity(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            statusFilter: any(named: 'statusFilter'),
          ),
        ).thenAnswer((_) async => Right(blockedActivities));

        // Act
        final result = await getAllLoginActivityUseCase(
          statusFilter: statusFilter,
        );

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return Right'), (activities) {
          expect(activities.length, 1);
          expect(activities[0].status, LoginStatus.blocked);
        });
      });

      test('should include user details in activities', () async {
        // Arrange
        when(
          () => mockRepository.getAllLoginActivity(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            statusFilter: any(named: 'statusFilter'),
          ),
        ).thenAnswer((_) async => Right(tAllLoginActivities));

        // Act
        final result = await getAllLoginActivityUseCase();

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return Right'), (activities) {
          expect(activities[0].userName, 'John Doe');
          expect(activities[0].userEmail, 'john@example.com');
          expect(activities[0].userRole, 'user');
          expect(activities[1].userRole, 'admin');
        });
      });
    });

    group('repository failures', () {
      test('should return ServerFailure when repository call fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to fetch all login activity');
        when(
          () => mockRepository.getAllLoginActivity(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            statusFilter: any(named: 'statusFilter'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await getAllLoginActivityUseCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure when network error occurs', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.getAllLoginActivity(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            statusFilter: any(named: 'statusFilter'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await getAllLoginActivityUseCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when user is not super admin', () async {
        // Arrange
        const tFailure = AuthFailure('Requires super admin privileges');
        when(
          () => mockRepository.getAllLoginActivity(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            statusFilter: any(named: 'statusFilter'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await getAllLoginActivityUseCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });

    group('edge cases', () {
      test('should call repository only once', () async {
        // Arrange
        when(
          () => mockRepository.getAllLoginActivity(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            statusFilter: any(named: 'statusFilter'),
          ),
        ).thenAnswer((_) async => Right(tAllLoginActivities));

        // Act
        await getAllLoginActivityUseCase();

        // Assert
        verify(
          () => mockRepository.getAllLoginActivity(
            limit: tLimit,
            offset: tOffset,
            statusFilter: null,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should use all custom parameters together', () async {
        // Arrange
        const customLimit = 200;
        const customOffset = 100;
        const customStatus = 'success';

        when(
          () => mockRepository.getAllLoginActivity(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            statusFilter: any(named: 'statusFilter'),
          ),
        ).thenAnswer((_) async => Right(tAllLoginActivities));

        // Act
        final result = await getAllLoginActivityUseCase(
          limit: customLimit,
          offset: customOffset,
          statusFilter: customStatus,
        );

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.getAllLoginActivity(
            limit: customLimit,
            offset: customOffset,
            statusFilter: customStatus,
          ),
        ).called(1);
      });

      test('should handle case-sensitive status filter', () async {
        // Arrange
        const statusFilter = 'SUCCESS'; // uppercase

        when(
          () => mockRepository.getAllLoginActivity(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            statusFilter: any(named: 'statusFilter'),
          ),
        ).thenAnswer((_) async => Right(tAllLoginActivities));

        // Act
        final result = await getAllLoginActivityUseCase(
          statusFilter: statusFilter,
        );

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.getAllLoginActivity(
            limit: tLimit,
            offset: tOffset,
            statusFilter: statusFilter,
          ),
        ).called(1);
      });
    });
  });
}
