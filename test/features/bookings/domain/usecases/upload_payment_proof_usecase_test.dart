import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/entities/payment_status.dart';
import 'package:spo_kick/features/bookings/domain/usecases/upload_payment_proof_usecase.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late UploadPaymentProofUseCase useCase;
  late MockBookingRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(Uint8List.fromList([1, 2, 3]));
  });

  setUp(() {
    mockRepository = MockBookingRepository();
    useCase = UploadPaymentProofUseCase(mockRepository);
  });

  group('UploadPaymentProofUseCase', () {
    const tBookingId = 'booking-123';
    const tFileName = 'payment_proof.jpg';
    final tImageBytes = Uint8List.fromList([1, 2, 3, 4, 5]); // Small image

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
      paymentStatus: PaymentStatus.uploaded,
      paymentProofUrl: 'https://example.com/payment_proof.jpg',
      paymentUploadedAt: DateTime.now(),
    );

    group('successful upload', () {
      test(
        'should return BookingEntity when payment proof upload succeeds',
        () async {
          // Arrange
          when(
            () => mockRepository.uploadPaymentProof(
              bookingId: any(named: 'bookingId'),
              imageBytes: any(named: 'imageBytes'),
              fileName: any(named: 'fileName'),
            ),
          ).thenAnswer((_) async => Right(tBookingEntity));

          // Act
          final result = await useCase(
            bookingId: tBookingId,
            imageBytes: tImageBytes,
            fileName: tFileName,
          );

          // Assert
          expect(result.isRight(), true);
          expect(
            result.getOrElse(() => tBookingEntity),
            equals(tBookingEntity),
          );
          verify(
            () => mockRepository.uploadPaymentProof(
              bookingId: tBookingId,
              imageBytes: tImageBytes,
              fileName: tFileName,
            ),
          ).called(1);
        },
      );

      test('should call repository with correct parameters', () async {
        // Arrange
        when(
          () => mockRepository.uploadPaymentProof(
            bookingId: any(named: 'bookingId'),
            imageBytes: any(named: 'imageBytes'),
            fileName: any(named: 'fileName'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        await useCase(
          bookingId: tBookingId,
          imageBytes: tImageBytes,
          fileName: tFileName,
        );

        // Assert
        verify(
          () => mockRepository.uploadPaymentProof(
            bookingId: tBookingId,
            imageBytes: tImageBytes,
            fileName: tFileName,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should accept JPG file extension', () async {
        // Arrange
        when(
          () => mockRepository.uploadPaymentProof(
            bookingId: any(named: 'bookingId'),
            imageBytes: any(named: 'imageBytes'),
            fileName: any(named: 'fileName'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          imageBytes: tImageBytes,
          fileName: 'image.jpg',
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept JPEG file extension', () async {
        // Arrange
        when(
          () => mockRepository.uploadPaymentProof(
            bookingId: any(named: 'bookingId'),
            imageBytes: any(named: 'imageBytes'),
            fileName: any(named: 'fileName'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          imageBytes: tImageBytes,
          fileName: 'image.jpeg',
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept PNG file extension', () async {
        // Arrange
        when(
          () => mockRepository.uploadPaymentProof(
            bookingId: any(named: 'bookingId'),
            imageBytes: any(named: 'imageBytes'),
            fileName: any(named: 'fileName'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          imageBytes: tImageBytes,
          fileName: 'image.png',
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept WebP file extension', () async {
        // Arrange
        when(
          () => mockRepository.uploadPaymentProof(
            bookingId: any(named: 'bookingId'),
            imageBytes: any(named: 'imageBytes'),
            fileName: any(named: 'fileName'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          imageBytes: tImageBytes,
          fileName: 'image.webp',
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept uppercase file extension', () async {
        // Arrange
        when(
          () => mockRepository.uploadPaymentProof(
            bookingId: any(named: 'bookingId'),
            imageBytes: any(named: 'imageBytes'),
            fileName: any(named: 'fileName'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          imageBytes: tImageBytes,
          fileName: 'image.JPG',
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept mixed case file extension', () async {
        // Arrange
        when(
          () => mockRepository.uploadPaymentProof(
            bookingId: any(named: 'bookingId'),
            imageBytes: any(named: 'imageBytes'),
            fileName: any(named: 'fileName'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          imageBytes: tImageBytes,
          fileName: 'image.JpG',
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept large file (under 10MB limit)', () async {
        // Arrange
        final largeImageBytes = Uint8List.fromList(
          List.filled(9 * 1024 * 1024, 1),
        ); // 9MB

        when(
          () => mockRepository.uploadPaymentProof(
            bookingId: any(named: 'bookingId'),
            imageBytes: any(named: 'imageBytes'),
            fileName: any(named: 'fileName'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          imageBytes: largeImageBytes,
          fileName: tFileName,
        );

        // Assert
        expect(result.isRight(), true);
      });
    });

    group('validation failures - booking ID', () {
      test(
        'should return ValidationFailure when booking ID is empty',
        () async {
          // Act
          final result = await useCase(
            bookingId: '',
            imageBytes: tImageBytes,
            fileName: tFileName,
          );

          // Assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure, isA<ValidationFailure>());
            expect(
              (failure as ValidationFailure).message,
              'Booking ID is required',
            );
          }, (_) => fail('Should return failure'));
          verifyNever(
            () => mockRepository.uploadPaymentProof(
              bookingId: any(named: 'bookingId'),
              imageBytes: any(named: 'imageBytes'),
              fileName: any(named: 'fileName'),
            ),
          );
        },
      );
    });

    group('validation failures - image bytes', () {
      test(
        'should return ValidationFailure when image bytes are empty',
        () async {
          // Arrange
          final emptyBytes = Uint8List.fromList([]);

          // Act
          final result = await useCase(
            bookingId: tBookingId,
            imageBytes: emptyBytes,
            fileName: tFileName,
          );

          // Assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure, isA<ValidationFailure>());
            expect(
              (failure as ValidationFailure).message,
              'Image data is required',
            );
          }, (_) => fail('Should return failure'));
        },
      );

      test(
        'should return ValidationFailure when image bytes exceed 10MB',
        () async {
          // Arrange
          final tooLargeBytes = Uint8List.fromList(
            List.filled(11 * 1024 * 1024, 1),
          ); // 11MB

          // Act
          final result = await useCase(
            bookingId: tBookingId,
            imageBytes: tooLargeBytes,
            fileName: tFileName,
          );

          // Assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure, isA<ValidationFailure>());
            expect(
              (failure as ValidationFailure).message,
              'Image file is too large. Maximum size is 10MB',
            );
          }, (_) => fail('Should return failure'));
        },
      );

      test(
        'should return ValidationFailure when image bytes exactly exceed 10MB',
        () async {
          // Arrange
          final exactlyTooLarge = Uint8List.fromList(
            List.filled((10 * 1024 * 1024) + 1, 1),
          );

          // Act
          final result = await useCase(
            bookingId: tBookingId,
            imageBytes: exactlyTooLarge,
            fileName: tFileName,
          );

          // Assert
          expect(result.isLeft(), true);
        },
      );

      test('should accept exactly 10MB image', () async {
        // Arrange
        final exactly10MB = Uint8List.fromList(
          List.filled(10 * 1024 * 1024, 1),
        );

        when(
          () => mockRepository.uploadPaymentProof(
            bookingId: any(named: 'bookingId'),
            imageBytes: any(named: 'imageBytes'),
            fileName: any(named: 'fileName'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          imageBytes: exactly10MB,
          fileName: tFileName,
        );

        // Assert
        expect(result.isRight(), true);
      });
    });

    group('validation failures - file extension', () {
      test(
        'should return ValidationFailure when file extension is invalid',
        () async {
          // Act
          final result = await useCase(
            bookingId: tBookingId,
            imageBytes: tImageBytes,
            fileName: 'image.txt',
          );

          // Assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure, isA<ValidationFailure>());
            expect(
              (failure as ValidationFailure).message,
              'Invalid image format. Please use JPG, PNG, or WebP',
            );
          }, (_) => fail('Should return failure'));
        },
      );

      test('should return ValidationFailure for PDF extension', () async {
        // Act
        final result = await useCase(
          bookingId: tBookingId,
          imageBytes: tImageBytes,
          fileName: 'document.pdf',
        );

        // Assert
        expect(result.isLeft(), true);
      });

      test('should return ValidationFailure for BMP extension', () async {
        // Act
        final result = await useCase(
          bookingId: tBookingId,
          imageBytes: tImageBytes,
          fileName: 'image.bmp',
        );

        // Assert
        expect(result.isLeft(), true);
      });

      test('should return ValidationFailure for GIF extension', () async {
        // Act
        final result = await useCase(
          bookingId: tBookingId,
          imageBytes: tImageBytes,
          fileName: 'image.gif',
        );

        // Assert
        expect(result.isLeft(), true);
      });

      test(
        'should return ValidationFailure when file has no extension',
        () async {
          // Act
          final result = await useCase(
            bookingId: tBookingId,
            imageBytes: tImageBytes,
            fileName: 'imagefile',
          );

          // Assert
          expect(result.isLeft(), true);
        },
      );

      test('should return ValidationFailure when file name is empty', () async {
        // Act
        final result = await useCase(
          bookingId: tBookingId,
          imageBytes: tImageBytes,
          fileName: '',
        );

        // Assert
        expect(result.isLeft(), true);
      });
    });

    group('repository failures', () {
      test('should return ServerFailure when repository call fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to upload payment proof');
        when(
          () => mockRepository.uploadPaymentProof(
            bookingId: any(named: 'bookingId'),
            imageBytes: any(named: 'imageBytes'),
            fileName: any(named: 'fileName'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          imageBytes: tImageBytes,
          fileName: tFileName,
        );

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure when network error occurs', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.uploadPaymentProof(
            bookingId: any(named: 'bookingId'),
            imageBytes: any(named: 'imageBytes'),
            fileName: any(named: 'fileName'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          imageBytes: tImageBytes,
          fileName: tFileName,
        );

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure when booking not found', () async {
        // Arrange
        const tFailure = ServerFailure('Booking not found');
        when(
          () => mockRepository.uploadPaymentProof(
            bookingId: any(named: 'bookingId'),
            imageBytes: any(named: 'imageBytes'),
            fileName: any(named: 'fileName'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(
          bookingId: 'non-existent-id',
          imageBytes: tImageBytes,
          fileName: tFileName,
        );

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure when user unauthorized', () async {
        // Arrange
        const tFailure = ServerFailure(
          'You are not authorized to upload payment proof',
        );
        when(
          () => mockRepository.uploadPaymentProof(
            bookingId: any(named: 'bookingId'),
            imageBytes: any(named: 'imageBytes'),
            fileName: any(named: 'fileName'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          imageBytes: tImageBytes,
          fileName: tFileName,
        );

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure when storage upload fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to upload file to storage');
        when(
          () => mockRepository.uploadPaymentProof(
            bookingId: any(named: 'bookingId'),
            imageBytes: any(named: 'imageBytes'),
            fileName: any(named: 'fileName'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          imageBytes: tImageBytes,
          fileName: tFileName,
        );

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test(
        'should return ServerFailure when payment proof already exists',
        () async {
          // Arrange
          const tFailure = ServerFailure('Payment proof already uploaded');
          when(
            () => mockRepository.uploadPaymentProof(
              bookingId: any(named: 'bookingId'),
              imageBytes: any(named: 'imageBytes'),
              fileName: any(named: 'fileName'),
            ),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(
            bookingId: tBookingId,
            imageBytes: tImageBytes,
            fileName: tFileName,
          );

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );
    });

    group('edge cases', () {
      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.uploadPaymentProof(
            bookingId: any(named: 'bookingId'),
            imageBytes: any(named: 'imageBytes'),
            fileName: any(named: 'fileName'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        await useCase(
          bookingId: tBookingId,
          imageBytes: tImageBytes,
          fileName: tFileName,
        );

        // Assert
        verify(
          () => mockRepository.uploadPaymentProof(
            bookingId: tBookingId,
            imageBytes: tImageBytes,
            fileName: tFileName,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle file name with multiple dots', () async {
        // Arrange
        when(
          () => mockRepository.uploadPaymentProof(
            bookingId: any(named: 'bookingId'),
            imageBytes: any(named: 'imageBytes'),
            fileName: any(named: 'fileName'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          imageBytes: tImageBytes,
          fileName: 'my.payment.proof.jpg',
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle file name with spaces', () async {
        // Arrange
        when(
          () => mockRepository.uploadPaymentProof(
            bookingId: any(named: 'bookingId'),
            imageBytes: any(named: 'imageBytes'),
            fileName: any(named: 'fileName'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          imageBytes: tImageBytes,
          fileName: 'payment proof image.jpg',
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle file name with special characters', () async {
        // Arrange
        when(
          () => mockRepository.uploadPaymentProof(
            bookingId: any(named: 'bookingId'),
            imageBytes: any(named: 'imageBytes'),
            fileName: any(named: 'fileName'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          imageBytes: tImageBytes,
          fileName: 'payment_proof-2026@01.jpg',
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle very small image (1 byte)', () async {
        // Arrange
        final tinyImageBytes = Uint8List.fromList([1]);

        when(
          () => mockRepository.uploadPaymentProof(
            bookingId: any(named: 'bookingId'),
            imageBytes: any(named: 'imageBytes'),
            fileName: any(named: 'fileName'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          imageBytes: tinyImageBytes,
          fileName: tFileName,
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle booking ID with special characters', () async {
        // Arrange
        const specialBookingId = 'booking-123_456-xyz';

        when(
          () => mockRepository.uploadPaymentProof(
            bookingId: any(named: 'bookingId'),
            imageBytes: any(named: 'imageBytes'),
            fileName: any(named: 'fileName'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          bookingId: specialBookingId,
          imageBytes: tImageBytes,
          fileName: tFileName,
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle very long file name', () async {
        // Arrange
        final longFileName = '${'payment' * 50}.jpg';

        when(
          () => mockRepository.uploadPaymentProof(
            bookingId: any(named: 'bookingId'),
            imageBytes: any(named: 'imageBytes'),
            fileName: any(named: 'fileName'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          bookingId: tBookingId,
          imageBytes: tImageBytes,
          fileName: longFileName,
        );

        // Assert
        expect(result.isRight(), true);
      });
    });
  });
}
