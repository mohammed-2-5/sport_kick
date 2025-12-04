import 'package:equatable/equatable.dart';

/// Domain entity representing a favorite field.
///
/// Stores the field ID and when it was added to favorites.
/// Used in the domain layer for business logic.
class FavoriteFieldEntity extends Equatable {
  /// The ID of the favorited field
  final String fieldId;

  /// When the field was added to favorites
  final DateTime addedAt;

  const FavoriteFieldEntity({
    required this.fieldId,
    required this.addedAt,
  });

  @override
  List<Object> get props => [fieldId, addedAt];

  @override
  String toString() => 'FavoriteFieldEntity(fieldId: $fieldId, addedAt: $addedAt)';
}
