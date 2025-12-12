import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/super_admin/domain/entities/day_hours_entity.dart';

/// Days of the week.
enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  String get displayName {
    return name[0].toUpperCase() + name.substring(1);
  }

  String get shortName {
    return name.substring(0, 3).toUpperCase();
  }
}

/// Platform Settings Entity
///
/// Represents platform-wide configuration settings.
class PlatformSettingsEntity extends Equatable {
  final String id;
  final Map<DayOfWeek, DayHoursEntity> defaultOperatingHours;
  final bool enforceOperatingHours;
  final DateTime? updatedAt;
  final String? updatedBy;

  const PlatformSettingsEntity({
    required this.id,
    required this.defaultOperatingHours,
    this.enforceOperatingHours = true,
    this.updatedAt,
    this.updatedBy,
  });

  /// Create default platform settings.
  factory PlatformSettingsEntity.defaults() {
    return const PlatformSettingsEntity(
      id: 'default',
      defaultOperatingHours: {
        DayOfWeek.monday: DayHoursEntity(),
        DayOfWeek.tuesday: DayHoursEntity(),
        DayOfWeek.wednesday: DayHoursEntity(),
        DayOfWeek.thursday: DayHoursEntity(),
        DayOfWeek.friday: DayHoursEntity(),
        DayOfWeek.saturday: DayHoursEntity(
          openTime: '09:00',
          closeTime: '23:00',
        ),
        DayOfWeek.sunday: DayHoursEntity(openTime: '09:00', closeTime: '23:00'),
      },
    );
  }

  @override
  List<Object?> get props => [
    id,
    defaultOperatingHours,
    enforceOperatingHours,
    updatedAt,
    updatedBy,
  ];

  PlatformSettingsEntity copyWith({
    String? id,
    Map<DayOfWeek, DayHoursEntity>? defaultOperatingHours,
    bool? enforceOperatingHours,
    DateTime? updatedAt,
    String? updatedBy,
  }) {
    return PlatformSettingsEntity(
      id: id ?? this.id,
      defaultOperatingHours:
          defaultOperatingHours ?? this.defaultOperatingHours,
      enforceOperatingHours:
          enforceOperatingHours ?? this.enforceOperatingHours,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }

  /// Update hours for a specific day.
  PlatformSettingsEntity updateDayHours(DayOfWeek day, DayHoursEntity hours) {
    final updatedHours = Map<DayOfWeek, DayHoursEntity>.from(
      defaultOperatingHours,
    );
    updatedHours[day] = hours;
    return copyWith(defaultOperatingHours: updatedHours);
  }

  /// Get hours for a specific day.
  DayHoursEntity getHoursForDay(DayOfWeek day) {
    return defaultOperatingHours[day] ?? const DayHoursEntity();
  }
}
