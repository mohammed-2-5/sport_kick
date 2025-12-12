# 🚀 Sport Kick - Implementation Phases Plan

**Last Updated:** December 1, 2025
**Current Status:** 85% Complete - Ready for MVP with critical fixes
**Document Purpose:** Comprehensive roadmap for completing all missing features and improvements

---

## 📊 Overview

This document outlines a phased approach to complete all remaining work items, fix placeholders, and implement missing features in the Sport Kick application.

### Quick Stats
- ✅ **Completed Features:** 8 major modules (Auth, Fields, Bookings, Owner, Super Admin, City, Favorites, Settings)
- ⚠️ **Placeholder URLs:** 3 items
- ❌ **Missing Features:** 4 major features
- 📝 **TODO Comments:** 31 items across codebase
- 🧪 **Test Coverage:** ~5% (needs improvement)

---

## 🎯 Phase 1: Critical Pre-Production Fixes
**Priority:** 🔴 **CRITICAL**
**Timeline:** 1-2 days
**Must Complete Before:** MVP Launch

### 1.1 Update Placeholder URLs ⚠️ **BLOCKING**
**File:** `lib/features/settings/presentation/constants/settings_constants.dart`

**Current State:**
```dart
static const String privacyPolicyUrl = 'https://example.com/privacy-policy';
static const String termsOfServiceUrl = 'https://example.com/terms-of-service';
static const String helpCenterUrl = 'https://example.com/help';
```

**Tasks:**
- [ ] Create or obtain Privacy Policy document
- [ ] Create or obtain Terms of Service document
- [ ] Set up Help Center (can be email: `help@sportkick.com` with mailto: link)
- [ ] Update constants with real URLs
- [ ] Test all links from settings pages (user and owner)

**Acceptance Criteria:**
- All three links open valid, accessible resources
- Privacy policy covers data collection, Supabase usage, user rights
- Terms of service covers usage rules, booking policies, refunds
- Help center provides contact method

**Estimated Time:** 4-6 hours (including document creation)

---

### 1.2 Fix API Client Unused Warning
**File:** `lib/core/network/api_client.dart`

**Issue:** This entire file is unused since app uses Supabase directly

**Options:**
1. **Remove it** (Recommended)
   - Delete `api_client.dart`
   - Remove from DI container
   - Remove `dio` dependency from `pubspec.yaml` if not used elsewhere

2. **Keep it** (if planning external API integrations)
   - Document its purpose
   - Add comment explaining when to use it

**Recommended Action:** Remove

**Tasks:**
- [ ] Search codebase for any `ApiClient` imports
- [ ] Remove file if unused
- [ ] Remove DI registration
- [ ] Update documentation

**Estimated Time:** 30 minutes

---

### 1.3 Handle "Coming Soon" Features - Decide Strategy
**Priority:** 🔴 **CRITICAL** - UX Decision Required

#### Option A: Hide Features (Quick Fix)
**Recommended for MVP Launch**

| Feature | Action | File |
|---------|--------|------|
| Reviews Section | Comment out widget | `field_details_page.dart` |
| Business Hours | Hide settings button | `owner_settings_page.dart` |
| Map View Button | Remove button | `nearby_fields_preview.dart` |
| Payments | Keep in "Coming Soon" list | `home_upcoming_features.dart` |

**Tasks:**
- [ ] Temporarily hide reviews section on field details
- [ ] Remove business hours button from owner settings
- [ ] Remove map view button from home page
- [ ] Update "Coming Soon" widget to only show Payments

**Estimated Time:** 2 hours

#### Option B: Implement Features (Full Solution)
**See Phase 2 & 3 for full implementation plans**

---

### 1.4 Verify All Critical User Flows
**Testing Checklist:**

- [ ] **User Registration & Login**
  - Register new account
  - Login with existing account
  - Password reset flow (now working)
  - Profile viewing and editing (now working)

