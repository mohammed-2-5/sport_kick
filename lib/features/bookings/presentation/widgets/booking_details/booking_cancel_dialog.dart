import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/core/widgets/premium/premium_text_field.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';

/// Dialog for canceling a booking with optional reason.
class BookingCancelDialog extends StatefulWidget {
  final String bookingId;

  const BookingCancelDialog({super.key, required this.bookingId});

  /// Shows the cancel dialog and returns true if booking was canceled.
  static Future<bool?> show(BuildContext context, String bookingId) {
    return showDialog<bool>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<BookingCubit>(),
        child: BookingCancelDialog(bookingId: bookingId),
      ),
    );
  }

  @override
  State<BookingCancelDialog> createState() => _BookingCancelDialogState();
}

class _BookingCancelDialogState extends State<BookingCancelDialog> {
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.cancel_outlined,
              color: AppColors.error,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            context.l10n.cancelBooking,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.cancelBookingConfirm,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: BookingConstants.standardPadding),
          PremiumTextField(
            label: context.l10n.cancelReasonOptional,
            controller: _reasonController,
            hintText: context.l10n.cancelReasonPlaceholder,
            maxLines: 3,
            prefixIcon: Icons.edit_note,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            context.l10n.keepBooking,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        PremiumButton(
          label: context.l10n.cancelBooking,
          onPressed: _cancelBooking,
          style: PremiumButtonStyle.primary,
          height: 44,
          fullWidth: false,
        ),
      ],
    );
  }

  void _cancelBooking() {
    Navigator.of(context).pop(true);
    context.read<BookingCubit>().cancelBooking(
      bookingId: widget.bookingId,
      reason: _reasonController.text.isEmpty
          ? context.l10n.canceledByUser
          : _reasonController.text,
    );
  }
}
