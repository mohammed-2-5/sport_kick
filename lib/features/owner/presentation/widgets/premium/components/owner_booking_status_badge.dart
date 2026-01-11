import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

class OwnerBookingStatusBadge extends StatelessWidget {
  final BookingStatus status;

  const OwnerBookingStatusBadge({super.key, required this.status});

  List<Color> get _gradientColors {
    switch (status) {
      case BookingStatus.pending:
        return [Colors.orange, Colors.deepOrange];
      case BookingStatus.confirmed:
        return [Colors.green, Colors.teal];
      case BookingStatus.canceled:
        return [Colors.red, Colors.redAccent];
      case BookingStatus.completed:
        return [Colors.blue, Colors.blueAccent];
    }
  }

  String _statusLabel(BuildContext context) {
    switch (status) {
      case BookingStatus.pending:
        return context.l10n.statusPending;
      case BookingStatus.confirmed:
        return context.l10n.statusConfirmed;
      case BookingStatus.canceled:
        return context.l10n.statusCancelled;
      case BookingStatus.completed:
        return context.l10n.statusCompleted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: _gradientColors),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _gradientColors.first.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        _statusLabel(context),
        style: AppTextStyles.labelSmall.copyWith(
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}