- [ ] **Field Browsing**
  - Search fields (verify working)
  - Apply filters (verify working)
  - View field details
  - Add to favorites

- [ ] **Booking Flow**
  - Select field
  - Choose date and time slot
  - Create booking
  - View booking details
  - Cancel booking

- [ ] **Owner Dashboard**
  - View fields
  - Manage bookings
  - Approve/reject bookings
  - View analytics

- [ ] **Super Admin**
  - Create admin accounts
  - Manage users
  - View platform statistics
  - Assign fields to admins

- [ ] **Settings**
  - Change password (verify working)
  - Update preferences
  - Toggle notifications
  - External links (verify all work after URL update)

**Estimated Time:** 4-6 hours (manual testing)

---

### 1.5 Fix Remaining Lint Issues
**Current:** 86 issues (mostly pre-existing)

**Priority Issues to Fix:**
1. Remove unused import in `auth_cubit.dart`
2. Replace deprecated `Share` with `SharePlus` in export services
3. Fix deprecated Radio `groupValue` and `onChanged` usage
4. Add `const` constructors where missing
5. Fix async context warning in `user_settings_page.dart:77`

**Tasks:**
- [ ] Fix unused import: `lib/features/auth/presentation/cubit/auth_cubit.dart:2`
- [ ] Update share functionality in CSV/PDF export services
- [ ] Update Radio widgets to use RadioGroup
- [ ] Run `dart fix --apply` to auto-fix const issues
- [ ] Verify no new issues introduced

**Estimated Time:** 3-4 hours

---

### Phase 1 Summary
**Total Estimated Time:** 12-18 hours (1.5-2 days)
**Deliverables:**
- ✅ All external URLs functional
- ✅ Unused code removed
- ✅ "Coming Soon" features handled appropriately
- ✅ All critical user flows tested and working
- ✅ Lint issues reduced significantly

---

## 🎯 Phase 2: High Priority MVP Features
**Priority:** 🟡 **HIGH**
**Timeline:** 1-2 weeks
**Goal:** Complete MVP with essential features

### 2.1 Reviews & Ratings System 🌟
**Status:** ❌ Not Implemented (Only UI placeholder exists)

#### Database Schema
```sql
-- Create reviews table
CREATE TABLE reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  field_id UUID NOT NULL REFERENCES fields(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  booking_id UUID REFERENCES bookings(id) ON DELETE SET NULL,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  -- Ensure one review per user per field
  UNIQUE(field_id, user_id)
);

-- Create index for fast queries
CREATE INDEX idx_reviews_field ON reviews(field_id);
CREATE INDEX idx_reviews_user ON reviews(user_id);
CREATE INDEX idx_reviews_rating ON reviews(rating);

-- Update fields table to store average rating
ALTER TABLE fields
ADD COLUMN average_rating DECIMAL(3,2) DEFAULT 0.0,
ADD COLUMN review_count INTEGER DEFAULT 0;

-- Function to update field rating
CREATE OR REPLACE FUNCTION update_field_rating()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE fields
  SET
    average_rating = (SELECT AVG(rating) FROM reviews WHERE field_id = NEW.field_id),
    review_count = (SELECT COUNT(*) FROM reviews WHERE field_id = NEW.field_id)
  WHERE id = NEW.field_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to auto-update field rating
CREATE TRIGGER trigger_update_field_rating
AFTER INSERT OR UPDATE OR DELETE ON reviews
FOR EACH ROW EXECUTE FUNCTION update_field_rating();
```

#### Implementation Tasks

**2.1.1 Domain Layer**
- [ ] Create `ReviewEntity` in `lib/features/reviews/domain/entities/`
  - Properties: id, fieldId, userId, bookingId, rating, comment, createdAt
  - Extend Equatable

- [ ] Create `ReviewRepository` interface in `lib/features/reviews/domain/repositories/`

