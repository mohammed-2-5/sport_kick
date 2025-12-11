import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/premium/premium_time_slot_card.dart';

/// Section displaying time slots for a specific period.
///
/// Shows period header with icon and a grid of time slot cards
/// with staggered entrance animations.
class TimeSlotPeriodSection extends StatelessWidget {
  final String period;
  final List<TimeSlotEntity> slots;
  final TimeSlotEntity? selectedSlot;
  final ValueChanged<TimeSlotEntity> onSlotSelected;

  const TimeSlotPeriodSection({
    super.key,
    required this.period,
    required this.slots,
    required this.selectedSlot,
    required this.onSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getPeriodColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getPeriodIcon(),
                    size: 18,
                    color: _getPeriodColor(),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  period,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${slots.where((s) => s.isAvailable).length} available',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: slots.asMap().entries.map((entry) {
                final index = entry.key;
                final slot = entry.value;
                final isSelected = selectedSlot == slot;

                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: PremiumTimeSlotCard(
                          slot: slot,
                          isSelected: isSelected,
                          onTap: slot.isAvailable
                              ? () => onSlotSelected(slot)
                              : null,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPeriodIcon() {
    switch (period) {
      case 'Morning':
        return Icons.wb_sunny_outlined;
      case 'Afternoon':
        return Icons.wb_sunny;
      case 'Evening':
        return Icons.nightlight_outlined;
      default:
        return Icons.schedule;
    }
  }

  Color _getPeriodColor() {
    switch (period) {
      case 'Morning':
        return const Color(0xFFFFB347); // Orange
      case 'Afternoon':
        return const Color(0xFFFFD700); // Gold
      case 'Evening':
        return const Color(0xFF6B5B95); // Purple
      default:
        return AppColors.accentCyan;
    }
  }
}
