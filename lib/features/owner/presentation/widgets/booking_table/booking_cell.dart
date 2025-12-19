import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';

/// Individual cell in the booking grid.
class BookingCell extends StatelessWidget {
  final BookingEntity? booking;
  final bool isOpen;
  final bool isToday;
  final bool isPast;
  final String hour;
  final int dayIndex;
  final VoidCallback? onTap;

  const BookingCell({
    required this.booking,
    required this.isOpen,
    required this.isToday,
    required this.isPast,
    required this.hour,
    required this.dayIndex,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 52,
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          border: Border(
            right: BorderSide(color: AppColors.border.withValues(alpha: 0.3)),
            bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.15)),
          ),
        ),
        child: booking != null ? _buildBookingContent() : _buildEmptyContent(),
      ),
    );
  }

  /// Get cell background color based on state.
  Color _getBackgroundColor() {
    if (!isOpen) {
      return AppColors.textSecondary.withValues(alpha: 0.08);
    }

    if (booking != null) {
      return _getStatusColor().withValues(alpha: 0.12);
    }

    // Gray out past empty slots
    if (isPast) {
      return AppColors.textSecondary.withValues(alpha: 0.05);
    }

    if (isToday) {
      return AppColors.goldAccent.withValues(alpha: 0.05);
    }

    return Colors.transparent;
  }

  /// Get color for booking status.
  Color _getStatusColor() {
    if (booking == null) return Colors.transparent;

    switch (booking!.status) {
      case BookingStatus.confirmed:
        return const Color(0xFF10B981); // Green
      case BookingStatus.pending:
        return const Color(0xFFF59E0B); // Amber
      case BookingStatus.completed:
        return const Color(0xFF3B82F6); // Blue
      case BookingStatus.canceled:
        return const Color(0xFFEF4444); // Red
    }
  }

  /// Get status icon.
  IconData _getStatusIcon() {
    if (booking == null) return Icons.add_rounded;

    switch (booking!.status) {
      case BookingStatus.confirmed:
        return Icons.check_circle_rounded;
      case BookingStatus.pending:
        return Icons.schedule_rounded;
      case BookingStatus.completed:
        return Icons.verified_rounded;
      case BookingStatus.canceled:
        return Icons.cancel_rounded;
    }
  }

  /// Build content for a booked cell.
  Widget _buildBookingContent() {
    final customerName = booking!.isManual
        ? booking!.customerName ?? 'Walk-in'
        : booking!.userName ?? 'Customer';

    final displayName = customerName.split(' ').first; // First name only

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Customer name
          Text(
            displayName,
            style: AppTextStyles.labelSmall.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: _getStatusColor(),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          // Status icon and label
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_getStatusIcon(), size: 10, color: _getStatusColor()),
              const SizedBox(width: 2),
              Text(
                _getStatusLabel(),
                style: AppTextStyles.labelSmall.copyWith(
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                  color: _getStatusColor().withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          // Manual booking indicator
          if (booking!.isManual)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.navyDeep.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Manual',
                  style: AppTextStyles.labelSmall.copyWith(
                    fontSize: 7,
                    fontWeight: FontWeight.w500,
                    color: AppColors.navyDeep,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Build content for an empty cell.
  Widget _buildEmptyContent() {
    if (!isOpen) {
      return Center(
        child: Icon(
          Icons.block_rounded,
          size: 14,
          color: AppColors.textSecondary.withValues(alpha: 0.3),
        ),
      );
    }

    // Show lock icon for past empty slots
    if (isPast) {
      return Center(
        child: Icon(
          Icons.history_rounded,
          size: 14,
          color: AppColors.textSecondary.withValues(alpha: 0.2),
        ),
      );
    }

    // Show subtle add indicator for empty open slots
    return Center(
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.accentCyan.withValues(alpha: 0.3),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          Icons.add_rounded,
          size: 16,
          color: AppColors.accentCyan.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  /// Get short status label.
  String _getStatusLabel() {
    if (booking == null) return '';

    switch (booking!.status) {
      case BookingStatus.confirmed:
        return 'Conf';
      case BookingStatus.pending:
        return 'Pend';
      case BookingStatus.completed:
        return 'Done';
      case BookingStatus.canceled:
        return 'Canc';
    }
  }
}
