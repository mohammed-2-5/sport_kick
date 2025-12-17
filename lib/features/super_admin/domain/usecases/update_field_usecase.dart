import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';

/// Use case for updating an existing field.
///
/// Allows super admin to:
/// - Update field name, address, price
/// - Change owner assignment
/// - Update location coordinates
/// - Modify facilities and amenities
class UpdateFieldUseCase {
  final SuperAdminRepository _repository;

  const UpdateFieldUseCase(this._repository);

  /// Update a field with the given data.
  ///
  /// Returns [FieldEntity] on success, [Failure] on error.
  Future<Either<Failure, FieldEntity>> call({
    required String fieldId,
    String? name,
    String? address,
    String? description,
    double? pricePerHour,
    double? latitude,
    double? longitude,
    String? ownerId,
    String? sportCategoryId,
    String? surfaceType,
    bool? isIndoor,
    bool? isVerified,
    bool? isActive,
    List<String>? facilities,
    String? paymentPhone,
    String? paymentMethod,
  }) {
    return _repository.updateField(
      fieldId: fieldId,
      name: name,
      address: address,
      description: description,
      pricePerHour: pricePerHour,
      latitude: latitude,
      longitude: longitude,
      ownerId: ownerId,
      sportCategoryId: sportCategoryId,
      surfaceType: surfaceType,
      isIndoor: isIndoor,
      isVerified: isVerified,
      isActive: isActive,
      facilities: facilities,
      paymentPhone: paymentPhone,
      paymentMethod: paymentMethod,
    );
  }
}