- [ ] Create Use Cases:
  - [ ] `GetFieldReviewsUseCase` - Get all reviews for a field
  - [ ] `GetUserReviewsUseCase` - Get all reviews by a user
  - [ ] `CreateReviewUseCase` - Create new review (must have booking)
  - [ ] `UpdateReviewUseCase` - Update existing review
  - [ ] `DeleteReviewUseCase` - Delete review

**2.1.2 Data Layer**
- [ ] Create `ReviewModel` in `lib/features/reviews/data/models/`
  - Add `fromJson` and `toJson` methods
  - Add `toEntity` method

- [ ] Create `ReviewRemoteDataSource` in `lib/features/reviews/data/datasources/`
  - Implement Supabase queries
  - Handle pagination for large review lists

- [ ] Create `ReviewRepositoryImpl` in `lib/features/reviews/data/repositories/`

**2.1.3 Presentation Layer**
- [ ] Create `ReviewsCubit` with states:
  - `ReviewsInitial`
  - `ReviewsLoading`
  - `ReviewsLoaded`
  - `ReviewsError`
  - `ReviewCreated`
  - `ReviewUpdated`

- [ ] Create pages:
  - [ ] `AllReviewsPage` - View all reviews for a field
  - [ ] `CreateReviewPage` - Create/edit review

- [ ] Create widgets:
  - [ ] `ReviewCard` - Display single review
  - [ ] `ReviewsList` - List of reviews
  - [ ] `RatingStars` - Star rating display
  - [ ] `RatingInput` - Star rating input
  - [ ] `ReviewForm` - Review creation/edit form

**2.1.4 Update Existing Code**
- [ ] Remove placeholder from `field_reviews_section.dart`
- [ ] Replace with actual review display (top 3 reviews)
- [ ] Wire up "See all" button to `AllReviewsPage`
- [ ] Add review prompt after booking completion
- [ ] Update `FieldEntity` to include averageRating and reviewCount

**2.1.5 Dependency Injection**
- [ ] Uncomment and implement review dependencies in `injection_container.dart:174`

**Estimated Time:** 20-25 hours

---

### 2.2 Business Hours Configuration ⏰
**Status:** ❌ Not Implemented (Dialog shows "coming soon")

#### Database Schema
```sql
-- Create business_hours table
CREATE TABLE business_hours (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  field_id UUID NOT NULL REFERENCES fields(id) ON DELETE CASCADE,
  day_of_week INTEGER NOT NULL CHECK (day_of_week >= 0 AND day_of_week <= 6), -- 0=Sunday, 6=Saturday
  is_open BOOLEAN DEFAULT true,
  opening_time TIME NOT NULL DEFAULT '08:00',
  closing_time TIME NOT NULL DEFAULT '23:00',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  -- One entry per field per day
  UNIQUE(field_id, day_of_week)
);

CREATE INDEX idx_business_hours_field ON business_hours(field_id);
```

#### Implementation Tasks

**2.2.1 Domain Layer**
- [ ] Create `BusinessHoursEntity` in `lib/features/owner/domain/entities/`
  - Properties: id, fieldId, dayOfWeek, isOpen, openingTime, closingTime

- [ ] Add methods to `OwnerRepository`:
  - `getBusinessHours(String fieldId)`
  - `updateBusinessHours(BusinessHoursEntity hours)`
  - `setFieldClosed(String fieldId, int dayOfWeek)`

- [ ] Create Use Cases:
  - [ ] `GetBusinessHoursUseCase`
  - [ ] `UpdateBusinessHoursUseCase`
  - [ ] `GenerateDefaultBusinessHoursUseCase` - Create default 7-day schedule

**2.2.2 Data Layer**
- [ ] Create `BusinessHoursModel`
- [ ] Add methods to `OwnerRemoteDataSource`
- [ ] Update `OwnerRepositoryImpl`

