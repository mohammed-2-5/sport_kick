import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/error_handler.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details_content.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details_loading_view.dart';

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
            return const BookingDetailsLoadingView();
          }

          if (state is BookingDetailsLoaded) {
            return BookingDetailsContent(booking: state.booking);
          }

          // If not loaded yet, show loading
          return const BookingDetailsLoadingView();
        },
      ),
    );
  }
}
