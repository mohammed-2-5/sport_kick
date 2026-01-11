import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/entities/payment_status.dart';
import 'package:spo_kick/features/bookings/domain/usecases/upload_payment_proof_usecase.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/payment_proof_cubit.dart';

// Mock Classes
class MockUploadPaymentProofUseCase extends Mock
    implements UploadPaymentProofUseCase {}

class MockImagePicker extends Mock implements ImagePicker {}

class MockXFile extends Mock implements XFile {}

void main() {
  late PaymentProofCubit cubit;
  late MockUploadPaymentProofUseCase mockUploadPaymentProofUseCase;
  late MockImagePicker mockImagePicker;

  // Test data
  final now = DateTime.now();
  late BookingEntity tBooking;
  late BookingEntity tUpdatedBooking;
  late Uint8List tImageBytes;
  const tFileName = 'payment_proof.jpg';
  const tBookingId = 'booking-123';
  const tProofUrl = 'https://storage.example.com/proofs/booking-123.jpg';

  setUpAll(() {
    registerFallbackValue(Uint8List(0));
  });

  setUp(() {
    mockUploadPaymentProofUseCase = MockUploadPaymentProofUseCase();
    mockImagePicker = MockImagePicker();

    tImageBytes = Uint8List.fromList([0xFF, 0xD8, 0xFF, 0xE0]); // JPEG header

    tBooking = BookingEntity(
      id: tBookingId,
      userId: 'user-1',
      fieldId: 'field-1',
      date: now.add(const Duration(days: 1)),
      startTime: '14:00',
      endTime: '16:00',
      status: BookingStatus.confirmed,
      totalPrice: 300.0,
      currency: 'EGP',
      fieldName: 'Al-Ahly Stadium',
      userName: 'Ahmed Ali',
      createdAt: now,
      paymentStatus: PaymentStatus.pending,
    );

    tUpdatedBooking = tBooking.copyWith(
      paymentStatus: PaymentStatus.uploaded,
      paymentProofUrl: tProofUrl,
      paymentUploadedAt: now,
    );

    cubit = PaymentProofCubit(
      uploadPaymentProofUseCase: mockUploadPaymentProofUseCase,
      imagePicker: mockImagePicker,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('PaymentProofCubit -', () {
    test('initial state should be PaymentProofInitial', () {
      expect(cubit.state, equals(const PaymentProofInitial()));
    });

    group('selectImage -', () {
      test('should emit Selected state with image bytes', () {
        cubit.selectImage(imageBytes: tImageBytes, fileName: tFileName);

        expect(cubit.state, isA<PaymentProofSelected>());
        final state = cubit.state as PaymentProofSelected;
        expect(state.imageBytes, equals(tImageBytes));
        expect(state.fileName, equals(tFileName));
      });

      blocTest<PaymentProofCubit, PaymentProofState>(
        'should emit Selected with correct data',
        build: () => cubit,
        act: (cubit) =>
            cubit.selectImage(imageBytes: tImageBytes, fileName: tFileName),
        expect: () => [
          PaymentProofSelected(imageBytes: tImageBytes, fileName: tFileName),
        ],
      );
    });

    group('clearSelection -', () {
      blocTest<PaymentProofCubit, PaymentProofState>(
        'should emit Initial when clearing selection',
        build: () => cubit,
        seed: () =>
            PaymentProofSelected(imageBytes: tImageBytes, fileName: tFileName),
        act: (cubit) => cubit.clearSelection(),
        expect: () => [const PaymentProofInitial()],
      );
    });

    group('uploadProof -', () {
      blocTest<PaymentProofCubit, PaymentProofState>(
        'should emit [Uploading, Success] when upload succeeds',
        build: () {
          when(
            () => mockUploadPaymentProofUseCase(
              bookingId: tBookingId,
              imageBytes: tImageBytes,
              fileName: tFileName,
            ),
          ).thenAnswer((_) async => Right(tUpdatedBooking));
          return cubit;
        },
        seed: () =>
            PaymentProofSelected(imageBytes: tImageBytes, fileName: tFileName),
        act: (cubit) => cubit.uploadProof(tBookingId),
        expect: () => [
          const PaymentProofUploading(),
          isA<PaymentProofSuccess>()
              .having((s) => s.proofUrl, 'proofUrl', tProofUrl)
              .having(
                (s) => s.updatedBooking,
                'updatedBooking',
                tUpdatedBooking,
              ),
        ],
        verify: (_) {
          verify(
            () => mockUploadPaymentProofUseCase(
              bookingId: tBookingId,
              imageBytes: tImageBytes,
              fileName: tFileName,
            ),
          ).called(1);
        },
      );

      blocTest<PaymentProofCubit, PaymentProofState>(
        'should emit [Uploading, Error] when upload fails',
        build: () {
          when(
            () => mockUploadPaymentProofUseCase(
              bookingId: tBookingId,
              imageBytes: tImageBytes,
              fileName: tFileName,
            ),
          ).thenAnswer((_) async => const Left(ServerFailure('Upload failed')));
          return cubit;
        },
        seed: () =>
            PaymentProofSelected(imageBytes: tImageBytes, fileName: tFileName),
        act: (cubit) => cubit.uploadProof(tBookingId),
        expect: () => [
          const PaymentProofUploading(),
          const PaymentProofError(message: 'Upload failed'),
        ],
      );

      blocTest<PaymentProofCubit, PaymentProofState>(
        'should emit Error when network failure occurs',
        build: () {
          when(
            () => mockUploadPaymentProofUseCase(
              bookingId: tBookingId,
              imageBytes: tImageBytes,
              fileName: tFileName,
            ),
          ).thenAnswer(
            (_) async => const Left(NetworkFailure('No internet connection')),
          );
          return cubit;
        },
        seed: () =>
            PaymentProofSelected(imageBytes: tImageBytes, fileName: tFileName),
        act: (cubit) => cubit.uploadProof(tBookingId),
        expect: () => [
          const PaymentProofUploading(),
          const PaymentProofError(message: 'No internet connection'),
        ],
      );

      blocTest<PaymentProofCubit, PaymentProofState>(
        'should emit Error when validation fails',
        build: () {
          when(
            () => mockUploadPaymentProofUseCase(
              bookingId: tBookingId,
              imageBytes: tImageBytes,
              fileName: tFileName,
            ),
          ).thenAnswer(
            (_) async =>
                const Left(ValidationFailure('Image file is too large')),
          );
          return cubit;
        },
        seed: () =>
            PaymentProofSelected(imageBytes: tImageBytes, fileName: tFileName),
        act: (cubit) => cubit.uploadProof(tBookingId),
        expect: () => [
          const PaymentProofUploading(),
          const PaymentProofError(message: 'Image file is too large'),
        ],
      );

      blocTest<PaymentProofCubit, PaymentProofState>(
        'should do nothing when state is not Selected',
        build: () => cubit,
        act: (cubit) => cubit.uploadProof(tBookingId),
        expect: () => [], // No state changes
        verify: (_) {
          verifyNever(
            () => mockUploadPaymentProofUseCase(
              bookingId: any(named: 'bookingId'),
              imageBytes: any(named: 'imageBytes'),
              fileName: any(named: 'fileName'),
            ),
          );
        },
      );

      blocTest<PaymentProofCubit, PaymentProofState>(
        'should do nothing when state is Uploading',
        build: () => cubit,
        seed: () => const PaymentProofUploading(),
        act: (cubit) => cubit.uploadProof(tBookingId),
        expect: () => [], // No state changes
      );
    });

    group('reset -', () {
      blocTest<PaymentProofCubit, PaymentProofState>(
        'should emit Initial when resetting from Selected',
        build: () => cubit,
        seed: () =>
            PaymentProofSelected(imageBytes: tImageBytes, fileName: tFileName),
        act: (cubit) => cubit.reset(),
        expect: () => [const PaymentProofInitial()],
      );

      blocTest<PaymentProofCubit, PaymentProofState>(
        'should emit Initial when resetting from Error',
        build: () => cubit,
        seed: () => const PaymentProofError(message: 'Some error'),
        act: (cubit) => cubit.reset(),
        expect: () => [const PaymentProofInitial()],
      );

      blocTest<PaymentProofCubit, PaymentProofState>(
        'should emit Initial when resetting from Success',
        build: () => cubit,
        seed: () => PaymentProofSuccess(
          proofUrl: tProofUrl,
          uploadedAt: now,
          updatedBooking: tUpdatedBooking,
        ),
        act: (cubit) => cubit.reset(),
        expect: () => [const PaymentProofInitial()],
      );
    });
  });

  group('PaymentProofState -', () {
    group('PaymentProofInitial -', () {
      test('props should be empty', () {
        const state = PaymentProofInitial();
        expect(state.props, isEmpty);
      });

      test('equality works correctly', () {
        const state1 = PaymentProofInitial();
        const state2 = PaymentProofInitial();
        expect(state1, equals(state2));
      });
    });

    group('PaymentProofSelected -', () {
      test('props should include imageBytes and fileName', () {
        final state1 = PaymentProofSelected(
          imageBytes: tImageBytes,
          fileName: tFileName,
        );
        final state2 = PaymentProofSelected(
          imageBytes: tImageBytes,
          fileName: tFileName,
        );
        final state3 = PaymentProofSelected(
          imageBytes: tImageBytes,
          fileName: 'different.png',
        );

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });
    });

    group('PaymentProofUploading -', () {
      test('props should be empty', () {
        const state = PaymentProofUploading();
        expect(state.props, isEmpty);
      });
    });

    group('PaymentProofSuccess -', () {
      test('props should include proofUrl, uploadedAt, and updatedBooking', () {
        final state1 = PaymentProofSuccess(
          proofUrl: tProofUrl,
          uploadedAt: now,
          updatedBooking: tUpdatedBooking,
        );
        final state2 = PaymentProofSuccess(
          proofUrl: tProofUrl,
          uploadedAt: now,
          updatedBooking: tUpdatedBooking,
        );
        final state3 = PaymentProofSuccess(
          proofUrl: 'different-url',
          uploadedAt: now,
          updatedBooking: tUpdatedBooking,
        );

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });
    });

    group('PaymentProofError -', () {
      test('props should include message', () {
        const error1 = PaymentProofError(message: 'Error 1');
        const error2 = PaymentProofError(message: 'Error 1');
        const error3 = PaymentProofError(message: 'Error 2');

        expect(error1, equals(error2));
        expect(error1, isNot(equals(error3)));
      });
    });
  });
}
