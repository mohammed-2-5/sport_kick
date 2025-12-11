import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';

/// Cancel booking confirmation dialog widget.
class BookingListItemCancelDialog extends StatefulWidget {
  final VoidCallback onKeepBooking;
  final void Function(String reason) onCancelBooking;

  const BookingListItemCancelDialog({
    super.key,
    required this.onKeepBooking,
    required this.onCancelBooking,
  });

  @override
  State<BookingListItemCancelDialog> createState() =>
      _BookingListItemCancelDialogState();

  /// Shows the cancel dialog.
  static void show({
    required BuildContext context,
    required void Function(String reason) onCancelBooking,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) => BookingListItemCancelDialog(
        onKeepBooking: () => Navigator.of(dialogContext).pop(),
        onCancelBooking: (reason) {
          Navigator.of(dialogContext).pop();
          onCancelBooking(reason);
        },
      ),
    );
  }
}

class _BookingListItemCancelDialogState
    extends State<BookingListItemCancelDialog> {
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
            controller: _reasonController,
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
          onPressed: widget.onKeepBooking,
          child: const Text('Keep Booking'),
        ),
        ElevatedButton(
          onPressed: () {
            final reason = _reasonController.text.isEmpty
                ? 'Canceled by user'
                : _reasonController.text;
            widget.onCancelBooking(reason);
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          child: const Text(BookingConstants.cancelBookingLabel),
        ),
      ],
    );
  }
}
