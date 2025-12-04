import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';

/// Individual booking card widget displaying booking details.
///
/// Shows:
/// - Status badge with color-coded header
/// - Field name and image
/// - Date and time information
/// - Price details
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
      child: InkWell(
        onTap: () => _navigateToDetails(context),
        borderRadius: BorderRadius.circular(BookingConstants.standardPadding),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                _getStatusColor(booking.status).withValues(alpha: 0.03),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _getStatusColor(booking.status).withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: _getStatusColor(booking.status).withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(children: [_buildHeader(), _buildContent(context)]),
        ),
      ),
    );
  }

  /// Navigates to booking details page
  Future<void> _navigateToDetails(BuildContext context) async {
    final result = await context.pushNamed(
      'bookingDetails',
      pathParameters: {'bookingId': booking.id},
    );

    // If booking was canceled, refresh the list
    if (result == true && context.mounted) {
      context.read<BookingCubit>().refreshBookings();
    }
  }

  /// Builds the status header with colored gradient background
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(BookingConstants.standardPadding),
      decoration: BoxDecoration(
        gradient: _getStatusGradient(booking.status),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
        boxShadow: [
          BoxShadow(
            color: _getStatusColor(booking.status).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getStatusIcon(booking.status),
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: BookingConstants.itemSpacing),
          Text(
            booking.status.displayName.toUpperCase(),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.8,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '#${booking.id.substring(0, 6).toUpperCase()}',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: _getStatusColor(booking.status),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the content section with booking details
  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(BookingConstants.standardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Field name with image (if available)
          if (booking.fieldName != null) ...[
            _buildFieldInfo(),
            const SizedBox(height: BookingConstants.standardPadding),
            const Divider(height: 1),
            const SizedBox(height: BookingConstants.standardPadding),
          ],

          // Date and Time
          _buildDateTimeRow(),

          const SizedBox(height: BookingConstants.standardPadding),

          // Price with background
          _buildPriceContainer(),

          // Cancel button for upcoming bookings
          if (booking.canCancel && !isHistory) ...[
            const SizedBox(height: BookingConstants.itemSpacing),
            _buildCancelButton(context),
          ],

          // Cancellation reason if canceled
          if (booking.status == BookingStatus.canceled &&
              booking.cancellationReason != null) ...[
            const SizedBox(height: BookingConstants.itemSpacing),
            _buildCancellationReason(),
          ],
        ],
      ),
    );
  }

  /// Builds field name and image row
  Widget _buildFieldInfo() {
    return Row(
      children: [
        if (booking.fieldImage != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              booking.fieldImage!,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.sports_soccer,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(width: BookingConstants.itemSpacing),
        ],
        Expanded(
          child: Text(
            booking.fieldName!,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const Icon(
          Icons.chevron_right,
          color: AppColors.textSecondary,
          size: 20,
        ),
      ],
    );
  }

  /// Builds date and time information row
  Widget _buildDateTimeRow() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(BookingConstants.smallPadding),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.calendar_today,
            size: 16,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: BookingConstants.itemSpacing),
        Text(
          booking.formattedDate,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(BookingConstants.smallPadding),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.access_time,
            size: 16,
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: BookingConstants.itemSpacing),
        Text(
          booking.formattedTimeSlot,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  /// Builds price container with total price
  Widget _buildPriceContainer() {
    return Container(
      padding: const EdgeInsets.all(BookingConstants.itemSpacing),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.payments_outlined, size: 18, color: AppColors.primary),
              SizedBox(width: BookingConstants.smallPadding),
              Text(
                BookingConstants.totalPriceLabel,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Text(
            booking.formattedPrice,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds cancel booking button
  Widget _buildCancelButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showCancelDialog(context),
        icon: const Icon(Icons.cancel_outlined, size: 18),
        label: const Text(BookingConstants.cancelBookingLabel),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: const BorderSide(color: AppColors.error),
        ),
      ),
    );
  }

  /// Builds cancellation reason display
  Widget _buildCancellationReason() {
    return Container(
      padding: const EdgeInsets.all(BookingConstants.itemSpacing),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 16, color: AppColors.error),
          const SizedBox(width: BookingConstants.smallPadding),
          Expanded(
            child: Text(
              booking.cancellationReason!,
              style: const TextStyle(fontSize: 13, color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  /// Shows cancel booking confirmation dialog
  void _showCancelDialog(BuildContext context) {
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

  /// Gets color for booking status
  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return AppColors.warning;
      case BookingStatus.confirmed:
        return AppColors.success;
      case BookingStatus.canceled:
        return AppColors.error;
      case BookingStatus.completed:
        return AppColors.textSecondary;
    }
  }

  /// Gets gradient for booking status
  LinearGradient _getStatusGradient(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return AppGradients.warning;
      case BookingStatus.confirmed:
        return AppGradients.success;
      case BookingStatus.canceled:
        return AppGradients.error;
      case BookingStatus.completed:
        return LinearGradient(
          colors: [
            AppColors.textSecondary,
            AppColors.textSecondary.withValues(alpha: 0.8),
          ],
        );
    }
  }

  /// Gets icon for booking status
  IconData _getStatusIcon(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Icons.schedule;
      case BookingStatus.confirmed:
        return Icons.check_circle;
      case BookingStatus.canceled:
        return Icons.cancel;
      case BookingStatus.completed:
        return Icons.done_all;
    }
  }
}
