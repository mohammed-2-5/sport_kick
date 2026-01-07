import 'package:flutter/material.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/premium/time_slot_booked_badge.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/premium/time_slot_duration_unavailable_badge.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/premium/time_slot_price_badge.dart';

/// Displays the status of a time slot (price, booked, or unavailable).
///
/// Shows appropriate badge based on slot availability and duration.
class TimeSlotStatusDisplay extends StatelessWidget {
  final TimeSlotEntity slot;
  final bool isSelected;
  final bool isAvailable;
  final bool isDisabledForDuration;

  const TimeSlotStatusDisplay({
    super.key,
    required this.slot,
    required this.isSelected,
    required this.isAvailable,
    required this.isDisabledForDuration,
  });

  @override
  Widget build(BuildContext context) {
    if (!slot.isAvailable) {
      return const TimeSlotBookedBadge();
    }

    if (isDisabledForDuration) {
      return const TimeSlotDurationUnavailableBadge();
    }

    return TimeSlotPriceBadge(slot: slot, isSelected: isSelected);
  }
}
