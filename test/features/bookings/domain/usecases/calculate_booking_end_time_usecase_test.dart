import 'package:flutter_test/flutter_test.dart';
import 'package:spo_kick/features/bookings/domain/usecases/calculate_booking_end_time_usecase.dart';

void main() {
  late CalculateBookingEndTimeUseCase useCase;

  setUp(() {
    useCase = CalculateBookingEndTimeUseCase();
  });

  group('CalculateBookingEndTimeUseCase', () {
    group('successful calculations', () {
      test('should calculate end time correctly for 1 hour duration', () {
        // Arrange
        const startTime = '14:30';
        const durationHours = 1;

        // Act
        final result = useCase(
          startTime: startTime,
          durationHours: durationHours,
        );

        // Assert
        expect(result, '15:30');
      });

      test('should calculate end time correctly for 2 hour duration', () {
        // Arrange
        const startTime = '14:30';
        const durationHours = 2;

        // Act
        final result = useCase(
          startTime: startTime,
          durationHours: durationHours,
        );

        // Assert
        expect(result, '16:30');
      });

      test('should handle midnight times correctly', () {
        // Arrange
        const startTime = '00:00';
        const durationHours = 1;

        // Act
        final result = useCase(
          startTime: startTime,
          durationHours: durationHours,
        );

        // Assert
        expect(result, '01:00');
      });

      test('should handle morning hours correctly', () {
        // Arrange
        const startTime = '09:15';
        const durationHours = 2;

        // Act
        final result = useCase(
          startTime: startTime,
          durationHours: durationHours,
        );

        // Assert
        expect(result, '11:15');
      });

      test('should handle late evening hours correctly', () {
        // Arrange
        const startTime = '21:00';
        const durationHours = 2;

        // Act
        final result = useCase(
          startTime: startTime,
          durationHours: durationHours,
        );

        // Assert
        expect(result, '23:00');
      });

      test('should pad single digit hours with zero', () {
        // Arrange
        const startTime = '08:30';
        const durationHours = 1;

        // Act
        final result = useCase(
          startTime: startTime,
          durationHours: durationHours,
        );

        // Assert
        expect(result, '09:30');
      });
    });

    group('next day scenarios (should return null)', () {
      test('should return null when end time would be at 24:00', () {
        // Arrange
        const startTime = '23:00';
        const durationHours = 1;

        // Act
        final result = useCase(
          startTime: startTime,
          durationHours: durationHours,
        );

        // Assert
        expect(result, null);
      });

      test('should return null when end time would exceed 24:00', () {
        // Arrange
        const startTime = '23:00';
        const durationHours = 2;

        // Act
        final result = useCase(
          startTime: startTime,
          durationHours: durationHours,
        );

        // Assert
        expect(result, null);
      });

      test('should return null when end time would be well into next day', () {
        // Arrange
        const startTime = '22:00';
        const durationHours = 3;

        // Act
        final result = useCase(
          startTime: startTime,
          durationHours: durationHours,
        );

        // Assert
        expect(result, null);
      });
    });

    group('edge cases and error handling', () {
      test('should return null for invalid time format', () {
        // Arrange
        const startTime = 'invalid';
        const durationHours = 1;

        // Act
        final result = useCase(
          startTime: startTime,
          durationHours: durationHours,
        );

        // Assert
        expect(result, null);
      });

      test('should return null for malformed time (missing colon)', () {
        // Arrange
        const startTime = '1400';
        const durationHours = 1;

        // Act
        final result = useCase(
          startTime: startTime,
          durationHours: durationHours,
        );

        // Assert
        expect(result, null);
      });

      test('should return null for empty string', () {
        // Arrange
        const startTime = '';
        const durationHours = 1;

        // Act
        final result = useCase(
          startTime: startTime,
          durationHours: durationHours,
        );

        // Assert
        expect(result, null);
      });

      test('should handle zero duration', () {
        // Arrange
        const startTime = '14:30';
        const durationHours = 0;

        // Act
        final result = useCase(
          startTime: startTime,
          durationHours: durationHours,
        );

        // Assert
        expect(result, '14:30');
      });

      test('should handle negative duration gracefully', () {
        // Arrange
        const startTime = '14:30';
        const durationHours = -1;

        // Act
        final result = useCase(
          startTime: startTime,
          durationHours: durationHours,
        );

        // Assert
        // Negative duration should result in earlier time
        expect(result, '13:30');
      });
    });
  });
}
