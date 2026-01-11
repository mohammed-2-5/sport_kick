import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/repositories/booking_repository.dart';
import 'package:spo_kick/features/business_hours/domain/entities/business_hours_entity.dart';
import 'package:spo_kick/features/business_hours/domain/repositories/business_hours_repository.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/repositories/field_repository.dart';
import 'package:spo_kick/features/owner/presentation/cubit/booking_table/booking_table_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/booking_table/booking_table_state.dart';

// Mock Repositories
class MockFieldRepository extends Mock implements FieldRepository {}

class MockBookingRepository extends Mock implements BookingRepository {}

class MockBusinessHoursRepository extends Mock
    implements BusinessHoursRepository {}

void main() {
  late BookingTableCubit cubit;
  late MockFieldRepository mockFieldRepository;
  late MockBookingRepository mockBookingRepository;
  late MockBusinessHoursRepository mockBusinessHoursRepository;

  // Test data
  const ownerId = 'owner-1';
  final now = DateTime.now();
  final weekStart = now.subtract(Duration(days: (now.weekday + 1) % 7));

  final testField = FieldEntity(
    id: 'field-1',
    name: 'Test Field',
    sportCategoryId: 'cat-1',
    ownerId: ownerId,
    city: 'Cairo',
    address: 'Address',
    pricePerHour: 100,
    currency: 'EGP',
    isActive: true,
    createdAt: now,
    updatedAt: now,
  );

  final testBooking = BookingEntity(
    id: 'booking-1',
    userId: 'user-1',
    fieldId: 'field-1',
    date: weekStart, // Saturday
    startTime: '10:00',
    endTime: '11:00',
    status: BookingStatus.confirmed,
    totalPrice: 100,
    currency: 'EGP',
    createdAt: now,
  );

  final testBusinessHours = BusinessHoursEntity(
    id: 'hours-1',
    fieldId: 'field-1',
    dayOfWeek: 6, // Saturday
    isOpen: true,
    openingTime: '08:00',
    closingTime: '23:00',
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    mockFieldRepository = MockFieldRepository();
    mockBookingRepository = MockBookingRepository();
    mockBusinessHoursRepository = MockBusinessHoursRepository();

    cubit = BookingTableCubit(
      fieldRepository: mockFieldRepository,
      bookingRepository: mockBookingRepository,
      businessHoursRepository: mockBusinessHoursRepository,
      ownerId: ownerId,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('BookingTableCubit', () {
    test('initial state is BookingTableInitial', () {
      expect(cubit.state, const BookingTableInitial());
    });
  });

  group('initialize', () {
    blocTest<BookingTableCubit, BookingTableState>(
      'emits [Loading, Loaded] when initialization succeeds',
      build: () {
        when(
          () => mockFieldRepository.getFieldsByOwner(ownerId),
        ).thenAnswer((_) async => Right([testField]));
        when(
          () => mockBusinessHoursRepository.getFieldBusinessHours(testField.id),
        ).thenAnswer((_) async => Right([testBusinessHours]));
        when(
          () => mockBookingRepository.getOwnerBookings(),
        ).thenAnswer((_) async => Right([testBooking]));
        return cubit;
      },
      act: (cubit) => cubit.initialize(),
      expect: () => [
        const BookingTableLoading(message: 'Loading fields...'),
        isA<BookingTableLoaded>()
            .having((s) => s.selectedField, 'field', testField)
            .having((s) => s.ownerFields.length, 'fields count', 1)
            .having((s) => s.bookingSlots.length, 'slots', 1),
      ],
    );

    blocTest<BookingTableCubit, BookingTableState>(
      'emits [Loading, Error] when ownerId is empty',
      build: () => BookingTableCubit(
        fieldRepository: mockFieldRepository,
        bookingRepository: mockBookingRepository,
        businessHoursRepository: mockBusinessHoursRepository,
        ownerId: '',
      ),
      act: (cubit) => cubit.initialize(),
      expect: () => [
        const BookingTableLoading(message: 'Loading fields...'),
        const BookingTableError('Owner ID is missing. Please log in again.'),
      ],
    );

    blocTest<BookingTableCubit, BookingTableState>(
      'emits [Loading, Error] when no fields found',
      build: () {
        when(
          () => mockFieldRepository.getFieldsByOwner(ownerId),
        ).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (cubit) => cubit.initialize(),
      expect: () => [
        const BookingTableLoading(message: 'Loading fields...'),
        const BookingTableError(
          'No fields found for this owner. Please add a field first.',
        ),
      ],
    );

    blocTest<BookingTableCubit, BookingTableState>(
      'emits [Loading, Error] when repository fails',
      build: () {
        when(
          () => mockFieldRepository.getFieldsByOwner(ownerId),
        ).thenAnswer((_) async => const Left(ServerFailure('Network error')));
        return cubit;
      },
      act: (cubit) => cubit.initialize(),
      expect: () => [
        const BookingTableLoading(message: 'Loading fields...'),
        const BookingTableError(
          'No fields found for this owner. Please add a field first.',
        ), // Implementation converts failure to empty list
      ],
    );
  });

  group('navigation', () {
    final loadedState = BookingTableLoaded(
      selectedField: testField,
      ownerFields: [testField],
      weekStartDate: weekStart,
      businessHours: [testBusinessHours],
      bookingSlots: const {},
      isRefreshing: false,
    );

    setUp(() {
      when(
        () => mockBusinessHoursRepository.getFieldBusinessHours(testField.id),
      ).thenAnswer((_) async => Right([testBusinessHours]));
      when(
        () => mockBookingRepository.getOwnerBookings(),
      ).thenAnswer((_) async => Right([testBooking]));
    });

    blocTest<BookingTableCubit, BookingTableState>(
      'nextWeek advances week and reloads',
      build: () => cubit,
      seed: () => loadedState,
      act: (cubit) => cubit.nextWeek(),
      expect: () => [
        loadedState.copyWith(isRefreshing: true),
        isA<BookingTableLoaded>().having(
          (s) => s.weekStartDate,
          'next week',
          weekStart.add(const Duration(days: 7)),
        ),
      ],
    );

    blocTest<BookingTableCubit, BookingTableState>(
      'previousWeek subtracts week and reloads',
      build: () => cubit,
      seed: () => loadedState,
      act: (cubit) => cubit.previousWeek(),
      expect: () => [
        loadedState.copyWith(isRefreshing: true),
        isA<BookingTableLoaded>().having(
          (s) => s.weekStartDate,
          'prev week',
          weekStart.subtract(const Duration(days: 7)),
        ),
      ],
    );
  });

  group('selectField', () {
    final loadedState = BookingTableLoaded(
      selectedField: testField,
      ownerFields: [testField],
      weekStartDate: weekStart,
      businessHours: [testBusinessHours],
      bookingSlots: const {},
      isRefreshing: false,
    );

    blocTest<BookingTableCubit, BookingTableState>(
      'updates selected field and reloads data',
      build: () {
        when(
          () => mockBusinessHoursRepository.getFieldBusinessHours(testField.id),
        ).thenAnswer((_) async => Right([testBusinessHours]));
        when(
          () => mockBookingRepository.getOwnerBookings(),
        ).thenAnswer((_) async => Right([testBooking]));
        return cubit;
      },
      seed: () => loadedState,
      act: (cubit) => cubit.selectField(testField),
      expect: () => [
        loadedState.copyWith(isRefreshing: true),
        isA<BookingTableLoaded>().having(
          (s) => s.selectedField.id,
          'fieldId',
          testField.id,
        ),
      ],
    );
  });
}
