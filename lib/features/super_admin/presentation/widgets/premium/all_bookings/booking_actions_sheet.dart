import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';

/// Bottom sheet with action buttons for booking management.
///
/// Provides options for:
/// - Confirm booking (if pending)
/// - Complete booking (if confirmed)
/// - Cancel booking
class BookingActionsSheet extends StatelessWidget {
  final BookingEntity booking;
  final VoidCallback onConfirm;
  final VoidCallback onComplete;
  final VoidCallback onCancel;

  const BookingActionsSheet({
    super.key,
    required this.booking,
    required this.onConfirm,
    required this.onComplete,
    required this.onCancel,
  });

  /// Show the booking actions bottom sheet.
  static void show({
    required BuildContext context,
    required BookingEntity booking,
    required VoidCallback onConfirm,
    required VoidCallback onComplete,
    required VoidCallback onCancel,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => BookingActionsSheet(
        booking: booking,
        onConfirm: () {
          Navigator.of(context).pop();
          onConfirm();
        },
        onComplete: () {
          Navigator.of(context).pop();
          onComplete();
        },
        onCancel: () {
          Navigator.of(context).pop();
          onCancel();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          const Divider(height: 1, color: AppColors.border),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: _getStatusColor(booking.status).withValues(alpha: 0.15),
            ),
            child: Icon(
              Icons.calendar_month_rounded,
              color: _getStatusColor(booking.status),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        booking.fieldName ?? 'Unknown Field',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGrey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          booking.status,
                        ).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        booking.status.displayName,
                        style: AppTextStyles.labelSmall.copyWith(
                          fontSize: 12,
                          color: _getStatusColor(booking.status),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${booking.userName ?? 'Unknown'} • ${booking.formattedDate}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.mediumGrey,
                  ),
                ),
                Text(
                  '${booking.formattedTimeSlot} • ${booking.formattedPrice}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
      child: Column(
        children: [
          // Confirm action (only for pending bookings)
          if (booking.status == BookingStatus.pending)
            _buildActionTile(
              icon: Icons.check_circle_outline,
              title: 'Confirm Booking',
              subtitle: 'Approve this booking request',
              color: AppColors.success,
              onTap: onConfirm,
            ),

          if (booking.status == BookingStatus.pending)
            const SizedBox(height: 8),

          // Complete action (only for confirmed bookings)
          if (booking.status == BookingStatus.confirmed)
            _buildActionTile(
              icon: Icons.task_alt_rounded,
              title: 'Mark as Completed',
              subtitle: 'Booking has been fulfilled',
              color: AppColors.info,
              onTap: onComplete,
            ),

          if (booking.status == BookingStatus.confirmed)
            const SizedBox(height: 8),

          // Cancel action (for pending or confirmed bookings)
          if (booking.status == BookingStatus.pending ||
              booking.status == BookingStatus.confirmed)
            _buildActionTile(
              icon: Icons.cancel_outlined,
              title: 'Cancel Booking',
              subtitle: 'Cancel this booking with reason',
              color: AppColors.error,
              onTap: onCancel,
            ),

          // If booking is already completed or cancelled
          if (booking.status == BookingStatus.completed ||
              booking.status == BookingStatus.canceled)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    booking.status == BookingStatus.completed
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: booking.status == BookingStatus.completed
                        ? AppColors.success
                        : AppColors.error,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      booking.status == BookingStatus.completed
                          ? 'This booking has been completed'
                          : 'This booking has been cancelled',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.mediumGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: color.withValues(alpha: 0.7)),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return const Color(0xFFF59E0B);
      case BookingStatus.confirmed:
        return const Color(0xFF10B981);
      case BookingStatus.completed:
        return const Color(0xFF6366F1);
      case BookingStatus.canceled:
        return const Color(0xFFEF4444);
    }
  }
}
