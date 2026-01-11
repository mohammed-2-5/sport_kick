/// Time slot UI model for owner manual booking.
class TimeSlotUiModel {
  final String id;
  final String startTime;
  final String endTime;
  final bool isAvailable;

  const TimeSlotUiModel({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
  });

  String get displayTime => '$startTime-$endTime';
}
