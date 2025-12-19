import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium header for My Bookings page.
///
/// Uses [PremiumCurvedHeader] with back button and booking stats.
class MyBookingsHeader extends StatelessWidget {
  final VoidCallback onBack;

  const MyBookingsHeader({required this.onBack, super.key});

  @override
  Widget build(BuildContext context) {
    return PremiumCurvedHeader(
      title: context.l10n.myBookings,
      subtitle: context.l10n.trackBookingsSubtitle,
      showBackButton: true,
      onBackPressed: onBack,
      height: BookingConstants.myBookingsHeaderHeight,
    );
  }
}
