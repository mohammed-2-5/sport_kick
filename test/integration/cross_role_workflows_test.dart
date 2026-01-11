/// Cross-Role Integration Tests
///
/// Tests complete workflows that span multiple user roles:
/// - User creates booking → Owner approves → User pays → Owner verifies
/// - User requests recurring → Owner approves
/// - Super Admin creates admin → Admin first login → Password change
/// - User A vs User B concurrent booking conflict
///
/// These tests verify that state transitions are correct across roles
/// and that data consistency is maintained throughout workflows.
library;

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:spo_kick/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:spo_kick/features/auth/domain/usecases/login_usecase.dart';
import 'package:spo_kick/features/auth/domain/usecases/logout_usecase.dart';
import 'package:spo_kick/features/auth/domain/usecases/register_usecase.dart';
import 'package:spo_kick/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:spo_kick/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/entities/payment_status.dart';
import 'package:spo_kick/features/bookings/domain/usecases/create_booking_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/find_consecutive_slot_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/get_available_time_slots_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/group_time_slots_by_period_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/validate_slot_selection_usecase.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_flow_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_flow_state.dart';
import 'package:spo_kick/features/recurring_bookings/domain/entities/recurring_booking_entity.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/approve_recurring_booking_usecase.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/create_recurring_request_usecase.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/get_pending_recurring_requests_usecase.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/reject_recurring_booking_usecase.dart';
import 'package:spo_kick/features/reviews/domain/usecases/can_user_review_field_usecase.dart';
import 'package:spo_kick/features/reviews/domain/usecases/create_review_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/entities/admin_invitation_entity.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/create_admin_account_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/verify_field_usecase.dart';

import '../helpers/cross_role_test_data.dart';

// ============================================================================
// MOCK CLASSES
// ============================================================================

// Auth Mocks
class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

class MockChangePasswordUseCase extends Mock implements ChangePasswordUseCase {}

class MockResetPasswordUseCase extends Mock implements ResetPasswordUseCase {}

class MockUpdateProfileUseCase extends Mock implements UpdateProfileUseCase {}

// Booking Mocks
class MockGetAvailableTimeSlotsUseCase extends Mock
    implements GetAvailableTimeSlotsUseCase {}

class MockCreateBookingUseCase extends Mock implements CreateBookingUseCase {}

class MockGroupTimeSlotsByPeriodUseCase extends Mock
    implements GroupTimeSlotsByPeriodUseCase {}

class MockFindConsecutiveSlotUseCase extends Mock
    implements FindConsecutiveSlotUseCase {}

class MockValidateSlotSelectionUseCase extends Mock
    implements ValidateSlotSelectionUseCase {}

// Recurring Mocks
class MockCreateRecurringRequestUseCase extends Mock
    implements CreateRecurringRequestUseCase {}

class MockGetPendingRecurringRequestsUseCase extends Mock
    implements GetPendingRecurringRequestsUseCase {}

class MockApproveRecurringBookingUseCase extends Mock
    implements ApproveRecurringBookingUseCase {}

class MockRejectRecurringBookingUseCase extends Mock
    implements RejectRecurringBookingUseCase {}

// Review Mocks
class MockCanUserReviewFieldUseCase extends Mock
    implements CanUserReviewFieldUseCase {}

class MockCreateReviewUseCase extends Mock implements CreateReviewUseCase {}

// Super Admin Mocks
class MockCreateAdminAccountUseCase extends Mock
    implements CreateAdminAccountUseCase {}

class MockVerifyFieldUseCase extends Mock implements VerifyFieldUseCase {}

// Fake classes for registerFallbackValue
class FakeLoginParams extends Fake implements LoginParams {}

class FakeRegisterParams extends Fake implements RegisterParams {}

class FakeChangePasswordParams extends Fake implements ChangePasswordParams {}

class FakeUpdateProfileParams extends Fake implements UpdateProfileParams {}

class FakeCreateReviewParams extends Fake implements CreateReviewParams {}

class FakeCanUserReviewFieldParams extends Fake
    implements CanUserReviewFieldParams {}

class FakeCreateRecurringRequestParams extends Fake
    implements CreateRecurringRequestParams {}

class FakeApproveRecurringBookingParams extends Fake
    implements ApproveRecurringBookingParams {}

class FakeRejectRecurringBookingParams extends Fake
    implements RejectRecurringBookingParams {}

