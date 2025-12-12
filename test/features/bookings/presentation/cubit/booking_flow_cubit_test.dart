import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/domain/usecases/create_booking_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/get_available_time_slots_usecase.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_flow_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_flow_state.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';

// Mock Use Cases
class MockGetAvailableTimeSlotsUseCase extends Mock
    implements GetAvailableTimeSlotsUseCase {}

class MockCreateBookingUseCase extends Mock implements CreateBookingUseCase {}

void main() {
  late BookingFlowCubit cubit;
  late MockGetAvailableTimeSlotsUseCase mockGetTimeSlots;
  late MockCreateBookingUseCase mockCreateBooking;

  // Test data
  final testField = FieldEntity(
    id: 'field-1',
    name: 'Test Field',
    ownerId: 'owner-1',
    sportCategoryId: 'sport-1',
    city: 'Cairo',
    address: '123 Test St',
    pricePerHour: 100,
    isActive: true,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  final testSlot = TimeSlotEntity(
    startTime: '10:00',
    endTime: '11:00',
    isAvailable: true,
    price: 100,
    currency: 'EGP',
    isNextDay: false,
  );

  final testSlot2 = TimeSlotEntity(
    startTime: '11:00',
    endTime: '12:00',
    isAvailable: true,
    price: 100,
    currency: 'EGP',
    isNextDay: false,
  );

  final unavailableSlot = TimeSlotEntity(
    startTime: '14:00',
    endTime: '15:00',
    isAvailable: false,
    price: 100,
    currency: 'EGP',
    isNextDay: false,
  );

  final testBooking = BookingEntity(
    id: 'booking-1',
    userId: 'user-1',
    fieldId: 'field-1',
    date: DateTime.now(),
    startTime: '10:00',
    endTime: '11:00',
    totalPrice: 100,
    currency: 'EGP',
    status: BookingStatus.pending,
    createdAt: DateTime.now(),
  );

  setUp(() {
    mockGetTimeSlots = MockGetAvailableTimeSlotsUseCase();
    mockCreateBooking = MockCreateBookingUseCase();

    cubit = BookingFlowCubit(
      getAvailableTimeSlotsUseCase: mockGetTimeSlots,
      createBookingUseCase: mockCreateBooking,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('BookingFlowCubit', () {
    test('initial state is BookingFlowInitial', () {
      expect(cubit.state, const BookingFlowInitial());
    });
  });

  group('initializeFlow', () {
    blocTest<BookingFlowCubit, BookingFlowState>(
      'emits BookingFlowActive with isLoadingSlots=true, then loads slots',
      build: () {
        when(
          () => mockGetTimeSlots(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
          ),
        ).thenAnswer((_) async => Right([testSlot, testSlot2]));
        return cubit;
      },
      act: (cubit) => cubit.initializeFlow(testField),
      expect: () => [
        isA<BookingFlowActive>()
            .having((s) => s.fieldId, 'fieldId', 'field-1')
            .having((s) => s.fieldName, 'fieldName', 'Test Field')
            .having((s) => s.pricePerHour, 'pricePerHour', 100)
            .having((s) => s.isLoadingSlots, 'isLoadingSlots', true)
            .having((s) => s.selectedDuration, 'selectedDuration', 1),
        isA<BookingFlowActive>()
            .having((s) => s.isLoadingSlots, 'isLoadingSlots', false)
            .having((s) => s.slotsByPeriod.isNotEmpty, 'hasSlots', true),
      ],
    );

    blocTest<BookingFlowCubit, BookingFlowState>(
      'handles error when loading time slots fails',
      build: () {
        when(
          () => mockGetTimeSlots(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
          ),
        ).thenAnswer((_) async => const Left(ServerFailure('Network error')));
        return cubit;
      },
      act: (cubit) => cubit.initializeFlow(testField),
      expect: () => [
        isA<BookingFlowActive>().having(
          (s) => s.isLoadingSlots,
          'isLoadingSlots',
          true,
        ),
        isA<BookingFlowActive>()
            .having((s) => s.isLoadingSlots, 'isLoadingSlots', false)
            .having((s) => s.slotsError, 'error', 'Network error'),
      ],
    );
  });

  group('selectDate', () {
    final initialState = BookingFlowActive(
      currentStep: BookingFlowStep.selectDate,
      fieldId: 'field-1',
      fieldName: 'Test Field',
      pricePerHour: 100,
      selectedDate: DateTime(2024, 12, 15),
    );

    blocTest<BookingFlowCubit, BookingFlowState>(
      'updates selected date and reloads slots',
      build: () {
        when(
          () => mockGetTimeSlots(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
          ),
        ).thenAnswer((_) async => Right([testSlot]));
        return cubit;
      },
      seed: () => initialState,
      act: (cubit) => cubit.selectDate(DateTime(2024, 12, 20)),
      expect: () => [
        isA<BookingFlowActive>()
            .having(
              (s) => s.selectedDate,
              'selectedDate',
              DateTime(2024, 12, 20),
            )
            .having((s) => s.isLoadingSlots, 'isLoadingSlots', true),
        isA<BookingFlowActive>().having(
          (s) => s.isLoadingSlots,
          'isLoadingSlots',
          false,
        ),
      ],
    );
  });

  group('selectDuration', () {
    final stateWithSlot = BookingFlowActive(
      currentStep: BookingFlowStep.selectTime,
      fieldId: 'field-1',
      fieldName: 'Test Field',
      pricePerHour: 100,
      selectedDate: DateTime(2024, 12, 15),
      selectedTimeSlot: testSlot,
    );

    blocTest<BookingFlowCubit, BookingFlowState>(
      'updates duration and clears selected time slot',
      build: () => cubit,
      seed: () => stateWithSlot,
      act: (cubit) => cubit.selectDuration(2),
      expect: () => [
        isA<BookingFlowActive>()
            .having((s) => s.selectedDuration, 'selectedDuration', 2)
            .having((s) => s.selectedTimeSlot, 'selectedTimeSlot', isNull),
      ],
    );

    blocTest<BookingFlowCubit, BookingFlowState>(
      'ignores invalid duration values',
      build: () => cubit,
      seed: () => stateWithSlot,
      act: (cubit) => cubit.selectDuration(3),
      expect: () => [],
    );
  });

  group('selectTimeSlot', () {
    final activeState = BookingFlowActive(
      currentStep: BookingFlowStep.selectTime,
      fieldId: 'field-1',
      fieldName: 'Test Field',
      pricePerHour: 100,
      selectedDate: DateTime(2024, 12, 15),
      slotsByPeriod: {
        'Morning': [testSlot, testSlot2],
      },
      selectedDuration: 1,
    );

    blocTest<BookingFlowCubit, BookingFlowState>(
      'selects time slot for 1-hour booking',
      build: () => cubit,
      seed: () => activeState,
      act: (cubit) => cubit.selectTimeSlot(testSlot),
      expect: () => [
        isA<BookingFlowActive>().having(
          (s) => s.selectedTimeSlot,
          'selectedTimeSlot',
          testSlot,
        ),
      ],
    );

    blocTest<BookingFlowCubit, BookingFlowState>(
      'selects time slot with consecutive slot for 2-hour booking',
      build: () => cubit,
      seed: () => activeState.copyWith(selectedDuration: 2),
      act: (cubit) => cubit.selectTimeSlot(testSlot),
      expect: () => [
        isA<BookingFlowActive>()
            .having((s) => s.selectedTimeSlot, 'selectedTimeSlot', testSlot)
            .having((s) => s.secondTimeSlot, 'secondTimeSlot', testSlot2),
      ],
    );
  });

  group('step navigation', () {
    final dateStepState = BookingFlowActive(
      currentStep: BookingFlowStep.selectDate,
      fieldId: 'field-1',
      fieldName: 'Test Field',
      pricePerHour: 100,
      selectedDate: DateTime(2024, 12, 15),
    );

    final timeStepState = BookingFlowActive(
      currentStep: BookingFlowStep.selectTime,
      fieldId: 'field-1',
      fieldName: 'Test Field',
      pricePerHour: 100,
      selectedDate: DateTime(2024, 12, 15),
      selectedTimeSlot: testSlot,
    );

    blocTest<BookingFlowCubit, BookingFlowState>(
      'nextStep moves from selectDate to selectTime',
      build: () => cubit,
      seed: () => dateStepState,
      act: (cubit) => cubit.nextStep(),
      expect: () => [
        isA<BookingFlowActive>().having(
          (s) => s.currentStep,
          'currentStep',
          BookingFlowStep.selectTime,
        ),
      ],
    );

    blocTest<BookingFlowCubit, BookingFlowState>(
      'nextStep moves from selectTime to confirm when slot selected',
      build: () => cubit,
      seed: () => timeStepState,
      act: (cubit) => cubit.nextStep(),
      expect: () => [
        isA<BookingFlowActive>().having(
          (s) => s.currentStep,
          'currentStep',
          BookingFlowStep.confirm,
        ),
      ],
    );

    blocTest<BookingFlowCubit, BookingFlowState>(
      'previousStep moves from selectTime to selectDate',
      build: () => cubit,
      seed: () => timeStepState,
      act: (cubit) => cubit.previousStep(),
      expect: () => [
        isA<BookingFlowActive>().having(
          (s) => s.currentStep,
          'currentStep',
          BookingFlowStep.selectDate,
        ),
      ],
    );

    blocTest<BookingFlowCubit, BookingFlowState>(
      'goToStep can go back but not forward',
      build: () => cubit,
      seed: () => timeStepState,
      act: (cubit) => cubit.goToStep(BookingFlowStep.selectDate),
      expect: () => [
        isA<BookingFlowActive>().having(
          (s) => s.currentStep,
          'currentStep',
          BookingFlowStep.selectDate,
        ),
      ],
    );

    blocTest<BookingFlowCubit, BookingFlowState>(
      'goToStep does nothing when trying to go forward',
      build: () => cubit,
      seed: () => dateStepState,
      act: (cubit) => cubit.goToStep(BookingFlowStep.confirm),
      expect: () => [],
    );
  });

  group('submitBooking', () {
    final confirmState = BookingFlowActive(
      currentStep: BookingFlowStep.confirm,
      fieldId: 'field-1',
      fieldName: 'Test Field',
      pricePerHour: 100,
      selectedDate: DateTime(2024, 12, 15),
      selectedTimeSlot: testSlot,
      selectedDuration: 1,
    );

    blocTest<BookingFlowCubit, BookingFlowState>(
      'emits [Submitting, Success] on successful booking',
      build: () {
        when(
          () => mockCreateBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            notes: any(named: 'notes'),
            durationHours: any(named: 'durationHours'),
          ),
        ).thenAnswer((_) async => Right(testBooking));
        return cubit;
      },
      seed: () => confirmState,
      act: (cubit) => cubit.submitBooking(notes: 'Test notes'),
      expect: () => [
        isA<BookingFlowSubmitting>(),
        isA<BookingFlowSuccess>().having(
          (s) => s.booking.id,
          'bookingId',
          'booking-1',
        ),
      ],
    );

    blocTest<BookingFlowCubit, BookingFlowState>(
      'emits [Submitting, Error] on failed booking',
      build: () {
        when(
          () => mockCreateBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            notes: any(named: 'notes'),
            durationHours: any(named: 'durationHours'),
          ),
        ).thenAnswer(
          (_) async => const Left(ServerFailure('Slot already booked')),
        );
        return cubit;
      },
      seed: () => confirmState,
      act: (cubit) => cubit.submitBooking(),
      expect: () => [
        isA<BookingFlowSubmitting>(),
        isA<BookingFlowError>().having(
          (s) => s.message,
          'message',
          'Slot already booked',
        ),
      ],
    );
  });

  group('retryFromError', () {
    final errorState = BookingFlowError(
      message: 'Booking failed',
      previousState: BookingFlowActive(
        currentStep: BookingFlowStep.confirm,
        fieldId: 'field-1',
        fieldName: 'Test Field',
        pricePerHour: 100,
        selectedDate: DateTime(2024, 12, 15),
        selectedTimeSlot: testSlot,
      ),
    );

    blocTest<BookingFlowCubit, BookingFlowState>(
      'restores previous state on retry',
      build: () => cubit,
      seed: () => errorState,
      act: (cubit) => cubit.retryFromError(),
      expect: () => [isA<BookingFlowActive>()],
    );
  });

  group('reset', () {
    final activeState = BookingFlowActive(
      currentStep: BookingFlowStep.confirm,
      fieldId: 'field-1',
      fieldName: 'Test Field',
      pricePerHour: 100,
      selectedDate: DateTime(2024, 12, 15),
    );

    blocTest<BookingFlowCubit, BookingFlowState>(
      'resets to initial state',
      build: () => cubit,
      seed: () => activeState,
      act: (cubit) => cubit.reset(),
      expect: () => [const BookingFlowInitial()],
    );
  });

  group('BookingFlowActive computed properties', () {
    test('totalPrice calculates correctly for 1-hour booking', () {
      final state = BookingFlowActive(
        currentStep: BookingFlowStep.confirm,
        fieldId: 'field-1',
        fieldName: 'Test Field',
        pricePerHour: 100,
        selectedDate: DateTime(2024, 12, 15),
        selectedDuration: 1,
      );
      expect(state.totalPrice, 100);
    });

    test('totalPrice calculates correctly for 2-hour booking', () {
      final state = BookingFlowActive(
        currentStep: BookingFlowStep.confirm,
        fieldId: 'field-1',
        fieldName: 'Test Field',
        pricePerHour: 100,
        selectedDate: DateTime(2024, 12, 15),
        selectedDuration: 2,
      );
      expect(state.totalPrice, 200);
    });

    test('canProceed is true on selectDate step', () {
      final state = BookingFlowActive(
        currentStep: BookingFlowStep.selectDate,
        fieldId: 'field-1',
        fieldName: 'Test Field',
        pricePerHour: 100,
        selectedDate: DateTime(2024, 12, 15),
      );
      expect(state.canProceed, isTrue);
    });

    test('canProceed is false on selectTime step without slot', () {
      final state = BookingFlowActive(
        currentStep: BookingFlowStep.selectTime,
        fieldId: 'field-1',
        fieldName: 'Test Field',
        pricePerHour: 100,
        selectedDate: DateTime(2024, 12, 15),
      );
      expect(state.canProceed, isFalse);
    });

    test('progress calculates correctly for each step', () {
      expect(
        BookingFlowActive(
          currentStep: BookingFlowStep.selectDate,
          fieldId: 'f',
          fieldName: 'f',
          pricePerHour: 100,
          selectedDate: DateTime.now(),
        ).progress,
        closeTo(0.33, 0.01),
      );
    });
  });
}
