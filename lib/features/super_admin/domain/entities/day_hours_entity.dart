import 'package:equatable/equatable.dart';

/// Day Hours Entity
///
/// Represents operating hours for a single day.
class DayHoursEntity extends Equatable {
  final bool isOpen;
  final String openTime;
  final String closeTime;

  const DayHoursEntity({
    this.isOpen = true,
    this.openTime = '08:00',
    this.closeTime = '22:00',
  });

  @override
  List<Object?> get props => [isOpen, openTime, closeTime];

  DayHoursEntity copyWith({bool? isOpen, String? openTime, String? closeTime}) {
    return DayHoursEntity(
      isOpen: isOpen ?? this.isOpen,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
    );
  }

  /// Create from JSON map.
  factory DayHoursEntity.fromJson(Map<String, dynamic> json) {
    return DayHoursEntity(
      isOpen: json['isOpen'] as bool? ?? true,
      openTime: json['openTime'] as String? ?? '08:00',
      closeTime: json['closeTime'] as String? ?? '22:00',
    );
  }

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {'isOpen': isOpen, 'openTime': openTime, 'closeTime': closeTime};
  }

  /// Get display string.
  String get displayString {
    if (!isOpen) return 'Closed';
    return '$openTime - $closeTime';
  }
}
