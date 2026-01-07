import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/utils/booking_status_utils.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings/booking_list_item_cancel_dialog.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings/booking_list_item_content.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings/booking_list_item_header.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_field_by_id_usecase.dart';

/// Individual booking card widget displaying booking details.
///
/// Shows:
/// - Status badge with color-coded header
/// - Field name and image
/// - Date and time information
/// - Price details
/// - Payment status with actions
/// - Cancel button for upcoming bookings
/// - Cancellation reason if canceled
class BookingListItem extends StatelessWidget {
  final BookingEntity booking;
  final bool isHistory;

  const BookingListItem({
    super.key,
    required this.booking,
    this.isHistory = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: BookingConstants.standardPadding),
      child: PremiumCard(
        onTap: () => _navigateToDetails(context),
        accentColor: BookingStatusUtils.getStatusColor(booking.status),
        showAccentBorder: true,
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            BookingListItemHeader(
              status: booking.status,
              bookingId: booking.id,
            ),
            BookingListItemContent(
              booking: booking,
              isHistory: isHistory,
              onCancelPressed: () => _showCancelDialog(context),
              onPayNowPressed: () => _navigateToInvoice(context),
              onViewProofPressed: () => _navigateToInvoice(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToDetails(BuildContext context) async {
    final result = await context.pushNamed(
      'bookingDetails',
      pathParameters: {'bookingId': booking.id},
    );

    if (result == true && context.mounted) {
      context.read<BookingCubit>().refreshBookings();
    }
  }

  Future<void> _navigateToInvoice(BuildContext context) async {
    final getFieldByIdUseCase = sl<GetFieldByIdUseCase>();
    final result = await getFieldByIdUseCase(booking.fieldId);

    result.fold(
      (failure) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${context.l10n.error}: ${failure.message}'),
            ),
          );
        }
      },
      (field) async {
        if (context.mounted) {
          await context.pushNamed(
            'bookingInvoice',
            extra: {'booking': booking, 'field': field},
          );
          if (context.mounted) {
            context.read<BookingCubit>().refreshBookings();
          }
        }
      },
    );
  }

  void _showCancelDialog(BuildContext context) {
    final cubit = context.read<BookingCubit>();
    final l10n = context.l10n;

    BookingListItemCancelDialog.show(
      context: context,
      onCancelBooking: (reason) {
        cubit.cancelBooking(
          bookingId: booking.id,
          reason: reason,
          loadingMessage: l10n.cancelingBooking,
        );
      },
    );
  }
}
