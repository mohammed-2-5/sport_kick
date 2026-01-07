import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// Price breakdown card.
///
/// Updated: 2025-12-19
class OwnerBookingPriceCard extends StatelessWidget {
  final BookingEntity booking;

  const OwnerBookingPriceCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final pricePerHour = booking.totalPrice / booking.durationHours;
    final colorScheme = Theme.of(context).colorScheme;

    return PremiumCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.receipt_outlined,
                  color: colorScheme.secondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  context.l10n.priceBreakdown,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _PriceRow(
              label: context.l10n.pricePerHour,
              value: LocaleFormatters.formatPrice(
                context,
                amount: pricePerHour,
                currency: booking.currency,
                decimalDigits: 0,
              ),
            ),
            const SizedBox(height: 8),
            _PriceRow(
              label: context.l10n.durationLabel,
              value: context.l10n.hoursLabel(
                booking.durationHours,
                LocaleFormatters.formatNumber(
                  context,
                  booking.durationHours,
                  decimalDigits: 0,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),
            _PriceRow(
              label: context.l10n.totalPrice,
              value: LocaleFormatters.formatPrice(
                context,
                amount: booking.totalPrice,
                currency: booking.currency,
                decimalDigits: 0,
              ),
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: (isTotal ? AppTextStyles.bodyLarge : AppTextStyles.bodyMedium)
              .copyWith(
                fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
                color: isTotal
                    ? colorScheme.onSurface
                    : colorScheme.onSurfaceVariant,
              ),
        ),
        Text(
          value,
          style:
              (isTotal ? AppTextStyles.titleMedium : AppTextStyles.bodyMedium)
                  .copyWith(
                    fontWeight: FontWeight.w700,
                    color: isTotal
                        ? colorScheme.success
                        : colorScheme.onSurface,
                  ),
        ),
      ],
    );
  }
}
