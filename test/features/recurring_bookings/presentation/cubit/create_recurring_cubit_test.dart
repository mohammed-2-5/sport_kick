import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/recurring_bookings/domain/repositories/recurring_booking_repository.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/create_recurring_request_usecase.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/get_reserved_slots_usecase.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/cubit/create_recurring_cubit.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/cubit/create_recurring_state.dart';

// Mock Classes
class MockCreateRecurringRequestUseCase extends Mock
    implements CreateRecurringRequestUseCase {}

class MockGetReservedSlotsUseCase extends Mock
    implements GetReservedSlotsUseCase {}

void main() {
  late MockCreateRecurringRequestUseCase mockCreateRecurringRequestUseCase;
  late MockGetReservedSlotsUseCase mockGetReservedSlotsUseCase;

  // Test data
  final now = DateTime.now();
  late FieldEntity tField;
  late List<ReservedSlot> tReservedSlots;

  setUpAll(() {
    registerFallbackValue(
      const CreateRecurringRequestParams(
        fieldId: 'fallback-field-id',
        dayOfWeek: 0,
        startTime: '10:00',
        durationHours: 1,
      ),
    );
    registerFallbackValue(
      const GetReservedSlotsParams(fieldId: 'fallback-field-id'),
    );
  });

  setUp(() {
    mockCreateRecurringRequestUseCase = MockCreateRecurringRequestUseCase();
    mockGetReservedSlotsUseCase = MockGetReservedSlotsUseCase();

    tField = FieldEntity(
      id: 'field-1',
      name: 'Al-Ahly Stadium',
      sportCategoryId: 'sport-1',
      ownerId: 'owner-1',
      city: 'Cairo',
      address: '123 Stadium Street',
      pricePerHour: 200.0,
      currency: 'EGP',
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );

    tReservedSlots = [
      const ReservedSlot(
        dayOfWeek: 1, // Sunday
        startTime: '14:00',
        endTime: '16:00',
        userName: 'Ahmed Ali',
      ),
      const ReservedSlot(
        dayOfWeek: 3, // Tuesday
        startTime: '18:00',
        endTime: '20:00',
        userName: 'Mohamed Hassan',
      ),
      const ReservedSlot(
        dayOfWeek: 5, // Thursday
        startTime: '10:00',
        endTime: '12:00',
      ),
    ];
  });

  CreateRecurringCubit createCubit() {
    return CreateRecurringCubit(
      createRecurringRequestUseCase: mockCreateRecurringRequestUseCase,
      getReservedSlotsUseCase: mockGetReservedSlotsUseCase,
      field: tField,
    );
  }

  group('CreateRecurringCubit -', () {
    test('initial state should be CreateRecurringEditing with field', () async {
      when(
        () => mockGetReservedSlotsUseCase(any()),
      ).thenAnswer((_) async => const Right([]));

      final cubit = createCubit();
      // Wait for async constructor operations to complete
      await Future.delayed(const Duration(milliseconds: 100));

      expect(cubit.state, isA<CreateRecurringEditing>());
      final state = cubit.state as CreateRecurringEditing;
      expect(state.field, equals(tField));
      expect(state.selectedDayOfWeek, isNull);
      expect(state.selectedTime, isNull);
      expect(state.durationHours, equals(1));

      await cubit.close();
    });

    group('initialization - _loadReservedSlots -', () {
      test('should load reserved slots on creation', () async {
        when(
          () => mockGetReservedSlotsUseCase(any()),
        ).thenAnswer((_) async => Right(tReservedSlots));

        final cubit = createCubit();
        await Future.delayed(const Duration(milliseconds: 100));

        verify(
          () => mockGetReservedSlotsUseCase(
            const GetReservedSlotsParams(fieldId: 'field-1'),
          ),
        ).called(1);

        final state = cubit.state as CreateRecurringEditing;
        expect(state.reservedSlots, equals(tReservedSlots));
        expect(state.isLoadingSlots, isFalse);

        await cubit.close();
      });

      test('should handle reserved slots load failure gracefully', () async {
        when(() => mockGetReservedSlotsUseCase(any())).thenAnswer(
          (_) async =>
              const Left(ServerFailure('Failed to load reserved slots')),
        );

        final cubit = createCubit();
        await Future.delayed(const Duration(milliseconds: 100));

        expect(cubit.state, isA<CreateRecurringEditing>());
        final state = cubit.state as CreateRecurringEditing;
        expect(state.isLoadingSlots, isFalse);
        expect(state.reservedSlots, isEmpty);

        await cubit.close();
      });
    });

    group('selectDayOfWeek -', () {
      test('should update selectedDayOfWeek', () async {
        when(
          () => mockGetReservedSlotsUseCase(any()),
        ).thenAnswer((_) async => const Right([]));

        final cubit = createCubit();
        await Future.delayed(const Duration(milliseconds: 100));

        cubit.selectDayOfWeek(3); // Tuesday

        final state = cubit.state as CreateRecurringEditing;
        expect(state.selectedDayOfWeek, equals(3));

        await cubit.close();
      });

      test('should clear time when changing day', () async {
        when(
          () => mockGetReservedSlotsUseCase(any()),
        ).thenAnswer((_) async => const Right([]));

        final cubit = createCubit();
        await Future.delayed(const Duration(milliseconds: 100));

        cubit.selectDayOfWeek(1);
        cubit.selectTime('14:00');
        cubit.selectDayOfWeek(5); // Change day

        final state = cubit.state as CreateRecurringEditing;
        expect(state.selectedDayOfWeek, equals(5));
        expect(state.selectedTime, isNull);

        await cubit.close();
      });
    });

    group('selectTime -', () {
      test('should update selectedTime when slot is available', () async {
        when(
          () => mockGetReservedSlotsUseCase(any()),
        ).thenAnswer((_) async => const Right([]));

        final cubit = createCubit();
        await Future.delayed(const Duration(milliseconds: 100));

        cubit.selectDayOfWeek(2);
        cubit.selectTime('10:00');

        final state = cubit.state as CreateRecurringEditing;
        expect(state.selectedTime, equals('10:00'));

        await cubit.close();
      });

      test('should show error when slot is reserved', () async {
        when(
          () => mockGetReservedSlotsUseCase(any()),
        ).thenAnswer((_) async => Right(tReservedSlots));

        final cubit = createCubit();
        await Future.delayed(const Duration(milliseconds: 100));

        cubit.selectDayOfWeek(1); // Sunday - has reservation at 14:00-16:00
        cubit.selectTime('14:00');

        final state = cubit.state as CreateRecurringEditing;
        expect(state.errorMessage, isNotNull);
        expect(state.errorMessage, contains('reserved'));

        await cubit.close();
      });

      test('should allow selecting available slot on reserved day', () async {
        when(
          () => mockGetReservedSlotsUseCase(any()),
        ).thenAnswer((_) async => Right(tReservedSlots));

        final cubit = createCubit();
        await Future.delayed(const Duration(milliseconds: 100));

        cubit.selectDayOfWeek(1); // Sunday - reserved 14:00-16:00
        cubit.selectTime('10:00'); // Available slot

        final state = cubit.state as CreateRecurringEditing;
        expect(state.selectedTime, equals('10:00'));
        expect(state.errorMessage, isNull);

        await cubit.close();
      });
    });

    group('setDuration -', () {
      test('should update duration to 2 hours', () async {
        when(
          () => mockGetReservedSlotsUseCase(any()),
        ).thenAnswer((_) async => const Right([]));

        final cubit = createCubit();
        await Future.delayed(const Duration(milliseconds: 100));

        cubit.setDuration(2);

        final state = cubit.state as CreateRecurringEditing;
        expect(state.durationHours, equals(2));

        await cubit.close();
      });

      test('should ignore invalid duration values', () async {
        when(
          () => mockGetReservedSlotsUseCase(any()),
        ).thenAnswer((_) async => const Right([]));

        final cubit = createCubit();
        await Future.delayed(const Duration(milliseconds: 100));

        cubit.setDuration(3); // Invalid
        cubit.setDuration(0); // Invalid
        cubit.setDuration(-1); // Invalid

        final state = cubit.state as CreateRecurringEditing;
        expect(state.durationHours, equals(1)); // Still default

        await cubit.close();
      });
    });

    group('submit -', () {
      test('should emit Success when submission succeeds', () async {
        when(
          () => mockGetReservedSlotsUseCase(any()),
        ).thenAnswer((_) async => const Right([]));
        when(
          () => mockCreateRecurringRequestUseCase(any()),
        ).thenAnswer((_) async => const Right('recurring-booking-123'));

        final cubit = createCubit();
        await Future.delayed(const Duration(milliseconds: 100));

        cubit.selectDayOfWeek(2);
        cubit.selectTime('16:00');
        cubit.setDuration(2);
        await cubit.submit();

        expect(cubit.state, isA<CreateRecurringSuccess>());
        final state = cubit.state as CreateRecurringSuccess;
        expect(state.recurringBookingId, equals('recurring-booking-123'));

        verify(
          () => mockCreateRecurringRequestUseCase(
            const CreateRecurringRequestParams(
              fieldId: 'field-1',
              dayOfWeek: 2,
              startTime: '16:00',
              durationHours: 2,
            ),
          ),
        ).called(1);

        await cubit.close();
      });

      test('should emit Error when submission fails', () async {
        when(
          () => mockGetReservedSlotsUseCase(any()),
        ).thenAnswer((_) async => const Right([]));
        when(() => mockCreateRecurringRequestUseCase(any())).thenAnswer(
          (_) async => const Left(ServerFailure('Slot is no longer available')),
        );

        final cubit = createCubit();
        await Future.delayed(const Duration(milliseconds: 100));

        cubit.selectDayOfWeek(2);
        cubit.selectTime('16:00');
        await cubit.submit();

        expect(cubit.state, isA<CreateRecurringError>());
        final state = cubit.state as CreateRecurringError;
        expect(state.message, equals('Slot is no longer available'));

        await cubit.close();
      });

      test('should show validation error when form is incomplete', () async {
        when(
          () => mockGetReservedSlotsUseCase(any()),
        ).thenAnswer((_) async => const Right([]));

        final cubit = createCubit();
        await Future.delayed(const Duration(milliseconds: 100));

        cubit.selectDayOfWeek(2); // Day selected but no time
        await cubit.submit();

        expect(cubit.state, isA<CreateRecurringEditing>());
        final state = cubit.state as CreateRecurringEditing;
        expect(state.errorMessage, isNotNull);
        expect(state.errorMessage, contains('select'));

        await cubit.close();
      });

      test('should not submit when endTime would exceed 23:00', () async {
        when(
          () => mockGetReservedSlotsUseCase(any()),
        ).thenAnswer((_) async => const Right([]));

        final cubit = createCubit();
        await Future.delayed(const Duration(milliseconds: 100));

        cubit.selectDayOfWeek(2);
        cubit.selectTime('23:00');
        cubit.setDuration(2); // Would end at 25:00
        await cubit.submit();

        expect(cubit.state, isA<CreateRecurringEditing>());
        final state = cubit.state as CreateRecurringEditing;
        expect(state.errorMessage, isNotNull);

        await cubit.close();
      });
    });

    group('resetAfterError -', () {
      test(
        'should reset to editing state with field and reload slots',
        () async {
          when(
            () => mockGetReservedSlotsUseCase(any()),
          ).thenAnswer((_) async => Right(tReservedSlots));
          when(
            () => mockCreateRecurringRequestUseCase(any()),
          ).thenAnswer((_) async => const Left(ServerFailure('Test error')));

          final cubit = createCubit();
          await Future.delayed(const Duration(milliseconds: 100));

          // Get to error state
          cubit.selectDayOfWeek(2);
          cubit.selectTime('14:00');
          await cubit.submit();

          expect(cubit.state, isA<CreateRecurringError>());

          // Reset after error
          cubit.resetAfterError();
          await Future.delayed(const Duration(milliseconds: 100));

          expect(cubit.state, isA<CreateRecurringEditing>());
          final state = cubit.state as CreateRecurringEditing;
          expect(state.field, equals(tField));
          expect(state.reservedSlots, equals(tReservedSlots));

          await cubit.close();
        },
      );

      test('should do nothing when not in error state', () async {
        when(
          () => mockGetReservedSlotsUseCase(any()),
        ).thenAnswer((_) async => const Right([]));

        final cubit = createCubit();
        await Future.delayed(const Duration(milliseconds: 100));

        cubit.resetAfterError();

        expect(cubit.state, isA<CreateRecurringEditing>());

        await cubit.close();
      });
    });
  });

  group('CreateRecurringEditing -', () {
    test('pricePerBooking calculates correctly', () {
      final state = CreateRecurringEditing(field: tField, durationHours: 2);
      expect(state.pricePerBooking, equals(400.0)); // 200 * 2
    });

    test('endTime calculates correctly', () {
      final state = CreateRecurringEditing(
        field: tField,
        selectedTime: '14:00',
        durationHours: 2,
      );
      expect(state.endTime, equals('16:00'));
    });

    test('endTime returns null when exceeds 23:00', () {
      final state = CreateRecurringEditing(
        field: tField,
        selectedTime: '23:00',
        durationHours: 2,
      );
      expect(state.endTime, isNull);
    });

    test('endTime returns null when no time selected', () {
      final state = CreateRecurringEditing(field: tField);
      expect(state.endTime, isNull);
    });

    test('isValid returns true when all required fields are set', () {
      final validState = CreateRecurringEditing(
        field: tField,
        selectedDayOfWeek: 2,
        selectedTime: '14:00',
        durationHours: 1,
      );
      expect(validState.isValid, isTrue);

      final invalidState1 = CreateRecurringEditing(field: tField);
      expect(invalidState1.isValid, isFalse);

      final invalidState2 = CreateRecurringEditing(
        field: tField,
        selectedDayOfWeek: 2,
      );
      expect(invalidState2.isValid, isFalse);
    });

    test('isSlotReserved detects reserved slots correctly', () {
      final state = CreateRecurringEditing(
        field: tField,
        reservedSlots: tReservedSlots,
      );

      // Sunday 14:00-16:00 is reserved
      expect(state.isSlotReserved(1, '14:00'), isTrue);
      expect(state.isSlotReserved(1, '15:00'), isTrue);
      expect(state.isSlotReserved(1, '16:00'), isFalse); // After end time
      expect(state.isSlotReserved(1, '10:00'), isFalse);

      // Tuesday 18:00-20:00 is reserved
      expect(state.isSlotReserved(3, '18:00'), isTrue);
      expect(state.isSlotReserved(3, '19:00'), isTrue);
      expect(state.isSlotReserved(3, '20:00'), isFalse);

      // Monday has no reservations
      expect(state.isSlotReserved(2, '14:00'), isFalse);
    });

    test('selectedDayName returns correct day name', () {
      final saturday = CreateRecurringEditing(
        field: tField,
        selectedDayOfWeek: 0,
      );
      expect(saturday.selectedDayName, equals('Saturday'));

      final thursday = CreateRecurringEditing(
        field: tField,
        selectedDayOfWeek: 5,
      );
      expect(thursday.selectedDayName, equals('Thursday'));

      final noDay = CreateRecurringEditing(field: tField);
      expect(noDay.selectedDayName, equals(''));
    });

    test('copyWith creates correct copies', () {
      final original = CreateRecurringEditing(
        field: tField,
        selectedDayOfWeek: 2,
        selectedTime: '14:00',
        durationHours: 1,
        errorMessage: 'Error',
      );

      // Copy with new values
      final withNewDay = original.copyWith(selectedDayOfWeek: 5);
      expect(withNewDay.selectedDayOfWeek, equals(5));
      expect(withNewDay.selectedTime, equals('14:00'));

      // Clear time
      final withClearedTime = original.copyWith(clearTime: true);
      expect(withClearedTime.selectedTime, isNull);
      expect(withClearedTime.selectedDayOfWeek, equals(2));

      // Clear error
      final withClearedError = original.copyWith(clearError: true);
      expect(withClearedError.errorMessage, isNull);

      // Clear day
      final withClearedDay = original.copyWith(clearDayOfWeek: true);
      expect(withClearedDay.selectedDayOfWeek, isNull);
    });

    test('props returns all fields for equality', () {
      final state1 = CreateRecurringEditing(
        field: tField,
        selectedDayOfWeek: 2,
        selectedTime: '14:00',
      );
      final state2 = CreateRecurringEditing(
        field: tField,
        selectedDayOfWeek: 2,
        selectedTime: '14:00',
      );
      expect(state1, equals(state2));
    });
  });

  group('CreateRecurringSuccess -', () {
    test('props includes recurringBookingId', () {
      const success1 = CreateRecurringSuccess('id-1');
      const success2 = CreateRecurringSuccess('id-1');
      const success3 = CreateRecurringSuccess('id-2');

      expect(success1, equals(success2));
      expect(success1, isNot(equals(success3)));
    });
  });

  group('CreateRecurringError -', () {
    test('props includes message and field', () {
      final error1 = CreateRecurringError(message: 'Error', field: tField);
      final error2 = CreateRecurringError(message: 'Error', field: tField);
      final error3 = CreateRecurringError(
        message: 'Different Error',
        field: tField,
      );

      expect(error1, equals(error2));
      expect(error1, isNot(equals(error3)));
    });
  });
}