**2.2.3 Presentation Layer**
- [ ] Create `BusinessHoursPage` in `lib/features/owner/presentation/pages/`
  - Weekly schedule view
  - Toggle open/closed per day
  - Time pickers for opening/closing
  - Bulk actions (e.g., "Same hours all days")

- [ ] Create widgets:
  - [ ] `DayScheduleCard` - Single day configuration
  - [ ] `TimeRangePicker` - Select opening/closing times
  - [ ] `WeeklyScheduleView` - Full week overview

**2.2.4 Update Existing Code**
- [ ] Replace dialog in `owner_settings_page.dart:274` with navigation to `BusinessHoursPage`
- [ ] Update `owner_field_detail_page.dart` to show business hours
- [ ] Update booking page to respect business hours (disable unavailable times)

**2.2.5 Validation**
- [ ] Ensure closing time > opening time
- [ ] Prevent booking creation outside business hours
- [ ] Show "Closed" badge on fields when outside business hours

**Estimated Time:** 15-20 hours

---

### 2.3 Enhanced Error Logging (Production Monitoring) 📊

**Current State:** Placeholder methods in `error_logging_service.dart`

#### Option A: Firebase Crashlytics (Recommended)
**Tasks:**
- [ ] Add Firebase to project
  - [ ] Create Firebase project
  - [ ] Add Android configuration (`google-services.json`)
  - [ ] Add iOS configuration (`GoogleService-Info.plist`)
  - [ ] Add dependencies to `pubspec.yaml`:
    ```yaml
    firebase_core: ^3.10.0
    firebase_crashlytics: ^4.2.0
    ```

- [ ] Initialize Firebase in `main.dart`
  ```dart
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  ```

- [ ] Implement `_logToRemoteService()` in `error_logging_service.dart:159`
  - Uncomment existing code
  - Test error reporting
  - Configure Crashlytics settings

- [ ] Set up error handlers
  ```dart
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  ```

**Estimated Time:** 4-6 hours

#### Option B: Sentry (Alternative)
- More detailed error tracking
- Performance monitoring
- Better Flutter support
- Similar implementation time

---

### 2.4 Local Error Logging (Offline Debugging) 📝

**Current State:** Stub method in `error_logging_service.dart:221`

**Implementation Options:**

#### Option A: Hive (Local NoSQL Database)
- [ ] Initialize Hive boxes in `main.dart:48`
- [ ] Create `ErrorLogBox` adapter
- [ ] Implement `_logToLocalStorage()`
- [ ] Implement `clearOldLogs()`
- [ ] Implement `getRecentLogs()`

**Tasks:**
- [ ] Open Hive box for error logs
  ```dart
  await Hive.initFlutter();
  await Hive.openBox<ErrorLogEntry>('error_logs');
  ```

- [ ] Store logs with timestamp
- [ ] Implement 7-day cleanup
- [ ] Add debug screen to view recent logs (super admin only)

**Estimated Time:** 3-4 hours

#### Option B: SQLite (Relational Database)
- More complex but better querying
- Use `sqflite` package

---

### 2.5 Testing Implementation 🧪
**Current Coverage:** ~5%

**Priority Areas:**

**2.5.1 Unit Tests (High Priority)**
- [ ] Test all Use Cases
  - Auth use cases (7 tests)
  - Fields use cases (7 tests)
  - Bookings use cases (8 tests)
  - Owner use cases (8 tests)
  - Super Admin use cases (10 tests)

**Template:**
```dart
void main() {
  late UseCase useCase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    useCase = UseCase(mockRepository);
  });

  test('should return entity when successful', () async {
    // Arrange
    when(() => mockRepository.method()).thenAnswer(
      (_) async => Right(entity),
    );

    // Act
    final result = await useCase();

    // Assert
    expect(result, Right(entity));
    verify(() => mockRepository.method()).called(1);
  });

  test('should return failure when repository fails', () async {
    // Arrange
    when(() => mockRepository.method()).thenAnswer(
      (_) async => Left(ServerFailure('Error')),
    );

    // Act
    final result = await useCase();

    // Assert
    expect(result, Left(ServerFailure('Error')));
  });
}
```

