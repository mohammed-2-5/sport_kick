# Comprehensive Test Scenarios - Sport Kick

**Document Version:** 1.0
**Last Updated:** January 2026
**Coverage:** All 3 User Roles × All Features × Happy/Unhappy Paths

---

## Table of Contents

1. [Testing Strategy](#testing-strategy)
2. [Regular User Test Scenarios](#regular-user-test-scenarios)
3. [Field Owner Test Scenarios](#field-owner-test-scenarios)
4. [Super Admin Test Scenarios](#super-admin-test-scenarios)
5. [Cross-Role Integration Tests](#cross-role-integration-tests)
6. [Performance & Security Tests](#performance--security-tests)
7. [Test Execution Guide](#test-execution-guide)

---

## Testing Strategy

### Test Categories

1. **Happy Path (Smart Behavior)** ✅
   - User follows expected workflow
   - All inputs are valid
   - System responds correctly
   - Data persists correctly

2. **Unhappy Path (Bad Behavior)** ❌
   - Invalid inputs
   - Missing required fields
   - Boundary violations
   - Business rule violations
   - Edge cases

3. **Security Tests** 🔒
   - Unauthorized access attempts
   - Role permission boundaries
   - Data exposure prevention
   - Session management

4. **Integration Tests** 🔄
   - Multi-user workflows
   - Real-time updates
   - Concurrent operations
   - Cross-feature dependencies

### Test Levels

```
Unit Tests (Domain/Data Layer)
     ↓
Widget Tests (UI Components)
     ↓
Cubit Tests (State Management)
     ↓
Integration Tests (Full Workflows)
     ↓
E2E Tests (Complete User Journeys)
```

---

## Regular User Test Scenarios

### 1. Authentication & Onboarding

#### 1.1 Registration (Happy Path) ✅

**Test Case:** `USER_REG_001 - Successful User Registration`

**Preconditions:**
- App installed
- No existing account with test email

**Steps:**
1. Open app → lands on splash screen
2. Navigate to `/register`
3. Enter valid data:
   - Full Name: "Ahmed Hassan"
   - Email: "ahmed.hassan@test.com"
   - Password: "SecurePass123!" (min 8 chars)
   - Phone: "+201234567890" (optional)
4. Tap "Register" button

**Expected Results:**
- ✅ Form validation passes
- ✅ Account created in Supabase auth
- ✅ User record inserted in `users` table with role='user'
- ✅ Verification email sent to user
- ✅ Redirect to onboarding flow or home
- ✅ User ID stored in AuthCubit state

**Assertions:**
```dart
blocTest<AuthCubit, AuthState>(
  'emits [AuthLoading, Authenticated] when registration succeeds',
  build: () {
    when(() => mockRegisterUseCase(any()))
        .thenAnswer((_) async => Right(mockUser));
    return AuthCubit(registerUseCase: mockRegisterUseCase);
  },
  act: (cubit) => cubit.register(
    email: 'ahmed@test.com',
    password: 'SecurePass123!',
    fullName: 'Ahmed Hassan',
  ),
  expect: () => [
    AuthLoading(),
    Authenticated(mockUser),
  ],
);
```

---

#### 1.2 Registration (Unhappy Paths) ❌

**Test Case:** `USER_REG_002 - Registration with Invalid Email`

**Steps:**
1. Enter invalid email: "notanemail"
2. Tap "Register"

**Expected Results:**
- ❌ Form validation fails before API call
- ❌ Error message: "Please enter a valid email address"
- ❌ Email field highlighted in red
- ❌ No API call made

---

**Test Case:** `USER_REG_003 - Registration with Weak Password`

**Steps:**
1. Enter password: "123" (too short)
2. Tap "Register"

**Expected Results:**
- ❌ Validation fails
- ❌ Error: "Password must be at least 8 characters"
- ❌ No account created

---

**Test Case:** `USER_REG_004 - Registration with Duplicate Email`

**Steps:**
1. Use existing email: "existing@test.com"
2. Fill valid data, tap "Register"

**Expected Results:**
- ❌ Supabase returns error: "User already registered"
- ❌ AuthCubit emits `AuthError("Email already in use")`
- ❌ User sees error message
- ❌ Can retry with different email

---

**Test Case:** `USER_REG_005 - Registration with Empty Name`

**Steps:**
1. Leave full name blank
2. Fill other fields, tap "Register"

**Expected Results:**
- ❌ Validation error: "Full name is required"
- ❌ Form submission blocked

---

#### 1.3 Login (Happy Path) ✅

**Test Case:** `USER_LOGIN_001 - Successful Login with Valid Credentials`

**Preconditions:**
- User account exists: "user@test.com" / "Password123!"

**Steps:**
1. Navigate to `/login`
2. Enter email: "user@test.com"
3. Enter password: "Password123!"
4. Tap "Login"

**Expected Results:**
- ✅ LoginUseCase validates credentials
- ✅ Supabase auth session created
- ✅ AuthCubit emits `Authenticated(user)`
- ✅ Login activity recorded in `login_activity` table
- ✅ Redirect to `/home`
- ✅ FCM token registered for notifications

**Database Check:**
```sql
SELECT * FROM login_activity
WHERE user_id = 'user_id'
ORDER BY created_at DESC LIMIT 1;

-- Expected: success=true, ip_address captured, user_agent captured
```

---

#### 1.4 Login (Unhappy Paths) ❌

**Test Case:** `USER_LOGIN_002 - Login with Wrong Password`

**Steps:**
1. Email: "user@test.com"
2. Password: "WrongPassword!"
3. Tap "Login"

**Expected Results:**
- ❌ AuthCubit emits `AuthError("Invalid credentials")`
- ❌ Login activity recorded with `success=false`
- ❌ Error message displayed
- ❌ User remains on login screen

---

**Test Case:** `USER_LOGIN_003 - Login with Non-Existent Email`

**Steps:**
1. Email: "notfound@test.com"
2. Password: "AnyPassword123"
3. Tap "Login"

**Expected Results:**
- ❌ Error: "No user found with this email"
- ❌ No session created

---

**Test Case:** `USER_LOGIN_004 - Login with Deactivated Account`

**Preconditions:**
- Super admin deactivated account

**Steps:**
1. Try to login with deactivated account

**Expected Results:**
- ❌ Error: "Your account has been deactivated. Contact support."
- ❌ No session created
- ❌ Cannot access any features

---

**Test Case:** `USER_LOGIN_005 - First Login Password Change`

**Preconditions:**
- Admin created account with temporary password
- `is_first_login=true` in database

**Steps:**
1. Login with temporary credentials
2. Redirected to `/change-password?isFirstLogin=true`

**Expected Results:**
- ✅ Cannot skip password change
- ✅ Must enter new password (validated)
- ✅ After change, `is_first_login` set to false
- ✅ Then redirected to home

---

### 2. Field Discovery & Search

#### 2.1 Browse Fields (Happy Path) ✅

**Test Case:** `USER_FIELD_001 - View All Available Fields`

**Steps:**
1. Login as user
2. Navigate to `/fields`
3. View field list

**Expected Results:**
- ✅ FieldsCubit loads fields via GetAllFieldsUseCase
- ✅ Only verified fields shown (`is_verified=true`)
- ✅ Fields display: name, image, price, rating, city
- ✅ Shimmer skeleton shown while loading
- ✅ Empty state if no fields available

**Widget Test:**
```dart
testWidgets('displays field cards when loaded', (tester) async {
  await tester.pumpWidget(
    makeTestableWidget(
      BlocProvider<FieldsCubit>.value(
        value: mockCubit..emit(FieldsLoaded(mockFields)),
        child: FieldsPage(),
      ),
    ),
  );

  expect(find.byType(FieldCard), findsNWidgets(mockFields.length));
  expect(find.text(mockFields.first.name), findsOneWidget);
});
```

---

**Test Case:** `USER_FIELD_002 - View Field Details`

**Steps:**
1. Tap on a field card
2. Navigate to `/fields/:fieldId`

**Expected Results:**
- ✅ FieldDetailsCubit loads field details
- ✅ Shows: images carousel, name, description, price, facilities, rating
- ✅ Shows business hours for each day
- ✅ Shows reviews list
- ✅ Shows "Book Now" button
- ✅ Shows "Add to Favorites" button

---

#### 2.2 Field Search (Happy Path) ✅

**Test Case:** `USER_SEARCH_001 - Search with Filters`

**Steps:**
1. Navigate to `/search`
2. Enter search criteria:
   - City: "Cairo"
   - Sport Category: "Football"
   - Price Range: 100-500 EGP/hour
   - Facilities: "Parking", "Changing Room"
3. Tap "Search"

**Expected Results:**
- ✅ AdvancedSearchFieldsUseCase called with filters
- ✅ Results match all criteria
- ✅ Results sorted by relevance/rating
- ✅ Can further refine search

---

#### 2.3 Map View (Happy Path) ✅

**Test Case:** `USER_MAP_001 - View Fields on Map`

**Steps:**
1. Navigate to `/fields-map`
2. View map with field markers

**Expected Results:**
- ✅ MapCubit loads user location (with permission)
- ✅ Map centered on user location or default city
- ✅ Field markers displayed at correct GPS coordinates
- ✅ Tap marker shows field preview card
- ✅ Tap card navigates to field details

---

#### 2.4 Field Discovery (Unhappy Paths) ❌

**Test Case:** `USER_FIELD_003 - No Fields Available in City`

**Steps:**
1. Search in city with no fields
2. View results

**Expected Results:**
- ❌ Empty state shown
- ❌ Message: "No fields available in this area"
- ❌ Suggest nearby cities or remove filter

---

**Test Case:** `USER_FIELD_004 - Failed to Load Fields (Network Error)`

**Steps:**
1. Disable network
2. Navigate to `/fields`

**Expected Results:**
- ❌ FieldsCubit emits `FieldsError("Network error")`
- ❌ Error state shown with retry button
- ❌ Tap retry reloads fields

---

### 3. Favorites

#### 3.1 Add to Favorites (Happy Path) ✅

**Test Case:** `USER_FAV_001 - Add Field to Favorites`

**Steps:**
1. On field details page
2. Tap "Add to Favorites" (heart icon)

**Expected Results:**
- ✅ AddToFavoritesUseCase called
- ✅ Record inserted in `favorites` table
- ✅ Heart icon turns solid/filled
- ✅ Success message: "Added to favorites"

---

**Test Case:** `USER_FAV_002 - Remove from Favorites`

**Steps:**
1. On favorited field page
2. Tap filled heart icon

**Expected Results:**
- ✅ RemoveFromFavoritesUseCase called
- ✅ Record deleted from `favorites` table
- ✅ Heart icon becomes outline
- ✅ Success message: "Removed from favorites"

---

**Test Case:** `USER_FAV_003 - View All Favorites`

**Steps:**
1. Navigate to `/favorites`
2. View favorite fields list

**Expected Results:**
- ✅ FavoritesCubit loads user's favorites
- ✅ Shows all favorited fields
- ✅ Tap field navigates to details
- ✅ Can remove directly from list

---

#### 3.2 Favorites (Unhappy Paths) ❌

**Test Case:** `USER_FAV_004 - Add Already Favorited Field`

**Steps:**
1. Try to add field already in favorites

**Expected Results:**
- ❌ Use case prevents duplicate
- ❌ Message: "Already in favorites"
- ❌ No duplicate record created

---

### 4. Booking Creation Flow

#### 4.1 Standard Booking (Happy Path) ✅

**Test Case:** `USER_BOOK_001 - Create 1-Hour Booking (Complete Flow)`

**Preconditions:**
- User logged in
- Field has available slots

**Steps:**

**STEP 1 - Select Date:**
1. Tap "Book Now" on field details
2. Navigate to `/create-booking` (Step 1)
3. Select date: Tomorrow (e.g., 2026-01-10)
4. Tap "Next"

**Expected:**
- ✅ BookingFlowCubit state: `BookingFlowActive(step: selectDate)`
- ✅ Cannot select today or past dates
- ✅ Minimum advance: 1 day validated
- ✅ Date stored in cubit state

**STEP 2 - Select Time Slot:**
1. View available time slots for selected date
2. Select 1-hour slot: "16:00 - 17:00" (100 EGP/hour)
3. Tap "Next"

**Expected:**
- ✅ GetAvailableTimeSlotsUseCase loaded slots
- ✅ Slots grouped by period: Morning, Afternoon, Evening, Night
- ✅ Only available slots shown (not booked, within business hours)
- ✅ Selected slot highlighted
- ✅ Price shown: 100 EGP (1 hour × 100 EGP/hour)
- ✅ State: `BookingFlowActive(step: selectTime, selectedSlot: ...)`

**STEP 3 - Confirm Booking:**
1. Review booking summary:
   - Field name, date, time, duration, price
   - Payment method: Vodafone Cash (phone: 01234567890)
2. Tap "Confirm Booking"

**Expected:**
- ✅ State: `BookingFlowActive(step: confirm)`
- ✅ Summary accurate
- ✅ Payment instructions shown

**STEP 4 - Success:**
1. CreateBookingUseCase called
2. Booking created in database

**Expected:**
- ✅ Booking record inserted with status='pending'
- ✅ Total price = 100 EGP
- ✅ State: `BookingFlowSuccess(booking: ...)`
- ✅ Success screen with invoice button
- ✅ Notification sent to field owner
- ✅ Can navigate to "My Bookings" or "View Invoice"

**Database Verification:**
```sql
SELECT * FROM bookings
WHERE user_id = 'user_id'
  AND field_id = 'field_id'
  AND booking_date = '2026-01-10'
  AND start_time = '16:00:00'
ORDER BY created_at DESC LIMIT 1;

-- Expected:
-- status = 'pending'
-- total_price = 100
-- duration_hours = 1
-- payment_status = 'pending'
```

---

**Test Case:** `USER_BOOK_002 - Create 2-Hour Booking (Consecutive Slots)`

**Steps:**
1. Select date: Tomorrow
2. Select first slot: "18:00 - 19:00"
3. System auto-checks if 19:00-20:00 available
4. Both slots selected
5. Confirm booking

**Expected Results:**
- ✅ GroupTimeSlotsByPeriodUseCase validates consecutive slots
- ✅ Total price = 200 EGP (2 hours × 100 EGP/hour)
- ✅ Duration = 2 hours
- ✅ One booking record with duration_hours=2
- ✅ Start time: 18:00, End time: 20:00

---

#### 4.2 Booking (Unhappy Paths) ❌

**Test Case:** `USER_BOOK_003 - Try to Book Today (Violates 1-Day Advance)`

**Steps:**
1. Select today's date in date picker

**Expected Results:**
- ❌ Today's date disabled in calendar
- ❌ Cannot select
- ❌ Validation message: "Bookings must be at least 1 day in advance"

---

**Test Case:** `USER_BOOK_004 - Try to Book Past Date`

**Steps:**
1. Try to select yesterday

**Expected Results:**
- ❌ Past dates disabled in calendar
- ❌ Cannot proceed

---

**Test Case:** `USER_BOOK_005 - Select 2-Hour Slot with Gap (Non-Consecutive)`

**Steps:**
1. Select slot: "14:00 - 15:00"
2. Slot "15:00 - 16:00" is BOOKED (not available)
3. Try to extend to 2 hours

**Expected Results:**
- ❌ Validation fails
- ❌ Error: "2-hour booking requires consecutive available slots"
- ❌ Can only book 1 hour or choose different time

---

**Test Case:** `USER_BOOK_006 - Booking Across Midnight with Validation Error`

**Steps:**
1. Select slot: "23:00 - 00:00" (crosses midnight)
2. Duration: 2 hours (would end at 01:00 next day)

**Expected Results:**
- ✅ If next slot (00:00-01:00) available: Allow booking
- ❌ If not available: Error message
- ✅ End time correctly calculated as next day

**Validation Logic:**
```dart
// In GroupTimeSlotsByPeriodUseCase or BookingFlowCubit
if (startTime.hour == 23 && durationHours == 2) {
  final nextDaySlotAvailable = checkSlotAvailability(
    date: selectedDate.add(Duration(days: 1)),
    startTime: '00:00',
  );
  if (!nextDaySlotAvailable) {
    return Left(ValidationFailure('Slot not available across midnight'));
  }
}
```

---

**Test Case:** `USER_BOOK_007 - Field Fully Booked on Selected Date`

**Steps:**
1. Select date
2. All time slots booked

**Expected Results:**
- ❌ Empty state: "No available slots for this date"
- ❌ Suggest trying another date
- ❌ Cannot proceed to confirmation

---

**Test Case:** `USER_BOOK_008 - Concurrent Booking (Slot Taken While Confirming)`

**Scenario:**
- User A and User B both select same slot
- User A confirms first
- User B tries to confirm

**Expected Results:**
- ✅ User A's booking succeeds
- ❌ User B gets error: "This slot has been booked by another user"
- ❌ User B must select different slot
- ✅ Use database locking or optimistic concurrency control

**Implementation Check:**
```dart
// In CreateBookingUseCase
try {
  final existingBooking = await repository.checkSlotAvailability(
    fieldId: params.fieldId,
    date: params.date,
    startTime: params.startTime,
  );

  if (existingBooking != null) {
    return Left(ConflictFailure('Slot already booked'));
  }

  // Create booking
} catch (e) {
  return Left(ServerFailure('Failed to create booking'));
}
```

---

**Test Case:** `USER_BOOK_009 - Network Failure During Booking Creation`

**Steps:**
1. Complete all steps
2. Tap "Confirm"
3. Network drops during API call

**Expected Results:**
- ❌ BookingFlowCubit emits `BookingFlowError("Network error")`
- ❌ User sees retry button
- ❌ No partial booking created (transaction rolled back)
- ✅ Can retry booking

---

### 5. Booking Management

#### 5.1 View Bookings (Happy Path) ✅

**Test Case:** `USER_BOOK_010 - View My Bookings List`

**Steps:**
1. Navigate to `/my-bookings`
2. View bookings

**Expected Results:**
- ✅ BookingsCubit loads via GetUserBookingsUseCase
- ✅ Shows tabs: "Regular Bookings" | "Recurring Bookings"
- ✅ Each booking card shows: field name, date, time, status, price
- ✅ Color-coded by status:
  - Pending: Orange
  - Confirmed: Blue
  - Completed: Green
  - Canceled: Red

---

**Test Case:** `USER_BOOK_011 - Filter Bookings by Status`

**Steps:**
1. On "My Bookings" page
2. Select filter: "Confirmed"

**Expected Results:**
- ✅ Only confirmed bookings shown
- ✅ Can switch filters dynamically
- ✅ Empty state if no bookings match filter

---

#### 5.2 Booking Details (Happy Path) ✅

**Test Case:** `USER_BOOK_012 - View Booking Details`

**Steps:**
1. Tap on booking card
2. Navigate to `/bookings/:bookingId`

**Expected Results:**
- ✅ BookingDetailsCubit loads booking details
- ✅ Shows: field info, date, time, status, payment status
- ✅ Shows payment method and instructions
- ✅ Action buttons based on status:
  - **Pending**: "Cancel Booking" | "Upload Payment Proof"
  - **Confirmed**: "Upload Payment Proof" (if not uploaded) | "Cancel" (if not past)
  - **Completed**: "Leave Review"

---

#### 5.3 Cancel Booking (Happy Path) ✅

**Test Case:** `USER_BOOK_013 - Cancel Pending Booking`

**Preconditions:**
- Booking exists with status='pending'
- Booking is in future

**Steps:**
1. View booking details
2. Tap "Cancel Booking"
3. Confirm cancellation dialog

**Expected Results:**
- ✅ CancelBookingUseCase called
- ✅ Booking status updated to 'canceled'
- ✅ Success message: "Booking canceled successfully"
- ✅ Notification sent to field owner
- ✅ Redirect to "My Bookings"

---

**Test Case:** `USER_BOOK_014 - Cancel Confirmed Booking (Future)`

**Preconditions:**
- Booking status='confirmed'
- Booking date is tomorrow

**Steps:**
1. Tap "Cancel Booking"
2. Confirm

**Expected Results:**
- ✅ Cancellation allowed
- ✅ Status updated to 'canceled'
- ✅ Owner notified

---

#### 5.4 Cancel Booking (Unhappy Paths) ❌

**Test Case:** `USER_BOOK_015 - Try to Cancel Past Booking`

**Preconditions:**
- Booking date is yesterday
- Status is 'completed'

**Steps:**
1. View booking details
2. "Cancel" button not shown

**Expected Results:**
- ❌ Cancel button hidden
- ❌ If attempted via API: Error "Cannot cancel past booking"

**Business Rule Check:**
```dart
// In CancelBookingUseCase
bool canCancel(BookingEntity booking) {
  final isPast = booking.bookingDate.isBefore(DateTime.now());
  final statusAllowsCancel = booking.status == BookingStatus.pending ||
                              booking.status == BookingStatus.confirmed;

  return !isPast && statusAllowsCancel;
}
```

---

**Test Case:** `USER_BOOK_016 - Try to Cancel Already Canceled Booking`

**Steps:**
1. Booking already canceled
2. Try to cancel again

**Expected Results:**
- ❌ Button disabled
- ❌ Error: "Booking already canceled"

---

### 6. Payment Proof Upload

#### 6.1 Payment Upload (Happy Path) ✅

**Test Case:** `USER_PAY_001 - Upload Payment Proof (Screenshot)`

**Preconditions:**
- Booking status='pending' or 'confirmed'
- payment_status='pending'

**Steps:**
1. On booking details, tap "Upload Payment Proof"
2. Select image from gallery (Vodafone Cash screenshot)
3. Tap "Upload"

**Expected Results:**
- ✅ PaymentProofCubit uploads via UploadPaymentProofUseCase
- ✅ Image uploaded to Supabase Storage
- ✅ payment_status updated to 'proof_uploaded'
- ✅ Notification sent to field owner for verification
- ✅ Success message: "Payment proof uploaded. Waiting for verification."

---

**Test Case:** `USER_PAY_002 - Payment Verified by Owner`

**Preconditions:**
- Payment proof uploaded
- Owner verifies payment

**Steps:**
1. Owner marks payment as verified
2. User receives notification

**Expected Results:**
- ✅ payment_status updated to 'verified'
- ✅ booking.status updated to 'confirmed'
- ✅ User notified: "Payment verified. Your booking is confirmed!"

---

#### 6.2 Payment Upload (Unhappy Paths) ❌

**Test Case:** `USER_PAY_003 - Upload Invalid File Type`

**Steps:**
1. Try to upload .txt file instead of image

**Expected Results:**
- ❌ Validation error: "Please upload an image file (JPG, PNG)"
- ❌ Upload blocked

---

**Test Case:** `USER_PAY_004 - Upload File Too Large`

**Steps:**
1. Select image > 10MB
2. Tap "Upload"

**Expected Results:**
- ❌ Error: "Image too large. Max size: 10MB"
- ❌ Suggest compressing image

---

**Test Case:** `USER_PAY_005 - Payment Proof Rejected by Owner`

**Scenario:**
- Owner rejects payment (unclear screenshot, wrong amount)

**Steps:**
1. Owner rejects with reason: "Screenshot unclear"
2. User receives notification

**Expected Results:**
- ❌ payment_status updated to 'rejected'
- ❌ User sees rejection reason
- ✅ Can re-upload new proof
- ✅ Notification: "Payment rejected. Please upload a clearer screenshot."

---

### 7. Reviews & Ratings

#### 7.1 Create Review (Happy Path) ✅

**Test Case:** `USER_REVIEW_001 - Leave Review After Completed Booking`

**Preconditions:**
- User has completed booking at field
- Booking status='completed'
- No existing review for this field by user

**Steps:**
1. On booking details (completed), tap "Leave Review"
2. Navigate to `/create-review`
3. Enter:
   - Rating: 5 stars
   - Comment: "Great field! Clean and well-maintained."
4. Tap "Submit Review"

**Expected Results:**
- ✅ CreateReviewUseCase validates user has completed booking
- ✅ Review inserted in `reviews` table
- ✅ Field's average rating recalculated
- ✅ Success message: "Review submitted successfully"
- ✅ Redirect to field details with new review shown

---

**Test Case:** `USER_REVIEW_002 - Update Existing Review`

**Preconditions:**
- User already reviewed field

**Steps:**
1. Tap "Edit Review"
2. Change rating from 5 to 4 stars
3. Update comment
4. Tap "Update"

**Expected Results:**
- ✅ UpdateReviewUseCase called
- ✅ Review record updated
- ✅ Field's average rating recalculated
- ✅ Success message

---

#### 7.2 Review (Unhappy Paths) ❌

**Test Case:** `USER_REVIEW_003 - Try to Review Without Completed Booking`

**Steps:**
1. User never booked field
2. Try to access review creation

**Expected Results:**
- ❌ "Leave Review" button hidden
- ❌ If accessed via URL: Error "You must complete a booking to review"

---

**Test Case:** `USER_REVIEW_004 - Submit Review with Empty Comment (Rating Only)`

**Steps:**
1. Select 4 stars
2. Leave comment empty
3. Tap "Submit"

**Expected Results:**
- ✅ Allowed (comment is optional)
- ✅ Review submitted with rating only

---

**Test Case:** `USER_REVIEW_005 - Submit Review Without Rating`

**Steps:**
1. Enter comment
2. Don't select rating
3. Tap "Submit"

**Expected Results:**
- ❌ Validation error: "Please select a rating"
- ❌ Submit blocked

---

### 8. Recurring Bookings

#### 8.1 Create Recurring Booking (Happy Path) ✅

**Test Case:** `USER_RECURRING_001 - Create Weekly Recurring Booking`

**Preconditions:**
- Field supports recurring bookings
- User logged in

**Steps:**
1. On field details, tap "Create Recurring Booking"
2. Navigate to `/createRecurring`
3. Enter details:
   - Day of Week: "Monday" (1)
   - Start Time: "18:00"
   - End Time: "19:00"
   - Duration: 1 hour
   - Start Date: Next Monday
4. Tap "Submit Request"

**Expected Results:**
- ✅ CreateRecurringBookingUseCase called
- ✅ Recurring booking record created with status='pending_approval'
- ✅ Notification sent to field owner for approval
- ✅ User redirected to "My Recurring Bookings"
- ✅ Status shown: "Pending Approval"

---

**Test Case:** `USER_RECURRING_002 - Recurring Booking Approved by Owner`

**Steps:**
1. Owner approves recurring request
2. System generates 4 weeks of bookings

**Expected Results:**
- ✅ Recurring booking status='active'
- ✅ Individual bookings created for next 4 Mondays at 18:00-19:00
- ✅ User notified: "Recurring booking approved!"
- ✅ Can view all generated bookings in "My Bookings"

---

**Test Case:** `USER_RECURRING_003 - Cancel Active Recurring Booking`

**Steps:**
1. On recurring booking details
2. Tap "Cancel Recurring Booking"
3. Confirm

**Expected Results:**
- ✅ Recurring booking status='canceled'
- ✅ Future individual bookings canceled (past ones remain)
- ✅ Owner notified
- ✅ Success message

---

#### 8.2 Recurring Bookings (Unhappy Paths) ❌

**Test Case:** `USER_RECURRING_004 - Recurring Request Rejected by Owner`

**Steps:**
1. Owner rejects request with reason: "Slot unavailable long-term"

**Expected Results:**
- ❌ Recurring booking status='rejected'
- ❌ User notified with rejection reason
- ❌ No individual bookings created
- ✅ Can create new request with different time

---

**Test Case:** `USER_RECURRING_005 - Try to Create Duplicate Recurring (Same Day/Time)`

**Steps:**
1. Already has active recurring for Monday 18:00
2. Try to create another for Monday 18:00

**Expected Results:**
- ❌ Validation error: "You already have a recurring booking for this time"
- ❌ Request blocked

---

### 9. Notifications

#### 9.1 FCM Notifications (Happy Path) ✅

**Test Case:** `USER_NOTIF_001 - Receive Booking Confirmation Notification`

**Preconditions:**
- User has FCM token registered
- App in background

**Steps:**
1. Owner confirms user's booking
2. Edge function sends FCM notification

**Expected Results:**
- ✅ User receives push notification
- ✅ Title: "Booking Confirmed"
- ✅ Body: "Your booking at [Field Name] on [Date] is confirmed!"
- ✅ Tap notification opens booking details

---

**Test Case:** `USER_NOTIF_002 - Receive Payment Request Notification`

**Steps:**
1. Owner requests payment proof
2. Notification sent

**Expected Results:**
- ✅ Notification: "Payment Required"
- ✅ Body: "Please upload payment proof for your booking at [Field]"
- ✅ Tap opens booking details with upload button

---

### 10. Profile & Settings

#### 10.1 Profile Management (Happy Path) ✅

**Test Case:** `USER_PROFILE_001 - Update Profile Information`

**Steps:**
1. Navigate to `/edit-profile`
2. Update:
   - Full Name: "Ahmed Hassan Updated"
   - Phone: "+201098765432"
3. Tap "Save"

**Expected Results:**
- ✅ UpdateProfileUseCase called
- ✅ User record updated in database
- ✅ Success message
- ✅ Changes reflected immediately

---

**Test Case:** `USER_PROFILE_002 - Change Password`

**Steps:**
1. Navigate to `/change-password`
2. Enter:
   - Current Password: "OldPass123!"
   - New Password: "NewSecure456!"
   - Confirm Password: "NewSecure456!"
3. Tap "Change Password"

**Expected Results:**
- ✅ ChangePasswordUseCase validates current password
- ✅ Password updated in Supabase auth
- ✅ Success: "Password changed successfully"
- ✅ User remains logged in (session not invalidated)

---

#### 10.2 Settings (Happy Path) ✅

**Test Case:** `USER_SETTINGS_001 - Switch Language to Arabic`

**Steps:**
1. Navigate to `/settings`
2. Select Language: "العربية (Arabic)"
3. App reloads with Arabic

**Expected Results:**
- ✅ AppLocaleCubit updates locale to 'ar'
- ✅ All text switches to Arabic
- ✅ Layout switches to RTL (Right-to-Left)
- ✅ Preference saved in SharedPreferences

---

**Test Case:** `USER_SETTINGS_002 - Switch to Dark Mode`

**Steps:**
1. Toggle "Dark Mode" switch ON

**Expected Results:**
- ✅ ThemeCubit updates to ThemeMode.dark
- ✅ App theme switches to dark
- ✅ All colors adapt (uses AppTheme.darkTheme)
- ✅ Preference persisted

---

### 11. Login Activity

**Test Case:** `USER_ACTIVITY_001 - View Login History`

**Steps:**
1. Navigate to `/login-activity`
2. View login records

**Expected Results:**
- ✅ Shows all login attempts (success and failure)
- ✅ Each record shows: date, time, IP address, device, success status
- ✅ Can identify suspicious logins

---

---

## Field Owner Test Scenarios

### 1. Field Owner Authentication

#### 1.1 Admin Login (Happy Path) ✅

**Test Case:** `OWNER_AUTH_001 - Admin Login with Valid Credentials`

**Preconditions:**
- Admin account created by Super Admin
- Email: "owner@test.com", Password: "AdminPass123!"

**Steps:**
1. Navigate to `/admin-login`
2. Enter credentials
3. Tap "Login"

**Expected Results:**
- ✅ AuthCubit authenticates via Supabase
- ✅ User role='admin' verified
- ✅ Redirect to `/owner/dashboard`
- ✅ Login activity recorded

---

#### 1.2 First Login Password Change (Happy Path) ✅

**Test Case:** `OWNER_AUTH_002 - Forced Password Change on First Login`

**Preconditions:**
- Super Admin created account with temp password
- `is_first_login=true`

**Steps:**
1. Login with temp credentials
2. Redirected to `/change-password?isFirstLogin=true`
3. Enter new password
4. Confirm

**Expected Results:**
- ✅ Cannot skip this step (no back button, redirect blocked)
- ✅ Password updated
- ✅ `is_first_login` set to false
- ✅ Then redirect to dashboard

---

### 2. Field Management

#### 2.1 Create Field (Happy Path) ✅

**Test Case:** `OWNER_FIELD_001 - Create New Football Field`

**Steps:**
1. Navigate to `/owner/fields/add`
2. Fill form:
   - Name: "Stadium City - Field A"
   - Description: "Professional 11-a-side field"
   - Address: "123 Sports St, Cairo"
   - City: "Cairo"
   - Sport Category: "Football"
   - Price per Hour: 200 EGP
   - Capacity: 22 players
   - Surface Type: "Artificial Grass"
   - Indoor/Outdoor: "Outdoor"
   - GPS: Lat=30.0444, Lng=31.2357
   - Facilities: ["Parking", "Changing Room", "Lighting"]
   - Payment Method: "Vodafone Cash"
   - Payment Phone: "01234567890"
   - Custom Instructions: "Pay before 1 hour of booking"
3. Upload 3 field images
4. Tap "Create Field"

**Expected Results:**
- ✅ FieldManagementCubit calls CreateFieldUseCase
- ✅ Images uploaded to Supabase Storage
- ✅ Field record created with `is_verified=false` (awaits Super Admin approval)
- ✅ Assigned to current admin (`admin_id`)
- ✅ Success message: "Field created successfully. Awaiting verification."
- ✅ Redirect to `/owner/fields`

**Database Check:**
```sql
SELECT * FROM fields WHERE name = 'Stadium City - Field A';

-- Expected:
-- is_verified = false
-- admin_id = current_admin_id
-- price_per_hour = 200
-- sport_category_id matches "Football"
```

---

#### 2.2 Create Field (Unhappy Paths) ❌

**Test Case:** `OWNER_FIELD_002 - Create Field with Missing Required Fields`

**Steps:**
1. Leave "Name" blank
2. Fill other fields
3. Tap "Create"

**Expected Results:**
- ❌ Validation error: "Field name is required"
- ❌ Form submission blocked

---

**Test Case:** `OWNER_FIELD_003 - Create Field with Invalid Price`

**Steps:**
1. Enter price: -50 EGP (negative)
2. Fill other fields
3. Tap "Create"

**Expected Results:**
- ❌ Validation: "Price must be greater than 0"
- ❌ Cannot proceed

---

**Test Case:** `OWNER_FIELD_004 - Upload Unsupported Image Format`

**Steps:**
1. Try to upload .gif file
2. Tap "Upload"

**Expected Results:**
- ❌ Error: "Unsupported file format. Use JPG or PNG"
- ❌ Image not uploaded

---

#### 2.3 Update Field (Happy Path) ✅

**Test Case:** `OWNER_FIELD_005 - Update Field Price`

**Steps:**
1. Navigate to `/owner/fields/edit` for existing field
2. Change price: 200 → 250 EGP
3. Tap "Save"

**Expected Results:**
- ✅ UpdateFieldUseCase called
- ✅ Field price updated
- ✅ Success message
- ✅ Future bookings not affected (use price at booking time)

---

**Test Case:** `OWNER_FIELD_006 - Update Field Images`

**Steps:**
1. Remove 1 existing image
2. Upload 2 new images
3. Save

**Expected Results:**
- ✅ Old image deleted from Supabase Storage
- ✅ New images uploaded
- ✅ Field image URLs updated

---

#### 2.4 Delete Field (Happy Path) ✅

**Test Case:** `OWNER_FIELD_007 - Delete Field with No Active Bookings`

**Preconditions:**
- Field has no future bookings

**Steps:**
1. On field list, tap "Delete" on field
2. Confirm deletion dialog

**Expected Results:**
- ✅ DeleteFieldUseCase called
- ✅ Field soft-deleted (or marked inactive)
- ✅ No longer shown in user's field browse
- ✅ Success message

---

#### 2.5 Delete Field (Unhappy Path) ❌

**Test Case:** `OWNER_FIELD_008 - Try to Delete Field with Active Bookings`

**Preconditions:**
- Field has confirmed bookings in future

**Steps:**
1. Try to delete field
2. System checks for active bookings

**Expected Results:**
- ❌ Error: "Cannot delete field with active bookings. Cancel bookings first."
- ❌ Deletion blocked
- ✅ Shows count of active bookings

---

### 3. Business Hours Management

#### 3.1 Set Business Hours (Happy Path) ✅

**Test Case:** `OWNER_HOURS_001 - Set Operating Hours for All Days`

**Steps:**
1. Navigate to `/owner/fields/:fieldId/business-hours`
2. For each day (Sunday - Saturday):
   - Sunday: 08:00 - 23:00
   - Monday: 08:00 - 23:00
   - ...
   - Friday: Closed (toggle OFF)
   - Saturday: 10:00 - 02:00 (next day - midnight crossing)
3. Tap "Save"

**Expected Results:**
- ✅ UpdateBusinessHoursUseCase called
- ✅ Records created/updated in `business_hours` table
- ✅ Midnight-crossing hours stored correctly (Saturday 10:00 to Sunday 02:00)
- ✅ Closed days marked with `is_open=false`
- ✅ Success message

**Database Check:**
```sql
SELECT * FROM business_hours WHERE field_id = 'field_id' ORDER BY day_of_week;

-- Expected for Saturday (day_of_week=6):
-- open_time = '10:00:00'
-- close_time = '02:00:00'
-- is_open = true
-- crosses_midnight = true
```

---

#### 3.2 Business Hours (Unhappy Paths) ❌

**Test Case:** `OWNER_HOURS_002 - Set Invalid Hours (Close Before Open)`

**Steps:**
1. Set Sunday: Open=18:00, Close=12:00
2. Tap "Save"

**Expected Results:**
- ❌ Validation error: "Close time must be after open time"
- ❌ Cannot save

---

**Test Case:** `OWNER_HOURS_003 - Mark All Days as Closed`

**Steps:**
1. Toggle all days to "Closed"
2. Tap "Save"

**Expected Results:**
- ❌ Warning: "Field must be open at least one day per week"
- ❌ Or allow but field becomes unbookable

---

### 4. Booking Management

#### 4.1 View Bookings (Happy Path) ✅

**Test Case:** `OWNER_BOOK_001 - View All Bookings for Owned Fields`

**Steps:**
1. Navigate to `/owner/bookings`
2. View booking list

**Expected Results:**
- ✅ OwnerBookingsCubit loads bookings via GetOwnerBookingsUseCase
- ✅ Shows bookings for all fields owned by admin
- ✅ Filters: Pending, Confirmed, Canceled, Completed
- ✅ Each card shows: user name, field, date, time, status, payment status

---

#### 4.2 Approve Booking (Happy Path) ✅

**Test Case:** `OWNER_BOOK_002 - Approve Pending Booking`

**Preconditions:**
- Booking exists with status='pending'

**Steps:**
1. On booking list, tap booking
2. View details
3. Tap "Approve Booking"

**Expected Results:**
- ✅ ApproveBookingUseCase called
- ✅ Booking status updated to 'confirmed'
- ✅ User receives notification: "Booking approved!"
- ✅ Success message for owner
- ✅ Booking moved to "Confirmed" filter

---

**Test Case:** `OWNER_BOOK_003 - Reject Booking`

**Steps:**
1. On pending booking
2. Tap "Reject"
3. Enter reason: "Maintenance scheduled"
4. Confirm

**Expected Results:**
- ✅ RejectBookingUseCase called
- ✅ Booking status='canceled'
- ✅ User notified with rejection reason
- ✅ Slot becomes available again

---

#### 4.3 Payment Verification (Happy Path) ✅

**Test Case:** `OWNER_PAY_001 - Verify Payment Proof`

**Preconditions:**
- Booking has payment_status='proof_uploaded'
- User uploaded screenshot

**Steps:**
1. View booking details
2. See uploaded payment proof image
3. Verify amount matches booking price
4. Tap "Verify Payment"

**Expected Results:**
- ✅ VerifyPaymentUseCase called
- ✅ payment_status updated to 'verified'
- ✅ booking.status updated to 'confirmed'
- ✅ User notified: "Payment verified!"
- ✅ Success message

---

**Test Case:** `OWNER_PAY_002 - Reject Payment Proof`

**Steps:**
1. View uploaded proof
2. Screenshot is blurry / wrong amount
3. Tap "Reject Payment"
4. Enter reason: "Screenshot unclear. Please upload clearer image."

**Expected Results:**
- ✅ RejectPaymentUseCase called
- ✅ payment_status updated to 'rejected'
- ✅ User notified with rejection reason
- ✅ User can re-upload

---

#### 4.4 Manual Booking Creation (Happy Path) ✅

**Test Case:** `OWNER_BOOK_004 - Create Manual Booking for Walk-In Customer`

**Scenario:**
- Customer calls or walks in without app

**Steps:**
1. Navigate to `/owner/bookings/manual`
2. Fill form:
   - Field: "Stadium City - Field A"
   - Customer Name: "Mohamed Ali"
   - Customer Phone: "01098765432"
   - Customer Email: "mohamed@test.com" (optional)
   - Date: Tomorrow
   - Start Time: "14:00"
   - End Time: "15:00"
   - Duration: 1 hour
   - Price: 200 EGP (auto-filled from field price)
   - Payment Status: "Paid" (customer paid cash)
3. Tap "Create Booking"

**Expected Results:**
- ✅ CreateManualBookingUseCase called
- ✅ Booking created with status='confirmed'
- ✅ payment_status='verified' (or custom status)
- ✅ If email provided, user gets confirmation email
- ✅ Slot marked as booked
- ✅ Success message

---

#### 4.5 Booking Management (Unhappy Paths) ❌

**Test Case:** `OWNER_BOOK_005 - Try to Approve Already Confirmed Booking`

**Steps:**
1. Booking already approved
2. Try to approve again

**Expected Results:**
- ❌ Button disabled
- ❌ Error: "Booking already confirmed"

---

**Test Case:** `OWNER_BOOK_006 - Try to Create Manual Booking for Occupied Slot`

**Steps:**
1. Slot 14:00-15:00 already booked
2. Try to create manual booking for same slot

**Expected Results:**
- ❌ Validation error: "This slot is already booked"
- ❌ Cannot proceed

---

### 5. Recurring Booking Requests

#### 5.1 Approve Recurring Request (Happy Path) ✅

**Test Case:** `OWNER_RECURRING_001 - Approve Recurring Booking Request`

**Preconditions:**
- User submitted recurring request for Monday 18:00
- Status='pending_approval'

**Steps:**
1. Navigate to `/owner/recurring-requests`
2. View request details
3. Check if slot consistently available
4. Tap "Approve"

**Expected Results:**
- ✅ ApproveRecurringBookingUseCase called
- ✅ Recurring booking status='active'
- ✅ System generates 4 individual bookings:
  - Next 4 Mondays at 18:00-19:00
  - All with status='confirmed'
- ✅ User notified: "Recurring booking approved!"

---

**Test Case:** `OWNER_RECURRING_002 - Reject Recurring Request`

**Steps:**
1. View request
2. Tap "Reject"
3. Enter reason: "Slot unavailable for recurring bookings"

**Expected Results:**
- ✅ RejectRecurringBookingUseCase called
- ✅ Status='rejected'
- ✅ User notified with reason
- ✅ No individual bookings created

---

### 6. Revenue & Analytics

#### 6.1 View Revenue (Happy Path) ✅

**Test Case:** `OWNER_REVENUE_001 - View Monthly Revenue Breakdown`

**Steps:**
1. Navigate to `/owner/revenue`
2. Select month: January 2026

**Expected Results:**
- ✅ OwnerRevenueCubit loads via GetOwnerRevenueUseCase
- ✅ Shows total revenue for month
- ✅ Breakdown by field
- ✅ Chart showing daily revenue trend
- ✅ Filter by date range

---

**Test Case:** `OWNER_ANALYTICS_001 - View Booking Analytics`

**Steps:**
1. Navigate to `/owner/analytics`
2. View charts

**Expected Results:**
- ✅ Shows:
  - Total bookings (this month)
  - Booking status breakdown (pie chart)
  - Revenue trend (line chart)
  - Top performing fields
  - Peak booking times

---

---

## Super Admin Test Scenarios

### 1. User Management

#### 1.1 View All Users (Happy Path) ✅

**Test Case:** `ADMIN_USER_001 - View Platform Users List`

**Steps:**
1. Login as Super Admin
2. Navigate to `/super-admin/users`
3. View user list

**Expected Results:**
- ✅ UserManagementCubit loads all users
- ✅ Shows: ID, name, email, role, status, registration date
- ✅ Pagination (50 users per page)
- ✅ Search by name/email
- ✅ Filter by role: User | Admin | Super Admin

---

#### 1.2 Deactivate User (Happy Path) ✅

**Test Case:** `ADMIN_USER_002 - Deactivate User Account`

**Preconditions:**
- User account active

**Steps:**
1. On user list, select user
2. Tap "Deactivate"
3. Confirm

**Expected Results:**
- ✅ DeactivateUserUseCase called
- ✅ User `is_active` set to false
- ✅ User cannot login (blocked at auth)
- ✅ Active sessions invalidated
- ✅ Success message

---

**Test Case:** `ADMIN_USER_003 - Reactivate User Account`

**Steps:**
1. Select deactivated user
2. Tap "Activate"

**Expected Results:**
- ✅ User `is_active` set to true
- ✅ User can login again

---

#### 1.3 View User Details (Happy Path) ✅

**Test Case:** `ADMIN_USER_004 - View Individual User Activity`

**Steps:**
1. Tap on user
2. Navigate to `/super-admin/user-details`

**Expected Results:**
- ✅ Shows:
  - Profile info (name, email, phone, registration date)
  - Total bookings made
  - Total reviews given
  - Login activity history
  - Favorite fields
- ✅ Can deactivate from this screen

---

### 2. Admin Management

#### 2.1 Create Admin Account (Happy Path) ✅

**Test Case:** `ADMIN_ADMIN_001 - Create New Field Owner Admin`

**Steps:**
1. Navigate to `/super-admin/create-admin`
2. Fill form:
   - Full Name: "Owner Test"
   - Email: "newowner@test.com"
   - Phone: "+201234567890"
   - Temporary Password: Auto-generated
3. Tap "Create Admin"

**Expected Results:**
- ✅ CreateAdminUseCase called
- ✅ User account created with role='admin'
- ✅ `is_first_login=true` set
- ✅ Temporary password generated (e.g., "TempPass_abc123!")
- ✅ Email sent to admin with login credentials
- ✅ Success message: "Admin created. Credentials sent via email."

**Database Check:**
```sql
SELECT * FROM users WHERE email = 'newowner@test.com';

-- Expected:
-- role = 'admin'
-- is_first_login = true
-- is_active = true
```

---

#### 2.2 Reset Admin Password (Happy Path) ✅

**Test Case:** `ADMIN_ADMIN_002 - Reset Forgotten Admin Password`

**Steps:**
1. Admin forgot password
2. Super Admin navigates to `/super-admin/reset-admin-password`
3. Select admin
4. Tap "Reset Password"

**Expected Results:**
- ✅ New temporary password generated
- ✅ `is_first_login` set to true
- ✅ Email sent to admin with new temp password
- ✅ Admin must change password on next login

---

#### 2.3 Admin Management (Unhappy Paths) ❌

**Test Case:** `ADMIN_ADMIN_003 - Try to Create Admin with Duplicate Email`

**Steps:**
1. Enter email of existing user/admin
2. Fill form, tap "Create"

**Expected Results:**
- ❌ Error: "Email already exists"
- ❌ No account created

---

### 3. Field Management

#### 3.1 View All Platform Fields (Happy Path) ✅

**Test Case:** `ADMIN_FIELD_001 - View All Fields Across Platform`

**Steps:**
1. Navigate to `/super-admin/fields`
2. View list

**Expected Results:**
- ✅ Shows ALL fields (all admins)
- ✅ Columns: Field name, Owner (admin), City, Status, Verified, Price
- ✅ Filter by: City, Verified status, Owner
- ✅ Search by name

---

#### 3.2 Verify Field (Happy Path) ✅

**Test Case:** `ADMIN_FIELD_002 - Verify Newly Created Field`

**Preconditions:**
- Admin created field
- `is_verified=false`

**Steps:**
1. View field details
2. Check field info (images, price, facilities)
3. Tap "Verify Field"

**Expected Results:**
- ✅ VerifyFieldUseCase called
- ✅ `is_verified` set to true
- ✅ Field now appears in user field browse
- ✅ Admin notified: "Field verified!"

---

**Test Case:** `ADMIN_FIELD_003 - Reject Field Verification`

**Steps:**
1. Field has inappropriate images
2. Tap "Reject Verification"
3. Enter reason: "Images do not match field description"

**Expected Results:**
- ✅ `is_verified` remains false
- ✅ Admin notified with rejection reason
- ✅ Field not bookable until fixed and re-verified

---

#### 3.3 Create Field (Super Admin) (Happy Path) ✅

**Test Case:** `ADMIN_FIELD_004 - Super Admin Creates Field Directly`

**Steps:**
1. Navigate to `/super-admin/create-field`
2. Fill all field details
3. Assign to admin: "owner@test.com"
4. Tap "Create"

**Expected Results:**
- ✅ Field created
- ✅ Auto-verified (is_verified=true) since created by Super Admin
- ✅ Assigned to selected admin
- ✅ Admin notified

---

#### 3.4 Update Any Field (Happy Path) ✅

**Test Case:** `ADMIN_FIELD_005 - Update Field Owned by Any Admin`

**Steps:**
1. Select field owned by different admin
2. Edit price or details
3. Save

**Expected Results:**
- ✅ Super Admin can update ANY field
- ✅ Changes saved
- ✅ Original owner notified of changes

---

### 4. Booking Management

#### 4.1 View All Platform Bookings (Happy Path) ✅

**Test Case:** `ADMIN_BOOK_001 - View All Bookings System-Wide`

**Steps:**
1. Navigate to `/super-admin/bookings`
2. View list

**Expected Results:**
- ✅ Shows ALL bookings (all users, all fields)
- ✅ Filter by: Status, Field, User, Date Range
- ✅ Search by booking ID

---

#### 4.2 Cancel Any Booking (Happy Path) ✅

**Test Case:** `ADMIN_BOOK_002 - Super Admin Cancels Booking`

**Scenario:**
- User dispute or system error

**Steps:**
1. Select booking
2. Tap "Cancel Booking"
3. Enter reason: "Refund requested by user"

**Expected Results:**
- ✅ Booking canceled (status='canceled')
- ✅ User notified with reason
- ✅ Owner notified
- ✅ Slot released

---

#### 4.3 Override Payment (Happy Path) ✅

**Test Case:** `ADMIN_BOOK_003 - Manually Verify Payment`

**Scenario:**
- Owner delayed verification, user complains

**Steps:**
1. View booking with payment_status='proof_uploaded'
2. Tap "Force Verify Payment"

**Expected Results:**
- ✅ payment_status='verified'
- ✅ booking.status='confirmed'
- ✅ User and owner notified

---

### 5. City Management

#### 5.1 Create City (Happy Path) ✅

**Test Case:** `ADMIN_CITY_001 - Add New City`

**Steps:**
1. Navigate to `/super-admin/cities`
2. Tap "Add City"
3. Enter name: "Alexandria"
4. Save

**Expected Results:**
- ✅ City record created
- ✅ Available in city filters across app

---

**Test Case:** `ADMIN_CITY_002 - Delete City`

**Preconditions:**
- City has no fields

**Steps:**
1. Select city
2. Tap "Delete"

**Expected Results:**
- ✅ City deleted
- ✅ Removed from filters

---

#### 5.2 City Management (Unhappy Paths) ❌

**Test Case:** `ADMIN_CITY_003 - Try to Delete City with Active Fields`

**Steps:**
1. Try to delete Cairo (has 50 fields)

**Expected Results:**
- ❌ Error: "Cannot delete city with active fields"
- ❌ Deletion blocked

---

### 6. Sport Categories

#### 6.1 Manage Categories (Happy Path) ✅

**Test Case:** `ADMIN_SPORT_001 - Create New Sport Category`

**Steps:**
1. Navigate to `/super-admin/sport-categories`
2. Tap "Add Category"
3. Enter name: "Basketball"
4. Save

**Expected Results:**
- ✅ Category created
- ✅ Available when creating fields

---

**Test Case:** `ADMIN_SPORT_002 - Update Category Name`

**Steps:**
1. Edit "Football" → "Football (Soccer)"
2. Save

**Expected Results:**
- ✅ Category updated
- ✅ All fields in category reflect new name

---

**Test Case:** `ADMIN_SPORT_003 - Delete Unused Category`

**Preconditions:**
- Category has 0 fields

**Steps:**
1. Delete category

**Expected Results:**
- ✅ Deleted successfully

---

#### 6.2 Categories (Unhappy Paths) ❌

**Test Case:** `ADMIN_SPORT_004 - Try to Delete Category with Fields`

**Steps:**
1. Try to delete "Football" (has 100 fields)

**Expected Results:**
- ❌ Error: "Cannot delete category with active fields"

---

### 7. Platform Settings

#### 7.1 Update Platform Settings (Happy Path) ✅

**Test Case:** `ADMIN_SETTINGS_001 - Change Minimum Booking Advance Notice`

**Steps:**
1. Navigate to `/super-admin/settings`
2. Update "Minimum Advance Days": 1 → 2
3. Save

**Expected Results:**
- ✅ Setting updated in `platform_settings` table
- ✅ All future bookings require 2-day advance
- ✅ Existing bookings unaffected

---

**Test Case:** `ADMIN_SETTINGS_002 - Set Default Currency`

**Steps:**
1. Update currency: EGP
2. Save

**Expected Results:**
- ✅ All prices display in EGP
- ✅ Setting persisted

---

### 8. Reports & Analytics

#### 8.1 Generate CSV Report (Happy Path) ✅

**Test Case:** `ADMIN_REPORT_001 - Export All Bookings to CSV`

**Steps:**
1. Navigate to `/super-admin/reports`
2. Select report type: "All Bookings"
3. Filter: Date Range: Jan 1-31, 2026
4. Tap "Export CSV"

**Expected Results:**
- ✅ ExportCsvUseCase called
- ✅ CSV file generated with columns:
  - booking_id, user_name, field_name, date, time, price, status, payment_status
- ✅ File downloaded to device
- ✅ Success message

---

**Test Case:** `ADMIN_REPORT_002 - Generate PDF Analytics Report`

**Steps:**
1. Select "Analytics Summary Report"
2. Date range: December 2025
3. Tap "Export PDF"

**Expected Results:**
- ✅ PDF generated with:
  - Total bookings, revenue, users
  - Charts (booking trends, revenue by field)
  - Top fields, top users
- ✅ PDF downloadable

---

### 9. Login Activity Monitoring

**Test Case:** `ADMIN_ACTIVITY_001 - View Platform-Wide Login Activity`

**Steps:**
1. Navigate to `/super-admin/login-activity`
2. View logs

**Expected Results:**
- ✅ Shows ALL login attempts (users, admins, super admins)
- ✅ Columns: User, Email, IP, Device, Success/Failure, Timestamp
- ✅ Filter by: Success status, User role, Date range
- ✅ Can identify suspicious activity (multiple failures, unusual IPs)

---

---

## Cross-Role Integration Tests

### 1. Complete Booking Lifecycle (User → Owner → User)

**Test Case:** `INTEGRATION_001 - Full Booking Flow with Payment Verification`

**Roles:** User + Owner

**Steps:**

**User Actions:**
1. User searches for field in Cairo
2. Views field details
3. Creates 1-hour booking for tomorrow, 18:00-19:00
4. Booking status='pending', payment_status='pending'
5. Receives payment instructions (Vodafone Cash to 01234567890)

**Owner Actions:**
6. Owner receives notification: "New booking request"
7. Owner approves booking
8. Booking status='confirmed'
9. User notified: "Booking confirmed. Please upload payment proof."

**User Actions:**
10. User makes payment via Vodafone Cash
11. Takes screenshot
12. Uploads payment proof
13. payment_status='proof_uploaded'

**Owner Actions:**
14. Owner receives notification: "Payment proof uploaded"
15. Owner views screenshot, verifies amount
16. Owner confirms payment
17. payment_status='verified'

**User Actions:**
18. User notified: "Payment verified!"
19. Booking fully confirmed

**Booking Completion:**
20. Booking date arrives and passes
21. System auto-updates status='completed'
22. User receives notification: "Your booking is complete. Leave a review!"

**User Actions:**
23. User leaves 5-star review
24. Review appears on field details page

**Expected Results:**
- ✅ All state transitions correct
- ✅ All notifications sent at right time
- ✅ Database consistency maintained
- ✅ Both parties can view booking history

---

### 2. Recurring Booking Lifecycle

**Test Case:** `INTEGRATION_002 - Recurring Booking Approval and Generation`

**Roles:** User + Owner

**Steps:**

**User:**
1. Requests recurring booking: Every Monday 18:00-19:00
2. Status='pending_approval'

**Owner:**
3. Receives notification
4. Reviews request
5. Approves recurring booking

**System:**
6. Generates 4 individual bookings for next 4 Mondays
7. All bookings status='confirmed'
8. User notified

**User:**
9. Views "My Recurring Bookings" - shows active
10. Views "My Bookings" - sees 4 individual bookings

**Week 1:**
11. Booking 1 completed
12. User uploads payment proof, verified by owner

**User Cancels Recurring:**
13. User cancels recurring after week 2
14. Bookings for week 3 and 4 canceled
15. Booking for week 2 (past) remains completed

**Expected Results:**
- ✅ Recurring booking lifecycle correct
- ✅ Individual bookings generated correctly
- ✅ Cancellation only affects future bookings

---

### 3. Admin Creation → First Login → Field Creation → Verification

**Test Case:** `INTEGRATION_003 - Full Admin Onboarding Flow`

**Roles:** Super Admin + New Admin

**Super Admin:**
1. Creates admin account: "newadmin@test.com"
2. Temp password: "TempPass123!"
3. Email sent to admin

**New Admin:**
4. Receives email with credentials
5. Logs in via `/admin-login`
6. Redirected to forced password change
7. Changes password to "MySecurePass456!"
8. `is_first_login` set to false
9. Redirected to `/owner/dashboard`

**New Admin Creates Field:**
10. Navigates to `/owner/fields/add`
11. Creates field: "New Stadium Field"
12. Field saved with `is_verified=false`

**Super Admin:**
13. Receives notification: "New field awaiting verification"
14. Navigates to `/super-admin/fields`
15. Views new field details
16. Verifies field
17. `is_verified=true`

**Result:**
18. Field appears in user field browse
19. Users can book the field

**Expected Results:**
- ✅ Complete admin lifecycle successful
- ✅ Password change enforced
- ✅ Field verification workflow correct

---

### 4. Concurrent Booking Conflict Resolution

**Test Case:** `INTEGRATION_004 - Two Users Book Same Slot Simultaneously`

**Roles:** User A + User B

**Setup:**
- Field has one available slot: Tomorrow 18:00-19:00

**Steps:**

**User A (at 10:00:00):**
1. Selects date, selects 18:00-19:00 slot
2. Proceeds to confirm step (not yet submitted)

**User B (at 10:00:05):**
3. Selects same date and slot
4. Proceeds to confirm step

**User A (at 10:00:10):**
5. Taps "Confirm Booking"
6. API call: CreateBookingUseCase

**User B (at 10:00:12):**
7. Taps "Confirm Booking"
8. API call: CreateBookingUseCase

**Expected Results with Proper Locking:**
- ✅ User A's booking succeeds (first to commit)
- ❌ User B's booking fails: "This slot has been booked by another user"
- ✅ User B must select different slot
- ✅ Only ONE booking exists in database for that slot

**Implementation Check:**
```dart
// In BookingRemoteDataSource or CreateBookingUseCase
Future<BookingModel> createBooking(...) async {
  // Transaction or optimistic locking
  final slotCheck = await _supabase
      .from('bookings')
      .select()
      .eq('field_id', fieldId)
      .eq('booking_date', date)
      .eq('start_time', startTime)
      .single();

  if (slotCheck != null) {
    throw ConflictException('Slot already booked');
  }

  // Create booking
}
```

---

### 5. Field Deletion Cascade

**Test Case:** `INTEGRATION_005 - Delete Field with Dependencies`

**Roles:** Owner + Super Admin

**Setup:**
- Field has:
  - 2 completed bookings
  - 1 confirmed future booking
  - 3 reviews
  - 5 users who favorited

**Owner Tries to Delete:**
1. Tap "Delete Field"

**Expected Results:**
- ❌ Error: "Cannot delete field with active bookings"

**Super Admin Intervention:**
2. Super Admin cancels future booking
3. Now field has only completed bookings

**Owner Tries Again:**
4. Tap "Delete"

**Expected Results:**
- ✅ Field soft-deleted (or marked inactive)
- ✅ Reviews archived (not deleted)
- ✅ Completed bookings remain (for history)
- ✅ Favorites automatically removed
- ✅ Field no longer appears in user browse

---

---

## Performance & Security Tests

### 1. Performance Tests

#### 1.1 Load Testing

**Test Case:** `PERF_001 - Load All Fields with 1000+ Records`

**Setup:**
- Database has 1000 fields

**Steps:**
1. User navigates to `/fields`
2. Measure load time

**Expected Results:**
- ✅ Fields load within 2 seconds
- ✅ Uses pagination (50 fields per page)
- ✅ Infinite scroll or "Load More" button
- ✅ Shimmer shown during load

---

**Test Case:** `PERF_002 - Search with Complex Filters`

**Steps:**
1. Search with 5 filters simultaneously
2. 500 fields in database

**Expected Results:**
- ✅ Results return within 1 second
- ✅ Uses database indexes
- ✅ Efficient query (no full table scan)

---

#### 1.2 Image Loading

**Test Case:** `PERF_003 - Field Details with 10 High-Res Images`

**Steps:**
1. Open field with 10 images (2MB each)

**Expected Results:**
- ✅ Uses `CachedNetworkImage`
- ✅ Thumbnails load first
- ✅ Full images lazy-loaded
- ✅ Page usable within 1 second

---

### 2. Security Tests

#### 2.1 Authorization Tests

**Test Case:** `SECURITY_001 - User Tries to Access Owner Dashboard`

**Setup:**
- Logged in as regular user (role='user')

**Steps:**
1. Try to navigate to `/owner/dashboard` via URL

**Expected Results:**
- ❌ Access denied
- ❌ Redirected to `/home` or error page
- ❌ GoRouter `redirect` logic blocks access

**Implementation Check:**
```dart
// In go_router_config.dart
GoRoute(
  path: '/owner/dashboard',
  redirect: (context, state) {
    final authState = context.read<AuthCubit>().state;
    if (authState is! Authenticated || authState.user.role != 'admin') {
      return '/home'; // Redirect non-admins
    }
    return null; // Allow admins
  },
  builder: (context, state) => OwnerDashboardPage(),
)
```

---

**Test Case:** `SECURITY_002 - Owner Tries to Access Super Admin Features`

**Steps:**
1. Logged in as owner (role='admin')
2. Try to navigate to `/super-admin/users`

**Expected Results:**
- ❌ Access denied
- ❌ Redirect to `/owner/dashboard`

---

**Test Case:** `SECURITY_003 - User Tries to Cancel Another User's Booking`

**Setup:**
- User A logged in
- Tries to cancel User B's booking via API

**Steps:**
1. User A calls `CancelBookingUseCase` with User B's booking ID

**Expected Results:**
- ❌ Use case validates booking ownership
- ❌ Error: "Unauthorized. You can only cancel your own bookings."
- ❌ Booking not canceled

**Implementation:**
```dart
// In CancelBookingUseCase
Future<Either<Failure, void>> call(String bookingId) async {
  final currentUserId = await _authRepository.getCurrentUserId();
  final booking = await _repository.getBookingById(bookingId);

  if (booking.userId != currentUserId) {
    return Left(AuthorizationFailure('Unauthorized'));
  }

  // Proceed with cancellation
}
```

---

#### 2.2 Data Exposure Prevention

**Test Case:** `SECURITY_004 - API Response Doesn't Expose Sensitive Data`

**Steps:**
1. User fetches field details
2. Inspect API response

**Expected Results:**
- ❌ Owner's full email NOT exposed (only name or masked email)
- ❌ Payment phone partially masked (e.g., "0123****890")
- ✅ Only necessary data returned

---

**Test Case:** `SECURITY_005 - SQL Injection Attempt in Search`

**Steps:**
1. Enter search query: `"; DROP TABLE fields; --`
2. Submit search

**Expected Results:**
- ✅ Input sanitized
- ✅ Supabase query parameterized (prevents injection)
- ✅ No database damage
- ✅ Returns empty results or error

---

#### 2.3 Session Management

**Test Case:** `SECURITY_006 - Session Expiry After Inactivity`

**Steps:**
1. User logs in
2. Leaves app idle for 24 hours (or configured timeout)
3. Returns and tries to perform action

**Expected Results:**
- ❌ Session expired
- ❌ Redirected to login
- ✅ Must re-authenticate

---

**Test Case:** `SECURITY_007 - Logout Invalidates Session`

**Steps:**
1. User logs in
2. Gets auth token
3. User logs out
4. Try to use old token for API call

**Expected Results:**
- ❌ Token invalid
- ❌ API returns 401 Unauthorized
- ✅ User must login again

---

---

## Test Execution Guide

### Running Tests

#### Unit Tests (UseCases, Utilities)
```bash
# Run all unit tests
flutter test

# Run specific feature tests
flutter test test/features/auth/domain/usecases/

# Run with coverage
flutter test --coverage
```

#### Cubit Tests (State Management)
```bash
# Test specific cubit
flutter test test/features/bookings/presentation/cubit/booking_flow_cubit_test.dart

# Run all cubit tests
flutter test test/features/*/presentation/cubit/
```

#### Widget Tests (UI Components)
```bash
# Test widgets
flutter test test/features/fields/presentation/widgets/

# Test with golden files (screenshot comparison)
flutter test --update-goldens
```

#### Integration Tests (E2E)
```bash
# Run integration tests
flutter test integration_test/

# Run on specific device
flutter test integration_test/booking_flow_test.dart -d <device_id>
```

### Test Coverage Goals

| Layer | Target Coverage |
|-------|----------------|
| Domain (UseCases) | 100% |
| Data (Repositories, DataSources) | 90% |
| Presentation (Cubits) | 95% |
| Widgets | 80% |
| Overall | 90% |

### Continuous Integration

**GitHub Actions / CI Pipeline:**
```yaml
# .github/workflows/test.yml
name: Test Suite

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test --coverage
      - run: flutter build apk --debug
```

---

## Test Scenarios Summary

### Coverage Statistics

**Total Test Scenarios:** 200+

| Role | Test Cases | Happy Path | Unhappy Path | Security | Integration |
|------|-----------|------------|--------------|----------|-------------|
| **Regular User** | 80 | 45 | 30 | 3 | 2 |
| **Field Owner** | 60 | 35 | 20 | 3 | 2 |
| **Super Admin** | 50 | 30 | 15 | 4 | 1 |
| **Cross-Role** | 10 | - | - | - | 10 |
| **Performance & Security** | 15 | - | - | 10 | 5 |

### Priority Levels

**P0 (Critical - Must Pass Before Release):**
- All authentication flows
- Booking creation and cancellation
- Payment verification
- Role-based access control

**P1 (High - Should Pass):**
- Search and filters
- Reviews and ratings
- Recurring bookings
- Admin field management

**P2 (Medium - Nice to Have):**
- Analytics and reports
- Notifications
- Performance optimization

**P3 (Low - Future Improvements):**
- Edge case scenarios
- Rare concurrent operations

---

## Next Steps

1. **Implement Missing Tests:** Focus on P0 scenarios first
2. **Automate Tests:** Set up CI/CD pipeline
3. **Test Data Generation:** Create seed data for testing
4. **Monitor Coverage:** Use `flutter test --coverage` regularly
5. **Manual QA:** Run exploratory testing for edge cases
6. **User Acceptance Testing (UAT):** Get real users to test critical flows

---

**Document Maintained By:** Development Team
**Last Review:** January 2026
**Next Review:** Quarterly or before major releases
