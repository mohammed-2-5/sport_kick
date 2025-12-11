import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings/booking_list_item_cancel_button.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings/booking_list_item_cancellation_reason.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings/booking_list_item_date_time.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings/booking_list_item_field_info.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings/booking_list_item_price.dart';

/// Content section of the booking list item.
///
/// Displays field info, date/time, price, and actions.
class BookingListItemContent extends StatelessWidget {
  final BookingEntity booking;
  final bool isHistory;
  final VoidCallback onCancelPressed;

  const BookingListItemContent({
    super.key,
    required this.booking,
    required this.isHistory,
    required this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(BookingConstants.standardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (booking.fieldName != null) ...[
            BookingListItemFieldInfo(
              fieldName: booking.fieldName!,
              fieldImage: booking.fieldImage,
            ),
            const SizedBox(height: BookingConstants.standardPadding),
            const Divider(height: 1, color: AppColors.lightGrey),
            const SizedBox(height: BookingConstants.standardPadding),
          ],
          BookingListItemDateTime(
            formattedDate: booking.formattedDate,
            formattedTimeSlot: booking.formattedTimeSlot,
          ),
          const SizedBox(height: BookingConstants.standardPadding),
          BookingListItemPrice(formattedPrice: booking.formattedPrice),
          if (booking.canCancel && !isHistory) ...[
            const SizedBox(height: BookingConstants.itemSpacing),
            BookingListItemCancelButton(onPressed: onCancelPressed),
          ],
          if (booking.status == BookingStatus.canceled &&
              booking.cancellationReason != null) ...[
            const SizedBox(height: BookingConstants.itemSpacing),
            BookingListItemCancellationReason(
              reason: booking.cancellationReason!,
            ),
          ],
        ],
      ),
    );
  }
}
