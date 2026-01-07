import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/owner/domain/usecases/approve_booking_usecase.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late ApproveBookingUseCase useCase;
  late MockOwnerRepository mockRepository;

  setUp(() {
    mockRepository = MockOwnerRepository();
    useCase = ApproveBookingUseCase(mockRepository);
  });

  group('ApproveBookingUseCase', () {
    const tBookingId = 'booking-123';

    group('successful approval', () {
      test('should return Right with void when approval succeeds', () async {
        // Arrange
        when(
          () => mockRepository.approveBooking(any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(bookingId: tBookingId);

        // Assert
        expect(result.isRight(), true);
        verify(() => mockRepository.approveBooking(tBookingId)).called(1);
      });

      test('should call repository with correct booking ID', () async {
        // Arrange
        when(
          () => mockRepository.approveBooking(any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        await useCase(bookingId: tBookingId);

        // Assert
        verify(() => mockRepository.approveBooking(tBookingId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should succeed with standard UUID booking ID', () async {
        // Arrange
        const standardUuidId = 'f47ac10b-58cc-4372-a567-0e02b2c3d479';

        when(
          () => mockRepository.approveBooking(any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(bookingId: standardUuidId);

        // Assert
        expect(result.isRight(), true);
        verify(() => mockRepository.approveBooking(standardUuidId)).called(1);
      });

      test('should succeed with numeric booking ID', () async {
        // Arrange
        const numericId = '1234567890';

        when(
          () => mockRepository.approveBooking(any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(bookingId: numericId);

        // Assert
        expect(result.isRight(), true);
      });

      test('should succeed with hyphenated booking ID', () async {
        // Arrange
        const hyphenatedId = 'booking-2024-01-15-123';

        when(
          () => mockRepository.approveBooking(any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(bookingId: hyphenatedId);

        // Assert
        expect(result.isRight(), true);
        verify(() => mockRepository.approveBooking(hyphenatedId)).called(1);
      });

      test(
        'should accept booking ID with leading/trailing whitespace',
        () async {
          // Arrange
          const idWithWhitespace = '  booking-123  ';

          when(
            () => mockRepository.approveBooking(any()),
          ).thenAnswer((_) async => const Right<Failure, void>(null));

          // Act
          final result = await useCase(bookingId: idWithWhitespace);

          // Assert
          expect(result.isRight(), true);
          verify(
            () => mockRepository.approveBooking(idWithWhitespace),
          ).called(1);
        },
      );

      test('should accept short booking ID', () async {
        // Arrange
        const shortId = 'b1';

        when(
          () => mockRepository.approveBooking(any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(bookingId: shortId);

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept long booking ID', () async {
        // Arrange
        final longId = 'booking-${'1234567890' * 10}';

        when(
          () => mockRepository.approveBooking(any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(bookingId: longId);

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept booking ID with special characters', () async {
        // Arrange
        const specialId = 'booking-123_456-xyz.v1';

        when(
          () => mockRepository.approveBooking(any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(bookingId: specialId);

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept booking ID with single character', () async {
        // Arrange
        const singleChar = 'b';

        when(
          () => mockRepository.approveBooking(any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(bookingId: singleChar);

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept booking ID with uppercase letters', () async {
        // Arrange
        const uppercaseId = 'BOOKING-ABC-123-XYZ';

        when(
          () => mockRepository.approveBooking(any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(bookingId: uppercaseId);

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept booking ID with mixed case', () async {
        // Arrange
        const mixedCaseId = 'BoOkInG-123';

        when(
          () => mockRepository.approveBooking(any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(bookingId: mixedCaseId);

        // Assert
        expect(result.isRight(), true);
      });
    });

    group('repository failures', () {
      test('should return ServerFailure when repository call fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to approve booking');
        when(
          () => mockRepository.approveBooking(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(bookingId: tBookingId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure when network error occurs', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.approveBooking(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(bookingId: tBookingId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure when booking not found', () async {
        // Arrange
        const tFailure = ServerFailure('Booking not found');
        when(
          () => mockRepository.approveBooking(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(bookingId: 'non-existent-id');

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test(
        'should return ServerFailure when booking already approved',
        () async {
          // Arrange
          const tFailure = ServerFailure('Booking is already confirmed');
          when(
            () => mockRepository.approveBooking(any()),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(bookingId: tBookingId);

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );

      test('should return ServerFailure when user unauthorized', () async {
        // Arrange
        const tFailure = ServerFailure(
          'You are not authorized to approve this booking',
        );
        when(
          () => mockRepository.approveBooking(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(bookingId: tBookingId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test(
        'should return ServerFailure when booking is already canceled',
        () async {
          // Arrange
          const tFailure = ServerFailure('Cannot approve a canceled booking');
          when(
            () => mockRepository.approveBooking(any()),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(bookingId: tBookingId);

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );

      test(
        'should return ServerFailure when booking is in invalid state',
        () async {
          // Arrange
          const tFailure = ServerFailure(
            'Booking is in invalid state for approval',
          );
          when(
            () => mockRepository.approveBooking(any()),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(bookingId: tBookingId);

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );

      test('should return CacheFailure when local cache fails', () async {
        // Arrange
        const tFailure = CacheFailure('Cache operation failed');
        when(
          () => mockRepository.approveBooking(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(bookingId: tBookingId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });

    group('edge cases', () {
      test('should handle booking ID with leading zeros', () async {
        // Arrange
        const zeroLeadingId = '000123456789';

        when(
          () => mockRepository.approveBooking(any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(bookingId: zeroLeadingId);

        // Assert
        expect(result.isRight(), true);
        verify(() => mockRepository.approveBooking(zeroLeadingId)).called(1);
      });

      test('should handle booking ID with underscores', () async {
        // Arrange
        const underscoredId = 'booking_123_456_xyz';

        when(
          () => mockRepository.approveBooking(any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(bookingId: underscoredId);

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle very long booking ID (1000 chars)', () async {
        // Arrange
        final veryLongId = 'b' + ('1234567890' * 100);

        when(
          () => mockRepository.approveBooking(any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(bookingId: veryLongId);

        // Assert
        expect(result.isRight(), true);
      });

      test('should preserve booking ID exactly as provided', () async {
        // Arrange
        const exactId = '  Booking-123  ';

        when(
          () => mockRepository.approveBooking(any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        await useCase(bookingId: exactId);

        // Assert
        verify(() => mockRepository.approveBooking(exactId)).called(1);
      });

      test('should call repository only once', () async {
        // Arrange
        when(
          () => mockRepository.approveBooking(any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        await useCase(bookingId: tBookingId);

        // Assert
        verify(() => mockRepository.approveBooking(tBookingId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle concurrent calls independently', () async {
        // Arrange
        const id1 = 'booking-1';
        const id2 = 'booking-2';

        when(
          () => mockRepository.approveBooking(any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final future1 = useCase(bookingId: id1);
        final future2 = useCase(bookingId: id2);

        final results = await Future.wait([future1, future2]);

        // Assert
        expect(results[0].isRight(), true);
        expect(results[1].isRight(), true);
        verify(() => mockRepository.approveBooking(id1)).called(1);
        verify(() => mockRepository.approveBooking(id2)).called(1);
      });

      test('should handle booking ID with dots', () async {
        // Arrange
        const idWithDots = 'booking.123.456';

        when(
          () => mockRepository.approveBooking(any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(bookingId: idWithDots);

        // Assert
        expect(result.isRight(), true);
      });

      test(
        'should handle booking ID with dashes and underscores combined',
        () async {
          // Arrange
          const complexId = 'booking-123_456-789_xyz';

          when(
            () => mockRepository.approveBooking(any()),
          ).thenAnswer((_) async => const Right<Failure, void>(null));

          // Act
          final result = await useCase(bookingId: complexId);

          // Assert
          expect(result.isRight(), true);
        },
      );

      test(
        'should handle empty string booking ID (passed to repository)',
        () async {
          // Arrange - This tests that UseCase doesn't validate, passes to repo
          when(
            () => mockRepository.approveBooking(any()),
          ).thenAnswer((_) async => const Right<Failure, void>(null));

          // Act
          final result = await useCase(bookingId: '');

          // Assert - Repository is called even with empty string
          expect(result.isRight(), true);
          verify(() => mockRepository.approveBooking('')).called(1);
        },
      );

      test(
        'should pass exact booking ID to repository without modification',
        () async {
          // Arrange
          const exactId = 'ExAcT-BoOkInG-123';

          when(
            () => mockRepository.approveBooking(any()),
          ).thenAnswer((_) async => const Right<Failure, void>(null));

          // Act
          await useCase(bookingId: exactId);

          // Assert
          verify(() => mockRepository.approveBooking(exactId)).called(1);
        },
      );

      test('should handle rapid successive calls', () async {
        // Arrange
        when(
          () => mockRepository.approveBooking(any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final results = await Future.wait([
          useCase(bookingId: 'booking-1'),
          useCase(bookingId: 'booking-2'),
          useCase(bookingId: 'booking-3'),
        ]);

        // Assert
        expect(results.length, 3);
        expect(results.every((r) => r.isRight()), true);
        verify(() => mockRepository.approveBooking(any())).called(3);
      });

      test('should handle booking ID with whitespace in middle', () async {
        // Arrange
        const idWithSpace = 'booking 123';

        when(
          () => mockRepository.approveBooking(any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(bookingId: idWithSpace);

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle booking ID with special punctuation', () async {
        // Arrange
        const specialId = 'booking-123!@#\$%';

        when(
          () => mockRepository.approveBooking(any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(bookingId: specialId);

        // Assert
        expect(result.isRight(), true);
      });
    });

    group('repository interaction verification', () {
      test(
        'should pass exact values to repository without modification',
        () async {
          // Arrange
          const exactId = '  BookinG-123  ';

          when(
            () => mockRepository.approveBooking(any()),
          ).thenAnswer((_) async => const Right<Failure, void>(null));

          // Act
          await useCase(bookingId: exactId);

          // Assert
          verify(() => mockRepository.approveBooking(exactId)).called(1);
        },
      );

      test('should work with different booking ID formats', () async {
        // Test that UseCase works with any ID format - validation is repository responsibility
        final testIds = [
          'simple',
          'with-dashes',
          'with_underscores',
          '12345',
          'MixedCase123',
          'with.dots',
        ];

        for (final id in testIds) {
          when(
            () => mockRepository.approveBooking(any()),
          ).thenAnswer((_) async => const Right<Failure, void>(null));

          final result = await useCase(bookingId: id);

          expect(
            result.isRight(),
            true,
            reason: 'Should accept booking ID: $id',
          );
        }
      });

      test('should return repository error without modification', () async {
        // Arrange
        const tFailure = ServerFailure('Custom error from repository');
        when(
          () => mockRepository.approveBooking(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(bookingId: tBookingId);

        // Assert - Error should be returned as-is
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
