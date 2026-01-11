/// Time slot range data model.
class TimeSlotRange {
  final String start;
  final String end;

  const TimeSlotRange({required this.start, required this.end});
}

/// Day schedule data model.
class DaySchedule {
  final String day;
  final bool isOpen;
  final List<TimeSlotRange> timeSlots;

  const DaySchedule({
    required this.day,
    required this.isOpen,
    required this.timeSlots,
  });
}
