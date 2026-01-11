import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/domain/usecases/get_available_time_slots_usecase.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/time_slots/time_slot_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/time_slots/time_slot_state.dart';

// Mock Use Case
class MockGetAvailableTimeSlotsUseCase extends Mock
    implements GetAvailableTimeSlotsUseCase {}

void main() {
  late TimeSlotCubit cubit;
  late MockGetAvailableTimeSlotsUseCase mockGetTimeSlots;

  // Test data
  final now = DateTime.now();
  final testDate = DateTime(now.year, now.month, now.day);
  const fieldId = 'field-1';
  const loadingMessage = 'Loading slots...';

  final testSlot = TimeSlotEntity(
    startTime: '10:00',
    endTime: '11:00',
    isAvailable: true,
    price: 100.0,
    currency: 'EGP',
  );

  setUp(() {
    mockGetTimeSlots = MockGetAvailableTimeSlotsUseCase();
    cubit = TimeSlotCubit(getAvailableTimeSlotsUseCase: mockGetTimeSlots);
  });

  tearDown(() {
    cubit.close();
  });

  group('TimeSlotCubit', () {
    test('initial state is TimeSlotInitial', () {
      expect(cubit.state, const TimeSlotInitial());
    });
  });

  group('startBookingFlow', () {
    blocTest<TimeSlotCubit, TimeSlotState>(
      'starts flow and loads slots successfully',
      build: () {
        when(
          () => mockGetTimeSlots(fieldId: fieldId, date: testDate),
        ).thenAnswer((_) async => Right([testSlot]));
        return cubit;
      },
      act: (cubit) => cubit.startBookingFlow(
        fieldId,
        initialDate: testDate,
        loadingMessage: loadingMessage,
      ),
      expect: () => [
        const TimeSlotLoading(message: loadingMessage),
        isA<TimeSlotsLoaded>()
            .having((s) => s.fieldId, 'fieldId', fieldId)
            .having((s) => s.timeSlots.length, 'count', 1),
      ],
      verify: (cubit) {
        expect(cubit.currentFieldId, fieldId);
        expect(cubit.selectedDate, testDate);
      },
    );
  });

  group('changeSelectedDate', () {
    final nextDay = testDate.add(const Duration(days: 1));

    blocTest<TimeSlotCubit, TimeSlotState>(
      'reloads slots for new date',
      build: () {
        when(
          () => mockGetTimeSlots(fieldId: fieldId, date: testDate),
        ).thenAnswer((_) async => Right([testSlot]));
        when(
          () => mockGetTimeSlots(fieldId: fieldId, date: nextDay),
        ).thenAnswer((_) async => Right([testSlot]));
        return cubit;
      },
      act: (cubit) async {
        // First set the field ID
        await cubit.startBookingFlow(
          fieldId,
          initialDate: testDate,
          loadingMessage: loadingMessage,
        );
        // Then change date
        await cubit.changeSelectedDate(nextDay, loadingMessage: loadingMessage);
      },
      expect: () => [
        const TimeSlotLoading(message: loadingMessage),
        isA<TimeSlotsLoaded>().having((s) => s.timeSlots.length, 'count', 1),
        const TimeSlotLoading(message: loadingMessage),
        isA<TimeSlotsLoaded>().having((s) => s.selectedDate, 'date', nextDay),
      ],
    );

    blocTest<TimeSlotCubit, TimeSlotState>(
      'emits Error if fieldId is null',
      build: () => cubit,
      act: (cubit) =>
          cubit.changeSelectedDate(nextDay, loadingMessage: loadingMessage),
      expect: () => [
        const TimeSlotError(BookingConstants.selectDateFirstMessage),
      ],
    );
  });

  group('loadAvailableTimeSlots', () {
    blocTest<TimeSlotCubit, TimeSlotState>(
      'emits [Loading, Loaded] when slots exist',
      build: () {
        when(
          () => mockGetTimeSlots(fieldId: fieldId, date: testDate),
        ).thenAnswer((_) async => Right([testSlot]));
        return cubit;
      },
      act: (cubit) => cubit.loadAvailableTimeSlots(
        fieldId: fieldId,
        date: testDate,
        loadingMessage: loadingMessage,
      ),
      expect: () => [
        const TimeSlotLoading(message: loadingMessage),
        isA<TimeSlotsLoaded>(),
      ],
    );

    blocTest<TimeSlotCubit, TimeSlotState>(
      'emits [Loading, Error] when slots empty',
      build: () {
        when(
          () => mockGetTimeSlots(fieldId: fieldId, date: testDate),
        ).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (cubit) => cubit.loadAvailableTimeSlots(
        fieldId: fieldId,
        date: testDate,
        loadingMessage: loadingMessage,
      ),
      expect: () => [
        const TimeSlotLoading(message: loadingMessage),
        const TimeSlotError('No time slots available for this date'),
      ],
    );

    blocTest<TimeSlotCubit, TimeSlotState>(
      'emits [Loading, Error] when failure occurs',
      build: () {
        when(
          () => mockGetTimeSlots(fieldId: fieldId, date: testDate),
        ).thenAnswer((_) async => const Left(ServerFailure('Network error')));
        return cubit;
      },
      act: (cubit) => cubit.loadAvailableTimeSlots(
        fieldId: fieldId,
        date: testDate,
        loadingMessage: loadingMessage,
      ),
      expect: () => [
        const TimeSlotLoading(message: loadingMessage),
        const TimeSlotError('Network error'),
      ],
    );
  });

  group('selectTimeSlot', () {
    blocTest<TimeSlotCubit, TimeSlotState>(
      'updates selected slot in state',
      build: () {
        when(
          () => mockGetTimeSlots(fieldId: fieldId, date: testDate),
        ).thenAnswer((_) async => Right([testSlot]));
        return cubit;
      },
      act: (cubit) async {
        await cubit.startBookingFlow(
          fieldId,
          initialDate: testDate,
          loadingMessage: loadingMessage,
        );
        cubit.selectTimeSlot(testSlot);
      },
      expect: () => [
        const TimeSlotLoading(message: loadingMessage),
        isA<TimeSlotsLoaded>().having(
          (s) => s.selectedSlot,
          'selectedSlot',
          isNull,
        ),
        isA<TimeSlotsLoaded>().having(
          (s) => s.selectedSlot,
          'selectedSlot',
          testSlot,
        ),
      ],
    );
  });

  group('reset', () {
    blocTest<TimeSlotCubit, TimeSlotState>(
      'resets to initial state',
      build: () => cubit,
      seed: () => const TimeSlotError('Error'),
      act: (cubit) => cubit.reset(),
      expect: () => [const TimeSlotInitial()],
      verify: (cubit) {
        expect(cubit.selectedTimeSlot, isNull);
        expect(cubit.currentFieldId, isNull);
      },
    );
  });
}
