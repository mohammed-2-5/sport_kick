import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking/payment_status_badge.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

class OwnerBookingPaymentRow extends StatelessWidget {
  final BookingEntity booking;

  const OwnerBookingPaymentRow({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(
          Icons.payment_rounded,
          size: 16,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 8),
        Text(
          '${context.l10n.payment}:',
          style: AppTextStyles.bodyMedium.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 8),
        PaymentStatusBadge(status: booking.paymentStatus, isCompact: true),
        const Spacer(),
        Text(
          LocaleFormatters.formatPrice(
            context,
            amount: booking.totalPrice,
            currency: context.l10n.currencyEgp,
            decimalDigits: 0,
          ),
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.success,
          ),
        ),
      ],
    );
  }
}
