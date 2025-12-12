import 'dart:convert';

import 'package:spo_kick/features/super_admin/domain/entities/day_hours_entity.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_settings_entity.dart';

/// Platform Settings Model
///
/// Data transfer object for platform settings with JSON serialization.
class PlatformSettingsModel extends PlatformSettingsEntity {
  const PlatformSettingsModel({
    required super.id,
    required super.defaultOperatingHours,
    super.enforceOperatingHours,
    super.updatedAt,
    super.updatedBy,
  });

  /// Create from database records.
  factory PlatformSettingsModel.fromRecords(
    List<Map<String, dynamic>> records,
  ) {
    Map<DayOfWeek, DayHoursEntity> operatingHours =
        PlatformSettingsEntity.defaults().defaultOperatingHours;
    bool enforceHours = true;
    DateTime? updatedAt;
    String? updatedBy;

    for (final record in records) {
      final key = record['setting_key'] as String;
      final value = record['setting_value'];

      if (key == 'default_operating_hours') {
        final hoursMap = value is String ? jsonDecode(value) : value;
        operatingHours = _parseOperatingHours(hoursMap as Map<String, dynamic>);
        updatedAt = record['updated_at'] != null
            ? DateTime.parse(record['updated_at'] as String)
            : null;
        updatedBy = record['updated_by'] as String?;
      } else if (key == 'enforce_operating_hours') {
        enforceHours = value == true || value == 'true';
      }
    }

    return PlatformSettingsModel(
      id: 'platform_settings',
      defaultOperatingHours: operatingHours,
      enforceOperatingHours: enforceHours,
      updatedAt: updatedAt,
      updatedBy: updatedBy,
    );
  }

  /// Parse operating hours from JSON.
  static Map<DayOfWeek, DayHoursEntity> _parseOperatingHours(
    Map<String, dynamic> json,
  ) {
    final result = <DayOfWeek, DayHoursEntity>{};

    for (final day in DayOfWeek.values) {
      final dayData = json[day.name];
      if (dayData != null) {
        result[day] = DayHoursEntity.fromJson(dayData as Map<String, dynamic>);
      } else {
        result[day] = const DayHoursEntity();
      }
    }

    return result;
  }

  /// Convert operating hours to JSON.
  Map<String, dynamic> operatingHoursToJson() {
    final result = <String, dynamic>{};

    for (final entry in defaultOperatingHours.entries) {
      result[entry.key.name] = entry.value.toJson();
    }

    return result;
  }

  /// Create from entity.
  factory PlatformSettingsModel.fromEntity(PlatformSettingsEntity entity) {
    return PlatformSettingsModel(
      id: entity.id,
      defaultOperatingHours: entity.defaultOperatingHours,
      enforceOperatingHours: entity.enforceOperatingHours,
      updatedAt: entity.updatedAt,
      updatedBy: entity.updatedBy,
    );
  }
}
