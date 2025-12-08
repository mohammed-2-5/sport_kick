import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/utils/error_handler.dart';
import 'package:spo_kick/core/widgets/premium/empty_states.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details_content.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details_loading_view.dart';

/// Body widget for booking details page.
///
/// Handles state listening and content rendering.
class BookingDetailsBody extends StatelessWidget {
  final String bookingId;

  const BookingDetailsBody({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingCubit, BookingState>(
      listener: (context, state) => _handleStateChange(context, state),
      builder: (context, state) => _buildContent(context, state),
    );
  }

  void _handleStateChange(BuildContext context, BookingState state) {
    if (state is BookingError) {
      ErrorHandler.showErrorSnackbar(context, state.message);
    } else if (state is BookingCanceled) {
      ErrorHandler.showSuccessSnackbar(
        context,
        BookingConstants.bookingCancelledMessage,
      );
      Navigator.of(context).pop(true);
    }
  }

  Widget _buildContent(BuildContext context, BookingState state) {
    if (state is BookingLoading) {
      return const BookingDetailsLoadingView();
    }

    if (state is BookingError) {
      return EmptyStates.error(
        message: state.message,
        onRetry: () => context.read<BookingCubit>().loadBookingById(bookingId),
      );
    }

    if (state is BookingDetailsLoaded) {
      return BookingDetailsContent(booking: state.booking);
    }

    return const BookingDetailsLoadingView();
  }
}
