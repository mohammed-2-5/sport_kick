import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/premium/premium_time_slot_card.dart';
import 'package:spo_kick/l10n/app_localizations.dart';

/// Section displaying time slots for a specific period.
///
/// Shows period header with icon and a grid of time slot cards
/// with staggered entrance animations.
class TimeSlotPeriodSection extends StatelessWidget {
  final String period;
  final List<TimeSlotEntity> slots;
  final TimeSlotEntity? selectedSlot;
  final TimeSlotEntity? secondSlot;
  final int selectedDuration;
  final bool Function(TimeSlotEntity) canSelectSlot;
  final ValueChanged<TimeSlotEntity> onSlotSelected;

  const TimeSlotPeriodSection({
    super.key,
    required this.period,
    required this.slots,
    required this.selectedSlot,
    required this.onSlotSelected,
    this.secondSlot,
    this.selectedDuration = 1,
    required this.canSelectSlot,
  });

  String _displayLabel(AppLocalizations l10n) {
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PeriodHeader(
            period: period,
            availableCount: slots.where((s) => s.isAvailable).length,
            displayLabel: _displayLabel(l10n),
            availableText: l10n.availableCount(
              slots.where((s) => s.isAvailable).length,
            ),
          ),
          const SizedBox(height: 12),
          _SlotsHorizontalList(
            slots: slots,
            selectedSlot: selectedSlot,
            secondSlot: secondSlot,
            selectedDuration: selectedDuration,
            canSelectSlot: canSelectSlot,
            onSlotSelected: onSlotSelected,
          ),
        ],
      ),
    );
  }
}

class _PeriodHeader extends StatelessWidget {
  final String period;
  final int availableCount;
  final String displayLabel;
  final String availableText;

  const _PeriodHeader({
    required this.period,
    required this.availableCount,
    required this.displayLabel,
    required this.availableText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getPeriodColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_getPeriodIcon(), size: 18, color: _getPeriodColor()),
          ),
          const SizedBox(width: 12),
          Text(
            displayLabel,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              availableText,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
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
      case 'Late Night':
        return Icons.bedtime_outlined;
      default:
        return Icons.schedule;
    }
  }

  Color _getPeriodColor() {
    switch (period) {
      case 'Morning':
        return const Color(0xFFFFB347);
      case 'Afternoon':
        return const Color(0xFFFFD700);
      case 'Evening':
        return const Color(0xFF6B5B95);
      case 'Late Night':
        return const Color(0xFF2C3E50);
      default:
        return AppColors.accentCyan;
    }
  }
}

class _SlotsHorizontalList extends StatelessWidget {
  final List<TimeSlotEntity> slots;
  final TimeSlotEntity? selectedSlot;
  final TimeSlotEntity? secondSlot;
  final int selectedDuration;
  final bool Function(TimeSlotEntity) canSelectSlot;
  final ValueChanged<TimeSlotEntity> onSlotSelected;

  const _SlotsHorizontalList({
    required this.slots,
    required this.selectedSlot,
    required this.secondSlot,
    required this.selectedDuration,
    required this.canSelectSlot,
    required this.onSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: slots.asMap().entries.map((entry) {
          final index = entry.key;
          final slot = entry.value;
          final isSelected = selectedSlot == slot;
          final isSecondSlot = secondSlot == slot;
          final isDisabledForDuration =
              selectedDuration == 2 && slot.isAvailable && !canSelectSlot(slot);

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
                    isSecondSlot: isSecondSlot,
                    isDisabledForDuration: isDisabledForDuration,
                    onTap: () => onSlotSelected(slot),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
