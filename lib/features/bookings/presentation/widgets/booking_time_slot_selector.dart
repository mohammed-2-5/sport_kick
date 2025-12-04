import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/shimmer_loading.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';

/// Time slot selector widget for booking flow.
///
/// Displays available time slots organized by period (Morning, Afternoon, Evening)
/// and allows users to select a time slot.
class BookingTimeSlotSelector extends StatelessWidget {
  final Map<String, List<TimeSlotEntity>> slotsByPeriod;
  final TimeSlotEntity? selectedTimeSlot;
  final ValueChanged<TimeSlotEntity> onTimeSlotSelected;
  final bool isLoading;

  const BookingTimeSlotSelector({
    super.key,
    required this.slotsByPeriod,
    required this.selectedTimeSlot,
    required this.onTimeSlotSelected,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingState();
    }

    return _buildTimeSlots();
  }

  Widget _buildLoadingState() {
    return Column(
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
        ...List.generate(
          6,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: BookingConstants.smallPadding),
            child: ShimmerLoading(
              child: Container(
                height: BookingConstants.timeSlotHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(BookingConstants.borderRadius),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlots() {
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

          // Morning Slots
          if (slotsByPeriod['Morning']?.isNotEmpty ?? false) ...[
            _buildPeriodHeader('Morning', Icons.wb_sunny_outlined),
            const SizedBox(height: BookingConstants.smallPadding),
            ...slotsByPeriod['Morning']!.map((slot) {
              final index = animationIndex++;
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 30.0,
                  child: FadeInAnimation(
                    child: _buildTimeSlotCard(slot),
                  ),
                ),
              );
            }),
            const SizedBox(height: BookingConstants.standardPadding),
          ],

          // Afternoon Slots
          if (slotsByPeriod['Afternoon']?.isNotEmpty ?? false) ...[
            _buildPeriodHeader('Afternoon', Icons.wb_sunny),
            const SizedBox(height: BookingConstants.smallPadding),
            ...slotsByPeriod['Afternoon']!.map((slot) {
              final index = animationIndex++;
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 30.0,
                  child: FadeInAnimation(
                    child: _buildTimeSlotCard(slot),
                  ),
                ),
              );
            }),
            const SizedBox(height: BookingConstants.standardPadding),
          ],

          // Evening Slots
          if (slotsByPeriod['Evening']?.isNotEmpty ?? false) ...[
            _buildPeriodHeader('Evening', Icons.nightlight_outlined),
            const SizedBox(height: BookingConstants.smallPadding),
            ...slotsByPeriod['Evening']!.map((slot) {
              final index = animationIndex++;
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 30.0,
                  child: FadeInAnimation(
                    child: _buildTimeSlotCard(slot),
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildPeriodHeader(String period, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: BookingConstants.smallPadding),
        Text(
          period,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlotCard(TimeSlotEntity slot) {
    final isSelected = selectedTimeSlot == slot;
    final isAvailable = slot.isAvailable;

    return Padding(
      padding: const EdgeInsets.only(bottom: BookingConstants.smallPadding),
      child: InkWell(
        onTap: isAvailable
            ? () {
                onTimeSlotSelected(slot);
              }
            : null,
        borderRadius: BorderRadius.circular(BookingConstants.borderRadius),
        child: Container(
          padding: const EdgeInsets.all(BookingConstants.standardPadding),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.1)
                : !isAvailable
                    ? AppColors.textSecondary.withValues(alpha: 0.05)
                    : Colors.white,
            borderRadius:
                BorderRadius.circular(BookingConstants.borderRadius),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : !isAvailable
                      ? AppColors.textSecondary.withValues(alpha: 0.2)
                      : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      slot.formattedTimeRange,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isAvailable
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      slot.period,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Price or Status
              if (!isAvailable)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: BookingConstants.itemSpacing,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.block,
                        size: BookingConstants.statusIconSize,
                        color: AppColors.error,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Booked',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Text(
                  slot.formattedPrice,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),

              // Selected Indicator
              if (isSelected) ...[
                const SizedBox(width: BookingConstants.smallPadding),
                const Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 24,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