**Estimated Time:** 30-40 hours

**2.5.2 Widget Tests (Medium Priority)**
- [ ] Test critical user flows
  - Login page
  - Registration page
  - Field details page
  - Booking creation flow
  - Settings page

**Estimated Time:** 15-20 hours

**2.5.3 Integration Tests (Low Priority)**
- [ ] Full user journey tests
  - Register → Browse → Book → Cancel
  - Owner → Create Field → Approve Booking

**Estimated Time:** 10-15 hours

---

### Phase 2 Summary
**Total Estimated Time:** 97-130 hours (2-3 weeks with 1 developer)
**Key Deliverables:**
- ✅ Reviews & Ratings fully functional
- ✅ Business hours configuration
- ✅ Production error monitoring
- ✅ Local error logging
- ✅ Basic test coverage (>40%)

---

## 🎯 Phase 3: Medium Priority Enhancements
**Priority:** 🟢 **MEDIUM**
**Timeline:** 2-3 weeks
**Goal:** Improve user experience and add value-added features

### 3.1 Map View Integration 🗺️
**Status:** ❌ Not Implemented (Button exists but does nothing)

**Current Issue:** `nearby_fields_preview.dart:29` - "TODO: Navigate to Map View"

#### Option A: Google Maps (Recommended)
**Prerequisites:**
- Google Maps API key (already in dependencies)
- Enable Maps SDK for Android/iOS

**Implementation Tasks:**

**3.1.1 Create Map Page**
- [ ] Create `FieldsMapPage` in `lib/features/fields/presentation/pages/`
- [ ] Display all fields as map markers
- [ ] Show field info on marker tap
- [ ] Add "View Details" button on info window
- [ ] Add search bar on map
- [ ] Add filter button
- [ ] Current location button
- [ ] Cluster markers when zoomed out

**3.1.2 Update Field Entity**
- [ ] Ensure `latitude` and `longitude` fields exist
- [ ] Add validation for coordinates
- [ ] Update field creation to require location

**3.1.3 Wire Up Navigation**
- [ ] Replace TODO in `nearby_fields_preview.dart:29`
  ```dart
  onPressed: () {
    Navigator.pushNamed(context, AppRouter.fieldsMap);
  }
  ```
- [ ] Add route to `app_router.dart`

**3.1.4 Additional Features**
- [ ] Show distance from user location
- [ ] Sort by distance
- [ ] "Near Me" filter
- [ ] Directions integration

**Estimated Time:** 12-15 hours

#### Option B: OpenStreetMap (Free Alternative)
- Use `flutter_map` package
- No API key required
- Similar implementation

---

### 3.2 Payment Gateway Integration 💳
**Status:** ❌ Not Implemented (Listed as "Coming Soon")

**Business Decision Required:**
- Which payment provider? (Stripe, PayPal, local Egyptian gateways)
- Payment flow: Pay now vs Pay at venue?
- Deposit vs Full payment?

#### Recommended: Stripe Integration

**3.2.1 Backend Setup (Supabase Edge Functions)**
```typescript
// Create payment intent
Deno.serve(async (req) => {
  const { amount, bookingId } = await req.json();

  const paymentIntent = await stripe.paymentIntents.create({
    amount: amount * 100, // Convert to cents
    currency: 'egp',
    metadata: { bookingId }
  });

  return new Response(
    JSON.stringify({ clientSecret: paymentIntent.client_secret }),
    { headers: { 'Content-Type': 'application/json' } }
  );
});
```

