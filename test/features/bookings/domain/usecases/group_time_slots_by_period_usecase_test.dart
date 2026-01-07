import 'package:flutter_test/flutter_test.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/domain/usecases/group_time_slots_by_period_usecase.dart';

void main() {
  late GroupTimeSlotsByPeriodUseCase useCase;

  setUp(() {
    useCase = GroupTimeSlotsByPeriodUseCase();
  });

  group('GroupTimeSlotsByPeriodUseCase', () {
    group('morning slots (00:00 - 11:59)', () {
      test('should group early morning slots correctly', () {
        // Arrange
        const slots = [
          TimeSlotEntity(
            startTime: '00:00',
            endTime: '01:00',
            isAvailable: true,
            price: 150.0,
            currency: 'EGP',
          ),
          TimeSlotEntity(
            startTime: '06:00',
            endTime: '07:00',
            isAvailable: true,
            price: 150.0,
            currency: 'EGP',
          ),
        ];

        // Act
        final result = useCase(slots);

        // Assert
        expect(result.keys, contains('Morning'));
        expect(result['Morning']!.length, 2);
        expect(result['Morning']!.first.startTime, '00:00');
        expect(result['Morning']!.last.startTime, '06:00');
      });

      test('should group mid-morning slots correctly', () {
        // Arrange
        const slots = [
          TimeSlotEntity(
            startTime: '08:00',
            endTime: '09:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
          ),
          TimeSlotEntity(
            startTime: '09:00',
            endTime: '10:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
          ),
          TimeSlotEntity(
            startTime: '10:00',
            endTime: '11:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
          ),
        ];

        // Act
        final result = useCase(slots);

        // Assert
        expect(result.keys, contains('Morning'));
        expect(result['Morning']!.length, 3);
      });

      test('should include 11:00 slot in morning period', () {
        // Arrange
        const slots = [
          TimeSlotEntity(
            startTime: '11:00',
            endTime: '12:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
          ),
        ];

        // Act
        final result = useCase(slots);

        // Assert
        expect(result.keys, contains('Morning'));
        expect(result['Morning']!.length, 1);
        expect(result['Morning']!.first.startTime, '11:00');
      });
    });

    group('afternoon slots (12:00 - 16:59)', () {
      test('should group afternoon slots correctly', () {
        // Arrange
        const slots = [
          TimeSlotEntity(
            startTime: '12:00',
            endTime: '13:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
          ),
          TimeSlotEntity(
            startTime: '14:00',
            endTime: '15:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
          ),
          TimeSlotEntity(
            startTime: '16:00',
            endTime: '17:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
          ),
        ];

        // Act
        final result = useCase(slots);

        // Assert
        expect(result.keys, contains('Afternoon'));
        expect(result['Afternoon']!.length, 3);
      });

      test('should include 12:00 slot at start of afternoon', () {
        // Arrange
        const slots = [
          TimeSlotEntity(
            startTime: '12:00',
            endTime: '13:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
          ),
        ];

        // Act
        final result = useCase(slots);

        // Assert
        expect(result.keys, contains('Afternoon'));
        expect(result['Afternoon']!.length, 1);
      });
    });

    group('evening slots (17:00 - 22:59)', () {
      test('should group evening slots correctly', () {
        // Arrange
        const slots = [
          TimeSlotEntity(
            startTime: '17:00',
            endTime: '18:00',
            isAvailable: true,
            price: 250.0,
            currency: 'EGP',
          ),
          TimeSlotEntity(
            startTime: '20:00',
            endTime: '21:00',
            isAvailable: true,
            price: 250.0,
            currency: 'EGP',
          ),
          TimeSlotEntity(
            startTime: '22:00',
            endTime: '23:00',
            isAvailable: true,
            price: 250.0,
            currency: 'EGP',
          ),
        ];

        // Act
        final result = useCase(slots);

        // Assert
        expect(result.keys, contains('Evening'));
        expect(result['Evening']!.length, 3);
      });

      test('should include 17:00 slot at start of evening', () {
        // Arrange
        const slots = [
          TimeSlotEntity(
            startTime: '17:00',
            endTime: '18:00',
            isAvailable: true,
            price: 250.0,
            currency: 'EGP',
          ),
        ];

        // Act
        final result = useCase(slots);

        // Assert
        expect(result.keys, contains('Evening'));
        expect(result['Evening']!.length, 1);
      });

      test('should not include 23:00 in evening (boundary)', () {
        // Arrange
        const slots = [
          TimeSlotEntity(
            startTime: '23:00',
            endTime: '00:00',
            isAvailable: true,
            price: 250.0,
            currency: 'EGP',
            isNextDay: false,
          ),
        ];

        // Act
        final result = useCase(slots);

        // Assert
        expect(result.keys, contains('Evening'));
        expect(result['Evening']!.length, 1);
      });
    });

    group('late night slots (next day)', () {
      test('should group late night slots correctly', () {
        // Arrange
        const slots = [
          TimeSlotEntity(
            startTime: '00:00',
            endTime: '01:00',
            isAvailable: true,
            price: 300.0,
            currency: 'EGP',
            isNextDay: true,
          ),
          TimeSlotEntity(
            startTime: '01:00',
            endTime: '02:00',
            isAvailable: true,
            price: 300.0,
            currency: 'EGP',
            isNextDay: true,
          ),
          TimeSlotEntity(
            startTime: '02:00',
            endTime: '03:00',
            isAvailable: true,
            price: 300.0,
            currency: 'EGP',
            isNextDay: true,
          ),
        ];

        // Act
        final result = useCase(slots);

        // Assert
        expect(result.keys, contains('Late Night'));
        expect(result['Late Night']!.length, 3);
      });

      test('should distinguish between same time on different days', () {
        // Arrange
        const slots = [
          TimeSlotEntity(
            startTime: '01:00',
            endTime: '02:00',
            isAvailable: true,
            price: 150.0,
            currency: 'EGP',
            isNextDay: false, // Morning
          ),
          TimeSlotEntity(
            startTime: '01:00',
            endTime: '02:00',
            isAvailable: true,
            price: 300.0,
            currency: 'EGP',
            isNextDay: true, // Late Night
          ),
        ];

        // Act
        final result = useCase(slots);

        // Assert
        expect(result.keys, containsAll(['Morning', 'Late Night']));
        expect(result['Morning']!.length, 1);
        expect(result['Late Night']!.length, 1);
      });
    });

    group('multiple periods', () {
      test('should group slots across all periods correctly', () {
        // Arrange
        const slots = [
          TimeSlotEntity(
            startTime: '08:00',
            endTime: '09:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
          ),
          TimeSlotEntity(
            startTime: '14:00',
            endTime: '15:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
          ),
          TimeSlotEntity(
            startTime: '20:00',
            endTime: '21:00',
            isAvailable: true,
            price: 250.0,
            currency: 'EGP',
          ),
          TimeSlotEntity(
            startTime: '01:00',
            endTime: '02:00',
            isAvailable: true,
            price: 300.0,
            currency: 'EGP',
            isNextDay: true,
          ),
        ];

        // Act
        final result = useCase(slots);

        // Assert
        expect(result.keys.length, 4);
        expect(
          result.keys,
          containsAll(['Morning', 'Afternoon', 'Evening', 'Late Night']),
        );
        expect(result['Morning']!.length, 1);
        expect(result['Afternoon']!.length, 1);
        expect(result['Evening']!.length, 1);
        expect(result['Late Night']!.length, 1);
      });

      test('should handle full day schedule', () {
        // Arrange
        final slots = TimeSlotEntity.generateDefaultSlots(
          hourlyRate: 200.0,
          currency: 'EGP',
        );

        // Act
        final result = useCase(slots);

        // Assert
        expect(result.keys, containsAll(['Morning', 'Afternoon', 'Evening']));
        expect(result.keys, isNot(contains('Late Night')));
      });
    });

    group('empty and edge cases', () {
      test('should return empty map for empty input', () {
        // Arrange
        const slots = <TimeSlotEntity>[];

        // Act
        final result = useCase(slots);

        // Assert
        expect(result, isEmpty);
      });

      test('should remove empty periods from result', () {
        // Arrange
        const slots = [
          TimeSlotEntity(
            startTime: '08:00',
            endTime: '09:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
          ),
        ];

        // Act
        final result = useCase(slots);

        // Assert
        expect(result.keys.length, 1);
        expect(result.keys, contains('Morning'));
        expect(result.keys, isNot(contains('Afternoon')));
        expect(result.keys, isNot(contains('Evening')));
        expect(result.keys, isNot(contains('Late Night')));
      });

      test('should handle single slot in each period', () {
        // Arrange
        const slots = [
          TimeSlotEntity(
            startTime: '10:00',
            endTime: '11:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
          ),
          TimeSlotEntity(
            startTime: '14:00',
            endTime: '15:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
          ),
          TimeSlotEntity(
            startTime: '20:00',
            endTime: '21:00',
            isAvailable: true,
            price: 250.0,
            currency: 'EGP',
          ),
        ];

        // Act
        final result = useCase(slots);

        // Assert
        result.forEach((period, slots) {
          expect(slots.length, 1);
        });
      });
    });

    group('real-world scenarios', () {
      test('should group typical field operating hours (8 AM - 11 PM)', () {
        // Arrange
        final slots = TimeSlotEntity.generateDefaultSlots(
          hourlyRate: 200.0,
          currency: 'EGP',
        );

        // Act
        final result = useCase(slots);

        // Assert
        expect(result.keys, containsAll(['Morning', 'Afternoon', 'Evening']));
        expect(result['Morning']!.length, greaterThan(0));
        expect(result['Afternoon']!.length, greaterThan(0));
        expect(result['Evening']!.length, greaterThan(0));
      });

      test('should handle 24/7 field with late night hours', () {
        // Arrange
        final slots = [
          ...TimeSlotEntity.generateDefaultSlots(
            hourlyRate: 200.0,
            currency: 'EGP',
          ),
          const TimeSlotEntity(
            startTime: '23:00',
            endTime: '00:00',
            isAvailable: true,
            price: 300.0,
            currency: 'EGP',
          ),
          const TimeSlotEntity(
            startTime: '00:00',
            endTime: '01:00',
            isAvailable: true,
            price: 300.0,
            currency: 'EGP',
            isNextDay: true,
          ),
        ];

        // Act
        final result = useCase(slots);

        // Assert
        expect(
          result.keys,
          containsAll(['Morning', 'Afternoon', 'Evening', 'Late Night']),
        );
        expect(result['Late Night']!.length, 1);
      });

      test('should maintain slot order within periods', () {
        // Arrange
        const slots = [
          TimeSlotEntity(
            startTime: '10:00',
            endTime: '11:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
          ),
          TimeSlotEntity(
            startTime: '08:00',
            endTime: '09:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
          ),
          TimeSlotEntity(
            startTime: '09:00',
            endTime: '10:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
          ),
        ];

        // Act
        final result = useCase(slots);

        // Assert
        expect(result['Morning']!.length, 3);
        // Verify slots are in the same order as input
        expect(result['Morning']![0].startTime, '10:00');
        expect(result['Morning']![1].startTime, '08:00');
        expect(result['Morning']![2].startTime, '09:00');
      });
    });
  });
}
