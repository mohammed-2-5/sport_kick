import 'package:equatable/equatable.dart';

import 'payment_method.dart';

/// Field entity representing a sports field in the domain layer.
///
/// This is the core business entity for fields, independent of external
/// data sources or presentation logic.
class FieldEntity extends Equatable {
  /// Unique identifier for the field
  final String id;

  /// Field owner's user ID
  final String? ownerId;

  /// Sport category ID this field belongs to
  final String sportCategoryId;

  /// Name of the field
  final String name;

  /// Detailed description
  final String? description;

  /// Full address
  final String address;

  /// City ID (FK to cities table)
  final String? cityId;

  /// City name
  final String city;

  /// Geographic coordinates - latitude
  final double? latitude;

  /// Geographic coordinates - longitude
  final double? longitude;

  /// Hourly rental price
  final double pricePerHour;

  /// Currency (e.g., "EGP", "USD")
  final String currency;

  /// Surface type (e.g., "Natural Grass", "Artificial Turf")
  final String? surfaceType;

  /// Field capacity (number of players)
  final int? capacity;

  /// Is field indoor
  final bool isIndoor;

  /// List of image URLs
  final List<String> images;

  /// Video URL
  final String? videoUrl;

  /// List of facilities (e.g., "Parking", "Showers", "Lights")
  final List<String> facilities;

  /// Sport-specific data (JSON)
  final Map<String, dynamic>? sportSpecificData;

  /// Is field currently active and bookable
  final bool isActive;

  /// Is field verified by admin
  final bool isVerified;

  /// Average rating (1-5)
  final double? averageRating;

  /// Total number of reviews
  final int totalReviews;

  /// Total number of bookings
  final int totalBookings;

  /// Creation timestamp
  final DateTime createdAt;

  /// Last update timestamp
  final DateTime updatedAt;

  // Payment fields
  /// Phone number for mobile wallet payments (Vodafone Cash, InstaPay)
  final String? paymentPhone;

  /// Payment method (vodafone_cash, instapay)
  final PaymentMethod paymentMethod;

  /// Custom payment instructions from field owner
  final String? paymentInstructions;

  const FieldEntity({
    required this.id,
    this.ownerId,
    required this.sportCategoryId,
    required this.name,
    this.description,
    required this.address,
    this.cityId,
    required this.city,
    this.latitude,
    this.longitude,
    required this.pricePerHour,
    this.currency = 'EGP',
    this.surfaceType,
    this.capacity,
    this.isIndoor = false,
    this.images = const [],
    this.videoUrl,
    this.facilities = const [],
    this.sportSpecificData,
    this.isActive = true,
    this.isVerified = false,
    this.averageRating,
    this.totalReviews = 0,
    this.totalBookings = 0,
    required this.createdAt,
    required this.updatedAt,
    this.paymentPhone,
    this.paymentMethod = PaymentMethod.vodafoneCash,
    this.paymentInstructions,
  });

  /// Check if field has location coordinates
  bool get hasLocation => latitude != null && longitude != null;

  /// Check if field has images
  bool get hasImages => images.isNotEmpty;

  /// Check if field has facilities
  bool get hasFacilities => facilities.isNotEmpty;

  /// Check if field has reviews
  bool get hasReviews => totalReviews > 0;

  /// Get main image URL (first image or null)
  String? get mainImage => images.isNotEmpty ? images.first : null;

  /// Get rating display text
  String get ratingDisplay =>
      averageRating != null ? averageRating!.toStringAsFixed(1) : 'N/A';

  /// Check if field is popular (has many bookings)
  bool get isPopular => totalBookings > 10;

  /// Get formatted price with currency
  String get formattedPrice =>
      '${pricePerHour.toStringAsFixed(0)} $currency/hour';

  /// Get field size display (from capacity or surface type)
  String get fieldSize {
    if (capacity != null) {
      return '$capacity players';
    }
    if (surfaceType != null) {
      return surfaceType!;
    }
    return 'Standard';
  }

  /// Check if field has payment info configured
  bool get hasPaymentInfo => paymentPhone != null && paymentPhone!.isNotEmpty;

  /// Get payment instructions (custom or default template)
  String get effectivePaymentInstructions =>
      paymentInstructions ?? paymentMethod.instructionsTemplate;

  @override
  List<Object?> get props => [
    id,
    ownerId,
    sportCategoryId,
    name,
    description,
    address,
    cityId,
    city,
    latitude,
    longitude,
    pricePerHour,
    currency,
    surfaceType,
    capacity,
    isIndoor,
    images,
    videoUrl,
    facilities,
    sportSpecificData,
    isActive,
    isVerified,
    averageRating,
    totalReviews,
    totalBookings,
    createdAt,
    updatedAt,
    paymentPhone,
    paymentMethod,
    paymentInstructions,
  ];
}
