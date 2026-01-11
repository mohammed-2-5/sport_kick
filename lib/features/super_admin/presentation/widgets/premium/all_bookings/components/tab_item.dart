import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';

/// Tab item data.
class TabItem {
  final String label;
  final BookingStatus? status;

  const TabItem({required this.label, this.status});
}
