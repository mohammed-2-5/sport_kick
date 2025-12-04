import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';

/// Header widget for booking details page.
///
/// Displays:
/// - Field image (if available)
/// - Status banner with color-coded status
class BookingDetailsHeader extends StatelessWidget {
  final BookingEntity booking;

  const BookingDetailsHeader({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Field Image
        if (booking.fieldImage != null) _buildFieldImage(booking.fieldImage!),

        // Status Banner
        _buildStatusBanner(),
      ],
    );
  }

  Widget _buildFieldImage(String imageUrl) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.border,
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildStatusBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: _getStatusColor(booking.status).withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: _getStatusColor(booking.status).withValues(alpha: 0.3),
            width: 2,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getStatusIcon(booking.status),
            color: _getStatusColor(booking.status),
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            booking.status.displayName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _getStatusColor(booking.status),
            ),
          ),
        ],
      ),
    );
  }

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
