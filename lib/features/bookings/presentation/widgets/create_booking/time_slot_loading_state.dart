import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/shimmer_loading.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Loading state for time slot selector.
class TimeSlotLoadingState extends StatelessWidget {
  const TimeSlotLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.availableTimeSlots,
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: BookingConstants.itemSpacing),
        ...List.generate(
          6,
          (index) => Padding(
            padding: const EdgeInsets.only(
              bottom: BookingConstants.smallPadding,
            ),
            child: ShimmerLoading(
              child: Container(
                height: BookingConstants.timeSlotHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    BookingConstants.borderRadius,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