**3.2.2 Database Changes**
```sql
-- Add payment fields to bookings table
ALTER TABLE bookings
ADD COLUMN payment_status VARCHAR(20) DEFAULT 'pending', -- pending, paid, refunded
ADD COLUMN payment_intent_id VARCHAR(255),
ADD COLUMN payment_method VARCHAR(50),
ADD COLUMN amount_paid DECIMAL(10,2),
ADD COLUMN paid_at TIMESTAMPTZ;

-- Create payments table for detailed tracking
CREATE TABLE payments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  booking_id UUID NOT NULL REFERENCES bookings(id),
  amount DECIMAL(10,2) NOT NULL,
  currency VARCHAR(3) DEFAULT 'EGP',
  status VARCHAR(20) NOT NULL, -- pending, completed, failed, refunded
  payment_method VARCHAR(50),
  payment_intent_id VARCHAR(255),
  stripe_payment_id VARCHAR(255),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ
);
```

**3.2.3 Flutter Implementation**
- [ ] Add `flutter_stripe` package
- [ ] Create `PaymentService`
- [ ] Create `PaymentPage` with card input
- [ ] Implement payment confirmation flow
- [ ] Update booking flow to include payment
- [ ] Add refund functionality for cancellations

**3.2.4 Security Considerations**
- [ ] Never store card details
- [ ] Use Stripe's secure card input widget
- [ ] Implement webhook for payment confirmations
- [ ] Add transaction logging

**Estimated Time:** 25-30 hours (including testing)

---

### 3.3 Dark Theme Implementation 🌙
**Status:** ❌ Not Implemented (Multiple TODOs)

**Files to Update:**
- `main.dart:114` - Add dark theme
- `app_theme.dart:114` - Implement dark theme

**Implementation Tasks:**

**3.3.1 Define Dark Theme**
```dart
// In app_theme.dart
static ThemeData get darkTheme {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF1E1E1E),
      elevation: 2,
    ),
    // ... rest of theme
  );
}
```

**3.3.2 Update Dark Colors**
- [ ] Define dark variants in `app_colors.dart`
  ```dart
  // Dark theme colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFE0E0E0);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  ```

**3.3.3 Wire Up Theme Switching**
- [ ] Connect to settings preferences
- [ ] Already implemented in `user_settings_page.dart` (theme selector exists)
- [ ] Update `main.dart` to use theme mode
  ```dart
  MaterialApp(
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    themeMode: _themeMode, // From settings
  );
  ```

**3.3.4 Test All Screens**
- [ ] Verify all colors work in dark mode
- [ ] Fix any hardcoded colors
- [ ] Ensure images/icons are visible

**Estimated Time:** 8-10 hours

---

### 3.4 Push Notifications 📱
**Status:** Partial (Settings exist but no backend)

**Use Cases:**
- Booking confirmation
- Booking approved/rejected
- Booking reminder (1 hour before)
- New field added (nearby)
- Price drop on favorites

**Implementation:**

**3.4.1 Setup Firebase Cloud Messaging**
- [ ] Add FCM to Firebase project
- [ ] Add `firebase_messaging` package
- [ ] Configure Android/iOS for notifications
- [ ] Request notification permissions

**3.4.2 Backend (Supabase Edge Functions)**
- [ ] Create function to send notifications
- [ ] Trigger on booking status change
- [ ] Store FCM tokens in profiles table

**3.4.3 Flutter Implementation**
- [ ] Handle notification reception
- [ ] Navigate to relevant screen on tap
- [ ] Show in-app notification badges
- [ ] Respect user notification preferences (already in settings)

**Estimated Time:** 12-15 hours

---

### 3.5 Field Image Upload for Owners 📸
**Current:** Owners can't upload images (super admin only)

**Implementation:**

**3.5.1 Update Owner Field Creation/Edit**
- [ ] Add image picker to `add_edit_field_page.dart`
- [ ] Upload to Supabase Storage
- [ ] Multiple image support (gallery)
- [ ] Image preview before upload
- [ ] Delete/reorder images

**3.5.2 Supabase Storage Setup**
- [ ] Create `field-images` bucket
- [ ] Configure RLS policies (owners can upload to their fields)
- [ ] Set max file size limits
- [ ] Enable image optimization

