import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/recurring_bookings/domain/repositories/recurring_booking_repository.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/get_reserved_slots_usecase.dart';

class MockRecurringBookingRepository extends Mock
    implements RecurringBookingRepository {}

void main() {
  late GetReservedSlotsUseCase useCase;
  late MockRecurringBookingRepository mockRepository;

  setUp(() {
    mockRepository = MockRecurringBookingRepository();
    useCase = GetReservedSlotsUseCase(mockRepository);
  });

  group('GetReservedSlotsUseCase', () {
    const tFieldId = 'field-123';
    const tParams = GetReservedSlotsParams(fieldId: tFieldId);

    final tReservedSlots = [
      ReservedSlot(
        dayOfWeek: 1,
        startTime: '14:00',
        endTime: '16:00',
        userName: 'Ahmed Hassan',
      ),
      ReservedSlot(
        dayOfWeek: 3,
        startTime: '18:00',
        endTime: '19:00',
        userName: 'Mohamed Ali',
      ),
      ReservedSlot(dayOfWeek: 5, startTime: '20:00', endTime: '22:00'),
    ];

    group('successful retrieval', () {
      test('should return list of reserved slots when call succeeds', () async {
        // Arrange
        when(
          () => mockRepository.getReservedSlots(fieldId: any(named: 'fieldId')),
        ).thenAnswer((_) async => Right(tReservedSlots));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(Right(tReservedSlots)));
        verify(
          () => mockRepository.getReservedSlots(fieldId: tFieldId),
        ).called(1);
      });

      test('should return empty list when no slots are reserved', () async {
        // Arrange
        when(
          () => mockRepository.getReservedSlots(fieldId: any(named: 'fieldId')),
        ).thenAnswer((_) async => const Right([]));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should return Right'),
          (slots) => expect(slots, isEmpty),
        );
      });

      test('should return slots for all days of the week', () async {
        // Arrange
        final slotsAllDays = List.generate(
          7,
          (index) => ReservedSlot(
            dayOfWeek: index,
            startTime: '14:00',
            endTime: '16:00',
          ),
        );

        when(
          () => mockRepository.getReservedSlots(fieldId: any(named: 'fieldId')),
        ).thenAnswer((_) async => Right(slotsAllDays));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return Right'), (slots) {
          expect(slots.length, 7);
          for (int i = 0; i < 7; i++) {
            expect(slots[i].dayOfWeek, i);
          }
        });
      });

      test('should return slots with user information', () async {
        // Arrange
        final slotsWithUserInfo = [
          ReservedSlot(
            dayOfWeek: 1,
            startTime: '10:00',
            endTime: '12:00',
            userName: 'Premium User',
          ),
        ];

        when(
          () => mockRepository.getReservedSlots(fieldId: any(named: 'fieldId')),
        ).thenAnswer((_) async => Right(slotsWithUserInfo));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return Right'), (slots) {
          expect(slots.first.userName, 'Premium User');
        });
      });

      test('should return slots without user information', () async {
        // Arrange
        final slotsWithoutUserInfo = [
          ReservedSlot(dayOfWeek: 2, startTime: '14:00', endTime: '15:00'),
        ];

        when(
          () => mockRepository.getReservedSlots(fieldId: any(named: 'fieldId')),
        ).thenAnswer((_) async => Right(slotsWithoutUserInfo));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return Right'), (slots) {
          expect(slots.first.userName, isNull);
        });
      });

      test('should return multiple slots on the same day', () async {
        // Arrange
        final multipleSlotsPerDay = [
          ReservedSlot(dayOfWeek: 1, startTime: '08:00', endTime: '10:00'),
          ReservedSlot(dayOfWeek: 1, startTime: '14:00', endTime: '16:00'),
          ReservedSlot(dayOfWeek: 1, startTime: '18:00', endTime: '20:00'),
        ];

        when(
          () => mockRepository.getReservedSlots(fieldId: any(named: 'fieldId')),
        ).thenAnswer((_) async => Right(multipleSlotsPerDay));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return Right'), (slots) {
          expect(slots.length, 3);
          expect(slots.every((s) => s.dayOfWeek == 1), true);
        });
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.getReservedSlots(fieldId: any(named: 'fieldId')),
        ).thenAnswer((_) async => Right(tReservedSlots));

        // Act
        await useCase(tParams);

        // Assert
        verify(
          () => mockRepository.getReservedSlots(fieldId: tFieldId),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle different field IDs', () async {
        final fieldIds = ['field-1', 'field-2', 'field-3'];

        for (final fieldId in fieldIds) {
          // Arrange
          final params = GetReservedSlotsParams(fieldId: fieldId);

          when(
            () =>
                mockRepository.getReservedSlots(fieldId: any(named: 'fieldId')),
          ).thenAnswer((_) async => Right(tReservedSlots));

          // Act
          final result = await useCase(params);

          // Assert
          expect(result.isRight(), true);
        }
      });

      test('should handle UUID format field IDs', () async {
        // Arrange
        const uuidFieldId = '550e8400-e29b-41d4-a716-446655440000';
        const params = GetReservedSlotsParams(fieldId: uuidFieldId);

        when(
          () => mockRepository.getReservedSlots(fieldId: any(named: 'fieldId')),
        ).thenAnswer((_) async => Right(tReservedSlots));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.getReservedSlots(fieldId: uuidFieldId),
        ).called(1);
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to fetch reserved slots');

        when(
          () => mockRepository.getReservedSlots(fieldId: any(named: 'fieldId')),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ValidationFailure when field not found', () async {
        // Arrange
        const tFailure = ValidationFailure('Field not found');

        when(
          () => mockRepository.getReservedSlots(fieldId: any(named: 'fieldId')),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure on network error', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');

        when(
          () => mockRepository.getReservedSlots(fieldId: any(named: 'fieldId')),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });

    group('GetReservedSlotsParams', () {
      test('should support equality', () {
        const params1 = GetReservedSlotsParams(fieldId: tFieldId);
        const params2 = GetReservedSlotsParams(fieldId: tFieldId);

        expect(params1, equals(params2));
      });

      test('should have correct props', () {
        expect(tParams.props, [tFieldId]);
      });

      test('should not be equal with different values', () {
        const params1 = GetReservedSlotsParams(fieldId: tFieldId);
        const params2 = GetReservedSlotsParams(fieldId: 'different-field');

        expect(params1, isNot(equals(params2)));
      });
    });

    group('ReservedSlot', () {
      test('should have correct properties', () {
        const slot = ReservedSlot(
          dayOfWeek: 1,
          startTime: '14:00',
          endTime: '16:00',
          userName: 'Test User',
        );

        expect(slot.dayOfWeek, 1);
        expect(slot.startTime, '14:00');
        expect(slot.endTime, '16:00');
        expect(slot.userName, 'Test User');
      });

      test('should allow null userName', () {
        const slot = ReservedSlot(
          dayOfWeek: 2,
          startTime: '10:00',
          endTime: '11:00',
        );

        expect(slot.userName, isNull);
      });
    });
  });
}
