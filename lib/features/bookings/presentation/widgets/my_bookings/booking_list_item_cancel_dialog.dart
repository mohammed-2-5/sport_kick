import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
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
      title: Text(context.l10n.cancelBooking),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.cancelBookingConfirm,
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: BookingConstants.standardPadding),
          TextField(
            controller: _reasonController,
            decoration: InputDecoration(
              labelText: context.l10n.cancelReasonOptional,
              hintText: context.l10n.cancelReasonPlaceholder,
              border: const OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: widget.onKeepBooking,
          child: Text(context.l10n.keepBooking),
        ),
        ElevatedButton(
          onPressed: () {
            final reason = _reasonController.text.isEmpty
                ? context.l10n.canceledByUser
                : _reasonController.text;
            widget.onCancelBooking(reason);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkError
                : AppColors.error,
          ),
          child: Text(context.l10n.cancelBooking),
        ),
      ],
    );
  }
}