**3.5.3 Image Processing**
- [ ] Resize images before upload
- [ ] Generate thumbnails
- [ ] Compress for mobile

**Estimated Time:** 8-10 hours

---

### 3.6 Email Notifications 📧
**Use Cases:**
- Welcome email on registration
- Booking confirmation email
- Booking approved/rejected
- Password reset (already implemented in auth)
- Weekly digest for owners

**Implementation:**

**3.6.1 Choose Email Service**
- Supabase Auth (built-in, limited)
- SendGrid
- AWS SES
- Mailgun

**3.6.2 Create Email Templates**
- [ ] HTML templates for each email type
- [ ] Include branding
- [ ] Mobile-responsive

**3.6.3 Backend Integration**
- [ ] Supabase Edge Functions to send emails
- [ ] Trigger on events
- [ ] Queue for batch emails

**Estimated Time:** 10-12 hours

---

### Phase 3 Summary
**Total Estimated Time:** 75-92 hours (2-3 weeks)
**Key Deliverables:**
- ✅ Map view functional
- ✅ Payment processing (if business approves)
- ✅ Dark theme
- ✅ Push notifications
- ✅ Image upload for owners
- ✅ Email notifications

---

## 🎯 Phase 4: Low Priority Features
**Priority:** 🔵 **LOW**
**Timeline:** 1-2 weeks
**Goal:** Polish and nice-to-have features

### 4.1 Advanced Search Filters
**Enhance Existing Filters:**

- [ ] Field size filter (small, medium, large)
- [ ] Indoor/outdoor filter
- [ ] Grass type (natural, artificial)
- [ ] Parking availability
- [ ] Facilities (changing rooms, showers, cafeteria)
- [ ] Accessibility features
- [ ] Pet-friendly

**Estimated Time:** 6-8 hours

---

### 4.2 Booking History Export 📊
**Allow users to download their booking history**

- [ ] Export to PDF
- [ ] Export to CSV
- [ ] Filter by date range
- [ ] Include payment details
- [ ] Email export option

**Estimated Time:** 4-6 hours

---

### 4.3 Social Sharing 🔗
**Share fields and bookings**

- [ ] Share field details via WhatsApp/social media
- [ ] Share booking confirmation
- [ ] Invite friends to join booking
- [ ] Referral program

**Estimated Time:** 4-6 hours

---

### 4.4 Favorites Enhancements ⭐
**Currently basic, enhance with:**

- [ ] Favorite field notifications (price drop, availability)
- [ ] Organize favorites into lists (e.g., "Indoor Fields", "Weekend Fields")
- [ ] Share favorite lists

**Estimated Time:** 5-7 hours

---

### 4.5 Multi-language Support (Arabic) 🌍
**Status:** Settings exist but not implemented

- [ ] Add Arabic translations (use `intl` package)
- [ ] RTL layout support
- [ ] Switch language from settings (already has UI)
- [ ] Test all screens in Arabic

**Estimated Time:** 15-20 hours

---

### 4.6 Offline Mode Support 📴
**Allow basic functionality offline**

- [ ] Cache field data locally
- [ ] View past bookings offline
- [ ] Queue booking creation for when online
- [ ] Sync when connection restored

**Estimated Time:** 12-15 hours

---

### 4.7 Analytics Dashboard Enhancements 📈
**For Super Admin and Owners:**

- [ ] More detailed charts
- [ ] Custom date ranges
- [ ] Export reports (PDF/Excel)
- [ ] Email scheduled reports
- [ ] Compare time periods

**Estimated Time:** 10-12 hours

---

### Phase 4 Summary
**Total Estimated Time:** 56-74 hours (1-2 weeks)
**Key Deliverables:**
- ✅ Enhanced filters
- ✅ Export functionality
- ✅ Social features
- ✅ Multi-language
- ✅ Offline support
- ✅ Advanced analytics

