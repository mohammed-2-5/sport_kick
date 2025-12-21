import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/time_slot_card.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/time_slot_period_header.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/localization/l10n_extensions.dart';
import '../../../domain/entities/time_slot_entity.dart';
import '../../constants/booking_constants.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

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

  String _periodLabel(String period, BuildContext context) {
    final l10n = context.l10n;
    switch (period) {
      case 'Morning':
        return l10n.morning;
      case 'Afternoon':
        return l10n.afternoon;
      case 'Evening':
        return l10n.evening;
      case 'Late Night':
        return l10n.lateNight;
      default:
        return period;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    int animationIndex = 0;

    return AnimationLimiter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.availableTimeSlots,
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: BookingConstants.itemSpacing),
          if (slotsByPeriod['Morning']?.isNotEmpty ?? false) ...[
            TimeSlotPeriodHeader(
              period: l10n.morning,
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
                      periodLabel: _periodLabel(slot.period, context),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: BookingConstants.standardPadding),
          ],
          if (slotsByPeriod['Afternoon']?.isNotEmpty ?? false) ...[
            TimeSlotPeriodHeader(period: l10n.afternoon, icon: Icons.wb_sunny),
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
                      periodLabel: _periodLabel(slot.period, context),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: BookingConstants.standardPadding),
          ],
          if (slotsByPeriod['Evening']?.isNotEmpty ?? false) ...[
            TimeSlotPeriodHeader(
              period: l10n.evening,
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
                      periodLabel: _periodLabel(slot.period, context),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: BookingConstants.standardPadding),
          ],
          if (slotsByPeriod['Late Night']?.isNotEmpty ?? false) ...[
            TimeSlotPeriodHeader(
              period: l10n.lateNight,
              icon: Icons.bedtime_outlined,
            ),
            const SizedBox(height: BookingConstants.smallPadding),
            ...slotsByPeriod['Late Night']!.map((slot) {
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
                      periodLabel: _periodLabel(slot.period, context),
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
