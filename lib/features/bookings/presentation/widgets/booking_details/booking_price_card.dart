import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details/booking_price_row.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details/booking_total_row.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Premium card displaying price breakdown.
///
/// Shows:
/// - Hourly rate calculation
/// - Duration
/// - Total price with accent styling
class BookingPriceCard extends StatelessWidget {
  final BookingEntity booking;

  const BookingPriceCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final hourlyRate = booking.totalPrice / booking.durationInHours;
    final colorScheme = Theme.of(context).colorScheme;

    return PremiumCard(
      accentColor: colorScheme.primary,
      showAccentBorder: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.receipt_long,
                  color: colorScheme.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                context.l10n.priceBreakdown,
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: BookingConstants.standardPadding),
          BookingPriceRow(
            label: context.l10n.durationHours(booking.durationInHours),
            value:
                '${LocaleFormatters.formatPrice(context, amount: hourlyRate, currency: booking.currency, decimalDigits: 0)}/${context.l10n.perHour}',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(
              height: 1,
              color: colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          BookingTotalRow(formattedPrice: booking.formattedPrice),
        ],
      ),
    );
  }
}