---

## 🎯 Phase 5: Future Roadmap
**Priority:** 💡 **FUTURE**
**Timeline:** 3-6 months post-launch
**Goal:** Scale and compete

### 5.1 Team/Group Bookings 👥
- Book for multiple players
- Split payment
- Team profiles
- Recurring team bookings

**Estimated Time:** 30-40 hours

---

### 5.2 Tournaments & Leagues 🏆
- Create and manage tournaments
- Bracket generation
- Leaderboards
- Prize tracking

**Estimated Time:** 50-60 hours

---

### 5.3 Loyalty Program 🎁
- Points for bookings
- Redeem for discounts
- Tiered membership (Bronze, Silver, Gold)
- Special offers for loyal customers

**Estimated Time:** 20-25 hours

---

### 5.4 Equipment Rental
- Add equipment to bookings (balls, jerseys, etc.)
- Inventory management for owners
- Additional revenue stream

**Estimated Time:** 25-30 hours

---

### 5.5 Coaching & Training Sessions
- Book coaches
- Schedule training sessions
- Payment to coaches
- Rating for coaches

**Estimated Time:** 40-50 hours

---

### 5.6 Live Field Availability
- Real-time calendar view
- Block hours for maintenance
- Emergency closures
- Weather-based availability

**Estimated Time:** 15-20 hours

---

### 5.7 Mobile App Features
- Location-based push notifications
- Quick booking from notification
- Apple Pay / Google Pay
- Biometric login

**Estimated Time:** 20-25 hours

---

### 5.8 Web Admin Panel
- Separate web dashboard for super admin
- Advanced reporting
- Bulk operations
- Better data visualization

**Estimated Time:** 60-80 hours

---

## 📊 Summary & Timeline

### Overall Progress
- **Phase 1 (Critical):** 12-18 hours (1-2 days)
- **Phase 2 (High Priority):** 97-130 hours (2-3 weeks)
- **Phase 3 (Medium Priority):** 75-92 hours (2-3 weeks)
- **Phase 4 (Low Priority):** 56-74 hours (1-2 weeks)
- **Phase 5 (Future):** 260-330 hours (2-3 months)

**Total Development Time:** 500-644 hours

### Recommended Approach

#### Immediate (Before Launch)
1. Complete Phase 1 (Critical fixes)
2. Deploy MVP without Phase 2-5 features

#### Post-Launch (Month 1-2)
1. Monitor user feedback
2. Prioritize Phase 2 features based on demand
3. Implement reviews & business hours first

#### Post-Launch (Month 3-4)
1. Add Phase 3 features
2. Focus on payments and notifications
3. Gather metrics on usage

#### Long-term (Month 5+)
1. Phase 4 and 5 based on business needs
2. Scale infrastructure
3. Expand to new cities/countries

---

## 🎯 Quick Wins (Can Do Today)

These require minimal time but high impact:

1. **Update placeholder URLs** (30 min)
2. **Remove unused api_client.dart** (30 min)
3. **Hide "coming soon" features** (2 hours)
4. **Fix lint issues** (3-4 hours)
5. **Add const constructors** (1 hour)

**Total Quick Wins:** 7-8 hours

---

## 📝 Notes

### Code Quality Maintained
All implementations must follow:
- `CODE_QUALITY_STANDARDS.md`
- Clean Architecture
- Proper error handling
- Comprehensive testing
- Documentation

### Business Decisions Needed
Before implementing:
- **Payment Gateway:** Which provider?
- **Email Service:** Which provider?
- **Pricing Model:** How to charge?
- **Refund Policy:** When/how to refund?

### Technical Decisions Needed
- **Error Logging:** Firebase or Sentry?
- **Maps:** Google Maps or OpenStreetMap?
- **Local Storage:** Hive or SQLite?

---

**Document Maintained By:** Claude Code
**Review Schedule:** Weekly during active development
**Last Review:** December 1, 2025
