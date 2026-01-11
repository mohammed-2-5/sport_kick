import 'package:spo_kick/features/owner/presentation/models/time_slot_ui_model.dart';

class OwnerBookingConstants {
  /// Sample time slots for manual booking.
  static const List<TimeSlotUiModel> sampleTimeSlots = [
    TimeSlotUiModel(
      id: '1',
      startTime: '08:00',
      endTime: '09:00',
      isAvailable: true,
    ),
    TimeSlotUiModel(
      id: '2',
      startTime: '09:00',
      endTime: '10:00',
      isAvailable: true,
    ),
    TimeSlotUiModel(
      id: '3',
      startTime: '10:00',
      endTime: '11:00',
      isAvailable: false,
    ),
    TimeSlotUiModel(
      id: '4',
      startTime: '11:00',
      endTime: '12:00',
      isAvailable: true,
    ),
    TimeSlotUiModel(
      id: '5',
      startTime: '12:00',
      endTime: '13:00',
      isAvailable: true,
    ),
    TimeSlotUiModel(
      id: '6',
      startTime: '13:00',
      endTime: '14:00',
      isAvailable: false,
    ),
    TimeSlotUiModel(
      id: '7',
      startTime: '14:00',
      endTime: '15:00',
      isAvailable: true,
    ),
    TimeSlotUiModel(
      id: '8',
      startTime: '15:00',
      endTime: '16:00',
      isAvailable: true,
    ),
    TimeSlotUiModel(
      id: '9',
      startTime: '16:00',
      endTime: '17:00',
      isAvailable: true,
    ),
    TimeSlotUiModel(
      id: '10',
      startTime: '17:00',
      endTime: '18:00',
      isAvailable: false,
    ),
    TimeSlotUiModel(
      id: '11',
      startTime: '18:00',
      endTime: '19:00',
      isAvailable: true,
    ),
    TimeSlotUiModel(
      id: '12',
      startTime: '19:00',
      endTime: '20:00',
      isAvailable: true,
    ),
  ];
}
