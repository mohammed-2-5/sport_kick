import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';

/// Use case for creating a new field and assigning it to an admin.
///
/// Only super admin can create fields. This use case:
/// 1. Creates the field in the database
/// 2. Assigns it to the specified admin (sets owner_id)
/// 3. Creates audit trail entry in admin_field_assignments
///
/// Example:
/// ```dart
/// final result = await createFieldUseCase(
///   ownerId: 'admin-uuid',
///   sportCategoryId: 'football-uuid',
///   name: 'Champions Field',
///   address: '123 Main St',
///   city: 'Cairo',
///   pricePerHour: 200.0,
/// );
///
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (field) => print('Field created: ${field.name}'),
/// );
/// ```
class CreateFieldUseCase {
  final SuperAdminRepository repository;

  const CreateFieldUseCase(this.repository);

  /// Execute the use case to create a field.
  ///
  /// Parameters:
  /// - [ownerId]: ID of the admin who will own this field (required)
  /// - [sportCategoryId]: ID of the sport category (required)
  /// - [name]: Field name (required)
  /// - [address]: Full address (required)
  /// - [city]: City name (required)
  /// - [pricePerHour]: Hourly rental price (required)
  /// - [description]: Detailed description (optional)
  /// - [latitude]: GPS latitude (optional)
  /// - [longitude]: GPS longitude (optional)
  /// - [currency]: Currency code (default: 'EGP')
  /// - [surfaceType]: Surface type like 'Natural Grass' (optional)
  /// - [capacity]: Number of players (optional)
  /// - [isIndoor]: Indoor flag (default: false)
  /// - [images]: List of image URLs (default: empty)
  /// - [videoUrl]: Video URL (optional)
  /// - [facilities]: List of facilities (default: empty)
  /// - [paymentPhone]: Payment phone number (optional, defaults to 01068700814)
  /// - [paymentMethod]: Payment method: vodafone_cash or instapay (default: vodafone_cash)
  ///
  /// Returns:
  /// - [Right(FieldEntity)]: Field created successfully
  /// - [Left(Failure)]: Error occurred
  ///
  /// Errors:
  /// - [ValidationFailure]: Invalid input data
  /// - [NotFoundFailure]: Admin not found or invalid sport category
  /// - [UnauthorizedFailure]: User is not super admin
  /// - [ServerFailure]: Database error
  Future<Either<Failure, FieldEntity>> call({
    required String ownerId,
    required String sportCategoryId,
    required String name,
    required String address,
    required String city,
    required double pricePerHour,
    String? description,
    double? latitude,
    double? longitude,
    String currency = 'EGP',
    String? surfaceType,
    int? capacity,
    bool isIndoor = false,
    List<String> images = const [],
    String? videoUrl,
    List<String> facilities = const [],
    String? paymentPhone,
    String paymentMethod = 'vodafone_cash',
  }) async {
    return await repository.createField(
      ownerId: ownerId,
      sportCategoryId: sportCategoryId,
      name: name,
      description: description,
      address: address,
      city: city,
      latitude: latitude,
      longitude: longitude,
      pricePerHour: pricePerHour,
      currency: currency,
      surfaceType: surfaceType,
      capacity: capacity,
      isIndoor: isIndoor,
      images: images,
      videoUrl: videoUrl,
      facilities: facilities,
      paymentPhone: paymentPhone,
      paymentMethod: paymentMethod,
    );
  }
}
