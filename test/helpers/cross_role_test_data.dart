/// Cross-Role Test Data Factory
///
/// Provides realistic test data for integration tests involving multiple roles.
/// All data is designed to work together in realistic workflow scenarios.
library;

import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/entities/payment_status.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/city/domain/entities/city_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/payment_method.dart';
import 'package:spo_kick/features/fields/domain/entities/sport_category_entity.dart';
import 'package:spo_kick/features/recurring_bookings/domain/entities/recurring_booking_entity.dart';
import 'package:spo_kick/features/reviews/domain/entities/review_entity.dart';

/// Factory for creating test data for cross-role integration tests
class CrossRoleTestData {
  CrossRoleTestData._();

  static final DateTime _baseDate = DateTime(2026, 1, 15);
  static final DateTime _createdAt = DateTime(2026, 1, 1);

  // ============================================================================
  // USERS
  // ============================================================================

  /// Regular user for booking tests
  static UserEntity get regularUser => UserEntity(
    id: 'user-001',
    email: 'ahmed.hassan@test.com',
    fullName: 'Ahmed Hassan',
    phone: '+201234567890',
    role: 'user',
    isActive: true,
    passwordChanged: true,
    createdAt: _createdAt,
    updatedAt: _createdAt,
  );

  /// Second regular user for concurrent booking tests
  static UserEntity get regularUserB => UserEntity(
    id: 'user-002',
    email: 'mohamed.ali@test.com',
    fullName: 'Mohamed Ali',
    phone: '+201098765432',
    role: 'user',
    isActive: true,
    passwordChanged: true,
    createdAt: _createdAt,
    updatedAt: _createdAt,
  );

  /// Field owner/admin for approval tests
  static UserEntity get fieldOwner => UserEntity(
    id: 'admin-001',
    email: 'owner@stadium.com',
    fullName: 'Stadium Owner',
    phone: '+201111222333',
    role: 'admin',
    isActive: true,
    passwordChanged: true,
    fieldsCount: 2,
    totalRevenue: 50000.0,
    createdAt: _createdAt,
    updatedAt: _createdAt,
  );

  /// New admin (first login, must change password)
  static UserEntity get newAdmin => UserEntity(
    id: 'admin-002',
    email: 'newowner@stadium.com',
    fullName: 'New Stadium Owner',
    phone: '+201444555666',
    role: 'admin',
    isActive: true,
    passwordChanged: false, // Must change on first login
    createdAt: _createdAt,
    updatedAt: _createdAt,
  );

  /// Super admin for platform management
  static UserEntity get superAdmin => UserEntity(
    id: 'superadmin-001',
    email: 'superadmin@sportkick.com',
    fullName: 'Platform Admin',
    phone: '+201000000000',
    role: 'super_admin',
    isActive: true,
    passwordChanged: true,
    createdAt: _createdAt,
    updatedAt: _createdAt,
  );

  /// Deactivated user for testing blocked access
  static UserEntity get deactivatedUser => UserEntity(
    id: 'user-deactivated',
    email: 'blocked@test.com',
    fullName: 'Blocked User',
    role: 'user',
    isActive: false,
    createdAt: _createdAt,
    updatedAt: _createdAt,
  );

  // ============================================================================
  // FIELDS
  // ============================================================================

  /// Verified field ready for bookings
  static FieldEntity get verifiedField => FieldEntity(
    id: 'field-001',
    name: 'Stadium City - Field A',
    description: 'Professional 11-a-side football field with artificial grass',
    sportCategoryId: 'cat-football',
    ownerId: 'admin-001',
    city: 'Cairo',
    address: '123 Sports Avenue, Nasr City',
    pricePerHour: 200.0,
    currency: 'EGP',
    capacity: 22,
    surfaceType: 'Artificial Grass',
    isIndoor: false,
    isActive: true,
    isVerified: true,
    latitude: 30.0626,
    longitude: 31.3361,
    paymentMethod: PaymentMethod.vodafoneCash,
    paymentPhone: '01234567890',
    paymentInstructions: 'Pay within 1 hour of booking confirmation',
    facilities: ['Parking', 'Changing Room', 'Lighting', 'Seating'],
    images: [
      'https://storage.sportkick.com/fields/field-001/image1.jpg',
      'https://storage.sportkick.com/fields/field-001/image2.jpg',
    ],
    averageRating: 4.5,
    totalReviews: 25,
    createdAt: _createdAt,
    updatedAt: _createdAt,
  );

