import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/error_handler.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

/// Action buttons widget for booking details page.
///
/// Displays:
/// - Cancel booking button (if booking can be canceled)
/// - Contact support button
/// - Cancel booking confirmation dialog
class BookingDetailsActions extends StatelessWidget {
  final BookingEntity booking;

  const BookingDetailsActions({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Cancel Button (if applicable)
        if (booking.canCancel) ...[
          OutlinedButton.icon(
            onPressed: () => _showCancelDialog(context, booking),
            icon: const Icon(Icons.cancel_outlined),
            label: const Text(BookingConstants.cancelBookingLabel),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  BookingConstants.borderRadius,
                ),
              ),
            ),
          ),
          const SizedBox(height: BookingConstants.itemSpacing),
        ],

        // Contact Support Button
        OutlinedButton.icon(
          onPressed: () => _contactSupport(context, booking),
          icon: const Icon(Icons.support_agent),
          label: const Text('Contact Support'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                BookingConstants.borderRadius,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showCancelDialog(BuildContext context, BookingEntity booking) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(BookingConstants.cancelBookingLabel),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              BookingConstants.cancelConfirmationMessage,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: BookingConstants.standardPadding),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason (optional)',
                hintText: 'Why are you canceling?',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Keep Booking'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<BookingCubit>().cancelBooking(
                bookingId: booking.id,
                reason: reasonController.text.isEmpty
                    ? 'Canceled by user'
                    : reasonController.text,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text(BookingConstants.cancelBookingLabel),
          ),
        ],
      ),
    );
  }

  Future<void> _contactSupport(
    BuildContext context,
    BookingEntity booking,
  ) async {
    final emailUri = Uri(
      scheme: 'mailto',
      path: 'support@spokick.com',
      query: 'subject=Booking Support - ${booking.id}',
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        if (context.mounted) {
          ErrorHandler.showErrorSnackbar(
            context,
            'Could not open email client. Please contact support@spokick.com',
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ErrorHandler.showErrorSnackbar(context, 'Failed to open email client');
      }
    }
  }
}
