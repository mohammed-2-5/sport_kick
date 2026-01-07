import 'package:flutter_test/flutter_test.dart';
import 'package:spo_kick/features/bookings/domain/usecases/calculate_booking_price_usecase.dart';

void main() {
  late CalculateBookingPriceUseCase useCase;

  setUp(() {
    useCase = CalculateBookingPriceUseCase();
  });

  group('CalculateBookingPriceUseCase', () {
    group('standard calculations', () {
      test('should calculate price correctly for 1 hour duration', () {
        // Arrange
        const pricePerHour = 200.0;
        const durationHours = 1;

        // Act
        final result = useCase(
          pricePerHour: pricePerHour,
          durationHours: durationHours,
        );

        // Assert
        expect(result, 200.0);
      });

      test('should calculate price correctly for 2 hour duration', () {
        // Arrange
        const pricePerHour = 200.0;
        const durationHours = 2;

        // Act
        final result = useCase(
          pricePerHour: pricePerHour,
          durationHours: durationHours,
        );

        // Assert
        expect(result, 400.0);
      });

      test('should handle decimal price correctly', () {
        // Arrange
        const pricePerHour = 150.50;
        const durationHours = 2;

        // Act
        final result = useCase(
          pricePerHour: pricePerHour,
          durationHours: durationHours,
        );

        // Assert
        expect(result, 301.0);
      });

      test('should handle high price values', () {
        // Arrange
        const pricePerHour = 1000.0;
        const durationHours = 2;

        // Act
        final result = useCase(
          pricePerHour: pricePerHour,
          durationHours: durationHours,
        );

        // Assert
        expect(result, 2000.0);
      });

      test('should handle low price values', () {
        // Arrange
        const pricePerHour = 50.0;
        const durationHours = 1;

        // Act
        final result = useCase(
          pricePerHour: pricePerHour,
          durationHours: durationHours,
        );

        // Assert
        expect(result, 50.0);
      });
    });

    group('edge cases', () {
      test('should return zero for zero price', () {
        // Arrange
        const pricePerHour = 0.0;
        const durationHours = 2;

        // Act
        final result = useCase(
          pricePerHour: pricePerHour,
          durationHours: durationHours,
        );

        // Assert
        expect(result, 0.0);
      });

      test('should return zero for zero duration', () {
        // Arrange
        const pricePerHour = 200.0;
        const durationHours = 0;

        // Act
        final result = useCase(
          pricePerHour: pricePerHour,
          durationHours: durationHours,
        );

        // Assert
        expect(result, 0.0);
      });

      test('should handle both zero values', () {
        // Arrange
        const pricePerHour = 0.0;
        const durationHours = 0;

        // Act
        final result = useCase(
          pricePerHour: pricePerHour,
          durationHours: durationHours,
        );

        // Assert
        expect(result, 0.0);
      });

      test('should handle very small decimal prices', () {
        // Arrange
        const pricePerHour = 0.01;
        const durationHours = 2;

        // Act
        final result = useCase(
          pricePerHour: pricePerHour,
          durationHours: durationHours,
        );

        // Assert
        expect(result, 0.02);
      });

      test('should handle fractional currency amounts', () {
        // Arrange
        const pricePerHour = 99.99;
        const durationHours = 1;

        // Act
        final result = useCase(
          pricePerHour: pricePerHour,
          durationHours: durationHours,
        );

        // Assert
        expect(result, 99.99);
      });

      test('should preserve precision for decimal multiplication', () {
        // Arrange
        const pricePerHour = 33.33;
        const durationHours = 2;

        // Act
        final result = useCase(
          pricePerHour: pricePerHour,
          durationHours: durationHours,
        );

        // Assert
        expect(result, 66.66);
      });
    });

    group('real-world scenarios', () {
      test('should calculate typical Egyptian field price (200 EGP x 2h)', () {
        // Arrange
        const pricePerHour = 200.0;
        const durationHours = 2;

        // Act
        final result = useCase(
          pricePerHour: pricePerHour,
          durationHours: durationHours,
        );

        // Assert
        expect(result, 400.0);
      });

      test('should calculate premium field price (500 EGP x 1h)', () {
        // Arrange
        const pricePerHour = 500.0;
        const durationHours = 1;

        // Act
        final result = useCase(
          pricePerHour: pricePerHour,
          durationHours: durationHours,
        );

        // Assert
        expect(result, 500.0);
      });

      test('should calculate budget field price (100 EGP x 2h)', () {
        // Arrange
        const pricePerHour = 100.0;
        const durationHours = 2;

        // Act
        final result = useCase(
          pricePerHour: pricePerHour,
          durationHours: durationHours,
        );

        // Assert
        expect(result, 200.0);
      });
    });
  });
}