  /// Unverified field awaiting Super Admin approval
  static FieldEntity get unverifiedField => FieldEntity(
    id: 'field-002',
    name: 'New Stadium - Field B',
    description: 'Brand new 7-a-side field',
    sportCategoryId: 'cat-football',
    ownerId: 'admin-001',
    city: 'Cairo',
    address: '456 Sports Street, Maadi',
    pricePerHour: 150.0,
    currency: 'EGP',
    capacity: 14,
    surfaceType: 'Natural Grass',
    isIndoor: false,
    isActive: true,
    isVerified: false, // Awaiting verification
    latitude: 29.9602,
    longitude: 31.2569,
    paymentMethod: PaymentMethod.instapay,
    paymentPhone: '01234567890',
    facilities: ['Parking', 'Lighting'],
    createdAt: _createdAt,
    updatedAt: _createdAt,
  );

  /// Field with active bookings (cannot be deleted)
  static FieldEntity get fieldWithBookings => FieldEntity(
    id: 'field-003',
    name: 'Active Stadium',
    description: 'Field with active bookings',
    sportCategoryId: 'cat-football',
    ownerId: 'admin-001',
    city: 'Alexandria',
    address: '789 Sports Road',
    pricePerHour: 180.0,
    currency: 'EGP',
    capacity: 22,
    isActive: true,
    isVerified: true,
    createdAt: _createdAt,
    updatedAt: _createdAt,
  );

  // ============================================================================
  // BOOKINGS
  // ============================================================================

  /// Pending booking awaiting owner approval
  static BookingEntity get pendingBooking => BookingEntity(
    id: 'booking-001',
    userId: 'user-001',
    fieldId: 'field-001',
    date: _baseDate.add(const Duration(days: 1)),
    startTime: '18:00',
    endTime: '19:00',
    durationHours: 1,
    totalPrice: 200.0,
    currency: 'EGP',
    status: BookingStatus.pending,
    paymentStatus: PaymentStatus.pending,
    createdAt: DateTime.now(),
    userName: 'Ahmed Hassan',
    fieldName: 'Stadium City - Field A',
  );

  /// Confirmed booking awaiting payment
  static BookingEntity get confirmedBooking => BookingEntity(
    id: 'booking-002',
    userId: 'user-001',
    fieldId: 'field-001',
    date: _baseDate.add(const Duration(days: 2)),
    startTime: '16:00',
    endTime: '17:00',
    durationHours: 1,
    totalPrice: 200.0,
    currency: 'EGP',
    status: BookingStatus.confirmed,
    paymentStatus: PaymentStatus.pending,
    createdAt: DateTime.now(),
    userName: 'Ahmed Hassan',
    fieldName: 'Stadium City - Field A',
  );

  /// Booking with payment proof uploaded
  static BookingEntity get paymentUploadedBooking => BookingEntity(
    id: 'booking-003',
    userId: 'user-001',
    fieldId: 'field-001',
    date: _baseDate.add(const Duration(days: 3)),
    startTime: '20:00',
    endTime: '21:00',
    durationHours: 1,
    totalPrice: 200.0,
    currency: 'EGP',
    status: BookingStatus.confirmed,
    paymentStatus: PaymentStatus.uploaded,
    paymentProofUrl:
        'https://storage.sportkick.com/proofs/booking-003/proof.jpg',
    createdAt: DateTime.now(),
    userName: 'Ahmed Hassan',
    fieldName: 'Stadium City - Field A',
  );

  /// Completed booking (can be reviewed)
  static BookingEntity get completedBooking => BookingEntity(
    id: 'booking-004',
    userId: 'user-001',
    fieldId: 'field-001',
    date: _baseDate.subtract(const Duration(days: 1)),
    startTime: '18:00',
    endTime: '19:00',
    durationHours: 1,
    totalPrice: 200.0,
    currency: 'EGP',
    status: BookingStatus.completed,
    paymentStatus: PaymentStatus.verified,
    createdAt: _createdAt,
    userName: 'Ahmed Hassan',
    fieldName: 'Stadium City - Field A',
  );

  /// 2-hour booking with consecutive slots
  static BookingEntity get twoHourBooking => BookingEntity(
    id: 'booking-005',
    userId: 'user-001',
    fieldId: 'field-001',
    date: _baseDate.add(const Duration(days: 4)),
    startTime: '14:00',
    endTime: '16:00',
    durationHours: 2,
    totalPrice: 400.0,
    currency: 'EGP',
    status: BookingStatus.pending,
    paymentStatus: PaymentStatus.pending,
    createdAt: DateTime.now(),
    userName: 'Ahmed Hassan',
    fieldName: 'Stadium City - Field A',
  );

