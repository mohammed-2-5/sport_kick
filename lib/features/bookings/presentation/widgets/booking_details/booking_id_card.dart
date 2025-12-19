import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details/booking_copy_button.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/shared/booking_info_row.dart';

/// Premium card displaying the booking ID with copy functionality.
class BookingIdCard extends StatelessWidget {
  final String bookingId;

  const BookingIdCard({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: BookingInfoRow(
        icon: Icons.confirmation_number,
        title: context.l10n.bookingId,
        value: '#${bookingId.substring(0, 8).toUpperCase()}',
        iconColor: AppColors.primary,
        trailing: BookingCopyButton(
          textToCopy: bookingId,
          successMessage: context.l10n.bookingIdCopied,
        ),
      ),
    );
  }
}
