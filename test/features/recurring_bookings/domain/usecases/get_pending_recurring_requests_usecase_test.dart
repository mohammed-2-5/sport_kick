import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/recurring_bookings/domain/entities/recurring_booking_entity.dart';
import 'package:spo_kick/features/recurring_bookings/domain/repositories/recurring_booking_repository.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/get_pending_recurring_requests_usecase.dart';

class MockRecurringBookingRepository extends Mock
    implements RecurringBookingRepository {}

void main() {
  late GetPendingRecurringRequestsUseCase useCase;
  late MockRecurringBookingRepository mockRepository;

  setUp(() {
    mockRepository = MockRecurringBookingRepository();
    useCase = GetPendingRecurringRequestsUseCase(mockRepository);
  });

  group('GetPendingRecurringRequestsUseCase', () {
    final tPendingRequests = [
      RecurringBookingEntity(
        id: 'pending-1',
        fieldId: 'field-1',
        fieldName: 'Field A',
        dayOfWeek: 1,
        startTime: '14:00',
        endTime: '16:00',
        durationHours: 2,
        pricePerBooking: 150.0,
        status: RecurringBookingStatus.pendingApproval,
        createdAt: DateTime(2026, 1, 1),
        userId: 'user-1',
        userName: 'Ahmed Hassan',
        userEmail: 'ahmed@example.com',
        userPhone: '+201234567890',
      ),
      RecurringBookingEntity(
        id: 'pending-2',
        fieldId: 'field-2',
        fieldName: 'Field B',
        dayOfWeek: 3,
        startTime: '18:00',
        endTime: '19:00',
        durationHours: 1,
        pricePerBooking: 100.0,
        status: RecurringBookingStatus.pendingApproval,
        createdAt: DateTime(2026, 1, 2),
        userId: 'user-2',
        userName: 'Mohamed Ali',
        userEmail: 'mohamed@example.com',
      ),
    ];

    group('successful retrieval', () {
      test(
        'should return list of pending requests when call succeeds',
        () async {
          // Arrange
          when(
            () => mockRepository.getPendingRecurringRequests(),
          ).thenAnswer((_) async => Right(tPendingRequests));

          // Act
          final result = await useCase();

          // Assert
          expect(result, equals(Right(tPendingRequests)));
          verify(() => mockRepository.getPendingRecurringRequests()).called(1);
        },
      );

      test('should return empty list when no pending requests exist', () async {
        // Arrange
        when(
          () => mockRepository.getPendingRecurringRequests(),
        ).thenAnswer((_) async => const Right([]));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should return Right'),
          (requests) => expect(requests, isEmpty),
        );
      });

      test('should return requests with user information', () async {
        // Arrange
        final requestWithUserInfo = [
          RecurringBookingEntity(
            id: 'pending-1',
            fieldId: 'field-1',
            fieldName: 'Field A',
            dayOfWeek: 1,
            startTime: '14:00',
            endTime: '16:00',
            durationHours: 2,
            pricePerBooking: 150.0,
            status: RecurringBookingStatus.pendingApproval,
            createdAt: DateTime(2026, 1, 1),
            userId: 'user-1',
            userName: 'Ahmed Hassan',
            userEmail: 'ahmed@example.com',
            userPhone: '+201234567890',
            userAvatarUrl: 'https://example.com/avatar.jpg',
          ),
        ];

        when(
          () => mockRepository.getPendingRecurringRequests(),
        ).thenAnswer((_) async => Right(requestWithUserInfo));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return Right'), (requests) {
          final request = requests.first;
          expect(request.userId, 'user-1');
          expect(request.userName, 'Ahmed Hassan');
          expect(request.userEmail, 'ahmed@example.com');
          expect(request.userPhone, '+201234567890');
          expect(request.userAvatarUrl, isNotNull);
          expect(request.isPending, true);
        });
      });

      test('should return requests for multiple fields', () async {
        // Arrange
        final multiFieldRequests = [
          RecurringBookingEntity(
            id: 'pending-1',
            fieldId: 'field-1',
            fieldName: 'Field A',
            dayOfWeek: 1,
            startTime: '14:00',
            endTime: '16:00',
            durationHours: 2,
            pricePerBooking: 150.0,
            status: RecurringBookingStatus.pendingApproval,
            createdAt: DateTime(2026, 1, 1),
          ),
          RecurringBookingEntity(
            id: 'pending-2',
            fieldId: 'field-2',
            fieldName: 'Field B',
            dayOfWeek: 2,
            startTime: '10:00',
            endTime: '12:00',
            durationHours: 2,
            pricePerBooking: 200.0,
            status: RecurringBookingStatus.pendingApproval,
            createdAt: DateTime(2026, 1, 2),
          ),
          RecurringBookingEntity(
            id: 'pending-3',
            fieldId: 'field-3',
            fieldName: 'Field C',
            dayOfWeek: 3,
            startTime: '18:00',
            endTime: '20:00',
            durationHours: 2,
            pricePerBooking: 250.0,
            status: RecurringBookingStatus.pendingApproval,
            createdAt: DateTime(2026, 1, 3),
          ),
        ];

        when(
          () => mockRepository.getPendingRecurringRequests(),
        ).thenAnswer((_) async => Right(multiFieldRequests));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return Right'), (requests) {
          expect(requests.length, 3);
          expect(requests.map((r) => r.fieldId).toSet().length, 3);
        });
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.getPendingRecurringRequests(),
        ).thenAnswer((_) async => Right(tPendingRequests));

        // Act
        await useCase();

        // Assert
        verify(() => mockRepository.getPendingRecurringRequests()).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should return requests with all day of week values', () async {
        // Arrange
        final requestsAllDays = List.generate(
          7,
          (index) => RecurringBookingEntity(
            id: 'pending-$index',
            fieldId: 'field-1',
            fieldName: 'Field A',
            dayOfWeek: index,
            startTime: '14:00',
            endTime: '16:00',
            durationHours: 2,
            pricePerBooking: 150.0,
            status: RecurringBookingStatus.pendingApproval,
            createdAt: DateTime(2026, 1, 1),
          ),
        );

        when(
          () => mockRepository.getPendingRecurringRequests(),
        ).thenAnswer((_) async => Right(requestsAllDays));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return Right'), (requests) {
          expect(requests.length, 7);
          for (int i = 0; i < 7; i++) {
            expect(requests[i].dayOfWeek, i);
            expect(requests[i].dayName, isNotEmpty);
          }
        });
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to fetch pending requests');

        when(
          () => mockRepository.getPendingRecurringRequests(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when owner not authenticated', () async {
        // Arrange
        const tFailure = AuthFailure('Owner not authenticated');

        when(
          () => mockRepository.getPendingRecurringRequests(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when user is not an owner', () async {
        // Arrange
        const tFailure = AuthFailure('User is not a field owner');

        when(
          () => mockRepository.getPendingRecurringRequests(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure on network error', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');

        when(
          () => mockRepository.getPendingRecurringRequests(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
