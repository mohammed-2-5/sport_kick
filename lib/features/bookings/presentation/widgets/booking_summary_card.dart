import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_state.dart';

/// Booking summary card shown at the bottom of create booking page.
///
/// Displays:
/// - Selected date
/// - Selected time slot
/// - Total price
/// - Confirm booking button
class BookingSummaryCard extends StatelessWidget {
  final DateTime selectedDate;
  final TimeSlotEntity selectedTimeSlot;
  final VoidCallback onConfirm;

  const BookingSummaryCard({
    super.key,
    required this.selectedDate,
    required this.selectedTimeSlot,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(BookingConstants.standardPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Summary Details
              _buildSummaryDetails(),

              const SizedBox(height: BookingConstants.standardPadding),

              // Confirm Button
              _buildConfirmButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryDetails() {
    return Container(
      padding: const EdgeInsets.all(BookingConstants.standardPadding),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(BookingConstants.borderRadius),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            BookingConstants.dateLabel,
            DateFormat('MMM d, yyyy').format(selectedDate),
          ),
          const Divider(height: BookingConstants.standardPadding),
          _buildSummaryRow(
            BookingConstants.timeLabel,
            selectedTimeSlot.formattedTimeRange,
          ),
          const Divider(height: BookingConstants.standardPadding),
          _buildSummaryRow(
            BookingConstants.totalLabel,
            selectedTimeSlot.formattedPrice,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: FontWeight.w700,
            color: isTotal ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        final isLoading = state is BookingLoading;

        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: isLoading ? null : onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(BookingConstants.borderRadius),
              ),
              elevation: 0,
            ),
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    BookingConstants.confirmBookingLabel,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
