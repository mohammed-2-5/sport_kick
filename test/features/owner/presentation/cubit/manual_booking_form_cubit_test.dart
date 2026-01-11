import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/features/bookings/domain/usecases/calculate_booking_end_time_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/calculate_booking_price_usecase.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/presentation/cubit/manual_booking_form_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/manual_booking_form_state.dart';
import 'package:spo_kick/l10n/app_localizations.dart';

// Mock Classes
class MockCalculateBookingEndTimeUseCase extends Mock
    implements CalculateBookingEndTimeUseCase {}

class MockCalculateBookingPriceUseCase extends Mock
    implements CalculateBookingPriceUseCase {}

class MockAppLocalizations extends Mock implements AppLocalizations {}

void main() {
  late ManualBookingFormCubit cubit;
  late MockCalculateBookingEndTimeUseCase mockCalculateEndTime;
  late MockCalculateBookingPriceUseCase mockCalculatePrice;
  late MockAppLocalizations mockL10n;

  // Test data
  final now = DateTime.now();
  late FieldEntity tField;

  setUp(() {
    mockCalculateEndTime = MockCalculateBookingEndTimeUseCase();
    mockCalculatePrice = MockCalculateBookingPriceUseCase();
    mockL10n = MockAppLocalizations();

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

    // Setup default mock behaviors
    when(
      () => mockCalculateEndTime(
        startTime: any(named: 'startTime'),
        durationHours: any(named: 'durationHours'),
      ),
    ).thenAnswer((invocation) {
      final startTime =
          invocation.namedArguments[const Symbol('startTime')] as String;
      final duration =
          invocation.namedArguments[const Symbol('durationHours')] as int;
      final hour = int.parse(startTime.split(':')[0]);
      final endHour = hour + duration;
      if (endHour >= 24) return null;
      return '${endHour.toString().padLeft(2, '0')}:00';
    });

    when(
      () => mockCalculatePrice(
        pricePerHour: any(named: 'pricePerHour'),
        durationHours: any(named: 'durationHours'),
      ),
    ).thenAnswer((invocation) {
      final price =
          invocation.namedArguments[const Symbol('pricePerHour')] as double;
      final duration =
          invocation.namedArguments[const Symbol('durationHours')] as int;
      return price * duration;
    });

    // Setup l10n mocks for validation messages
    when(
      () => mockL10n.manualBookingSelectField,
    ).thenReturn('Field is required');
    when(() => mockL10n.manualBookingSelectDate).thenReturn('Date is required');
    when(
      () => mockL10n.manualBookingSelectTimeSlot,
    ).thenReturn('Time is required');
    when(
      () => mockL10n.manualBookingEnterValidPrice,
    ).thenReturn('Price is required');
    when(
      () => mockL10n.manualBookingEnterCustomerName,
    ).thenReturn('Customer name is required');
    when(
      () => mockL10n.manualBookingEnterCustomerPhone,
    ).thenReturn('Customer phone is required');

    cubit = ManualBookingFormCubit(
      calculateBookingEndTimeUseCase: mockCalculateEndTime,
      calculateBookingPriceUseCase: mockCalculatePrice,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('ManualBookingFormCubit -', () {
    test('initial state should be ManualBookingFormInitial', () {
      expect(cubit.state, isA<ManualBookingFormInitial>());
    });

    test('initial data should have currentStep = 0', () {
      expect(cubit.currentStep, equals(0));
    });

    group('setField -', () {
      test('should update selected field and calculate price', () {
        cubit.setField(tField);

        expect(cubit.formData.selectedField, equals(tField));
        expect(cubit.formData.totalPrice, equals(200.0)); // 200 * 1 hour
      });

      test('should clear time selections when field changes', () {
        // First set some values
        cubit.setField(tField);
        cubit.setDate(now);
        cubit.setStartTime('14:00');

        // Now change field - create new field manually
        final newField = FieldEntity(
          id: 'field-2',
          name: 'New Field',
          sportCategoryId: 'sport-1',
          ownerId: 'owner-1',
          city: 'Cairo',
          address: '456 New Street',
          pricePerHour: 300.0,
          currency: 'EGP',
          isActive: true,
          createdAt: now,
          updatedAt: now,
        );
        cubit.setField(newField);

        expect(cubit.formData.selectedStartTime, isNull);
        expect(cubit.formData.selectedEndTime, isNull);
      });

      test('should keep price when field is set to null (copyWith behavior)', () {
        cubit.setField(tField);
        expect(cubit.formData.totalPrice, equals(200.0));

        cubit.setField(null);
        // copyWith uses ?? so null doesn't clear the value
        // The price stays as old value because copyWith doesn't have clear flag for price
        expect(cubit.formData.totalPrice, equals(200.0));
      });
    });

    group('setDate -', () {
      test('should update selected date', () {
        final selectedDate = now.add(const Duration(days: 5));
        cubit.setDate(selectedDate);

        expect(cubit.formData.selectedDate, equals(selectedDate));
      });

      test('should clear time selections when date changes', () {
        cubit.setField(tField);
        cubit.setStartTime('14:00');
        cubit.setDate(now.add(const Duration(days: 1)));

        expect(cubit.formData.selectedStartTime, isNull);
        expect(cubit.formData.selectedEndTime, isNull);
      });
    });

    group('setStartTime -', () {
      test('should update start time and auto-calculate end time', () {
        cubit.setStartTime('14:00');

        expect(cubit.formData.selectedStartTime, equals('14:00'));
        expect(
          cubit.formData.selectedEndTime,
          equals('15:00'),
        ); // 1 hour default
      });

      test('should keep previous values when start time is set to null', () {
        cubit.setStartTime('14:00');
        expect(cubit.formData.selectedStartTime, equals('14:00'));
        expect(cubit.formData.selectedEndTime, equals('15:00'));

        cubit.setStartTime(null);
        // copyWith uses ?? so null doesn't override to null for either start or end time
        // The start time stays because copyWith keeps old value when passed null
        expect(cubit.formData.selectedStartTime, equals('14:00'));
        // End time also stays because copyWith(selectedEndTime: null) uses ?? which keeps old value
        expect(cubit.formData.selectedEndTime, equals('15:00'));
      });
    });

    group('setEndTime -', () {
      test('should update end time directly', () {
        cubit.setEndTime('18:00');

        expect(cubit.formData.selectedEndTime, equals('18:00'));
      });
    });

    group('setDuration -', () {
      test('should update duration and recalculate price and end time', () {
        cubit.setField(tField);
        cubit.setStartTime('14:00');
        cubit.setDuration(2);

        expect(cubit.formData.durationHours, equals(2));
        expect(cubit.formData.totalPrice, equals(400.0)); // 200 * 2 hours
        expect(cubit.formData.selectedEndTime, equals('16:00'));
      });

      test('should ignore invalid duration values', () {
        cubit.setDuration(3); // Invalid
        expect(cubit.formData.durationHours, equals(1)); // Still default

        cubit.setDuration(0); // Invalid
        expect(cubit.formData.durationHours, equals(1));

        cubit.setDuration(-1); // Invalid
        expect(cubit.formData.durationHours, equals(1));
      });
    });

    group('setCustomerDetails -', () {
      test('should update all customer details', () {
        cubit.setCustomerDetails(
          name: 'Ahmed Ali',
          phone: '+201234567890',
          email: 'ahmed@example.com',
          notes: 'VIP customer',
        );

        expect(cubit.formData.customerName, equals('Ahmed Ali'));
        expect(cubit.formData.customerPhone, equals('+201234567890'));
        expect(cubit.formData.customerEmail, equals('ahmed@example.com'));
        expect(cubit.formData.notes, equals('VIP customer'));
      });

      test('should allow partial updates', () {
        cubit.setCustomerDetails(name: 'Ahmed Ali');
        cubit.setCustomerDetails(phone: '+201234567890');

        expect(cubit.formData.customerName, equals('Ahmed Ali'));
        expect(cubit.formData.customerPhone, equals('+201234567890'));
      });
    });

    group('nextStep -', () {
      test('should navigate to step 1 when step 0 is valid', () {
        cubit.setField(tField);
        cubit.setDate(now.add(const Duration(days: 1)));
        cubit.setStartTime('14:00');

        cubit.nextStep(mockL10n);

        expect(cubit.currentStep, equals(1));
      });

      test('should emit ValidationError when field is missing', () {
        cubit.setDate(now.add(const Duration(days: 1)));
        cubit.setStartTime('14:00');

        cubit.nextStep(mockL10n);

        expect(cubit.state, isA<ManualBookingFormValidationError>());
        final state = cubit.state as ManualBookingFormValidationError;
        expect(state.message, contains('Field'));
      });

      test('should navigate to step 2 when step 1 is valid', () {
        // Setup step 0
        cubit.setField(tField);
        cubit.setDate(now.add(const Duration(days: 1)));
        cubit.setStartTime('14:00');
        cubit.nextStep(mockL10n);

        // Setup step 1
        cubit.setCustomerDetails(name: 'Ahmed Ali', phone: '+201234567890');
        cubit.nextStep(mockL10n);

        expect(cubit.currentStep, equals(2));
      });

      test('should emit ValidationError when customer name is missing', () {
        // Complete step 0
        cubit.setField(tField);
        cubit.setDate(now.add(const Duration(days: 1)));
        cubit.setStartTime('14:00');
        cubit.nextStep(mockL10n);

        // Try to proceed without customer name
        cubit.setCustomerDetails(phone: '+201234567890');
        cubit.nextStep(mockL10n);

        expect(cubit.state, isA<ManualBookingFormValidationError>());
      });

      test('should emit ReadyToSubmit when step 2 is complete', () {
        // Complete all steps
        cubit.setField(tField);
        cubit.setDate(now.add(const Duration(days: 1)));
        cubit.setStartTime('14:00');
        cubit.nextStep(mockL10n);

        cubit.setCustomerDetails(name: 'Ahmed Ali', phone: '+201234567890');
        cubit.nextStep(mockL10n);

        cubit.nextStep(mockL10n);

        expect(cubit.state, isA<ManualBookingFormReadyToSubmit>());
      });
    });

    group('previousStep -', () {
      test('should navigate back to previous step', () {
        cubit.setField(tField);
        cubit.setDate(now.add(const Duration(days: 1)));
        cubit.setStartTime('14:00');
        cubit.nextStep(mockL10n);

        expect(cubit.currentStep, equals(1));

        cubit.previousStep();

        expect(cubit.currentStep, equals(0));
      });

      test('should do nothing when at step 0', () {
        cubit.previousStep();

        expect(cubit.currentStep, equals(0));
      });
    });

    group('goToStep -', () {
      test('should navigate to specific step', () {
        cubit.goToStep(1);

        expect(cubit.state, isA<ManualBookingFormStepChanged>());
        final state = cubit.state as ManualBookingFormStepChanged;
        expect(state.targetStep, equals(1));
      });

      test('should not navigate to invalid step', () {
        cubit.goToStep(5);

        expect(cubit.currentStep, equals(0)); // Still at step 0
      });

      test('should not navigate to negative step', () {
        cubit.goToStep(-1);

        expect(cubit.currentStep, equals(0));
      });

      test('should not navigate to same step', () {
        cubit.goToStep(0);

        // State should not change
        expect(cubit.state, isA<ManualBookingFormInitial>());
      });
    });

    group('initializeWithData -', () {
      test('should initialize form with provided data', () {
        final initialData = {
          'selectedDate': now.add(const Duration(days: 2)),
          'selectedTime': '16:00',
        };

        cubit.initializeWithData(initialData);

        expect(
          cubit.formData.selectedDate,
          equals(initialData['selectedDate']),
        );
        expect(cubit.formData.selectedStartTime, equals('16:00'));
        expect(cubit.formData.selectedEndTime, equals('17:00'));
      });

      test('should do nothing when data is null', () {
        cubit.initializeWithData(null);

        expect(cubit.formData.selectedDate, isNull);
        expect(cubit.formData.selectedStartTime, isNull);
      });
    });

    group('prepareSubmission -', () {
      test('should emit ReadyToSubmit with current data', () {
        cubit.setField(tField);
        cubit.setDate(now);
        cubit.setStartTime('10:00');
        cubit.setCustomerDetails(name: 'Test', phone: '123');

        cubit.prepareSubmission();

        expect(cubit.state, isA<ManualBookingFormReadyToSubmit>());
        final state = cubit.state as ManualBookingFormReadyToSubmit;
        expect(state.data.selectedField, equals(tField));
      });
    });
  });

  group('ManualBookingFormData -', () {
    test('default values are correct', () {
      const data = ManualBookingFormData();

      expect(data.currentStep, equals(0));
      expect(data.durationHours, equals(1));
      expect(data.selectedField, isNull);
      expect(data.selectedDate, isNull);
    });

    test('copyWith creates new instance with updated values', () {
      final original = ManualBookingFormData(
        currentStep: 1,
        selectedField: tField,
        selectedDate: now,
        selectedStartTime: '14:00',
        durationHours: 1,
      );

      final updated = original.copyWith(durationHours: 2);

      expect(updated.durationHours, equals(2));
      expect(updated.selectedField, equals(tField));
      expect(updated.currentStep, equals(1));
    });

    test('copyWith with clearStartTime clears time', () {
      final original = ManualBookingFormData(
        selectedStartTime: '14:00',
        selectedEndTime: '15:00',
      );

      final updated = original.copyWith(clearStartTime: true);

      expect(updated.selectedStartTime, isNull);
      expect(updated.selectedEndTime, equals('15:00'));
    });

    test('copyWith with clearEndTime clears end time', () {
      final original = ManualBookingFormData(
        selectedStartTime: '14:00',
        selectedEndTime: '15:00',
      );

      final updated = original.copyWith(clearEndTime: true);

      expect(updated.selectedStartTime, equals('14:00'));
      expect(updated.selectedEndTime, isNull);
    });

    test('props includes all fields for equality', () {
      final data1 = ManualBookingFormData(
        currentStep: 1,
        selectedField: tField,
      );
      final data2 = ManualBookingFormData(
        currentStep: 1,
        selectedField: tField,
      );
      final data3 = ManualBookingFormData(
        currentStep: 2,
        selectedField: tField,
      );

      expect(data1, equals(data2));
      expect(data1, isNot(equals(data3)));
    });
  });

  group('ManualBookingFormState variants -', () {
    test('ManualBookingFormInitial props include data', () {
      final data = ManualBookingFormData(selectedField: tField);
      final state1 = ManualBookingFormInitial(data: data);
      final state2 = ManualBookingFormInitial(data: data);

      expect(state1, equals(state2));
    });

    test('ManualBookingFormStepChanged props include data and targetStep', () {
      final data = ManualBookingFormData(currentStep: 1);
      final state1 = ManualBookingFormStepChanged(data: data, targetStep: 1);
      final state2 = ManualBookingFormStepChanged(data: data, targetStep: 1);
      final state3 = ManualBookingFormStepChanged(data: data, targetStep: 2);

      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });

    test('ManualBookingFormValidationError props include data and message', () {
      const data = ManualBookingFormData();
      const state1 = ManualBookingFormValidationError(
        data: data,
        message: 'Error',
      );
      const state2 = ManualBookingFormValidationError(
        data: data,
        message: 'Error',
      );
      const state3 = ManualBookingFormValidationError(
        data: data,
        message: 'Different',
      );

      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });

    test('ManualBookingFormReadyToSubmit props include data', () {
      final data = ManualBookingFormData(
        selectedField: tField,
        customerName: 'Test',
      );
      final state1 = ManualBookingFormReadyToSubmit(data: data);
      final state2 = ManualBookingFormReadyToSubmit(data: data);

      expect(state1, equals(state2));
    });
  });
}
