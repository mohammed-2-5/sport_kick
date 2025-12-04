import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';

/// Notes and cancellation reason cards widget for booking details page.
///
/// Displays:
/// - User notes (if provided)
/// - Cancellation reason (if booking is canceled)
class BookingNotesCard extends StatelessWidget {
  final String? notes;
  final String? cancellationReason;

  const BookingNotesCard({
    super.key,
    this.notes,
    this.cancellationReason,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Notes (if any)
        if (notes != null && notes!.isNotEmpty) ...[
          _buildNotesCard(notes!),
          const SizedBox(height: BookingConstants.standardPadding),
        ],

        // Cancellation Reason (if canceled)
        if (cancellationReason != null) ...[
          _buildCancellationCard(cancellationReason!),
        ],
      ],
    );
  }

  Widget _buildNotesCard(String notes) {
    return Container(
      padding: const EdgeInsets.all(BookingConstants.standardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(BookingConstants.borderRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.note, color: AppColors.primary, size: 20),
              SizedBox(width: BookingConstants.smallPadding),
              Text(
                'Notes',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: BookingConstants.itemSpacing),
          Text(
            notes,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancellationCard(String reason) {
    return Container(
      padding: const EdgeInsets.all(BookingConstants.standardPadding),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(BookingConstants.borderRadius),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.error, size: 20),
              SizedBox(width: BookingConstants.smallPadding),
              Text(
                'Cancellation Reason',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: BookingConstants.itemSpacing),
          Text(
            reason,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.error,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
