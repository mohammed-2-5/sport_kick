import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/time_slot_card.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/time_slot_period_header.dart';

/// Content widget displaying time slots organized by period.
class TimeSlotsContent extends StatelessWidget {
  final Map<String, List<TimeSlotEntity>> slotsByPeriod;
  final TimeSlotEntity? selectedTimeSlot;
  final ValueChanged<TimeSlotEntity> onTimeSlotSelected;

  const TimeSlotsContent({
    super.key,
    required this.slotsByPeriod,
    required this.selectedTimeSlot,
    required this.onTimeSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    int animationIndex = 0;

    return AnimationLimiter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Time Slots',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: BookingConstants.itemSpacing),
          if (slotsByPeriod['Morning']?.isNotEmpty ?? false) ...[
            const TimeSlotPeriodHeader(
              period: 'Morning',
              icon: Icons.wb_sunny_outlined,
            ),
            const SizedBox(height: BookingConstants.smallPadding),
            ...slotsByPeriod['Morning']!.map((slot) {
              final index = animationIndex++;
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 30.0,
                  child: FadeInAnimation(
                    child: TimeSlotCard(
                      slot: slot,
                      isSelected: selectedTimeSlot == slot,
                      onTap: () => onTimeSlotSelected(slot),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: BookingConstants.standardPadding),
          ],
          if (slotsByPeriod['Afternoon']?.isNotEmpty ?? false) ...[
            const TimeSlotPeriodHeader(
              period: 'Afternoon',
              icon: Icons.wb_sunny,
            ),
            const SizedBox(height: BookingConstants.smallPadding),
            ...slotsByPeriod['Afternoon']!.map((slot) {
              final index = animationIndex++;
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 30.0,
                  child: FadeInAnimation(
                    child: TimeSlotCard(
                      slot: slot,
                      isSelected: selectedTimeSlot == slot,
                      onTap: () => onTimeSlotSelected(slot),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: BookingConstants.standardPadding),
          ],
          if (slotsByPeriod['Evening']?.isNotEmpty ?? false) ...[
            const TimeSlotPeriodHeader(
              period: 'Evening',
              icon: Icons.nightlight_outlined,
            ),
            const SizedBox(height: BookingConstants.smallPadding),
            ...slotsByPeriod['Evening']!.map((slot) {
              final index = animationIndex++;
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 30.0,
                  child: FadeInAnimation(
                    child: TimeSlotCard(
                      slot: slot,
                      isSelected: selectedTimeSlot == slot,
                      onTap: () => onTimeSlotSelected(slot),
                    ),
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
