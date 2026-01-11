import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/login_activity_entity.dart';
import 'package:spo_kick/features/auth/domain/usecases/get_login_activity_usecase.dart';
import 'package:spo_kick/features/auth/presentation/cubit/login_activity_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/login_activity_state.dart';

// Mock Classes
class MockGetLoginActivityUseCase extends Mock
    implements GetLoginActivityUseCase {}

class MockGetAllLoginActivityUseCase extends Mock
    implements GetAllLoginActivityUseCase {}

void main() {
  late LoginActivityCubit cubit;
  late MockGetLoginActivityUseCase mockGetLoginActivityUseCase;
  late MockGetAllLoginActivityUseCase mockGetAllLoginActivityUseCase;

  // Test data
  final now = DateTime.now();
  const tUserId = 'user-123';
  late List<LoginActivityEntity> tActivities;
  late List<LoginActivityEntity> tMoreActivities;

  setUp(() {
    mockGetLoginActivityUseCase = MockGetLoginActivityUseCase();
    mockGetAllLoginActivityUseCase = MockGetAllLoginActivityUseCase();

    // Create 20 activities (page size)
    tActivities = List.generate(
      20,
      (i) => LoginActivityEntity(
        id: 'activity-$i',
        userId: tUserId,
        timestamp: now.subtract(Duration(hours: i)),
        ipAddress: '192.168.1.$i',
        deviceType: i % 2 == 0 ? DeviceType.mobile : DeviceType.web,
        deviceName: i % 2 == 0 ? 'iPhone 14' : 'Chrome',
        location: 'Cairo, Egypt',
        status: i == 0
            ? LoginStatus.success
            : (i == 1 ? LoginStatus.failed : LoginStatus.success),
        isCurrentSession: i == 0,
      ),
    );

    // Create more activities for pagination
    tMoreActivities = List.generate(
      10,
      (i) => LoginActivityEntity(
        id: 'activity-${20 + i}',
        userId: tUserId,
        timestamp: now.subtract(Duration(hours: 20 + i)),
        ipAddress: '192.168.2.$i',
        deviceType: DeviceType.mobile,
        status: LoginStatus.success,
      ),
    );

    cubit = LoginActivityCubit(
      getLoginActivity: mockGetLoginActivityUseCase,
      getAllLoginActivity: mockGetAllLoginActivityUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('LoginActivityCubit -', () {
    test('initial state should be LoginActivityInitial', () {
      expect(cubit.state, equals(const LoginActivityInitial()));
    });

    group('loadLoginActivity -', () {
      blocTest<LoginActivityCubit, LoginActivityState>(
        'should emit [Loading, Loaded] when successful with full page',
        build: () {
          when(
            () => mockGetLoginActivityUseCase(tUserId, limit: 20, offset: 0),
          ).thenAnswer((_) async => Right(tActivities));
          return cubit;
        },
        act: (cubit) => cubit.loadLoginActivity(tUserId),
        expect: () => [
          const LoginActivityLoading(),
          LoginActivityLoaded(activities: tActivities, hasMore: true),
        ],
        verify: (_) {
          verify(
            () => mockGetLoginActivityUseCase(tUserId, limit: 20, offset: 0),
          ).called(1);
        },
      );

      blocTest<LoginActivityCubit, LoginActivityState>(
        'should emit Loaded with hasMore=false when partial page returned',
        build: () {
          final partialList = tActivities.take(10).toList();
          when(
            () => mockGetLoginActivityUseCase(tUserId, limit: 20, offset: 0),
          ).thenAnswer((_) async => Right(partialList));
          return cubit;
        },
        act: (cubit) => cubit.loadLoginActivity(tUserId),
        expect: () => [
          const LoginActivityLoading(),
          isA<LoginActivityLoaded>()
              .having((s) => s.hasMore, 'hasMore', false)
              .having((s) => s.activities.length, 'activities.length', 10),
        ],
      );

      blocTest<LoginActivityCubit, LoginActivityState>(
        'should emit [Loading, Error] when failure occurs',
        build: () {
          when(
            () => mockGetLoginActivityUseCase(tUserId, limit: 20, offset: 0),
          ).thenAnswer(
            (_) async =>
                const Left(ServerFailure('Failed to load login activity')),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadLoginActivity(tUserId),
        expect: () => [
          const LoginActivityLoading(),
          const LoginActivityError('Failed to load login activity'),
        ],
      );

      blocTest<LoginActivityCubit, LoginActivityState>(
        'should emit Loaded with empty list when no activity',
        build: () {
          when(
            () => mockGetLoginActivityUseCase(tUserId, limit: 20, offset: 0),
          ).thenAnswer((_) async => const Right([]));
          return cubit;
        },
        act: (cubit) => cubit.loadLoginActivity(tUserId),
        expect: () => [
          const LoginActivityLoading(),
          const LoginActivityLoaded(activities: [], hasMore: false),
        ],
      );
    });

    group('loadAllLoginActivity -', () {
      blocTest<LoginActivityCubit, LoginActivityState>(
        'should emit [Loading, Loaded] when successful (super admin)',
        build: () {
          when(
            () => mockGetAllLoginActivityUseCase(
              limit: 20,
              offset: 0,
              statusFilter: null,
            ),
          ).thenAnswer((_) async => Right(tActivities));
          return cubit;
        },
        act: (cubit) => cubit.loadAllLoginActivity(),
        expect: () => [
          const LoginActivityLoading(),
          LoginActivityLoaded(activities: tActivities, hasMore: true),
        ],
        verify: (_) {
          verify(
            () => mockGetAllLoginActivityUseCase(
              limit: 20,
              offset: 0,
              statusFilter: null,
            ),
          ).called(1);
        },
      );

      blocTest<LoginActivityCubit, LoginActivityState>(
        'should pass status filter when provided',
        build: () {
          when(
            () => mockGetAllLoginActivityUseCase(
              limit: 20,
              offset: 0,
              statusFilter: 'failed',
            ),
          ).thenAnswer((_) async => Right([tActivities[1]]));
          return cubit;
        },
        act: (cubit) => cubit.loadAllLoginActivity(statusFilter: 'failed'),
        verify: (_) {
          verify(
            () => mockGetAllLoginActivityUseCase(
              limit: 20,
              offset: 0,
              statusFilter: 'failed',
            ),
          ).called(1);
        },
      );

      blocTest<LoginActivityCubit, LoginActivityState>(
        'should emit Error when failure occurs',
        build: () {
          when(
            () => mockGetAllLoginActivityUseCase(
              limit: 20,
              offset: 0,
              statusFilter: null,
            ),
          ).thenAnswer(
            (_) async => const Left(ServerFailure('Unauthorized access')),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadAllLoginActivity(),
        expect: () => [
          const LoginActivityLoading(),
          const LoginActivityError('Unauthorized access'),
        ],
      );
    });

    group('loadMore -', () {
      blocTest<LoginActivityCubit, LoginActivityState>(
        'should append new activities when loadMore is called (user)',
        build: () {
          when(
            () => mockGetLoginActivityUseCase(tUserId, limit: 20, offset: 0),
          ).thenAnswer((_) async => Right(tActivities));
          when(
            () => mockGetLoginActivityUseCase(tUserId, limit: 20, offset: 20),
          ).thenAnswer((_) async => Right(tMoreActivities));
          return cubit;
        },
        act: (cubit) async {
          await cubit.loadLoginActivity(tUserId);
          await cubit.loadMore();
        },
        expect: () => [
          const LoginActivityLoading(),
          LoginActivityLoaded(activities: tActivities, hasMore: true),
          LoginActivityLoaded(
            activities: tActivities,
            hasMore: true,
            isLoadingMore: true,
          ),
          LoginActivityLoaded(
            activities: [...tActivities, ...tMoreActivities],
            hasMore: false, // Less than page size
            isLoadingMore: false,
          ),
        ],
      );

      blocTest<LoginActivityCubit, LoginActivityState>(
        'should not load more when hasMore is false',
        build: () {
          when(
            () => mockGetLoginActivityUseCase(tUserId, limit: 20, offset: 0),
          ).thenAnswer((_) async => Right(tMoreActivities)); // Less than 20
          return cubit;
        },
        act: (cubit) async {
          await cubit.loadLoginActivity(tUserId);
          await cubit.loadMore(); // Should not trigger
        },
        expect: () => [
          const LoginActivityLoading(),
          LoginActivityLoaded(activities: tMoreActivities, hasMore: false),
          // No more states - loadMore was skipped
        ],
      );

      blocTest<LoginActivityCubit, LoginActivityState>(
        'should not load more when already loading more',
        build: () {
          return cubit;
        },
        seed: () => LoginActivityLoaded(
          activities: tActivities,
          hasMore: true,
          isLoadingMore: true,
        ),
        act: (cubit) => cubit.loadMore(),
        expect: () => [], // No state changes
      );

      blocTest<LoginActivityCubit, LoginActivityState>(
        'should not load more when state is not Loaded',
        build: () => cubit,
        act: (cubit) => cubit.loadMore(),
        expect: () => [], // No state changes
      );

      blocTest<LoginActivityCubit, LoginActivityState>(
        'should handle loadMore failure gracefully',
        build: () {
          when(
            () => mockGetLoginActivityUseCase(tUserId, limit: 20, offset: 0),
          ).thenAnswer((_) async => Right(tActivities));
          when(
            () => mockGetLoginActivityUseCase(tUserId, limit: 20, offset: 20),
          ).thenAnswer(
            (_) async => const Left(NetworkFailure('Connection lost')),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.loadLoginActivity(tUserId);
          await cubit.loadMore();
        },
        expect: () => [
          const LoginActivityLoading(),
          LoginActivityLoaded(activities: tActivities, hasMore: true),
          LoginActivityLoaded(
            activities: tActivities,
            hasMore: true,
            isLoadingMore: true,
          ),
          // Should revert to loaded state without new data
          LoginActivityLoaded(
            activities: tActivities,
            hasMore: true,
            isLoadingMore: false,
          ),
        ],
      );

      blocTest<LoginActivityCubit, LoginActivityState>(
        'should load more for super admin view',
        build: () {
          when(
            () => mockGetAllLoginActivityUseCase(
              limit: 20,
              offset: 0,
              statusFilter: null,
            ),
          ).thenAnswer((_) async => Right(tActivities));
          when(
            () => mockGetAllLoginActivityUseCase(
              limit: 20,
              offset: 20,
              statusFilter: null,
            ),
          ).thenAnswer((_) async => Right(tMoreActivities));
          return cubit;
        },
        act: (cubit) async {
          await cubit.loadAllLoginActivity();
          await cubit.loadMore();
        },
        expect: () => [
          const LoginActivityLoading(),
          LoginActivityLoaded(activities: tActivities, hasMore: true),
          LoginActivityLoaded(
            activities: tActivities,
            hasMore: true,
            isLoadingMore: true,
          ),
          LoginActivityLoaded(
            activities: [...tActivities, ...tMoreActivities],
            hasMore: false,
            isLoadingMore: false,
          ),
        ],
      );
    });

    group('refresh -', () {
      blocTest<LoginActivityCubit, LoginActivityState>(
        'should refresh user activity when userId is set',
        build: () {
          when(
            () => mockGetLoginActivityUseCase(tUserId, limit: 20, offset: 0),
          ).thenAnswer((_) async => Right(tActivities));
          return cubit;
        },
        act: (cubit) async {
          await cubit.loadLoginActivity(tUserId);
          await cubit.refresh();
        },
        verify: (_) {
          // Called twice - initial load and refresh
          verify(
            () => mockGetLoginActivityUseCase(tUserId, limit: 20, offset: 0),
          ).called(2);
        },
      );

      blocTest<LoginActivityCubit, LoginActivityState>(
        'should refresh all activity when super admin view was used',
        build: () {
          when(
            () => mockGetAllLoginActivityUseCase(
              limit: 20,
              offset: 0,
              statusFilter: null,
            ),
          ).thenAnswer((_) async => Right(tActivities));
          return cubit;
        },
        act: (cubit) async {
          await cubit.loadAllLoginActivity();
          await cubit.refresh();
        },
        verify: (_) {
          // Called twice - initial load and refresh
          verify(
            () => mockGetAllLoginActivityUseCase(
              limit: 20,
              offset: 0,
              statusFilter: null,
            ),
          ).called(2);
        },
      );

      blocTest<LoginActivityCubit, LoginActivityState>(
        'should do nothing when no previous load was done',
        build: () => cubit,
        act: (cubit) => cubit.refresh(),
        expect: () => [], // No state changes
      );
    });
  });

  group('LoginActivityLoaded -', () {
    test('copyWith creates new instance with updated values', () {
      final original = LoginActivityLoaded(
        activities: tActivities,
        hasMore: true,
        isLoadingMore: false,
      );

      final withLoadingMore = original.copyWith(isLoadingMore: true);
      expect(withLoadingMore.isLoadingMore, isTrue);
      expect(withLoadingMore.activities, equals(tActivities));

      final withNoMore = original.copyWith(hasMore: false);
      expect(withNoMore.hasMore, isFalse);

      final withNewActivities = original.copyWith(activities: tMoreActivities);
      expect(withNewActivities.activities, equals(tMoreActivities));
    });

    test('props includes all fields for equality', () {
      final state1 = LoginActivityLoaded(
        activities: tActivities,
        hasMore: true,
        isLoadingMore: false,
      );
      final state2 = LoginActivityLoaded(
        activities: tActivities,
        hasMore: true,
        isLoadingMore: false,
      );
      final state3 = LoginActivityLoaded(
        activities: tActivities,
        hasMore: true,
        isLoadingMore: true,
      );

      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });
  });

  group('LoginActivityError -', () {
    test('props includes message', () {
      const error1 = LoginActivityError('Error 1');
      const error2 = LoginActivityError('Error 1');
      const error3 = LoginActivityError('Error 2');

      expect(error1, equals(error2));
      expect(error1, isNot(equals(error3)));
    });
  });

  group('LoginActivityEntity -', () {
    test('entity equality works correctly', () {
      final entity1 = LoginActivityEntity(
        id: 'test-1',
        userId: 'user-1',
        timestamp: now,
        status: LoginStatus.success,
      );
      final entity2 = LoginActivityEntity(
        id: 'test-1',
        userId: 'user-1',
        timestamp: now,
        status: LoginStatus.success,
      );
      final entity3 = LoginActivityEntity(
        id: 'test-2',
        userId: 'user-1',
        timestamp: now,
        status: LoginStatus.success,
      );

      expect(entity1, equals(entity2));
      expect(entity1, isNot(equals(entity3)));
    });

    test('copyWith creates correct copies', () {
      final original = LoginActivityEntity(
        id: 'test-1',
        userId: 'user-1',
        timestamp: now,
        status: LoginStatus.success,
        deviceType: DeviceType.mobile,
      );

      final withNewStatus = original.copyWith(status: LoginStatus.failed);
      expect(withNewStatus.status, equals(LoginStatus.failed));
      expect(withNewStatus.id, equals('test-1'));
    });
  });

  group('LoginStatus -', () {
    test('displayName returns correct value', () {
      expect(LoginStatus.success.displayName, equals('Success'));
      expect(LoginStatus.failed.displayName, equals('Failed'));
      expect(LoginStatus.blocked.displayName, equals('Blocked'));
    });

    test('fromString parses correctly', () {
      expect(LoginStatus.fromString('success'), equals(LoginStatus.success));
      expect(LoginStatus.fromString('FAILED'), equals(LoginStatus.failed));
      expect(LoginStatus.fromString('blocked'), equals(LoginStatus.blocked));
      expect(LoginStatus.fromString('unknown'), equals(LoginStatus.success));
      expect(LoginStatus.fromString(null), equals(LoginStatus.success));
    });
  });

  group('DeviceType -', () {
    test('displayName returns correct value', () {
      expect(DeviceType.mobile.displayName, equals('Mobile'));
      expect(DeviceType.web.displayName, equals('Web'));
      expect(DeviceType.desktop.displayName, equals('Desktop'));
    });

    test('fromString parses correctly', () {
      expect(DeviceType.fromString('mobile'), equals(DeviceType.mobile));
      expect(DeviceType.fromString('WEB'), equals(DeviceType.web));
      expect(DeviceType.fromString('desktop'), equals(DeviceType.desktop));
      expect(DeviceType.fromString('unknown'), equals(DeviceType.mobile));
      expect(DeviceType.fromString(null), equals(DeviceType.mobile));
    });
  });
}
