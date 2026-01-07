import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/premium/confirmation/booking_summary_card.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/premium/confirmation/price_breakdown_card.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/premium/confirmation/terms_notice_card.dart';

/// Premium booking confirmation widget with glassmorphism design.
///
/// Displays a summary of the booking with:
/// - Field information
/// - Selected date and time
/// - Price breakdown with duration
/// - Confirm button with loading state
class PremiumBookingConfirmation extends StatelessWidget {
  final String fieldName;
  final DateTime selectedDate;
  final TimeSlotEntity selectedSlot;
  final double totalPrice;
  final int durationHours;
  final VoidCallback onConfirm;
  final VoidCallback onBack;
  final bool isSubmitting;

  const PremiumBookingConfirmation({
    super.key,
    required this.fieldName,
    required this.selectedDate,
    required this.selectedSlot,
    required this.totalPrice,
    required this.durationHours,
    required this.onConfirm,
    required this.onBack,
    this.isSubmitting = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.confirmYourBooking,
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.reviewBookingDetails,
            style: AppTextStyles.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),

          // Booking Summary Card
          BookingSummaryCard(
            fieldName: fieldName,
            selectedDate: selectedDate,
            selectedSlot: selectedSlot,
            durationHours: durationHours,
          ),

          const SizedBox(height: 24),

          // Price Breakdown
          PriceBreakdownCard(
            selectedSlot: selectedSlot,
            totalPrice: totalPrice,
            durationHours: durationHours,
          ),

          const SizedBox(height: 32),

          // Terms Notice
          const TermsNoticeCard(),

          const SizedBox(height: 32),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: PremiumButton(
                  label: context.l10n.back,
                  onPressed: onBack,
                  style: PremiumButtonStyle.outline,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: PremiumButton(
                  label: context.l10n.confirmBooking,
                  onPressed: onConfirm,
                  loading: isSubmitting,
                  icon: Icons.check_circle_outline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
