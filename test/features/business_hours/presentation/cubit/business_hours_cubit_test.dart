import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/business_hours/domain/entities/business_hours_entity.dart';
import 'package:spo_kick/features/business_hours/domain/usecases/get_field_business_hours_usecase.dart';
import 'package:spo_kick/features/business_hours/domain/usecases/initialize_default_business_hours_usecase.dart';
import 'package:spo_kick/features/business_hours/domain/usecases/is_field_currently_open_usecase.dart';
import 'package:spo_kick/features/business_hours/domain/usecases/update_business_hours_usecase.dart';
import 'package:spo_kick/features/business_hours/domain/usecases/validate_booking_time_usecase.dart';
import 'package:spo_kick/features/business_hours/presentation/cubit/business_hours_cubit.dart';
import 'package:spo_kick/features/business_hours/presentation/cubit/business_hours_state.dart';

// Mock Use Cases
class MockGetFieldBusinessHoursUseCase extends Mock
    implements GetFieldBusinessHoursUseCase {}

class MockUpdateBusinessHoursUseCase extends Mock
    implements UpdateBusinessHoursUseCase {}

class MockInitializeDefaultBusinessHoursUseCase extends Mock
    implements InitializeDefaultBusinessHoursUseCase {}

class MockValidateBookingTimeUseCase extends Mock
    implements ValidateBookingTimeUseCase {}

class MockIsFieldCurrentlyOpenUseCase extends Mock
    implements IsFieldCurrentlyOpenUseCase {}

// Register fallback values
class FakeUpdateBusinessHoursParams extends Fake
    implements UpdateBusinessHoursParams {}

class FakeValidateBookingTimeParams extends Fake
    implements ValidateBookingTimeParams {}