  /// Canceled booking
  static BookingEntity get canceledBooking => BookingEntity(
    id: 'booking-canceled',
    userId: 'user-001',
    fieldId: 'field-001',
    date: _baseDate,
    startTime: '10:00',
    endTime: '11:00',
    durationHours: 1,
    totalPrice: 200.0,
    currency: 'EGP',
    status: BookingStatus.canceled,
    paymentStatus: PaymentStatus.pending,
    createdAt: _createdAt,
  );

  // ============================================================================
  // TIME SLOTS
  // ============================================================================

  /// Available morning slots
  static List<TimeSlotEntity> get morningSlots => [
    const TimeSlotEntity(
      startTime: '08:00',
      endTime: '09:00',
      isAvailable: true,
      price: 200.0,
      currency: 'EGP',
      isNextDay: false,
    ),
    const TimeSlotEntity(
      startTime: '09:00',
      endTime: '10:00',
      isAvailable: true,
      price: 200.0,
      currency: 'EGP',
      isNextDay: false,
    ),
    const TimeSlotEntity(
      startTime: '10:00',
      endTime: '11:00',
      isAvailable: false, // Already booked
      price: 200.0,
      currency: 'EGP',
      isNextDay: false,
    ),
  ];

  /// Available afternoon slots
  static List<TimeSlotEntity> get afternoonSlots => [
    const TimeSlotEntity(
      startTime: '14:00',
      endTime: '15:00',
      isAvailable: true,
      price: 200.0,
      currency: 'EGP',
      isNextDay: false,
    ),
    const TimeSlotEntity(
      startTime: '15:00',
      endTime: '16:00',
      isAvailable: true,
      price: 200.0,
      currency: 'EGP',
      isNextDay: false,
    ),
    const TimeSlotEntity(
      startTime: '16:00',
      endTime: '17:00',
      isAvailable: true,
      price: 200.0,
      currency: 'EGP',
      isNextDay: false,
    ),
  ];

  /// Evening slots (includes the contested 18:00 slot)
  static List<TimeSlotEntity> get eveningSlots => [
    const TimeSlotEntity(
      startTime: '18:00',
      endTime: '19:00',
      isAvailable: true, // This is the slot both users want
      price: 200.0,
      currency: 'EGP',
      isNextDay: false,
    ),
    const TimeSlotEntity(
      startTime: '19:00',
      endTime: '20:00',
      isAvailable: true,
      price: 200.0,
      currency: 'EGP',
      isNextDay: false,
    ),
    const TimeSlotEntity(
      startTime: '20:00',
      endTime: '21:00',
      isAvailable: true,
      price: 200.0,
      currency: 'EGP',
      isNextDay: false,
    ),
  ];

  /// All available slots for a day
  static List<TimeSlotEntity> get allAvailableSlots => [
    ...morningSlots,
    ...afternoonSlots,
    ...eveningSlots,
  ];

  /// Grouped slots by period
  static Map<String, List<TimeSlotEntity>> get slotsByPeriod => {
    'Morning': morningSlots,
    'Afternoon': afternoonSlots,
    'Evening': eveningSlots,
  };

  // ============================================================================
  // RECURRING BOOKINGS
  // ============================================================================

  /// Pending recurring booking request
  static RecurringBookingEntity get pendingRecurringRequest =>
      RecurringBookingEntity(
        id: 'recurring-001',
        fieldId: 'field-001',
        fieldName: 'Stadium City - Field A',
        dayOfWeek: 1, // Sunday
        startTime: '18:00',
        endTime: '19:00',
        durationHours: 1,
        pricePerBooking: 200.0,
        status: RecurringBookingStatus.pendingApproval,
        createdAt: DateTime.now(),
        userId: 'user-001',
        userName: 'Ahmed Hassan',
        userPhone: '+201234567890',
      );

  /// Active recurring booking
  static RecurringBookingEntity get activeRecurringBooking =>
      RecurringBookingEntity(
        id: 'recurring-002',
        fieldId: 'field-001',
        fieldName: 'Stadium City - Field A',
        dayOfWeek: 3, // Tuesday
        startTime: '20:00',
        endTime: '21:00',
        durationHours: 1,
        pricePerBooking: 200.0,
        status: RecurringBookingStatus.active,
        startedAt: _createdAt,
        createdAt: _createdAt,
        userId: 'user-001',
        userName: 'Ahmed Hassan',
      );

  // ============================================================================
  // REVIEWS
  // ============================================================================

