import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/owner/domain/usecases/reject_booking_usecase.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late RejectBookingUseCase useCase;
  late MockOwnerRepository mockRepository;

  setUp(() {
    mockRepository = MockOwnerRepository();
    useCase = RejectBookingUseCase(mockRepository);
  });

  group('RejectBookingUseCase', () {
    const tBookingId = 'booking-123';
    const tReason = 'Field is unavailable';

    group('successful rejection', () {
      test('should return Right with void when rejection succeeds', () async {
        // Arrange
        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(bookingId: tBookingId, reason: tReason);

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.rejectBooking(tBookingId, tReason),
        ).called(1);
      });

      test('should call repository with correct parameters', () async {
        // Arrange
        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        await useCase(bookingId: tBookingId, reason: tReason);

        // Assert
        verify(
          () => mockRepository.rejectBooking(tBookingId, tReason),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should succeed with standard UUID booking ID', () async {
        // Arrange
        const standardUuidId = 'f47ac10b-58cc-4372-a567-0e02b2c3d479';

        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(
          bookingId: standardUuidId,
          reason: tReason,
        );

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.rejectBooking(standardUuidId, tReason),
        ).called(1);
      });

      test('should succeed with numeric booking ID', () async {
        // Arrange
        const numericId = '1234567890';

        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(bookingId: numericId, reason: tReason);

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle rejection with short reason', () async {
        // Arrange
        const shortReason = 'No';

        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          reason: shortReason,
        );

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.rejectBooking(tBookingId, shortReason),
        ).called(1);
      });

      test('should handle rejection with long reason', () async {
        // Arrange
        const longReason =
            'The field is currently under maintenance and unavailable for bookings. '
            'We apologize for any inconvenience caused. Please try booking another time.';

        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(bookingId: tBookingId, reason: longReason);

        // Assert
        expect(result.isRight(), true);
      });

      test(
        'should handle rejection with special characters in reason',
        () async {
          // Arrange
          const specialReason = "Can't provide field! Issue @ location #1 :(";

          when(
            () => mockRepository.rejectBooking(any(), any()),
          ).thenAnswer((_) async => const Right<Failure, void>(null));

          // Act
          final result = await useCase(
            bookingId: tBookingId,
            reason: specialReason,
          );

          // Assert
          expect(result.isRight(), true);
        },
      );

      test('should handle rejection with Arabic reason', () async {
        // Arrange
        const arabicReason = 'الملعب غير متاح حالياً';

        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          reason: arabicReason,
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle rejection with mixed language reason', () async {
        // Arrange
        const mixedReason = 'Field unavailable - الملعب غير متاح';

        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          reason: mixedReason,
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept reason with leading/trailing whitespace', () async {
        // Arrange
        const reasonWithWhitespace = '  Field is unavailable  ';

        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          reason: reasonWithWhitespace,
        );

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.rejectBooking(tBookingId, reasonWithWhitespace),
        ).called(1);
      });

      test('should accept reason with single character', () async {
        // Arrange
        const singleChar = 'X';

        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(bookingId: tBookingId, reason: singleChar);

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept reason with numbers', () async {
        // Arrange
        const numberReason = '123 456 789';

        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          reason: numberReason,
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept reason with punctuation', () async {
        // Arrange
        const punctuationReason = 'Field unavailable, try later! Yes?';

        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          reason: punctuationReason,
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept reason with emojis', () async {
        // Arrange
        const emojiReason = 'Field under maintenance ⛔🔧';

        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          reason: emojiReason,
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept reason with URLs', () async {
        // Arrange
        const urlReason = 'See details at https://example.com/info';

        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(bookingId: tBookingId, reason: urlReason);

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept reason with line breaks', () async {
        // Arrange
        const multilineReason = 'Line 1\nLine 2\nLine 3';

        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          reason: multilineReason,
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept reason with tabs', () async {
        // Arrange
        const tabReason = 'Field\tStatus:\tUnderMaintenance';

        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(bookingId: tBookingId, reason: tabReason);

        // Assert
        expect(result.isRight(), true);
      });
    });

    group('repository failures', () {
      test('should return ServerFailure when repository call fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to reject booking');
        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(bookingId: tBookingId, reason: tReason);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure when network error occurs', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(bookingId: tBookingId, reason: tReason);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure when booking not found', () async {
        // Arrange
        const tFailure = ServerFailure('Booking not found');
        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(
          bookingId: 'non-existent-id',
          reason: tReason,
        );

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test(
        'should return ServerFailure when booking already rejected',
        () async {
          // Arrange
          const tFailure = ServerFailure('Booking is already rejected');
          when(
            () => mockRepository.rejectBooking(any(), any()),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(bookingId: tBookingId, reason: tReason);

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );

      test('should return ServerFailure when user unauthorized', () async {
        // Arrange
        const tFailure = ServerFailure(
          'You are not authorized to reject this booking',
        );
        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(bookingId: tBookingId, reason: tReason);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test(
        'should return ServerFailure when booking cannot be rejected',
        () async {
          // Arrange
          const tFailure = ServerFailure(
            'Booking is in invalid state for rejection',
          );
          when(
            () => mockRepository.rejectBooking(any(), any()),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(bookingId: tBookingId, reason: tReason);

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );

      test('should return CacheFailure when local cache fails', () async {
        // Arrange
        const tFailure = CacheFailure('Cache operation failed');
        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(bookingId: tBookingId, reason: tReason);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure when reason storage fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to store rejection reason');
        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(bookingId: tBookingId, reason: tReason);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });

    group('edge cases', () {
      test('should handle booking ID with special characters', () async {
        // Arrange
        const specialBookingId = 'booking-123-456_xyz.v1';

        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(
          bookingId: specialBookingId,
          reason: tReason,
        );

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.rejectBooking(specialBookingId, tReason),
        ).called(1);
      });

      test('should handle very long booking ID', () async {
        // Arrange
        final longBookingId = 'booking-${'1234567890' * 10}';

        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(bookingId: longBookingId, reason: tReason);

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle very long reason (1000 chars)', () async {
        // Arrange
        final longReason = 'A' * 1000;

        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(bookingId: tBookingId, reason: longReason);

        // Assert
        expect(result.isRight(), true);
      });

      test(
        'should preserve booking ID and reason exactly as provided',
        () async {
          // Arrange
          const exactBookingId = '  Booking-123  ';
          const exactReason = '  Field unavailable  ';

          when(
            () => mockRepository.rejectBooking(any(), any()),
          ).thenAnswer((_) async => const Right<Failure, void>(null));

          // Act
          await useCase(bookingId: exactBookingId, reason: exactReason);

          // Assert
          verify(
            () => mockRepository.rejectBooking(exactBookingId, exactReason),
          ).called(1);
        },
      );

      test('should call repository only once', () async {
        // Arrange
        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        await useCase(bookingId: tBookingId, reason: tReason);

        // Assert
        verify(
          () => mockRepository.rejectBooking(tBookingId, tReason),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle concurrent calls independently', () async {
        // Arrange
        const id1 = 'booking-1';
        const id2 = 'booking-2';
        const reason1 = 'Reason 1';
        const reason2 = 'Reason 2';

        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final future1 = useCase(bookingId: id1, reason: reason1);
        final future2 = useCase(bookingId: id2, reason: reason2);

        final results = await Future.wait([future1, future2]);

        // Assert
        expect(results[0].isRight(), true);
        expect(results[1].isRight(), true);
        verify(() => mockRepository.rejectBooking(id1, reason1)).called(1);
        verify(() => mockRepository.rejectBooking(id2, reason2)).called(1);
      });

      test(
        'should handle reason with newlines and special whitespace',
        () async {
          // Arrange
          const complexReason = 'Line1\nLine2\rLine3\r\nLine4';

          when(
            () => mockRepository.rejectBooking(any(), any()),
          ).thenAnswer((_) async => const Right<Failure, void>(null));

          // Act
          final result = await useCase(
            bookingId: tBookingId,
            reason: complexReason,
          );

          // Assert
          expect(result.isRight(), true);
        },
      );

      test('should handle booking ID with numbers at end', () async {
        // Arrange
        const numericEndId = 'booking-123456789';

        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(bookingId: numericEndId, reason: tReason);

        // Assert
        expect(result.isRight(), true);
      });

      test(
        'should handle empty string booking ID (passed to repository)',
        () async {
          // Arrange - This tests that UseCase doesn't validate, passes to repo
          when(
            () => mockRepository.rejectBooking(any(), any()),
          ).thenAnswer((_) async => const Right<Failure, void>(null));

          // Act
          final result = await useCase(bookingId: '', reason: tReason);

          // Assert - Repository is called even with empty string
          expect(result.isRight(), true);
          verify(() => mockRepository.rejectBooking('', tReason)).called(1);
        },
      );

      test(
        'should handle empty string reason (passed to repository)',
        () async {
          // Arrange - This tests that UseCase doesn't validate, passes to repo
          when(
            () => mockRepository.rejectBooking(any(), any()),
          ).thenAnswer((_) async => const Right<Failure, void>(null));

          // Act
          final result = await useCase(bookingId: tBookingId, reason: '');

          // Assert - Repository is called even with empty reason
          expect(result.isRight(), true);
          verify(() => mockRepository.rejectBooking(tBookingId, '')).called(1);
        },
      );

      test('should handle very long reason with mixed content', () async {
        // Arrange
        final complexReason =
            'Reason with ${'mixed123@!#content' * 50} and more data';

        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          reason: complexReason,
        );

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
          const exactReason = '  UnAvailable  ';

          when(
            () => mockRepository.rejectBooking(any(), any()),
          ).thenAnswer((_) async => const Right<Failure, void>(null));

          // Act
          await useCase(bookingId: exactId, reason: exactReason);

          // Assert
          verify(
            () => mockRepository.rejectBooking(exactId, exactReason),
          ).called(1);
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
            () => mockRepository.rejectBooking(any(), any()),
          ).thenAnswer((_) async => const Right<Failure, void>(null));

          final result = await useCase(bookingId: id, reason: tReason);

          expect(
            result.isRight(),
            true,
            reason: 'Should accept booking ID: $id',
          );
        }
      });

      test('should work with different reason formats', () async {
        // Test that UseCase works with any reason format - validation is repository responsibility
        final testReasons = [
          'simple',
          'with-dashes',
          'with_underscores',
          '123 456',
          'MixedCase Reason',
          'multiple words in reason',
        ];

        for (final reason in testReasons) {
          when(
            () => mockRepository.rejectBooking(any(), any()),
          ).thenAnswer((_) async => const Right<Failure, void>(null));

          final result = await useCase(bookingId: tBookingId, reason: reason);

          expect(
            result.isRight(),
            true,
            reason: 'Should accept reason: $reason',
          );
        }
      });

      test('should return repository error without modification', () async {
        // Arrange
        const tFailure = ServerFailure('Custom error from repository');
        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(bookingId: tBookingId, reason: tReason);

        // Assert - Error should be returned as-is
        expect(result, equals(const Left(tFailure)));
      });

      test('should handle same booking ID with different reasons', () async {
        // Arrange
        when(
          () => mockRepository.rejectBooking(any(), any()),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result1 = await useCase(
          bookingId: 'booking-same',
          reason: 'Reason 1',
        );
        final result2 = await useCase(
          bookingId: 'booking-same',
          reason: 'Reason 2',
        );

        // Assert
        expect(result1.isRight(), true);
        expect(result2.isRight(), true);
        verify(
          () => mockRepository.rejectBooking('booking-same', 'Reason 1'),
        ).called(1);
        verify(
          () => mockRepository.rejectBooking('booking-same', 'Reason 2'),
        ).called(1);
      });

      test(
        'should handle rapid successive calls with different parameters',
        () async {
          // Arrange
          when(
            () => mockRepository.rejectBooking(any(), any()),
          ).thenAnswer((_) async => const Right<Failure, void>(null));

          // Act
          final results = await Future.wait([
            useCase(bookingId: 'booking-1', reason: 'Reason 1'),
            useCase(bookingId: 'booking-2', reason: 'Reason 2'),
            useCase(bookingId: 'booking-3', reason: 'Reason 3'),
          ]);

          // Assert
          expect(results.length, 3);
          expect(results.every((r) => r.isRight()), true);
          verify(() => mockRepository.rejectBooking(any(), any())).called(3);
        },
      );
    });
  });
}
