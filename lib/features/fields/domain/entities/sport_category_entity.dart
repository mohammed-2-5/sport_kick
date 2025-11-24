import 'package:equatable/equatable.dart';

/// Sport category entity representing a type of sport.
///
/// Categories include: Football, Basketball, Tennis, Volleyball, etc.
class SportCategoryEntity extends Equatable {
  /// Unique identifier for the sport category
  final String id;

  /// Name of the sport (e.g., "Football", "Basketball")
  final String name;

  /// Short name or code (e.g., "FB", "BB")
  final String? slug;

  /// Icon name or emoji
  final String? icon;

  /// Color code for UI (hex format)
  final String? color;

  /// Description of the sport
  final String? description;

  /// Is this category active
  final bool isActive;

  /// Display order (for sorting)
  final int displayOrder;

  /// Creation timestamp
  final DateTime createdAt;

  const SportCategoryEntity({
    required this.id,
    required this.name,
    this.slug,
    this.icon,
    this.color,
    this.description,
    this.isActive = true,
    this.displayOrder = 0,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        icon,
        color,
        description,
        isActive,
        displayOrder,
        createdAt,
      ];
}
