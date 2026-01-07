import 'package:flutter_test/flutter_test.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/domain/usecases/find_consecutive_slot_usecase.dart';

void main() {
  late FindConsecutiveSlotUseCase useCase;

  setUp(() {
    useCase = FindConsecutiveSlotUseCase();
  });

  group('FindConsecutiveSlotUseCase', () {
    group('standard consecutive slot finding', () {
      test('should find consecutive slot for morning hours', () {
        // Arrange
        const currentSlot = TimeSlotEntity(
          startTime: '09:00',
          endTime: '10:00',
          isAvailable: true,
          price: 200.0,
          currency: 'EGP',
        );

        const nextSlot = TimeSlotEntity(
          startTime: '10:00',
          endTime: '11:00',
          isAvailable: true,
          price: 200.0,
          currency: 'EGP',
        );

        final slotsByPeriod = {
          'Morning': [currentSlot, nextSlot],
        };

        // Act
        final result = useCase(slot: currentSlot, slotsByPeriod: slotsByPeriod);

        // Assert
        expect(result, nextSlot);
      });

      test('should find consecutive slot for afternoon hours', () {
        // Arrange
        const currentSlot = TimeSlotEntity(
          startTime: '14:00',
          endTime: '15:00',
          isAvailable: true,
          price: 200.0,
          currency: 'EGP',
        );

        const nextSlot = TimeSlotEntity(
          startTime: '15:00',
          endTime: '16:00',
          isAvailable: true,
          price: 200.0,
          currency: 'EGP',
        );

        final slotsByPeriod = {
          'Afternoon': [currentSlot, nextSlot],
        };

        // Act
        final result = useCase(slot: currentSlot, slotsByPeriod: slotsByPeriod);

        // Assert
        expect(result, nextSlot);
      });

      test('should find consecutive slot for evening hours', () {
        // Arrange
        const currentSlot = TimeSlotEntity(
          startTime: '20:00',
          endTime: '21:00',
          isAvailable: true,
          price: 200.0,
          currency: 'EGP',
        );

        const nextSlot = TimeSlotEntity(
          startTime: '21:00',
          endTime: '22:00',
          isAvailable: true,
          price: 200.0,
          currency: 'EGP',
        );

        final slotsByPeriod = {
          'Evening': [currentSlot, nextSlot],
        };

        // Act
        final result = useCase(slot: currentSlot, slotsByPeriod: slotsByPeriod);

        // Assert
        expect(result, nextSlot);
      });

      test('should find consecutive slot across different periods', () {
        // Arrange
        const currentSlot = TimeSlotEntity(
          startTime: '11:00',
          endTime: '12:00',
          isAvailable: true,
          price: 200.0,
          currency: 'EGP',
        );

        const nextSlot = TimeSlotEntity(
          startTime: '12:00',
          endTime: '13:00',
          isAvailable: true,
          price: 200.0,
          currency: 'EGP',
        );

        final slotsByPeriod = {
          'Morning': [currentSlot],
          'Afternoon': [nextSlot],
        };

        // Act
        final result = useCase(slot: currentSlot, slotsByPeriod: slotsByPeriod);

        // Assert
        expect(result, nextSlot);
      });
    });

    group('cross-midnight scenarios', () {
      test('should find consecutive slot for 23:00 -> 00:00 (next day)', () {
        // Arrange
        const currentSlot = TimeSlotEntity(
          startTime: '23:00',
          endTime: '00:00',
          isAvailable: true,
          price: 200.0,
          currency: 'EGP',
          isNextDay: false,
        );

        const nextSlot = TimeSlotEntity(
          startTime: '00:00',
          endTime: '01:00',
          isAvailable: true,
          price: 200.0,
          currency: 'EGP',
          isNextDay: true,
        );

        final slotsByPeriod = {
          'Evening': [currentSlot],
          'Late Night': [nextSlot],
        };

        // Act
        final result = useCase(slot: currentSlot, slotsByPeriod: slotsByPeriod);

        // Assert
        expect(result, nextSlot);
      });

      test(
        'should find consecutive slot when current slot is already next day',
        () {
          // Arrange
          const currentSlot = TimeSlotEntity(
            startTime: '01:00',
            endTime: '02:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
            isNextDay: true,
          );

          const nextSlot = TimeSlotEntity(
            startTime: '02:00',
            endTime: '03:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
            isNextDay: true,
          );

          final slotsByPeriod = {
            'Late Night': [currentSlot, nextSlot],
          };

          // Act
          final result = useCase(
            slot: currentSlot,
            slotsByPeriod: slotsByPeriod,
          );

          // Assert
          expect(result, nextSlot);
        },
      );

      test('should handle 00:00 modulo correctly', () {
        // Arrange
        const currentSlot = TimeSlotEntity(
          startTime: '00:00',
          endTime: '01:00',
          isAvailable: true,
          price: 200.0,
          currency: 'EGP',
          isNextDay: true,
        );

        const nextSlot = TimeSlotEntity(
          startTime: '01:00',
          endTime: '02:00',
          isAvailable: true,
          price: 200.0,
          currency: 'EGP',
          isNextDay: true,
        );

        final slotsByPeriod = {
          'Late Night': [currentSlot, nextSlot],
        };

        // Act
        final result = useCase(slot: currentSlot, slotsByPeriod: slotsByPeriod);

        // Assert
        expect(result, nextSlot);
      });
    });

    group('edge cases', () {
      test('should return null when consecutive slot does not exist', () {
        // Arrange
        const currentSlot = TimeSlotEntity(
          startTime: '22:00',
          endTime: '23:00',
          isAvailable: true,
          price: 200.0,
          currency: 'EGP',
        );

        final slotsByPeriod = {
          'Evening': [currentSlot],
        };

        // Act
        final result = useCase(slot: currentSlot, slotsByPeriod: slotsByPeriod);

        // Assert
        expect(result, null);
      });

      test('should return null when slot map is empty', () {
        // Arrange
        const currentSlot = TimeSlotEntity(
          startTime: '09:00',
          endTime: '10:00',
          isAvailable: true,
          price: 200.0,
          currency: 'EGP',
        );

        final slotsByPeriod = <String, List<TimeSlotEntity>>{};

        // Act
        final result = useCase(slot: currentSlot, slotsByPeriod: slotsByPeriod);

        // Assert
        expect(result, null);
      });

      test(
        'should return null when consecutive time exists but wrong day flag',
        () {
          // Arrange
          const currentSlot = TimeSlotEntity(
            startTime: '09:00',
            endTime: '10:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
            isNextDay: false,
          );

          // Next slot has correct time but wrong day flag
          const wrongDaySlot = TimeSlotEntity(
            startTime: '10:00',
            endTime: '11:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
            isNextDay: true, // Should be false
          );

          final slotsByPeriod = {
            'Morning': [currentSlot, wrongDaySlot],
          };

          // Act
          final result = useCase(
            slot: currentSlot,
            slotsByPeriod: slotsByPeriod,
          );

          // Assert
          expect(result, null);
        },
      );

      test(
        'should handle multiple periods with no matching consecutive slot',
        () {
          // Arrange
          const currentSlot = TimeSlotEntity(
            startTime: '10:00',
            endTime: '11:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
          );

          const otherSlot1 = TimeSlotEntity(
            startTime: '14:00',
            endTime: '15:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
          );

          const otherSlot2 = TimeSlotEntity(
            startTime: '18:00',
            endTime: '19:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
          );

          final slotsByPeriod = {
            'Morning': [currentSlot],
            'Afternoon': [otherSlot1],
            'Evening': [otherSlot2],
          };

          // Act
          final result = useCase(
            slot: currentSlot,
            slotsByPeriod: slotsByPeriod,
          );

          // Assert
          expect(result, null);
        },
      );
    });

    group('real-world booking scenarios', () {
      test('should support 2-hour booking starting at 10:00', () {
        // Arrange
        final slots = TimeSlotEntity.generateDefaultSlots(
          hourlyRate: 200.0,
          currency: 'EGP',
        );
        final slotsByPeriod = TimeSlotEntity.groupSlotsByPeriod(slots);
        final currentSlot = slots.firstWhere((s) => s.startTime == '10:00');

        // Act
        final result = useCase(slot: currentSlot, slotsByPeriod: slotsByPeriod);

        // Assert
        expect(result, isNotNull);
        expect(result!.startTime, '11:00');
      });

      test('should support 2-hour booking ending at midnight', () {
        // Arrange
        final slots = [
          const TimeSlotEntity(
            startTime: '22:00',
            endTime: '23:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
          ),
          const TimeSlotEntity(
            startTime: '23:00',
            endTime: '00:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
          ),
          const TimeSlotEntity(
            startTime: '00:00',
            endTime: '01:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
            isNextDay: true,
          ),
        ];
        final slotsByPeriod = TimeSlotEntity.groupSlotsByPeriod(slots);
        final currentSlot = slots.firstWhere((s) => s.startTime == '22:00');

        // Act
        final result = useCase(slot: currentSlot, slotsByPeriod: slotsByPeriod);

        // Assert
        expect(result, isNotNull);
        expect(result!.startTime, '23:00');
      });
    });
  });
}