  /// Review for completed booking
  static ReviewEntity get fieldReview => ReviewEntity(
    id: 'review-001',
    userId: 'user-001',
    fieldId: 'field-001',
    bookingId: 'booking-004',
    rating: 5,
    comment: 'Excellent field! Clean and well-maintained. Great lighting.',
    createdAt: _createdAt,
    updatedAt: _createdAt,
    userName: 'Ahmed Hassan',
  );

  // ============================================================================
  // CITIES & CATEGORIES
  // ============================================================================

  static CityEntity get cairoCity => CityEntity(
    id: 'city-cairo',
    name: 'Cairo',
    arabicName: 'القاهرة',
    isActive: true,
    createdAt: _createdAt,
  );

  static CityEntity get alexandriaCity => CityEntity(
    id: 'city-alex',
    name: 'Alexandria',
    arabicName: 'الإسكندرية',
    isActive: true,
    createdAt: _createdAt,
  );

  static SportCategoryEntity get footballCategory => SportCategoryEntity(
    id: 'cat-football',
    name: 'Football',
    icon: 'football.png',
    isActive: true,
    createdAt: _createdAt,
  );

  static SportCategoryEntity get basketballCategory => SportCategoryEntity(
    id: 'cat-basketball',
    name: 'Basketball',
    icon: 'basketball.png',
    isActive: true,
    createdAt: _createdAt,
  );

  // ============================================================================
  // WORKFLOW SCENARIOS
  // ============================================================================

  /// Complete booking lifecycle data
  static BookingLifecycleData get bookingLifecycle => BookingLifecycleData(
    user: regularUser,
    owner: fieldOwner,
    field: verifiedField,
    pendingBooking: pendingBooking,
    confirmedBooking: confirmedBooking,
    paymentUploadedBooking: paymentUploadedBooking,
    completedBooking: completedBooking,
    review: fieldReview,
  );

  /// Concurrent booking conflict data
  static ConcurrentBookingData get concurrentBookingScenario =>
      ConcurrentBookingData(
        userA: regularUser,
        userB: regularUserB,
        field: verifiedField,
        contestedSlot: eveningSlots.first, // 18:00-19:00
        date: _baseDate.add(const Duration(days: 5)),
      );

  /// Admin onboarding data
  static AdminOnboardingData get adminOnboardingScenario => AdminOnboardingData(
    superAdmin: superAdmin,
    newAdmin: newAdmin,
    newField: unverifiedField,
    tempPassword: 'TempPass_abc123!',
    newPassword: 'SecureNewPass456!',
  );

  /// Field verification data
  static FieldVerificationData get fieldVerificationScenario =>
      FieldVerificationData(
        owner: fieldOwner,
        superAdmin: superAdmin,
        unverifiedField: unverifiedField,
        verifiedField: verifiedField,
      );
}

// ============================================================================
// WORKFLOW DATA CLASSES
// ============================================================================

/// Data for complete booking lifecycle test
class BookingLifecycleData {
  final UserEntity user;
  final UserEntity owner;
  final FieldEntity field;
  final BookingEntity pendingBooking;
  final BookingEntity confirmedBooking;
  final BookingEntity paymentUploadedBooking;
  final BookingEntity completedBooking;
  final ReviewEntity review;

  const BookingLifecycleData({
    required this.user,
    required this.owner,
    required this.field,
    required this.pendingBooking,
    required this.confirmedBooking,
    required this.paymentUploadedBooking,
    required this.completedBooking,
    required this.review,
  });
}

/// Data for concurrent booking conflict test
class ConcurrentBookingData {
  final UserEntity userA;
  final UserEntity userB;
  final FieldEntity field;
  final TimeSlotEntity contestedSlot;
  final DateTime date;

  const ConcurrentBookingData({
    required this.userA,
    required this.userB,
    required this.field,
    required this.contestedSlot,
    required this.date,
  });
}

/// Data for admin onboarding test
class AdminOnboardingData {
  final UserEntity superAdmin;
  final UserEntity newAdmin;
  final FieldEntity newField;
  final String tempPassword;
  final String newPassword;

  const AdminOnboardingData({
    required this.superAdmin,
    required this.newAdmin,
    required this.newField,
    required this.tempPassword,
    required this.newPassword,
  });
}

/// Data for field verification test
class FieldVerificationData {
  final UserEntity owner;
  final UserEntity superAdmin;
  final FieldEntity unverifiedField;
  final FieldEntity verifiedField;

  const FieldVerificationData({
    required this.owner,
    required this.superAdmin,
    required this.unverifiedField,
    required this.verifiedField,
  });
}
