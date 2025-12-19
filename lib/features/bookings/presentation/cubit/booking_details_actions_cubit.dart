import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

part 'booking_details_actions_state.dart';

/// Cubit for managing booking details page actions.
///
/// Handles:
/// - Cancel dialog state
/// - Contact support action
/// - Action loading states
class BookingDetailsActionsCubit extends Cubit<BookingDetailsActionsState> {
  BookingDetailsActionsCubit() : super(const BookingDetailsActionsInitial());

  /// Shows the cancel booking dialog.
  void showCancelDialog() {
    emit(const BookingDetailsActionsCancelDialogOpen());
  }

  /// Hides the cancel booking dialog.
  void hideCancelDialog() {
    emit(const BookingDetailsActionsInitial());
  }

  /// Initiates contact support action.
  Future<void> contactSupport(BuildContext context, String bookingId) async {
    emit(const BookingDetailsActionsLoading());
    final l10n = context.l10n;

    final emailUri = Uri(
      scheme: 'mailto',
      path: 'support@spokick.com',
      query: 'subject=Booking Support - $bookingId',
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
        emit(const BookingDetailsActionsInitial());
      } else {
        emit(
          BookingDetailsActionsError(
            l10n.emailClientUnavailable('support@spokick.com'),
          ),
        );
      }
    } catch (e) {
      emit(BookingDetailsActionsError(l10n.emailClientOpenFailed));
    }
  }

  /// Resets error state.
  void clearError() {
    emit(const BookingDetailsActionsInitial());
  }
}
