import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/domain/usecases/find_consecutive_slot_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/validate_slot_selection_usecase.dart';

class MockFindConsecutiveSlotUseCase extends Mock
    implements FindConsecutiveSlotUseCase {}

void main() {
  late ValidateSlotSelectionUseCase useCase;
  late MockFindConsecutiveSlotUseCase mockFindConsecutiveSlotUseCase;

  setUp(() {
    mockFindConsecutiveSlotUseCase = MockFindConsecutiveSlotUseCase();
    useCase = ValidateSlotSelectionUseCase(
      findConsecutiveSlotUseCase: mockFindConsecutiveSlotUseCase,
    );
  });

  setUpAll(() {
    registerFallbackValue(
      const TimeSlotEntity(
        startTime: '00:00',
        endTime: '01:00',
        isAvailable: true,
        price: 200.0,
        currency: 'EGP',
      ),
    );
    registerFallbackValue(<String, List<TimeSlotEntity>>{});
  });

  group('ValidateSlotSelectionUseCase', () {
    group('1-hour duration bookings', () {
      test('should return true when slot is available for 1 hour', () {
        // Arrange
        const slot = TimeSlotEntity(
          startTime: '09:00',
          endTime: '10:00',
          isAvailable: true,
          price: 200.0,
          currency: 'EGP',
        );
        final slotsByPeriod = <String, List<TimeSlotEntity>>{};

        // Act
        final result = useCase(
          slot: slot,
          durationHours: 1,
          slotsByPeriod: slotsByPeriod,
        );

        // Assert
        expect(result, true);
        verifyNever(
          () => mockFindConsecutiveSlotUseCase(
            slot: any(named: 'slot'),
            slotsByPeriod: any(named: 'slotsByPeriod'),
          ),
        );
      });

      test('should return false when slot is not available for 1 hour', () {
        // Arrange
        const slot = TimeSlotEntity(
          startTime: '09:00',
          endTime: '10:00',
          isAvailable: false,
          price: 200.0,
          currency: 'EGP',
        );
        final slotsByPeriod = <String, List<TimeSlotEntity>>{};

        // Act
        final result = useCase(
          slot: slot,
          durationHours: 1,
          slotsByPeriod: slotsByPeriod,
        );

        // Assert
        expect(result, false);
        verifyNever(
          () => mockFindConsecutiveSlotUseCase(
            slot: any(named: 'slot'),
            slotsByPeriod: any(named: 'slotsByPeriod'),
          ),
        );
      });

      test('should not call find consecutive slot for 1 hour duration', () {
        // Arrange
        const slot = TimeSlotEntity(
          startTime: '14:00',
          endTime: '15:00',
          isAvailable: true,
          price: 200.0,
          currency: 'EGP',
        );
        final slotsByPeriod = <String, List<TimeSlotEntity>>{};

        // Act
        useCase(slot: slot, durationHours: 1, slotsByPeriod: slotsByPeriod);

        // Assert
        verifyNever(
          () => mockFindConsecutiveSlotUseCase(
            slot: any(named: 'slot'),
            slotsByPeriod: any(named: 'slotsByPeriod'),
          ),
        );
      });
    });

    group('2-hour duration bookings', () {
      test('should return true when both slots are available', () {
        // Arrange
        const firstSlot = TimeSlotEntity(
          startTime: '09:00',
          endTime: '10:00',
          isAvailable: true,
          price: 200.0,
          currency: 'EGP',
        );

        const secondSlot = TimeSlotEntity(
          startTime: '10:00',
          endTime: '11:00',
          isAvailable: true,
          price: 200.0,
          currency: 'EGP',
        );

        final slotsByPeriod = {
          'Morning': [firstSlot, secondSlot],
        };

        when(
          () => mockFindConsecutiveSlotUseCase(
            slot: any(named: 'slot'),
            slotsByPeriod: any(named: 'slotsByPeriod'),
          ),
        ).thenReturn(secondSlot);

        // Act
        final result = useCase(
          slot: firstSlot,
          durationHours: 2,
          slotsByPeriod: slotsByPeriod,
        );

        // Assert
        expect(result, true);
        verify(
          () => mockFindConsecutiveSlotUseCase(
            slot: firstSlot,
            slotsByPeriod: slotsByPeriod,
          ),
        ).called(1);
      });

      test('should return false when first slot is not available', () {
        // Arrange
        const firstSlot = TimeSlotEntity(
          startTime: '09:00',
          endTime: '10:00',
          isAvailable: false,
          price: 200.0,
          currency: 'EGP',
        );

        const secondSlot = TimeSlotEntity(
          startTime: '10:00',
          endTime: '11:00',
          isAvailable: true,
          price: 200.0,
          currency: 'EGP',
        );

        final slotsByPeriod = {
          'Morning': [firstSlot, secondSlot],
        };

        when(
          () => mockFindConsecutiveSlotUseCase(
            slot: any(named: 'slot'),
            slotsByPeriod: any(named: 'slotsByPeriod'),
          ),
        ).thenReturn(secondSlot);

        // Act
        final result = useCase(
          slot: firstSlot,
          durationHours: 2,
          slotsByPeriod: slotsByPeriod,
        );

        // Assert
        expect(result, false);
      });

      test('should return false when second slot is not available', () {
        // Arrange
        const firstSlot = TimeSlotEntity(
          startTime: '09:00',
          endTime: '10:00',
          isAvailable: true,
          price: 200.0,
          currency: 'EGP',
        );

        const secondSlot = TimeSlotEntity(
          startTime: '10:00',
          endTime: '11:00',
          isAvailable: false,
          price: 200.0,
          currency: 'EGP',
        );

        final slotsByPeriod = {
          'Morning': [firstSlot, secondSlot],
        };

        when(
          () => mockFindConsecutiveSlotUseCase(
            slot: any(named: 'slot'),
            slotsByPeriod: any(named: 'slotsByPeriod'),
          ),
        ).thenReturn(secondSlot);

        // Act
        final result = useCase(
          slot: firstSlot,
          durationHours: 2,
          slotsByPeriod: slotsByPeriod,
        );

        // Assert
        expect(result, false);
        verify(
          () => mockFindConsecutiveSlotUseCase(
            slot: firstSlot,
            slotsByPeriod: slotsByPeriod,
          ),
        ).called(1);
      });

      test('should return false when both slots are not available', () {
        // Arrange
        const firstSlot = TimeSlotEntity(
          startTime: '09:00',
          endTime: '10:00',
          isAvailable: false,
          price: 200.0,
          currency: 'EGP',
        );

        const secondSlot = TimeSlotEntity(
          startTime: '10:00',
          endTime: '11:00',
          isAvailable: false,
          price: 200.0,
          currency: 'EGP',
        );

        final slotsByPeriod = {
          'Morning': [firstSlot, secondSlot],
        };

        when(
          () => mockFindConsecutiveSlotUseCase(
            slot: any(named: 'slot'),
            slotsByPeriod: any(named: 'slotsByPeriod'),
          ),
        ).thenReturn(secondSlot);

        // Act
        final result = useCase(
          slot: firstSlot,
          durationHours: 2,
          slotsByPeriod: slotsByPeriod,
        );

        // Assert
        expect(result, false);
      });

      test('should return false when consecutive slot does not exist', () {
        // Arrange
        const firstSlot = TimeSlotEntity(
          startTime: '22:00',
          endTime: '23:00',
          isAvailable: true,
          price: 200.0,
          currency: 'EGP',
        );

        final slotsByPeriod = {
          'Evening': [firstSlot],
        };

        when(
          () => mockFindConsecutiveSlotUseCase(
            slot: any(named: 'slot'),
            slotsByPeriod: any(named: 'slotsByPeriod'),
          ),
        ).thenReturn(null);

        // Act
        final result = useCase(
          slot: firstSlot,
          durationHours: 2,
          slotsByPeriod: slotsByPeriod,
        );

        // Assert
        expect(result, false);
        verify(
          () => mockFindConsecutiveSlotUseCase(
            slot: firstSlot,
            slotsByPeriod: slotsByPeriod,
          ),
        ).called(1);
      });

      test('should call find consecutive slot with correct parameters', () {
        // Arrange
        const firstSlot = TimeSlotEntity(
          startTime: '14:00',
          endTime: '15:00',
          isAvailable: true,
          price: 200.0,
          currency: 'EGP',
        );

        const secondSlot = TimeSlotEntity(
          startTime: '15:00',
          endTime: '16:00',
          isAvailable: true,
          price: 200.0,
          currency: 'EGP',
        );

        final slotsByPeriod = {
          'Afternoon': [firstSlot, secondSlot],
        };

        when(
          () => mockFindConsecutiveSlotUseCase(
            slot: any(named: 'slot'),
            slotsByPeriod: any(named: 'slotsByPeriod'),
          ),
        ).thenReturn(secondSlot);

        // Act
        useCase(
          slot: firstSlot,
          durationHours: 2,
          slotsByPeriod: slotsByPeriod,
        );

        // Assert
        final captured = verify(
          () => mockFindConsecutiveSlotUseCase(
            slot: captureAny(named: 'slot'),
            slotsByPeriod: captureAny(named: 'slotsByPeriod'),
          ),
        ).captured;
        expect(captured[0], firstSlot);
        expect(captured[1], slotsByPeriod);
      });
    });

    group('cross-midnight scenarios', () {
      test(
        'should validate 23:00 -> 00:00 booking correctly when both available',
        () {
          // Arrange
          const firstSlot = TimeSlotEntity(
            startTime: '23:00',
            endTime: '00:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
            isNextDay: false,
          );

          const secondSlot = TimeSlotEntity(
            startTime: '00:00',
            endTime: '01:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
            isNextDay: true,
          );

          final slotsByPeriod = {
            'Evening': [firstSlot],
            'Late Night': [secondSlot],
          };

          when(
            () => mockFindConsecutiveSlotUseCase(
              slot: any(named: 'slot'),
              slotsByPeriod: any(named: 'slotsByPeriod'),
            ),
          ).thenReturn(secondSlot);

          // Act
          final result = useCase(
            slot: firstSlot,
            durationHours: 2,
            slotsByPeriod: slotsByPeriod,
          );

          // Assert
          expect(result, true);
        },
      );

      test('should validate late night 2-hour booking correctly', () {
        // Arrange
        const firstSlot = TimeSlotEntity(
          startTime: '01:00',
          endTime: '02:00',
          isAvailable: true,
          price: 300.0,
          currency: 'EGP',
          isNextDay: true,
        );

        const secondSlot = TimeSlotEntity(
          startTime: '02:00',
          endTime: '03:00',
          isAvailable: true,
          price: 300.0,
          currency: 'EGP',
          isNextDay: true,
        );

        final slotsByPeriod = {
          'Late Night': [firstSlot, secondSlot],
        };

        when(
          () => mockFindConsecutiveSlotUseCase(
            slot: any(named: 'slot'),
            slotsByPeriod: any(named: 'slotsByPeriod'),
          ),
        ).thenReturn(secondSlot);

        // Act
        final result = useCase(
          slot: firstSlot,
          durationHours: 2,
          slotsByPeriod: slotsByPeriod,
        );

        // Assert
        expect(result, true);
      });
    });

    group('real-world scenarios', () {
      test('should validate typical 2-hour booking in the evening', () {
        // Arrange
        const firstSlot = TimeSlotEntity(
          startTime: '19:00',
          endTime: '20:00',
          isAvailable: true,
          price: 250.0,
          currency: 'EGP',
        );

        const secondSlot = TimeSlotEntity(
          startTime: '20:00',
          endTime: '21:00',
          isAvailable: true,
          price: 250.0,
          currency: 'EGP',
        );

        final slotsByPeriod = {
          'Evening': [firstSlot, secondSlot],
        };

        when(
          () => mockFindConsecutiveSlotUseCase(
            slot: any(named: 'slot'),
            slotsByPeriod: any(named: 'slotsByPeriod'),
          ),
        ).thenReturn(secondSlot);

        // Act
        final result = useCase(
          slot: firstSlot,
          durationHours: 2,
          slotsByPeriod: slotsByPeriod,
        );

        // Assert
        expect(result, true);
      });

      test('should reject 2-hour booking when first hour is booked', () {
        // Arrange
        const firstSlot = TimeSlotEntity(
          startTime: '14:00',
          endTime: '15:00',
          isAvailable: false, // Already booked
          price: 200.0,
          currency: 'EGP',
        );

        const secondSlot = TimeSlotEntity(
          startTime: '15:00',
          endTime: '16:00',
          isAvailable: true,
          price: 200.0,
          currency: 'EGP',
        );

        final slotsByPeriod = {
          'Afternoon': [firstSlot, secondSlot],
        };

        when(
          () => mockFindConsecutiveSlotUseCase(
            slot: any(named: 'slot'),
            slotsByPeriod: any(named: 'slotsByPeriod'),
          ),
        ).thenReturn(secondSlot);

        // Act
        final result = useCase(
          slot: firstSlot,
          durationHours: 2,
          slotsByPeriod: slotsByPeriod,
        );

        // Assert
        expect(result, false);
      });

      test('should reject 2-hour booking when second hour is booked', () {
        // Arrange
        const firstSlot = TimeSlotEntity(
          startTime: '14:00',
          endTime: '15:00',
          isAvailable: true,
          price: 200.0,
          currency: 'EGP',
        );

        const secondSlot = TimeSlotEntity(
          startTime: '15:00',
          endTime: '16:00',
          isAvailable: false, // Already booked
          price: 200.0,
          currency: 'EGP',
        );

        final slotsByPeriod = {
          'Afternoon': [firstSlot, secondSlot],
        };

        when(
          () => mockFindConsecutiveSlotUseCase(
            slot: any(named: 'slot'),
            slotsByPeriod: any(named: 'slotsByPeriod'),
          ),
        ).thenReturn(secondSlot);

        // Act
        final result = useCase(
          slot: firstSlot,
          durationHours: 2,
          slotsByPeriod: slotsByPeriod,
        );

        // Assert
        expect(result, false);
      });

      test('should reject 2-hour booking at end of operating hours', () {
        // Arrange
        const lastSlot = TimeSlotEntity(
          startTime: '22:00',
          endTime: '23:00',
          isAvailable: true,
          price: 250.0,
          currency: 'EGP',
        );

        final slotsByPeriod = {
          'Evening': [lastSlot],
        };

        when(
          () => mockFindConsecutiveSlotUseCase(
            slot: any(named: 'slot'),
            slotsByPeriod: any(named: 'slotsByPeriod'),
          ),
        ).thenReturn(null); // No next slot available

        // Act
        final result = useCase(
          slot: lastSlot,
          durationHours: 2,
          slotsByPeriod: slotsByPeriod,
        );

        // Assert
        expect(result, false);
      });
    });
  });
}