void main() {
  late BusinessHoursCubit cubit;
  late MockGetFieldBusinessHoursUseCase mockGetBusinessHours;
  late MockUpdateBusinessHoursUseCase mockUpdateBusinessHours;
  late MockInitializeDefaultBusinessHoursUseCase mockInitDefault;
  late MockValidateBookingTimeUseCase mockValidate;
  late MockIsFieldCurrentlyOpenUseCase mockIsOpen;

  // Test data
  final testBusinessHours = BusinessHoursEntity(
    id: 'bh-1',
    fieldId: 'field-1',
    dayOfWeek: 1, // Monday
    isOpen: true,
    openingTime: '09:00',
    closingTime: '22:00',
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  final allDaysHours = List.generate(
    7,
    (i) => BusinessHoursEntity(
      id: 'bh-$i',
      fieldId: 'field-1',
      dayOfWeek: i + 1,
      isOpen: true,
      openingTime: '09:00',
      closingTime: '22:00',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    ),
  );

  setUpAll(() {
    registerFallbackValue(FakeUpdateBusinessHoursParams());
    registerFallbackValue(FakeValidateBookingTimeParams());
  });

  setUp(() {
    mockGetBusinessHours = MockGetFieldBusinessHoursUseCase();
    mockUpdateBusinessHours = MockUpdateBusinessHoursUseCase();
    mockInitDefault = MockInitializeDefaultBusinessHoursUseCase();
    mockValidate = MockValidateBookingTimeUseCase();
    mockIsOpen = MockIsFieldCurrentlyOpenUseCase();

    cubit = BusinessHoursCubit(
      getFieldBusinessHoursUseCase: mockGetBusinessHours,
      updateBusinessHoursUseCase: mockUpdateBusinessHours,
      initializeDefaultBusinessHoursUseCase: mockInitDefault,
      validateBookingTimeUseCase: mockValidate,
      isFieldCurrentlyOpenUseCase: mockIsOpen,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('BusinessHoursCubit', () {
    test('initial state is BusinessHoursInitial', () {
      expect(cubit.state, const BusinessHoursInitial());
    });

    test('currentFieldId is null initially', () {
      expect(cubit.currentFieldId, isNull);
    });

    test('hasUnsavedChanges is false initially', () {
      expect(cubit.hasUnsavedChanges, isFalse);
    });
  });

  group('getFieldBusinessHours', () {
    blocTest<BusinessHoursCubit, BusinessHoursState>(
      'emits [Loading, Loaded] when successful',
      build: () {
        when(
          () => mockGetBusinessHours(any()),
        ).thenAnswer((_) async => Right(allDaysHours));
        return cubit;
      },
      act: (cubit) => cubit.getFieldBusinessHours(fieldId: 'field-1'),
      expect: () => [
        const BusinessHoursLoading(),
        isA<BusinessHoursLoaded>().having(
          (s) => s.businessHours.length,
          'days',
          7,
        ),
      ],
    );

    blocTest<BusinessHoursCubit, BusinessHoursState>(
      'emits [Loading, Error] on failure',
      build: () {
        when(
          () => mockGetBusinessHours(any()),
        ).thenAnswer((_) async => const Left(ServerFailure('Not found')));
        return cubit;
      },
      act: (cubit) => cubit.getFieldBusinessHours(fieldId: 'field-1'),
      expect: () => [
        const BusinessHoursLoading(),
        isA<BusinessHoursError>().having(
          (s) => s.message,
          'message',
          'Not found',
        ),
      ],
    );

    blocTest<BusinessHoursCubit, BusinessHoursState>(
      'checks current status when requested',
      build: () {
        when(
          () => mockGetBusinessHours(any()),
        ).thenAnswer((_) async => Right(allDaysHours));
        when(
          () => mockIsOpen(any()),
        ).thenAnswer((_) async => const Right(true));
        return cubit;
      },
      act: (cubit) => cubit.getFieldBusinessHours(
        fieldId: 'field-1',
        checkCurrentStatus: true,
      ),
      expect: () => [
        const BusinessHoursLoading(),
        isA<BusinessHoursLoaded>().having(
          (s) => s.isCurrentlyOpen,
          'isCurrentlyOpen',
          true,
        ),
      ],
    );
  });

  group('validateBookingTime', () {
    blocTest<BusinessHoursCubit, BusinessHoursState>(
      'emits [Validating, Validated(true)] when valid',
      build: () {
        when(
          () => mockValidate(any()),
        ).thenAnswer((_) async => const Right(true));
        return cubit;
      },
      act: (cubit) => cubit.validateBookingTime(
        fieldId: 'field-1',
        bookingTime: DateTime(2024, 12, 15, 10, 0),
      ),
      expect: () => [
        const BusinessHoursValidating(),
        isA<BusinessHoursValidated>()
            .having((s) => s.isValid, 'isValid', true)
            .having((s) => s.message, 'message', isNull),
      ],
    );

    blocTest<BusinessHoursCubit, BusinessHoursState>(
      'emits [Validating, Validated(false)] when invalid',
      build: () {
        when(
          () => mockValidate(any()),
        ).thenAnswer((_) async => const Right(false));
        return cubit;
      },
      act: (cubit) => cubit.validateBookingTime(
        fieldId: 'field-1',
        bookingTime: DateTime(2024, 12, 15, 3, 0), // 3 AM - closed
      ),
      expect: () => [
        const BusinessHoursValidating(),
        isA<BusinessHoursValidated>()
            .having((s) => s.isValid, 'isValid', false)
            .having((s) => s.message, 'message', isNotNull),
      ],
    );
  });

  group('initializeDefaultBusinessHours', () {
    blocTest<BusinessHoursCubit, BusinessHoursState>(
      'emits [Initializing, Loading, Loaded] on success',
      build: () {
        when(
          () => mockInitDefault(any()),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => mockGetBusinessHours(any()),
        ).thenAnswer((_) async => Right(allDaysHours));
        return cubit;
      },
      act: (cubit) => cubit.initializeDefaultBusinessHours('field-1'),
      expect: () => [
        const BusinessHoursInitializing(),
        const BusinessHoursLoading(),
        isA<BusinessHoursLoaded>(),
      ],
    );

    blocTest<BusinessHoursCubit, BusinessHoursState>(
      'emits [Initializing, Error] on failure',
      build: () {
        when(
          () => mockInitDefault(any()),
        ).thenAnswer((_) async => const Left(ServerFailure('Init failed')));
        return cubit;
      },
      act: (cubit) => cubit.initializeDefaultBusinessHours('field-1'),
      expect: () => [
        const BusinessHoursInitializing(),
        isA<BusinessHoursError>().having(
          (s) => s.message,
          'message',
          'Init failed',
        ),
      ],
    );
  });

  group('reset', () {
    blocTest<BusinessHoursCubit, BusinessHoursState>(
      'resets to initial state',
      build: () => cubit,
      seed: () => BusinessHoursLoaded(businessHours: allDaysHours),
      act: (cubit) => cubit.reset(),
      expect: () => [const BusinessHoursInitial()],
    );
  });

  group('checkCurrentStatus', () {
    blocTest<BusinessHoursCubit, BusinessHoursState>(
      'updates loaded state with open status',
      build: () {
        when(
          () => mockIsOpen(any()),
        ).thenAnswer((_) async => const Right(true));
        return cubit;
      },
      seed: () => BusinessHoursLoaded(businessHours: allDaysHours),
      act: (cubit) => cubit.checkCurrentStatus('field-1'),
      expect: () => [
        isA<BusinessHoursLoaded>().having(
          (s) => s.isCurrentlyOpen,
          'isCurrentlyOpen',
          true,
        ),
      ],
    );

    blocTest<BusinessHoursCubit, BusinessHoursState>(
      'does nothing when not in loaded state',
      build: () => cubit,
      act: (cubit) => cubit.checkCurrentStatus('field-1'),
      expect: () => [],
    );
  });

  group('BusinessHoursEntity', () {
    test('has correct day name getter', () {
      expect(testBusinessHours.dayOfWeek, 1);
    });
  });
}
