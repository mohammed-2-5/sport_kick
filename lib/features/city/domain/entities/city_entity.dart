import 'package:equatable/equatable.dart';

/// City Entity
///
/// Represents a city in the system where football fields can be located.
class CityEntity extends Equatable {
  final String id;
  final String name;
  final String? arabicName;
  final bool isActive;
  final int? fieldsCount;
  final DateTime createdAt;

  const CityEntity({
    required this.id,
    required this.name,
    this.arabicName,
    required this.isActive,
    this.fieldsCount,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        arabicName,
        isActive,
        fieldsCount,
        createdAt,
      ];

  /// Create a copy with updated fields
  CityEntity copyWith({
    String? id,
    String? name,
    String? arabicName,
    bool? isActive,
    int? fieldsCount,
    DateTime? createdAt,
  }) {
    return CityEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      arabicName: arabicName ?? this.arabicName,
      isActive: isActive ?? this.isActive,
      fieldsCount: fieldsCount ?? this.fieldsCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() => 'CityEntity(id: $id, name: $name, isActive: $isActive)';
}
