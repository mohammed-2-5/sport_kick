import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/error_handler.dart';
import 'package:spo_kick/core/widgets/shimmer_loading.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details_actions.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details_header.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details_info_section.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details_timeline.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_notes_card.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_price_breakdown.dart';

/// Page displaying detailed information about a specific booking.
///
/// Shows:
/// - Field details with image
/// - Booking status and timeline
/// - Date, time, and duration
/// - Price breakdown
/// - Actions (cancel booking if applicable)
class BookingDetailsPage extends StatelessWidget {
  final String bookingId;

  const BookingDetailsPage({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(BookingConstants.bookingDetailsTitle),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: BlocConsumer<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is BookingError) {
            ErrorHandler.showErrorSnackbar(context, state.message);
          } else if (state is BookingCanceled) {
            ErrorHandler.showSuccessSnackbar(
              context,
              BookingConstants.bookingCancelledMessage,
            );
            // Navigate back to My Bookings
            Navigator.of(
              context,
            ).pop(true); // Return true to indicate refresh needed
          }
        },
        builder: (context, state) {
          if (state is BookingLoading) {
            return _buildLoadingState();
          }

          if (state is BookingDetailsLoaded) {
            return _buildDetailsContent(context, state.booking);
          }

          // If not loaded yet, show loading
          return _buildLoadingState();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShimmerLoading(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: BookingConstants.standardPadding,
              ),
              height: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  BookingConstants.borderRadius,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsContent(BuildContext context, BookingEntity booking) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Field Image + Status Banner
          BookingDetailsHeader(booking: booking),

          // Main Content
          Padding(
            padding: const EdgeInsets.all(BookingConstants.standardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Section: Field Name + Booking ID + Date/Time
                BookingDetailsInfoSection(booking: booking),

                const SizedBox(height: BookingConstants.standardPadding),

                // Price Breakdown
                BookingPriceBreakdown(booking: booking),

                const SizedBox(height: BookingConstants.standardPadding),

                // Timeline Card
                BookingDetailsTimeline(booking: booking),

                // Notes and Cancellation Reason (if any)
                if ((booking.notes != null && booking.notes!.isNotEmpty) ||
                    (booking.status == BookingStatus.canceled &&
                        booking.cancellationReason != null)) ...[
                  const SizedBox(height: BookingConstants.standardPadding),
                  BookingNotesCard(
                    notes: booking.notes,
                    cancellationReason: booking.status == BookingStatus.canceled
                        ? booking.cancellationReason
                        : null,
                  ),
                ],

                const SizedBox(height: BookingConstants.largePadding),

                // Action Buttons
                BookingDetailsActions(booking: booking),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
