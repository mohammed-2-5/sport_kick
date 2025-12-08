import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
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
      child: PremiumCard(
        onTap: () => _navigateToDetails(context),
        accentColor: _getStatusColor(booking.status),
        showAccentBorder: true,
        padding: EdgeInsets
            .zero, // Handle padding internally for header/content split
        child: Column(children: [_buildHeader(), _buildContent(context)]),
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
      padding: const EdgeInsets.symmetric(
        horizontal: BookingConstants.standardPadding,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        gradient: _getStatusGradient(booking.status),
        // No border radius needed at top as PremiumCard clips it,
        // but explicit radius helps prevent anti-aliasing artifacts
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getStatusIcon(booking.status),
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            booking.status.displayName.toUpperCase(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 1.0,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
            const Divider(height: 1, color: AppColors.lightGrey),
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
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
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
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.sports_soccer,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booking.fieldName!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              // Removed invalid reference to booking.location
              // Use fieldName or subtitle if available in future
            ],
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
        Expanded(
          child: _buildInfoBadge(
            icon: Icons.calendar_today,
            text: booking.formattedDate,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoBadge(
            icon: Icons.access_time,
            text: booking.formattedTimeSlot,
            color: AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBadge({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds price container with total price
  Widget _buildPriceContainer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(
                Icons.receipt_long,
                size: 18,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: 8),
              Text(
                'Total Price',
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
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  /// Builds cancellation reason display
  Widget _buildCancellationReason() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.info_outline, size: 16, color: AppColors.error),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              booking.cancellationReason!,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.error,
                height: 1.4,
              ),
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