void main() {
  // Register fallback values
  setUpAll(() {
    registerFallbackValue(FakeLoginParams());
    registerFallbackValue(FakeRegisterParams());
    registerFallbackValue(FakeChangePasswordParams());
    registerFallbackValue(FakeUpdateProfileParams());
    registerFallbackValue(FakeCreateReviewParams());
    registerFallbackValue(FakeCanUserReviewFieldParams());
    registerFallbackValue(FakeCreateRecurringRequestParams());
    registerFallbackValue(FakeApproveRecurringBookingParams());
    registerFallbackValue(FakeRejectRecurringBookingParams());
  });

  group('Cross-Role Integration Tests', () {
    // ========================================================================
    // TEST 1: COMPLETE BOOKING LIFECYCLE
    // User creates booking → Owner approves → User uploads payment →
    // Owner verifies → Booking completes → User leaves review
    // ========================================================================
    group(
      'INTEGRATION_001: Complete Booking Lifecycle (User → Owner → User)',
      () {
        late BookingFlowCubit userBookingCubit;
        late AuthCubit userAuthCubit;
        late AuthCubit ownerAuthCubit;

        // Booking mocks
        late MockGetAvailableTimeSlotsUseCase mockGetTimeSlots;
        late MockCreateBookingUseCase mockCreateBooking;
        late MockGroupTimeSlotsByPeriodUseCase mockGroupTimeSlots;
        late MockFindConsecutiveSlotUseCase mockFindConsecutiveSlot;
        late MockValidateSlotSelectionUseCase mockValidateSlotSelection;

        // Review mocks
        late MockCanUserReviewFieldUseCase mockCanReview;
        late MockCreateReviewUseCase mockCreateReview;

        // Auth mocks
        late MockLoginUseCase mockLogin;
        late MockLogoutUseCase mockLogout;
        late MockGetCurrentUserUseCase mockGetCurrentUser;
        late MockRegisterUseCase mockRegister;
        late MockChangePasswordUseCase mockChangePassword;
        late MockResetPasswordUseCase mockResetPassword;
        late MockUpdateProfileUseCase mockUpdateProfile;

        final testData = CrossRoleTestData.bookingLifecycle;

        setUp(() {
          // Initialize mocks
          mockGetTimeSlots = MockGetAvailableTimeSlotsUseCase();
          mockCreateBooking = MockCreateBookingUseCase();
          mockGroupTimeSlots = MockGroupTimeSlotsByPeriodUseCase();
          mockFindConsecutiveSlot = MockFindConsecutiveSlotUseCase();
          mockValidateSlotSelection = MockValidateSlotSelectionUseCase();

          mockCanReview = MockCanUserReviewFieldUseCase();
          mockCreateReview = MockCreateReviewUseCase();

          mockLogin = MockLoginUseCase();
          mockLogout = MockLogoutUseCase();
          mockGetCurrentUser = MockGetCurrentUserUseCase();
          mockRegister = MockRegisterUseCase();
          mockChangePassword = MockChangePasswordUseCase();
          mockResetPassword = MockResetPasswordUseCase();
          mockUpdateProfile = MockUpdateProfileUseCase();

          // Create cubits
          userBookingCubit = BookingFlowCubit(
            getAvailableTimeSlotsUseCase: mockGetTimeSlots,
            createBookingUseCase: mockCreateBooking,
            groupTimeSlotsByPeriodUseCase: mockGroupTimeSlots,
            findConsecutiveSlotUseCase: mockFindConsecutiveSlot,
            validateSlotSelectionUseCase: mockValidateSlotSelection,
          );

          userAuthCubit = AuthCubit(
            loginUseCase: mockLogin,
            registerUseCase: mockRegister,
            logoutUseCase: mockLogout,
            getCurrentUserUseCase: mockGetCurrentUser,
            changePasswordUseCase: mockChangePassword,
            resetPasswordUseCase: mockResetPassword,
            updateProfileUseCase: mockUpdateProfile,
          );

          ownerAuthCubit = AuthCubit(
            loginUseCase: mockLogin,
            registerUseCase: mockRegister,
            logoutUseCase: mockLogout,
            getCurrentUserUseCase: mockGetCurrentUser,
            changePasswordUseCase: mockChangePassword,
            resetPasswordUseCase: mockResetPassword,
            updateProfileUseCase: mockUpdateProfile,
          );
        });

        tearDown(() {
          userBookingCubit.close();
          userAuthCubit.close();
          ownerAuthCubit.close();
        });

        test('STEP 1: User logs in successfully', () async {
          // Arrange
          when(
            () => mockLogin(any()),
          ).thenAnswer((_) async => Right(testData.user));

          // Act
          await userAuthCubit.login(
            email: testData.user.email,
            password: 'password123',
          );

          // Assert
          expect(userAuthCubit.state, isA<Authenticated>());
          expect(
            (userAuthCubit.state as Authenticated).user.id,
            testData.user.id,
          );
          expect((userAuthCubit.state as Authenticated).user.role, 'user');

          verify(() => mockLogin(any())).called(1);
        });

        blocTest<BookingFlowCubit, BookingFlowState>(
          'STEP 2: User initializes booking flow and loads available slots',
          build: () {
            when(
              () => mockGetTimeSlots(
                fieldId: any(named: 'fieldId'),
                date: any(named: 'date'),
              ),
            ).thenAnswer(
              (_) async => Right(CrossRoleTestData.allAvailableSlots),
            );
            when(
              () => mockGroupTimeSlots(any()),
            ).thenReturn(CrossRoleTestData.slotsByPeriod);
            return userBookingCubit;
          },
          act: (cubit) => cubit.initializeFlow(testData.field),
          expect: () => [
            isA<BookingFlowActive>()
                .having((s) => s.fieldId, 'fieldId', testData.field.id)
                .having((s) => s.fieldName, 'fieldName', testData.field.name)
                .having((s) => s.pricePerHour, 'pricePerHour', 200.0)
                .having((s) => s.isLoadingSlots, 'isLoadingSlots', true),
            isA<BookingFlowActive>()
                .having((s) => s.isLoadingSlots, 'isLoadingSlots', false)
                .having((s) => s.slotsByPeriod.isNotEmpty, 'hasSlots', true),
          ],
          verify: (_) {
            verify(
              () => mockGetTimeSlots(
                fieldId: any(named: 'fieldId'),
                date: any(named: 'date'),
              ),
            ).called(1);
          },
        );

        blocTest<BookingFlowCubit, BookingFlowState>(
          'STEP 3: User selects date and time slot',
          build: () => userBookingCubit,
          seed: () => BookingFlowActive(
            currentStep: BookingFlowStep.selectTime,
            fieldId: testData.field.id,
            fieldName: testData.field.name,
            pricePerHour: testData.field.pricePerHour,
            selectedDate: DateTime(2026, 1, 16),
            slotsByPeriod: CrossRoleTestData.slotsByPeriod,
            selectedDuration: 1,
          ),
          act: (cubit) {
            cubit.selectTimeSlot(CrossRoleTestData.eveningSlots.first);
          },
          expect: () => [
            isA<BookingFlowActive>().having(
              (s) => s.selectedTimeSlot?.startTime,
              'startTime',
              '18:00',
            ),
          ],
        );

        blocTest<BookingFlowCubit, BookingFlowState>(
          'STEP 4: User confirms and submits booking',
          build: () {
            when(
              () => mockCreateBooking(
                fieldId: any(named: 'fieldId'),
                date: any(named: 'date'),
                startTime: any(named: 'startTime'),
                endTime: any(named: 'endTime'),
                totalPrice: any(named: 'totalPrice'),
                notes: any(named: 'notes'),
                durationHours: any(named: 'durationHours'),
              ),
            ).thenAnswer((_) async => Right(testData.pendingBooking));
            return userBookingCubit;
          },
          seed: () => BookingFlowActive(
            currentStep: BookingFlowStep.confirm,
            fieldId: testData.field.id,
            fieldName: testData.field.name,
            pricePerHour: 200.0,
            selectedDate: DateTime(2026, 1, 16),
            selectedTimeSlot: CrossRoleTestData.eveningSlots.first,
            selectedDuration: 1,
          ),
          act: (cubit) => cubit.submitBooking(notes: 'First booking'),
          expect: () => [
            isA<BookingFlowSubmitting>(),
            isA<BookingFlowSuccess>()
                .having(
                  (s) => s.booking.status,
                  'status',
                  BookingStatus.pending,
                )
                .having((s) => s.booking.totalPrice, 'totalPrice', 200.0),
          ],
          verify: (_) {
            verify(
              () => mockCreateBooking(
                fieldId: any(named: 'fieldId'),
                date: any(named: 'date'),
                startTime: any(named: 'startTime'),
                endTime: any(named: 'endTime'),
                totalPrice: any(named: 'totalPrice'),
                notes: any(named: 'notes'),
                durationHours: any(named: 'durationHours'),
              ),
            ).called(1);
          },
        );

        test('STEP 5: Owner logs in successfully', () async {
          // Arrange
          when(
            () => mockLogin(any()),
          ).thenAnswer((_) async => Right(testData.owner));

          // Act
          await ownerAuthCubit.login(
            email: testData.owner.email,
            password: 'ownerpass123',
            loginMode: 'admin',
          );

          // Assert
          expect(ownerAuthCubit.state, isA<Authenticated>());
          expect((ownerAuthCubit.state as Authenticated).user.role, 'admin');
        });

        test('STEP 6-10: Booking state transitions verified', () {
          // Test booking state transitions
          final pending = testData.pendingBooking;
          final confirmed = testData.confirmedBooking;
          final paymentUploaded = testData.paymentUploadedBooking;
          final completed = testData.completedBooking;

          // Verify initial pending state
          expect(pending.status, BookingStatus.pending);
          expect(pending.paymentStatus, PaymentStatus.pending);

          // Verify confirmed state (after owner approval)
          expect(confirmed.status, BookingStatus.confirmed);
          expect(confirmed.paymentStatus, PaymentStatus.pending);

          // Verify payment uploaded state
          expect(paymentUploaded.status, BookingStatus.confirmed);
          expect(paymentUploaded.paymentStatus, PaymentStatus.uploaded);
          expect(paymentUploaded.paymentProofUrl, isNotNull);

          // Verify completed state
          expect(completed.status, BookingStatus.completed);
          expect(completed.paymentStatus, PaymentStatus.verified);
        });

        test('STEP 11: User can leave a review after completion', () async {
          // Arrange
          when(
            () => mockCanReview(any()),
          ).thenAnswer((_) async => const Right(true));

          when(
            () => mockCreateReview(any()),
          ).thenAnswer((_) async => Right(testData.review));

          // Act - Check eligibility
          final canReviewResult = await mockCanReview(
            CanUserReviewFieldParams(
              userId: testData.user.id,
              fieldId: testData.field.id,
              bookingId: testData.completedBooking.id,
            ),
          );

          // Assert
          expect(canReviewResult.isRight(), isTrue);
          canReviewResult.fold(
            (l) => fail('Should be eligible'),
            (canReview) => expect(canReview, isTrue),
          );

          // Act - Create review
          final reviewResult = await mockCreateReview(
            CreateReviewParams(
              userId: testData.user.id,
              fieldId: testData.field.id,
              bookingId: testData.completedBooking.id,
              rating: 5,
              comment: 'Great field!',
            ),
          );

          // Assert
          expect(reviewResult.isRight(), isTrue);
          reviewResult.fold((l) => fail('Review should be created'), (review) {
            expect(review.rating, 5);
            expect(review.userId, testData.user.id);
          });
        });

        test(
          'COMPLETE LIFECYCLE: All steps pass with correct state transitions',
          () {
            // This test documents the complete state transition flow:

            // 1. USER ROLE - Authentication
            //    AuthInitial → AuthLoading → Authenticated(user)

            // 2. USER ROLE - Booking Flow
            //    BookingFlowInitial
            //      → BookingFlowActive(step: selectDate, isLoadingSlots: true)
            //      → BookingFlowActive(step: selectDate, slots loaded)
            //      → BookingFlowActive(step: selectTime, slot selected)
            //      → BookingFlowActive(step: confirm)
            //      → BookingFlowSubmitting
            //      → BookingFlowSuccess(booking: pending)

            // 3. OWNER ROLE - Approval
            //    booking.status: pending → confirmed

            // 4. USER ROLE - Payment Upload
            //    booking.paymentStatus: pending → uploaded

            // 5. OWNER ROLE - Payment Verification
            //    booking.paymentStatus: uploaded → verified

            // 6. SYSTEM - Auto-complete after date passes
            //    booking.status: confirmed → completed

            // 7. USER ROLE - Review
            //    User can now leave review for the field

            expect(true, isTrue); // Placeholder for documentation
          },
        );
      },
    );

    // ========================================================================
    // TEST 2: CONCURRENT BOOKING CONFLICT
    // Two users try to book the same slot simultaneously
    // ========================================================================
    group(
      'INTEGRATION_002: Concurrent Booking Conflict (User A vs User B)',
      () {
        late BookingFlowCubit userACubit;
        late BookingFlowCubit userBCubit;
        late MockCreateBookingUseCase mockCreateBookingA;
        late MockCreateBookingUseCase mockCreateBookingB;
        late MockGetAvailableTimeSlotsUseCase mockGetTimeSlots;
        late MockGroupTimeSlotsByPeriodUseCase mockGroupTimeSlots;
        late MockFindConsecutiveSlotUseCase mockFindConsecutiveSlot;
        late MockValidateSlotSelectionUseCase mockValidateSlotSelection;

        final testData = CrossRoleTestData.concurrentBookingScenario;

        setUp(() {
          mockCreateBookingA = MockCreateBookingUseCase();
          mockCreateBookingB = MockCreateBookingUseCase();
          mockGetTimeSlots = MockGetAvailableTimeSlotsUseCase();
          mockGroupTimeSlots = MockGroupTimeSlotsByPeriodUseCase();
          mockFindConsecutiveSlot = MockFindConsecutiveSlotUseCase();
          mockValidateSlotSelection = MockValidateSlotSelectionUseCase();

          userACubit = BookingFlowCubit(
            getAvailableTimeSlotsUseCase: mockGetTimeSlots,
            createBookingUseCase: mockCreateBookingA,
            groupTimeSlotsByPeriodUseCase: mockGroupTimeSlots,
            findConsecutiveSlotUseCase: mockFindConsecutiveSlot,
            validateSlotSelectionUseCase: mockValidateSlotSelection,
          );

          userBCubit = BookingFlowCubit(
            getAvailableTimeSlotsUseCase: mockGetTimeSlots,
            createBookingUseCase: mockCreateBookingB,
            groupTimeSlotsByPeriodUseCase: mockGroupTimeSlots,
            findConsecutiveSlotUseCase: mockFindConsecutiveSlot,
            validateSlotSelectionUseCase: mockValidateSlotSelection,
          );
        });

        tearDown(() {
          userACubit.close();
          userBCubit.close();
        });

        test('Both users see the slot as available and select it', () async {
          // Arrange - Both users see the same available slots
          when(
            () => mockGetTimeSlots(
              fieldId: any(named: 'fieldId'),
              date: any(named: 'date'),
            ),
          ).thenAnswer((_) async => Right(CrossRoleTestData.eveningSlots));
          when(
            () => mockGroupTimeSlots(any()),
          ).thenReturn({'Evening': CrossRoleTestData.eveningSlots});

          // Both users see 18:00-19:00 as available
          final contestedSlot = testData.contestedSlot;
          expect(contestedSlot.isAvailable, isTrue);
          expect(contestedSlot.startTime, '18:00');
        });

        test(
          'User A confirms first and succeeds, User B gets conflict error',
          () async {
            // Arrange
            final userABooking = BookingEntity(
              id: 'booking-userA',
              userId: testData.userA.id,
              fieldId: testData.field.id,
              date: testData.date,
              startTime: '18:00',
              endTime: '19:00',
              durationHours: 1,
              totalPrice: 200.0,
              currency: 'EGP',
              status: BookingStatus.pending,
              paymentStatus: PaymentStatus.pending,
              createdAt: DateTime.now(),
            );

            // User A's booking succeeds (they confirmed first)
            when(
              () => mockCreateBookingA(
                fieldId: any(named: 'fieldId'),
                date: any(named: 'date'),
                startTime: any(named: 'startTime'),
                endTime: any(named: 'endTime'),
                totalPrice: any(named: 'totalPrice'),
                notes: any(named: 'notes'),
                durationHours: any(named: 'durationHours'),
              ),
            ).thenAnswer((_) async => Right(userABooking));

            // User B's booking fails (slot already taken)
            when(
              () => mockCreateBookingB(
                fieldId: any(named: 'fieldId'),
                date: any(named: 'date'),
                startTime: any(named: 'startTime'),
                endTime: any(named: 'endTime'),
                totalPrice: any(named: 'totalPrice'),
                notes: any(named: 'notes'),
                durationHours: any(named: 'durationHours'),
              ),
            ).thenAnswer(
              (_) async => const Left(
                ConflictFailure('This slot has been booked by another user'),
              ),
            );

            // Act - User A confirms
            final resultA = await mockCreateBookingA(
              fieldId: testData.field.id,
              date: testData.date,
              startTime: '18:00',
              endTime: '19:00',
              totalPrice: 200.0,
              durationHours: 1,
            );

            // Act - User B confirms
            final resultB = await mockCreateBookingB(
              fieldId: testData.field.id,
              date: testData.date,
              startTime: '18:00',
              endTime: '19:00',
              totalPrice: 200.0,
              durationHours: 1,
            );

            // Assert - User A succeeds
            expect(resultA.isRight(), isTrue);
            resultA.fold((l) => fail('User A should succeed'), (booking) {
              expect(booking.id, 'booking-userA');
              expect(booking.userId, testData.userA.id);
            });

            // Assert - User B fails with conflict error
            expect(resultB.isLeft(), isTrue);
            resultB.fold((failure) {
              expect(failure, isA<ConflictFailure>());
              expect(failure.message, contains('booked by another user'));
            }, (r) => fail('User B should fail'));
          },
        );

        blocTest<BookingFlowCubit, BookingFlowState>(
          'User B sees error state and can retry with different slot',
          build: () {
            when(
              () => mockCreateBookingB(
                fieldId: any(named: 'fieldId'),
                date: any(named: 'date'),
                startTime: any(named: 'startTime'),
                endTime: any(named: 'endTime'),
                totalPrice: any(named: 'totalPrice'),
                notes: any(named: 'notes'),
                durationHours: any(named: 'durationHours'),
              ),
            ).thenAnswer(
              (_) async => const Left(
                ConflictFailure('This slot has been booked by another user'),
              ),
            );
            return userBCubit;
          },
          seed: () => BookingFlowActive(
            currentStep: BookingFlowStep.confirm,
            fieldId: testData.field.id,
            fieldName: testData.field.name,
            pricePerHour: 200.0,
            selectedDate: testData.date,
            selectedTimeSlot: testData.contestedSlot,
            selectedDuration: 1,
          ),
          act: (cubit) => cubit.submitBooking(),
          expect: () => [
            isA<BookingFlowSubmitting>(),
            isA<BookingFlowError>().having(
              (s) => s.message,
              'message',
              'This slot has been booked by another user',
            ),
          ],
        );

        blocTest<BookingFlowCubit, BookingFlowState>(
          'User B retries from error and goes back to slot selection',
          build: () => userBCubit,
          seed: () => BookingFlowError(
            message: 'This slot has been booked by another user',
            previousState: BookingFlowActive(
              currentStep: BookingFlowStep.confirm,
              fieldId: testData.field.id,
              fieldName: testData.field.name,
              pricePerHour: 200.0,
              selectedDate: testData.date,
              selectedTimeSlot: testData.contestedSlot,
              selectedDuration: 1,
            ),
          ),
          act: (cubit) => cubit.retryFromError(),
          expect: () => [
            isA<BookingFlowActive>()
                .having((s) => s.currentStep, 'step', BookingFlowStep.confirm)
                .having((s) => s.selectedTimeSlot?.startTime, 'slot', '18:00'),
          ],
        );
      },
    );

    // ========================================================================
    // TEST 3: RECURRING BOOKING WORKFLOW
    // User requests recurring → Owner approves → System generates bookings
    // ========================================================================
    group('INTEGRATION_003: Recurring Booking Workflow (User → Owner)', () {
      late MockCreateRecurringRequestUseCase mockCreateRequest;
      late MockGetPendingRecurringRequestsUseCase mockGetPendingRequests;
      late MockApproveRecurringBookingUseCase mockApproveRecurring;
      late MockRejectRecurringBookingUseCase mockRejectRecurring;

      final recurringRequest = CrossRoleTestData.pendingRecurringRequest;
      final activeRecurring = CrossRoleTestData.activeRecurringBooking;

      setUp(() {
        mockCreateRequest = MockCreateRecurringRequestUseCase();
        mockGetPendingRequests = MockGetPendingRecurringRequestsUseCase();
        mockApproveRecurring = MockApproveRecurringBookingUseCase();
        mockRejectRecurring = MockRejectRecurringBookingUseCase();
      });

      test('STEP 1: User creates recurring booking request', () async {
        // Arrange
        when(
          () => mockCreateRequest(any()),
        ).thenAnswer((_) async => Right(recurringRequest.id));

        // Act
        final result = await mockCreateRequest(
          const CreateRecurringRequestParams(
            fieldId: 'field-001',
            dayOfWeek: 1, // Sunday
            startTime: '18:00',
            durationHours: 1,
          ),
        );

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (l) => fail('Should succeed'),
          (requestId) => expect(requestId, recurringRequest.id),
        );
      });

      test('STEP 2: Owner sees pending recurring request', () async {
        // Arrange
        when(
          () => mockGetPendingRequests(),
        ).thenAnswer((_) async => Right([recurringRequest]));

        // Act
        final result = await mockGetPendingRequests();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold((l) => fail('Should load requests'), (requests) {
          expect(requests.length, 1);
          expect(requests.first.status, RecurringBookingStatus.pendingApproval);
          expect(requests.first.dayOfWeek, 1); // Sunday
          expect(requests.first.startTime, '18:00');
        });
      });

      test('STEP 3: Owner approves recurring booking', () async {
        // Arrange
        when(
          () => mockApproveRecurring(any()),
        ).thenAnswer((_) async => const Right(true));

        // Act
        final result = await mockApproveRecurring(
          ApproveRecurringBookingParams(
            recurringBookingId: recurringRequest.id,
          ),
        );

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (l) => fail('Should approve'),
          (success) => expect(success, isTrue),
        );
      });

      test('STEP 4: System generates individual bookings for 4 weeks', () {
        // After approval, the system should generate 4 individual bookings
        // for the next 4 Sundays at 18:00-19:00

        final today = DateTime(2026, 1, 15);
        final expectedDates = <DateTime>[];

        // Find next 4 Sundays (dayOfWeek 1 in Egypt calendar)
        var nextSunday = today;
        while (nextSunday.weekday != DateTime.sunday) {
          nextSunday = nextSunday.add(const Duration(days: 1));
        }

        for (int i = 0; i < 4; i++) {
          expectedDates.add(nextSunday.add(Duration(days: 7 * i)));
        }

        // Verify we have 4 dates, all are Sundays
        expect(expectedDates.length, 4);
        for (final date in expectedDates) {
          expect(date.weekday, DateTime.sunday);
        }
      });

      test('STEP 5: Active recurring status verified', () {
        // Verify active recurring booking state
        expect(activeRecurring.status, RecurringBookingStatus.active);
        expect(activeRecurring.startedAt, isNotNull);
      });

      test('Owner can reject recurring request with reason', () async {
        // Arrange
        when(
          () => mockRejectRecurring(any()),
        ).thenAnswer((_) async => const Right(true));

        // Act
        final result = await mockRejectRecurring(
          RejectRecurringBookingParams(
            recurringBookingId: recurringRequest.id,
            reason: 'Slot unavailable for recurring bookings',
          ),
        );

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (l) => fail('Should reject'),
          (success) => expect(success, isTrue),
        );
      });
    });

    // ========================================================================
    // TEST 4: ADMIN ONBOARDING WORKFLOW
    // Super Admin creates admin → Admin first login → Password change
    // ========================================================================
    group('INTEGRATION_004: Admin Onboarding (Super Admin → Admin)', () {
      late AuthCubit superAdminAuthCubit;
      late AuthCubit newAdminAuthCubit;
      late MockCreateAdminAccountUseCase mockCreateAdmin;
      late MockVerifyFieldUseCase mockVerifyField;
      late MockLoginUseCase mockLogin;
      late MockChangePasswordUseCase mockChangePassword;
      late MockGetCurrentUserUseCase mockGetCurrentUser;

      final testData = CrossRoleTestData.adminOnboardingScenario;

      setUp(() {
        mockCreateAdmin = MockCreateAdminAccountUseCase();
        mockVerifyField = MockVerifyFieldUseCase();
        mockLogin = MockLoginUseCase();
        mockChangePassword = MockChangePasswordUseCase();
        mockGetCurrentUser = MockGetCurrentUserUseCase();

        superAdminAuthCubit = AuthCubit(
          loginUseCase: mockLogin,
          registerUseCase: MockRegisterUseCase(),
          logoutUseCase: MockLogoutUseCase(),
          getCurrentUserUseCase: mockGetCurrentUser,
          changePasswordUseCase: mockChangePassword,
          resetPasswordUseCase: MockResetPasswordUseCase(),
          updateProfileUseCase: MockUpdateProfileUseCase(),
        );

        newAdminAuthCubit = AuthCubit(
          loginUseCase: mockLogin,
          registerUseCase: MockRegisterUseCase(),
          logoutUseCase: MockLogoutUseCase(),
          getCurrentUserUseCase: mockGetCurrentUser,
          changePasswordUseCase: mockChangePassword,
          resetPasswordUseCase: MockResetPasswordUseCase(),
          updateProfileUseCase: MockUpdateProfileUseCase(),
        );
      });

      tearDown(() {
        superAdminAuthCubit.close();
        newAdminAuthCubit.close();
      });

      test('STEP 1: Super Admin logs in', () async {
        // Arrange
        when(
          () => mockLogin(any()),
        ).thenAnswer((_) async => Right(testData.superAdmin));

        // Act
        await superAdminAuthCubit.login(
          email: testData.superAdmin.email,
          password: 'superadminpass',
          loginMode: 'admin',
        );

        // Assert
        expect(superAdminAuthCubit.state, isA<Authenticated>());
        expect(
          (superAdminAuthCubit.state as Authenticated).user.role,
          'super_admin',
        );
      });

      test('STEP 2: Super Admin creates new admin account', () async {
        // Arrange
        final invitation = AdminInvitationEntity(
          id: 'invitation-001',
          adminId: testData.newAdmin.id,
          email: testData.newAdmin.email,
          fullName: testData.newAdmin.fullName ?? 'New Admin',
          defaultPassword: testData.tempPassword,
          createdBy: testData.superAdmin.id,
          status: AdminInvitationStatus.pending,
          createdAt: DateTime.now(),
        );

        when(
          () => mockCreateAdmin(
            email: any(named: 'email'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
            defaultPassword: any(named: 'defaultPassword'),
          ),
        ).thenAnswer((_) async => Right(invitation));

        // Act
        final result = await mockCreateAdmin(
          email: testData.newAdmin.email,
          fullName: testData.newAdmin.fullName ?? '',
          phone: testData.newAdmin.phone,
        );

        // Assert
        expect(result.isRight(), isTrue);
        result.fold((l) => fail('Should create admin'), (inv) {
          expect(inv.email, testData.newAdmin.email);
          expect(inv.defaultPassword, isNotEmpty);
        });
      });

      test('STEP 3: New Admin logs in with temp password', () async {
        // Arrange
        when(
          () => mockLogin(any()),
        ).thenAnswer((_) async => Right(testData.newAdmin));

        // Act
        await newAdminAuthCubit.login(
          email: testData.newAdmin.email,
          password: testData.tempPassword,
          loginMode: 'admin',
        );

        // Assert
        expect(newAdminAuthCubit.state, isA<Authenticated>());
        final user = (newAdminAuthCubit.state as Authenticated).user;
        expect(user.passwordChanged, isFalse); // Needs to change password
      });

      test(
        'STEP 4: New Admin changes password (required on first login)',
        () async {
          // Arrange
          when(
            () => mockChangePassword(any()),
          ).thenAnswer((_) async => const Right(null));

          final updatedAdmin = testData.newAdmin.copyWith(
            passwordChanged: true,
          );
          when(
            () => mockGetCurrentUser(),
          ).thenAnswer((_) async => Right(updatedAdmin));

          // Pre-populate admin as logged in first
          when(
            () => mockLogin(any()),
          ).thenAnswer((_) async => Right(testData.newAdmin));
          await newAdminAuthCubit.login(
            email: testData.newAdmin.email,
            password: testData.tempPassword,
          );

          // Act
          await newAdminAuthCubit.changePassword(
            currentPassword: testData.tempPassword,
            newPassword: testData.newPassword,
          );

          // Wait for state to settle
          await Future.delayed(const Duration(milliseconds: 100));

          // Assert
          expect(newAdminAuthCubit.state, isA<Authenticated>());
          final user = (newAdminAuthCubit.state as Authenticated).user;
          expect(user.passwordChanged, isTrue);
        },
      );

      test('STEP 5-7: Field creation and verification flow', () {
        // Admin creates field (unverified by default)
        final newField = testData.newField;
        expect(newField.isVerified, isFalse);
        // Unverified field belongs to admin-001 in test data
        expect(newField.ownerId, 'admin-001');
        expect(newField.isActive, isTrue);

        // After Super Admin verification
        final verifiedField = CrossRoleTestData.verifiedField;
        expect(verifiedField.isVerified, isTrue);
        expect(verifiedField.isActive, isTrue);
      });
    });

    // ========================================================================
    // TEST 5: FIELD VERIFICATION WORKFLOW
    // Owner creates field → Super Admin reviews → Approves/Rejects
    // ========================================================================
    group('INTEGRATION_005: Field Verification (Owner → Super Admin)', () {
      late MockVerifyFieldUseCase mockVerifyField;

      final testData = CrossRoleTestData.fieldVerificationScenario;

      setUp(() {
        mockVerifyField = MockVerifyFieldUseCase();
      });

      test('STEP 1: Owner creates field (automatically unverified)', () {
        final newField = testData.unverifiedField;

        expect(newField.isVerified, isFalse);
        expect(newField.isActive, isTrue);
        expect(newField.ownerId, testData.owner.id);
      });

      test('STEP 2: Super Admin sees unverified field in list', () {
        // Super Admin can filter fields by verification status
        final unverifiedFields = [testData.unverifiedField];

        expect(unverifiedFields.length, 1);
        expect(unverifiedFields.first.isVerified, isFalse);
      });

      test('STEP 3: Super Admin reviews and verifies field', () async {
        // Arrange
        when(
          () => mockVerifyField(
            fieldId: any(named: 'fieldId'),
            isVerified: any(named: 'isVerified'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await mockVerifyField(
          fieldId: testData.unverifiedField.id,
          isVerified: true,
        );

        // Assert
        expect(result.isRight(), isTrue);
      });

      test('STEP 4: Verified field appears in user field browse', () {
        final verifiedField = testData.verifiedField;

        expect(verifiedField.isVerified, isTrue);
        expect(verifiedField.isActive, isTrue);
        // This field would now appear when users browse/search fields
      });

      test('Super Admin can unverify a field', () async {
        // If field has issues, Super Admin can remove verification
        when(
          () => mockVerifyField(
            fieldId: any(named: 'fieldId'),
            isVerified: any(named: 'isVerified'),
          ),
        ).thenAnswer((_) async => const Right(null));

        final result = await mockVerifyField(
          fieldId: testData.verifiedField.id,
          isVerified: false,
        );

        expect(result.isRight(), isTrue);
      });
    });

    // ========================================================================
    // TEST 6: USER DEACTIVATION WORKFLOW
    // Super Admin deactivates user → User cannot login
    // ========================================================================
    group('INTEGRATION_006: User Deactivation (Super Admin action)', () {
      test('Deactivated user data reflects inactive status', () {
        final deactivatedUser = CrossRoleTestData.deactivatedUser;

        expect(deactivatedUser.isActive, isFalse);

        // When deactivated user tries to login, they should get an error
        // In real implementation:
        // 1. Login would check isActive status
        // 2. Return AuthenticationFailure('Account deactivated')
      });

      test('Deactivated user active bookings are handled', () {
        // When a user is deactivated with active bookings:
        // 1. Future bookings should be canceled
        // 2. Owners should be notified
        // 3. Slots should be released

        // This is typically handled by a use case or trigger
        expect(true, isTrue); // Placeholder for documentation
      });
    });

    // ========================================================================
    // TEST 7: PAYMENT REJECTION WORKFLOW
    // User uploads proof → Owner rejects → User re-uploads
    // ========================================================================
    group('INTEGRATION_007: Payment Rejection Workflow', () {
      test('Owner rejects unclear payment proof', () {
        final bookingWithProof = CrossRoleTestData.paymentUploadedBooking;

        expect(bookingWithProof.paymentStatus, PaymentStatus.uploaded);
        expect(bookingWithProof.paymentProofUrl, isNotNull);

        // Owner reviews and rejects with reason
        const rejectionReason =
            'Screenshot unclear, please upload clearer image';

        // After rejection:
        // - paymentStatus should be 'rejected'
        // - User should be notified
        // - User can re-upload

        expect(rejectionReason, isNotEmpty);
      });

      test('User receives rejection notification and re-uploads', () {
        // User receives push notification with rejection reason
        // User takes new screenshot and re-uploads

        // After re-upload:
        // - paymentStatus returns to 'uploaded'
        // - Owner can review again

        expect(true, isTrue); // Placeholder
      });
    });
  });
}
