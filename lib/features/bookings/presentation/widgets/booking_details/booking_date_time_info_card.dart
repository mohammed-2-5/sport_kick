import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details/booking_duration_badge.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/shared/booking_info_row.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Premium card displaying booking date and time information.
///
/// Shows:
/// - Date with calendar icon
/// - Time slot with clock icon
/// - Duration badge
class BookingDateTimeInfoCard extends StatelessWidget {
  final BookingEntity booking;

  const BookingDateTimeInfoCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.dateTimeLabel,
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: BookingConstants.standardPadding),
          BookingInfoRow(
            icon: Icons.calendar_today,
            title: context.l10n.bookingDate,
            value: LocaleFormatters.formatDate(context, booking.date),
            iconColor: AppColors.primary,
          ),
          const SizedBox(height: BookingConstants.standardPadding),
          BookingInfoRow(
            icon: Icons.access_time,
            title: context.l10n.timeSlot,
            value: LocaleFormatters.formatTimeRange(
              context,
              startTime: booking.startTime,
              endTime: booking.endTime,
              baseDate: booking.date,
            ),
            iconColor: AppColors.accentCyan,
            trailing: BookingDurationBadge(
              durationInHours: booking.durationInHours,
            ),
          ),
        ],
      ),
    );
  }
}
