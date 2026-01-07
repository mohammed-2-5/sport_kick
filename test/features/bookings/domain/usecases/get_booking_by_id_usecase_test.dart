import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/usecases/get_booking_by_id_usecase.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late GetBookingByIdUseCase useCase;
  late MockBookingRepository mockRepository;

  setUp(() {
    mockRepository = MockBookingRepository();
    useCase = GetBookingByIdUseCase(mockRepository);
  });

  group('GetBookingByIdUseCase', () {
    const tBookingId = 'booking-123';

    final tBookingEntity = BookingEntity(
      id: tBookingId,
      userId: 'user-1',
      fieldId: 'field-1',
      date: DateTime(2026, 1, 15),
      startTime: '09:00',
      endTime: '10:00',
      status: BookingStatus.confirmed,
      totalPrice: 200.0,
      currency: 'EGP',
      createdAt: DateTime.now(),
      fieldName: 'Test Field',
      userName: 'John Doe',
    );

    group('successful retrieval', () {
      test(
        'should return BookingEntity when repository call succeeds',
        () async {
          // Arrange
          when(
            () => mockRepository.getBookingById(any()),
          ).thenAnswer((_) async => Right(tBookingEntity));

          // Act
          final result = await useCase(tBookingId);

          // Assert
          expect(result.isRight(), true);
          expect(
            result.getOrElse(() => tBookingEntity),
            equals(tBookingEntity),
          );
          verify(() => mockRepository.getBookingById(tBookingId)).called(1);
        },
      );

      test('should call repository with correct booking ID', () async {
        // Arrange
        when(
          () => mockRepository.getBookingById(any()),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        await useCase(tBookingId);

        // Assert
        verify(() => mockRepository.getBookingById(tBookingId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should return booking with pending status', () async {
        // Arrange
        final pendingBooking = tBookingEntity.copyWith(
          status: BookingStatus.pending,
        );

        when(
          () => mockRepository.getBookingById(any()),
        ).thenAnswer((_) async => Right(pendingBooking));

        // Act
        final result = await useCase(tBookingId);

        // Assert
        expect(result.isRight(), true);
        final booking = result.getOrElse(() => tBookingEntity);
        expect(booking.status, BookingStatus.pending);
      });

      test('should return booking with confirmed status', () async {
        // Arrange
        final confirmedBooking = tBookingEntity.copyWith(
          status: BookingStatus.confirmed,
        );

        when(
          () => mockRepository.getBookingById(any()),
        ).thenAnswer((_) async => Right(confirmedBooking));

        // Act
        final result = await useCase(tBookingId);

        // Assert
        expect(result.isRight(), true);
        final booking = result.getOrElse(() => tBookingEntity);
        expect(booking.status, BookingStatus.confirmed);
      });

      test('should return booking with canceled status', () async {
        // Arrange
        final canceledBooking = tBookingEntity.copyWith(
          status: BookingStatus.canceled,
          cancellationReason: 'Changed plans',
          canceledAt: DateTime.now(),
        );

        when(
          () => mockRepository.getBookingById(any()),
        ).thenAnswer((_) async => Right(canceledBooking));

        // Act
        final result = await useCase(tBookingId);

        // Assert
        expect(result.isRight(), true);
        final booking = result.getOrElse(() => tBookingEntity);
        expect(booking.status, BookingStatus.canceled);
        expect(booking.cancellationReason, 'Changed plans');
      });

      test('should return booking with completed status', () async {
        // Arrange
        final completedBooking = tBookingEntity.copyWith(
          status: BookingStatus.completed,
        );

        when(
          () => mockRepository.getBookingById(any()),
        ).thenAnswer((_) async => Right(completedBooking));

        // Act
        final result = await useCase(tBookingId);

        // Assert
        expect(result.isRight(), true);
        final booking = result.getOrElse(() => tBookingEntity);
        expect(booking.status, BookingStatus.completed);
      });

      test('should return manual booking with customer info', () async {
        // Arrange
        final manualBooking = tBookingEntity.copyWith(
          isManual: true,
          customerName: 'Ahmed Mohamed',
          customerPhone: '01012345678',
        );

        when(
          () => mockRepository.getBookingById(any()),
        ).thenAnswer((_) async => Right(manualBooking));

        // Act
        final result = await useCase(tBookingId);

        // Assert
        expect(result.isRight(), true);
        final booking = result.getOrElse(() => tBookingEntity);
        expect(booking.isManual, true);
        expect(booking.customerName, 'Ahmed Mohamed');
        expect(booking.customerPhone, '01012345678');
      });
    });

    group('validation failures', () {
      test(
        'should return ValidationFailure when booking ID is empty',
        () async {
          // Act
          final result = await useCase('');

          // Assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure, isA<ValidationFailure>());
            expect(
              (failure as ValidationFailure).message,
              'Booking ID is required',
            );
          }, (_) => fail('Should return failure'));
          verifyNever(() => mockRepository.getBookingById(any()));
        },
      );

      test(
        'should return ValidationFailure when booking ID is only whitespace',
        () async {
          // Act
          final result = await useCase('   ');

          // Assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure, isA<ValidationFailure>());
            expect(
              (failure as ValidationFailure).message,
              'Booking ID is required',
            );
          }, (_) => fail('Should return failure'));
          verifyNever(() => mockRepository.getBookingById(any()));
        },
      );

      test(
        'should return ValidationFailure when booking ID is tabs and newlines',
        () async {
          // Act
          final result = await useCase('  \t  \n  ');

          // Assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure, isA<ValidationFailure>());
          }, (_) => fail('Should return failure'));
        },
      );
    });

    group('valid booking IDs', () {
      test(
        'should accept booking ID with leading/trailing whitespace',
        () async {
          // Arrange
          const bookingIdWithWhitespace = '  booking-123  ';

          when(
            () => mockRepository.getBookingById(any()),
          ).thenAnswer((_) async => Right(tBookingEntity));

          // Act
          final result = await useCase(bookingIdWithWhitespace);

          // Assert
          expect(result.isRight(), true);
          verify(
            () => mockRepository.getBookingById(bookingIdWithWhitespace),
          ).called(1);
        },
      );

      test('should accept booking ID with special characters', () async {
        // Arrange
        const specialBookingId = 'booking-123_456-xyz';

        when(
          () => mockRepository.getBookingById(any()),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(specialBookingId);

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept very long booking ID', () async {
        // Arrange
        final longBookingId = 'booking-${'1234567890' * 10}';

        when(
          () => mockRepository.getBookingById(any()),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(longBookingId);

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept single character booking ID', () async {
        // Arrange
        const shortBookingId = '1';

        when(
          () => mockRepository.getBookingById(any()),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(shortBookingId);

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept UUID format booking ID', () async {
        // Arrange
        const uuidBookingId = '550e8400-e29b-41d4-a716-446655440000';

        when(
          () => mockRepository.getBookingById(any()),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(uuidBookingId);

        // Assert
        expect(result.isRight(), true);
      });
    });

    group('repository failures', () {
      test('should return ServerFailure when repository call fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to get booking');
        when(
          () => mockRepository.getBookingById(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tBookingId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure when network error occurs', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.getBookingById(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tBookingId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure when booking not found', () async {
        // Arrange
        const tFailure = ServerFailure('Booking not found');
        when(
          () => mockRepository.getBookingById(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase('non-existent-id');

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure when user unauthorized', () async {
        // Arrange
        const tFailure = ServerFailure(
          'You are not authorized to view this booking',
        );
        when(
          () => mockRepository.getBookingById(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tBookingId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure when database error occurs', () async {
        // Arrange
        const tFailure = ServerFailure('Database error');
        when(
          () => mockRepository.getBookingById(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tBookingId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });

    group('edge cases', () {
      test('should call repository only once', () async {
        // Arrange
        when(
          () => mockRepository.getBookingById(any()),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        await useCase(tBookingId);

        // Assert
        verify(() => mockRepository.getBookingById(tBookingId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should preserve exact booking ID passed to repository', () async {
        // Arrange
        const exactId = '  booking-with-spaces  ';

        when(
          () => mockRepository.getBookingById(any()),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        await useCase(exactId);

        // Assert
        verify(() => mockRepository.getBookingById(exactId)).called(1);
      });

      test(
        'should handle booking with all optional fields populated',
        () async {
          // Arrange
          final fullBooking = BookingEntity(
            id: tBookingId,
            userId: 'user-1',
            fieldId: 'field-1',
            date: DateTime(2026, 1, 15),
            startTime: '09:00',
            endTime: '10:00',
            status: BookingStatus.confirmed,
            totalPrice: 200.0,
            currency: 'EGP',
            createdAt: DateTime.now(),
            confirmedAt: DateTime.now(),
            userName: 'John Doe',
            fieldName: 'Test Field',
            fieldImage: 'https://example.com/image.jpg',
            notes: 'Test notes',
            durationHours: 1,
            invoiceNumber: 'INV-20260115-0001',
          );

          when(
            () => mockRepository.getBookingById(any()),
          ).thenAnswer((_) async => Right(fullBooking));

          // Act
          final result = await useCase(tBookingId);

          // Assert
          expect(result.isRight(), true);
          final booking = result.getOrElse(() => tBookingEntity);
          expect(booking.userName, 'John Doe');
          expect(booking.fieldName, 'Test Field');
          expect(booking.notes, 'Test notes');
          expect(booking.invoiceNumber, 'INV-20260115-0001');
        },
      );

      test('should handle booking with minimal required fields', () async {
        // Arrange
        final minimalBooking = BookingEntity(
          id: tBookingId,
          userId: 'user-1',
          fieldId: 'field-1',
          date: DateTime(2026, 1, 15),
          startTime: '09:00',
          endTime: '10:00',
          status: BookingStatus.pending,
          totalPrice: 200.0,
          currency: 'EGP',
          createdAt: DateTime.now(),
        );

        when(
          () => mockRepository.getBookingById(any()),
        ).thenAnswer((_) async => Right(minimalBooking));

        // Act
        final result = await useCase(tBookingId);

        // Assert
        expect(result.isRight(), true);
        final booking = result.getOrElse(() => tBookingEntity);
        expect(booking.id, tBookingId);
        expect(booking.status, BookingStatus.pending);
      });
    });
  });
}
