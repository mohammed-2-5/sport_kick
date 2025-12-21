import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/utils/error_handler.dart';
import 'package:spo_kick/core/widgets/premium/empty_states.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_details_actions_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details/booking_details_content.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details/booking_details_loading_view.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_details/booking_floating_actions.dart';

/// Body widget for booking details page.
///
/// Handles state listening and content rendering with floating actions.
class BookingDetailsBody extends StatelessWidget {
  final String bookingId;

  const BookingDetailsBody({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingDetailsActionsCubit(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<BookingCubit, BookingState>(
            listener: _handleBookingStateChange,
          ),
          BlocListener<BookingDetailsActionsCubit, BookingDetailsActionsState>(
            listener: _handleActionsStateChange,
          ),
        ],
        child: BlocBuilder<BookingCubit, BookingState>(
          builder: (context, state) {
            if (state is BookingLoading) {
              return const BookingDetailsLoadingView();
            }

            if (state is BookingError) {
              return EmptyStates.error(
                context,
                message: state.message,
                onRetry: () => context.read<BookingCubit>().loadBookingById(
                  bookingId,
                  loadingMessage: context.l10n.loadingBookingDetails,
                ),
              );
            }

            if (state is BookingDetailsLoaded) {
              return Stack(
                children: [
                  BookingDetailsContent(booking: state.booking),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: BookingFloatingActions(booking: state.booking),
                  ),
                ],
              );
            }

            return const BookingDetailsLoadingView();
          },
        ),
      ),
    );
  }

  void _handleBookingStateChange(BuildContext context, BookingState state) {
    if (state is BookingError) {
      ErrorHandler.showErrorSnackbar(context, state.message);
    } else if (state is BookingCanceled) {
      ErrorHandler.showSuccessSnackbar(context, context.l10n.bookingCancelled);
      Navigator.of(context).pop(true);
    }
  }

  void _handleActionsStateChange(
    BuildContext context,
    BookingDetailsActionsState state,
  ) {
    if (state is BookingDetailsActionsError) {
      ErrorHandler.showErrorSnackbar(context, state.message);
    }
  }
}
