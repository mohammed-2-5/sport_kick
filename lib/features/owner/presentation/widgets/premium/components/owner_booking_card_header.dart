import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/components/owner_booking_status_badge.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

class OwnerBookingCardHeader extends StatelessWidget {
  final BookingEntity booking;

  const OwnerBookingCardHeader({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booking.fieldName ?? context.l10n.unknownField,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                booking.userName ?? context.l10n.unknownCustomer,
                style: AppTextStyles.bodySmall.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
        OwnerBookingStatusBadge(status: booking.status),
      ],
    );
  }
}
