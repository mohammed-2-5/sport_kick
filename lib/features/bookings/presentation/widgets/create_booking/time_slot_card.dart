import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Individual time slot card widget.
class TimeSlotCard extends StatelessWidget {
  final TimeSlotEntity slot;
  final bool isSelected;
  final VoidCallback? onTap;
  final String? periodLabel;

  const TimeSlotCard({
    super.key,
    required this.slot,
    required this.isSelected,
    this.onTap,
    this.periodLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable = slot.isAvailable;

    return Padding(
      padding: const EdgeInsets.only(bottom: BookingConstants.smallPadding),
      child: InkWell(
        onTap: isAvailable ? onTap : null,
        borderRadius: BorderRadius.circular(BookingConstants.borderRadius),
        child: Container(
          padding: const EdgeInsets.all(BookingConstants.standardPadding),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.1)
                : !isAvailable
                ? AppColors.textSecondary.withValues(alpha: 0.05)
                : Colors.white,
            borderRadius: BorderRadius.circular(BookingConstants.borderRadius),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleFormatters.formatTimeRange(
                        context,
                        startTime: slot.startTime,
                        endTime: slot.endTime,
                        isEndNextDay: slot.isNextDay,
                      ),
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isAvailable
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      periodLabel ?? slot.period,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.block,
                        size: BookingConstants.statusIconSize,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        context.l10n.bookedLabel,
                        style: AppTextStyles.labelSmall.copyWith(
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
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),
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
