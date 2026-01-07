import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/usecases/create_manual_booking_usecase.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late CreateManualBookingUseCase useCase;
  late MockBookingRepository mockRepository;

  setUp(() {
    mockRepository = MockBookingRepository();
    useCase = CreateManualBookingUseCase(mockRepository);
  });

  group('CreateManualBookingUseCase', () {
    const tFieldId = 'field-123';
    final tDate = DateTime(2026, 1, 15); // Future date
    const tStartTime = '09:00';
    const tEndTime = '11:00';
    const tTotalPrice = 400.0;
    const tCustomerName = 'Ahmed Mohamed';
    const tCustomerPhone = '01012345678';
    const tCustomerEmail = 'ahmed@example.com';
    const tNotes = 'Walk-in customer';

    final tBookingEntity = BookingEntity(
      id: 'booking-123',
      userId: 'user-1',
      fieldId: tFieldId,
      date: tDate,
      startTime: tStartTime,
      endTime: tEndTime,
      status: BookingStatus.confirmed,
      totalPrice: tTotalPrice,
      currency: 'EGP',
      createdAt: DateTime.now(),
      isManual: true,
      customerName: tCustomerName,
      customerPhone: tCustomerPhone,
      customerEmail: tCustomerEmail,
      notes: tNotes,
    );

    group('successful manual booking creation', () {
      test(
        'should return BookingEntity when manual booking creation succeeds',
        () async {
          // Arrange
          when(
            () => mockRepository.createManualBooking(
              fieldId: any(named: 'fieldId'),
              date: any(named: 'date'),
              startTime: any(named: 'startTime'),
              endTime: any(named: 'endTime'),
              totalPrice: any(named: 'totalPrice'),
              customerName: any(named: 'customerName'),
              customerPhone: any(named: 'customerPhone'),
              customerEmail: any(named: 'customerEmail'),
              notes: any(named: 'notes'),
            ),
          ).thenAnswer((_) async => Right(tBookingEntity));

          // Act
          final result = await useCase(
            fieldId: tFieldId,
            date: tDate,
            startTime: tStartTime,
            endTime: tEndTime,
            totalPrice: tTotalPrice,
            customerName: tCustomerName,
            customerPhone: tCustomerPhone,
            customerEmail: tCustomerEmail,
            notes: tNotes,
          );

          // Assert
          expect(result.isRight(), true);
          expect(
            result.getOrElse(() => tBookingEntity),
            equals(tBookingEntity),
          );
          verify(
            () => mockRepository.createManualBooking(
              fieldId: tFieldId,
              date: tDate,
              startTime: tStartTime,
              endTime: tEndTime,
              totalPrice: tTotalPrice,
              customerName: tCustomerName,
              customerPhone: tCustomerPhone,
              customerEmail: tCustomerEmail,
              notes: tNotes,
            ),
          ).called(1);
        },
      );

      test('should succeed without email (email is optional)', () async {
        // Arrange
        when(
          () => mockRepository.createManualBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            customerName: any(named: 'customerName'),
            customerPhone: any(named: 'customerPhone'),
            customerEmail: any(named: 'customerEmail'),
            notes: any(named: 'notes'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          customerName: tCustomerName,
          customerPhone: tCustomerPhone,
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should succeed without notes (notes is optional)', () async {
        // Arrange
        when(
          () => mockRepository.createManualBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            customerName: any(named: 'customerName'),
            customerPhone: any(named: 'customerPhone'),
            customerEmail: any(named: 'customerEmail'),
            notes: any(named: 'notes'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          customerName: tCustomerName,
          customerPhone: tCustomerPhone,
          customerEmail: tCustomerEmail,
        );

        // Assert
        expect(result.isRight(), true);
      });

      test(
        'should trim and clean customer name before passing to repository',
        () async {
          // Arrange
          const nameWithWhitespace = '  Ahmed Mohamed  ';

          when(
            () => mockRepository.createManualBooking(
              fieldId: any(named: 'fieldId'),
              date: any(named: 'date'),
              startTime: any(named: 'startTime'),
              endTime: any(named: 'endTime'),
              totalPrice: any(named: 'totalPrice'),
              customerName: any(named: 'customerName'),
              customerPhone: any(named: 'customerPhone'),
              customerEmail: any(named: 'customerEmail'),
              notes: any(named: 'notes'),
            ),
          ).thenAnswer((_) async => Right(tBookingEntity));

          // Act
          await useCase(
            fieldId: tFieldId,
            date: tDate,
            startTime: tStartTime,
            endTime: tEndTime,
            totalPrice: tTotalPrice,
            customerName: nameWithWhitespace,
            customerPhone: tCustomerPhone,
          );

          // Assert
          verify(
            () => mockRepository.createManualBooking(
              fieldId: tFieldId,
              date: tDate,
              startTime: tStartTime,
              endTime: tEndTime,
              totalPrice: tTotalPrice,
              customerName: 'Ahmed Mohamed',
              customerPhone: tCustomerPhone,
              customerEmail: null,
              notes: null,
            ),
          ).called(1);
        },
      );

      test('should clean phone number (remove spaces and dashes)', () async {
        // Arrange
        const phoneWithSpaces = '010 1234 5678';

        when(
          () => mockRepository.createManualBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            customerName: any(named: 'customerName'),
            customerPhone: any(named: 'customerPhone'),
            customerEmail: any(named: 'customerEmail'),
            notes: any(named: 'notes'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          customerName: tCustomerName,
          customerPhone: phoneWithSpaces,
        );

        // Assert
        verify(
          () => mockRepository.createManualBooking(
            fieldId: tFieldId,
            date: tDate,
            startTime: tStartTime,
            endTime: tEndTime,
            totalPrice: tTotalPrice,
            customerName: tCustomerName,
            customerPhone: '01012345678',
            customerEmail: null,
            notes: null,
          ),
        ).called(1);
      });
    });

    group('date validation', () {
      test(
        'should return ValidationFailure when date is in the past',
        () async {
          // Arrange
          final pastDate = DateTime(2025, 12, 1);

          // Act
          final result = await useCase(
            fieldId: tFieldId,
            date: pastDate,
            startTime: tStartTime,
            endTime: tEndTime,
            totalPrice: tTotalPrice,
            customerName: tCustomerName,
            customerPhone: tCustomerPhone,
          );

          // Assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure, isA<ValidationFailure>());
            expect(
              (failure as ValidationFailure).message,
              'Cannot book a date in the past',
            );
          }, (_) => fail('Should return failure'));
          verifyNever(
            () => mockRepository.createManualBooking(
              fieldId: any(named: 'fieldId'),
              date: any(named: 'date'),
              startTime: any(named: 'startTime'),
              endTime: any(named: 'endTime'),
              totalPrice: any(named: 'totalPrice'),
              customerName: any(named: 'customerName'),
              customerPhone: any(named: 'customerPhone'),
              customerEmail: any(named: 'customerEmail'),
              notes: any(named: 'notes'),
            ),
          );
        },
      );

      test(
        'should succeed when date is today (manual bookings allow same day)',
        () async {
          // Arrange
          final today = DateTime.now();
          final todayDate = DateTime(today.year, today.month, today.day);

          when(
            () => mockRepository.createManualBooking(
              fieldId: any(named: 'fieldId'),
              date: any(named: 'date'),
              startTime: any(named: 'startTime'),
              endTime: any(named: 'endTime'),
              totalPrice: any(named: 'totalPrice'),
              customerName: any(named: 'customerName'),
              customerPhone: any(named: 'customerPhone'),
              customerEmail: any(named: 'customerEmail'),
              notes: any(named: 'notes'),
            ),
          ).thenAnswer((_) async => Right(tBookingEntity));

          // Act
          final result = await useCase(
            fieldId: tFieldId,
            date: todayDate,
            startTime: tStartTime,
            endTime: tEndTime,
            totalPrice: tTotalPrice,
            customerName: tCustomerName,
            customerPhone: tCustomerPhone,
          );

          // Assert
          expect(result.isRight(), true);
        },
      );
    });

    group('time validation', () {
      test(
        'should return ValidationFailure when time format is invalid',
        () async {
          // Act
          final result = await useCase(
            fieldId: tFieldId,
            date: tDate,
            startTime: '0900',
            endTime: tEndTime,
            totalPrice: tTotalPrice,
            customerName: tCustomerName,
            customerPhone: tCustomerPhone,
          );

          // Assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure, isA<ValidationFailure>());
            expect(
              (failure as ValidationFailure).message,
              'Invalid time format',
            );
          }, (_) => fail('Should return failure'));
        },
      );

      test(
        'should return ValidationFailure when start time >= end time',
        () async {
          // Act
          final result = await useCase(
            fieldId: tFieldId,
            date: tDate,
            startTime: '11:00',
            endTime: '09:00',
            totalPrice: tTotalPrice,
            customerName: tCustomerName,
            customerPhone: tCustomerPhone,
          );

          // Assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure, isA<ValidationFailure>());
            expect(
              (failure as ValidationFailure).message,
              'End time must be after start time',
            );
          }, (_) => fail('Should return failure'));
        },
      );

      test(
        'should return ValidationFailure when start time equals end time',
        () async {
          // Act
          final result = await useCase(
            fieldId: tFieldId,
            date: tDate,
            startTime: '09:00',
            endTime: '09:00',
            totalPrice: tTotalPrice,
            customerName: tCustomerName,
            customerPhone: tCustomerPhone,
          );

          // Assert
          expect(result.isLeft(), true);
        },
      );
    });

    group('price validation', () {
      test('should return ValidationFailure when price is zero', () async {
        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: 0.0,
          customerName: tCustomerName,
          customerPhone: tCustomerPhone,
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<ValidationFailure>());
          expect(
            (failure as ValidationFailure).message,
            'Total price must be greater than zero',
          );
        }, (_) => fail('Should return failure'));
      });

      test('should return ValidationFailure when price is negative', () async {
        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: -100.0,
          customerName: tCustomerName,
          customerPhone: tCustomerPhone,
        );

        // Assert
        expect(result.isLeft(), true);
      });
    });

    group('customer name validation', () {
      test(
        'should return ValidationFailure when customer name is empty',
        () async {
          // Act
          final result = await useCase(
            fieldId: tFieldId,
            date: tDate,
            startTime: tStartTime,
            endTime: tEndTime,
            totalPrice: tTotalPrice,
            customerName: '',
            customerPhone: tCustomerPhone,
          );

          // Assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure, isA<ValidationFailure>());
            expect(
              (failure as ValidationFailure).message,
              'Customer name is required',
            );
          }, (_) => fail('Should return failure'));
        },
      );

      test(
        'should return ValidationFailure when customer name is only whitespace',
        () async {
          // Act
          final result = await useCase(
            fieldId: tFieldId,
            date: tDate,
            startTime: tStartTime,
            endTime: tEndTime,
            totalPrice: tTotalPrice,
            customerName: '   ',
            customerPhone: tCustomerPhone,
          );

          // Assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure, isA<ValidationFailure>());
            expect(
              (failure as ValidationFailure).message,
              'Customer name is required',
            );
          }, (_) => fail('Should return failure'));
        },
      );

      test(
        'should return ValidationFailure when customer name is too short (< 2 chars)',
        () async {
          // Act
          final result = await useCase(
            fieldId: tFieldId,
            date: tDate,
            startTime: tStartTime,
            endTime: tEndTime,
            totalPrice: tTotalPrice,
            customerName: 'A',
            customerPhone: tCustomerPhone,
          );

          // Assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure, isA<ValidationFailure>());
            expect(
              (failure as ValidationFailure).message,
              'Customer name must be at least 2 characters',
            );
          }, (_) => fail('Should return failure'));
        },
      );

      test('should accept customer name with exactly 2 characters', () async {
        // Arrange
        when(
          () => mockRepository.createManualBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            customerName: any(named: 'customerName'),
            customerPhone: any(named: 'customerPhone'),
            customerEmail: any(named: 'customerEmail'),
            notes: any(named: 'notes'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          customerName: 'Ab',
          customerPhone: tCustomerPhone,
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept customer name with Arabic characters', () async {
        // Arrange
        when(
          () => mockRepository.createManualBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            customerName: any(named: 'customerName'),
            customerPhone: any(named: 'customerPhone'),
            customerEmail: any(named: 'customerEmail'),
            notes: any(named: 'notes'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          customerName: 'أحمد محمد',
          customerPhone: tCustomerPhone,
        );

        // Assert
        expect(result.isRight(), true);
      });
    });

    group('customer phone validation', () {
      test('should return ValidationFailure when phone is empty', () async {
        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          customerName: tCustomerName,
          customerPhone: '',
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<ValidationFailure>());
          expect(
            (failure as ValidationFailure).message,
            'Customer phone number is required',
          );
        }, (_) => fail('Should return failure'));
      });

      test(
        'should return ValidationFailure when phone is only whitespace',
        () async {
          // Act
          final result = await useCase(
            fieldId: tFieldId,
            date: tDate,
            startTime: tStartTime,
            endTime: tEndTime,
            totalPrice: tTotalPrice,
            customerName: tCustomerName,
            customerPhone: '   ',
          );

          // Assert
          expect(result.isLeft(), true);
        },
      );

      test(
        'should return ValidationFailure when phone format is invalid (not Egyptian)',
        () async {
          // Act
          final result = await useCase(
            fieldId: tFieldId,
            date: tDate,
            startTime: tStartTime,
            endTime: tEndTime,
            totalPrice: tTotalPrice,
            customerName: tCustomerName,
            customerPhone: '1234567890',
          );

          // Assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure, isA<ValidationFailure>());
            expect(
              (failure as ValidationFailure).message,
              contains('Invalid phone number'),
            );
          }, (_) => fail('Should return failure'));
        },
      );

      test('should return ValidationFailure when phone is too short', () async {
        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          customerName: tCustomerName,
          customerPhone: '0101234567',
        );

        // Assert
        expect(result.isLeft(), true);
      });

      test('should return ValidationFailure when phone is too long', () async {
        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          customerName: tCustomerName,
          customerPhone: '010123456789',
        );

        // Assert
        expect(result.isLeft(), true);
      });

      test('should accept valid Egyptian phone starting with 010', () async {
        // Arrange
        when(
          () => mockRepository.createManualBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            customerName: any(named: 'customerName'),
            customerPhone: any(named: 'customerPhone'),
            customerEmail: any(named: 'customerEmail'),
            notes: any(named: 'notes'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          customerName: tCustomerName,
          customerPhone: '01012345678',
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept valid Egyptian phone starting with 011', () async {
        // Arrange
        when(
          () => mockRepository.createManualBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            customerName: any(named: 'customerName'),
            customerPhone: any(named: 'customerPhone'),
            customerEmail: any(named: 'customerEmail'),
            notes: any(named: 'notes'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          customerName: tCustomerName,
          customerPhone: '01112345678',
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept valid Egyptian phone starting with 012', () async {
        // Arrange
        when(
          () => mockRepository.createManualBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            customerName: any(named: 'customerName'),
            customerPhone: any(named: 'customerPhone'),
            customerEmail: any(named: 'customerEmail'),
            notes: any(named: 'notes'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          customerName: tCustomerName,
          customerPhone: '01212345678',
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept valid Egyptian phone starting with 015', () async {
        // Arrange
        when(
          () => mockRepository.createManualBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            customerName: any(named: 'customerName'),
            customerPhone: any(named: 'customerPhone'),
            customerEmail: any(named: 'customerEmail'),
            notes: any(named: 'notes'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          customerName: tCustomerName,
          customerPhone: '01512345678',
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept phone with spaces and clean it', () async {
        // Arrange
        when(
          () => mockRepository.createManualBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            customerName: any(named: 'customerName'),
            customerPhone: any(named: 'customerPhone'),
            customerEmail: any(named: 'customerEmail'),
            notes: any(named: 'notes'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          customerName: tCustomerName,
          customerPhone: '010 1234 5678',
        );

        // Assert
        verify(
          () => mockRepository.createManualBooking(
            fieldId: tFieldId,
            date: tDate,
            startTime: tStartTime,
            endTime: tEndTime,
            totalPrice: tTotalPrice,
            customerName: tCustomerName,
            customerPhone: '01012345678',
            customerEmail: null,
            notes: null,
          ),
        ).called(1);
      });

      test('should accept phone with dashes and clean it', () async {
        // Arrange
        when(
          () => mockRepository.createManualBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            customerName: any(named: 'customerName'),
            customerPhone: any(named: 'customerPhone'),
            customerEmail: any(named: 'customerEmail'),
            notes: any(named: 'notes'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          customerName: tCustomerName,
          customerPhone: '010-1234-5678',
        );

        // Assert
        verify(
          () => mockRepository.createManualBooking(
            fieldId: tFieldId,
            date: tDate,
            startTime: tStartTime,
            endTime: tEndTime,
            totalPrice: tTotalPrice,
            customerName: tCustomerName,
            customerPhone: '01012345678',
            customerEmail: null,
            notes: null,
          ),
        ).called(1);
      });

      test('should accept phone with parentheses and clean it', () async {
        // Arrange
        when(
          () => mockRepository.createManualBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            customerName: any(named: 'customerName'),
            customerPhone: any(named: 'customerPhone'),
            customerEmail: any(named: 'customerEmail'),
            notes: any(named: 'notes'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          customerName: tCustomerName,
          customerPhone: '(010) 1234-5678',
        );

        // Assert
        verify(
          () => mockRepository.createManualBooking(
            fieldId: tFieldId,
            date: tDate,
            startTime: tStartTime,
            endTime: tEndTime,
            totalPrice: tTotalPrice,
            customerName: tCustomerName,
            customerPhone: '01012345678',
            customerEmail: null,
            notes: null,
          ),
        ).called(1);
      });
    });

    group('customer email validation', () {
      test(
        'should return ValidationFailure when email format is invalid',
        () async {
          // Act
          final result = await useCase(
            fieldId: tFieldId,
            date: tDate,
            startTime: tStartTime,
            endTime: tEndTime,
            totalPrice: tTotalPrice,
            customerName: tCustomerName,
            customerPhone: tCustomerPhone,
            customerEmail: 'invalid-email',
          );

          // Assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure, isA<ValidationFailure>());
            expect(
              (failure as ValidationFailure).message,
              'Invalid email format',
            );
          }, (_) => fail('Should return failure'));
        },
      );

      test(
        'should return ValidationFailure when email is missing @ symbol',
        () async {
          // Act
          final result = await useCase(
            fieldId: tFieldId,
            date: tDate,
            startTime: tStartTime,
            endTime: tEndTime,
            totalPrice: tTotalPrice,
            customerName: tCustomerName,
            customerPhone: tCustomerPhone,
            customerEmail: 'ahmedexample.com',
          );

          // Assert
          expect(result.isLeft(), true);
        },
      );

      test(
        'should return ValidationFailure when email is missing domain',
        () async {
          // Act
          final result = await useCase(
            fieldId: tFieldId,
            date: tDate,
            startTime: tStartTime,
            endTime: tEndTime,
            totalPrice: tTotalPrice,
            customerName: tCustomerName,
            customerPhone: tCustomerPhone,
            customerEmail: 'ahmed@',
          );

          // Assert
          expect(result.isLeft(), true);
        },
      );

      test('should succeed when email is null', () async {
        // Arrange
        when(
          () => mockRepository.createManualBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            customerName: any(named: 'customerName'),
            customerPhone: any(named: 'customerPhone'),
            customerEmail: any(named: 'customerEmail'),
            notes: any(named: 'notes'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          customerName: tCustomerName,
          customerPhone: tCustomerPhone,
        );

        // Assert
        expect(result.isRight(), true);
      });

      test(
        'should succeed when email is empty string (treated as null)',
        () async {
          // Arrange
          when(
            () => mockRepository.createManualBooking(
              fieldId: any(named: 'fieldId'),
              date: any(named: 'date'),
              startTime: any(named: 'startTime'),
              endTime: any(named: 'endTime'),
              totalPrice: any(named: 'totalPrice'),
              customerName: any(named: 'customerName'),
              customerPhone: any(named: 'customerPhone'),
              customerEmail: any(named: 'customerEmail'),
              notes: any(named: 'notes'),
            ),
          ).thenAnswer((_) async => Right(tBookingEntity));

          // Act
          final result = await useCase(
            fieldId: tFieldId,
            date: tDate,
            startTime: tStartTime,
            endTime: tEndTime,
            totalPrice: tTotalPrice,
            customerName: tCustomerName,
            customerPhone: tCustomerPhone,
            customerEmail: '',
          );

          // Assert
          expect(result.isRight(), true);
        },
      );

      test('should accept valid email address', () async {
        // Arrange
        when(
          () => mockRepository.createManualBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            customerName: any(named: 'customerName'),
            customerPhone: any(named: 'customerPhone'),
            customerEmail: any(named: 'customerEmail'),
            notes: any(named: 'notes'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          customerName: tCustomerName,
          customerPhone: tCustomerPhone,
          customerEmail: 'ahmed.mohamed@example.com',
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should trim email before passing to repository', () async {
        // Arrange
        when(
          () => mockRepository.createManualBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            customerName: any(named: 'customerName'),
            customerPhone: any(named: 'customerPhone'),
            customerEmail: any(named: 'customerEmail'),
            notes: any(named: 'notes'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          customerName: tCustomerName,
          customerPhone: tCustomerPhone,
          customerEmail: '  ahmed@example.com  ',
        );

        // Assert
        verify(
          () => mockRepository.createManualBooking(
            fieldId: tFieldId,
            date: tDate,
            startTime: tStartTime,
            endTime: tEndTime,
            totalPrice: tTotalPrice,
            customerName: tCustomerName,
            customerPhone: tCustomerPhone,
            customerEmail: 'ahmed@example.com',
            notes: null,
          ),
        ).called(1);
      });
    });

    group('repository failures', () {
      test('should return ServerFailure when repository call fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to create manual booking');
        when(
          () => mockRepository.createManualBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            customerName: any(named: 'customerName'),
            customerPhone: any(named: 'customerPhone'),
            customerEmail: any(named: 'customerEmail'),
            notes: any(named: 'notes'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          customerName: tCustomerName,
          customerPhone: tCustomerPhone,
        );

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure when network error occurs', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.createManualBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            customerName: any(named: 'customerName'),
            customerPhone: any(named: 'customerPhone'),
            customerEmail: any(named: 'customerEmail'),
            notes: any(named: 'notes'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          customerName: tCustomerName,
          customerPhone: tCustomerPhone,
        );

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });

    group('edge cases', () {
      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.createManualBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            customerName: any(named: 'customerName'),
            customerPhone: any(named: 'customerPhone'),
            customerEmail: any(named: 'customerEmail'),
            notes: any(named: 'notes'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          customerName: tCustomerName,
          customerPhone: tCustomerPhone,
        );

        // Assert
        verify(
          () => mockRepository.createManualBooking(
            fieldId: tFieldId,
            date: tDate,
            startTime: tStartTime,
            endTime: tEndTime,
            totalPrice: tTotalPrice,
            customerName: tCustomerName,
            customerPhone: tCustomerPhone,
            customerEmail: null,
            notes: null,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });
  });
}
