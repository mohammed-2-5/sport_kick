import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/super_admin/presentation/constants/admin_ui_constants.dart';

/// Booking card widget for user details page
class UserBookingCard extends StatelessWidget {
  final BookingEntity booking;
  final VoidCallback onTap;

  const UserBookingCard({
    required this.booking,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AdminUIConstants.cardMarginBottom),
      shape: RoundedRectangleBorder(
        borderRadius: AdminUIConstants.borderRadiusMedium,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AdminUIConstants.borderRadiusMedium,
        child: Padding(
          padding: AdminUIConstants.paddingCard,
          child: Row(
            children: [
              // Booking Icon
              Container(
                padding: AdminUIConstants.paddingCard,
                decoration: BoxDecoration(
                  color: _getStatusColor(
                    booking.status,
                  ).withValues(alpha: AdminUIConstants.opacityLight),
                  borderRadius: AdminUIConstants.borderRadiusMedium,
                ),
                child: Icon(
                  _getStatusIcon(booking.status),
                  color: _getStatusColor(booking.status),
                  size: AdminUIConstants.iconSizeMedium,
                ),
              ),
              const SizedBox(width: AdminUIConstants.listItemSpacing),

              // Booking Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.fieldName ?? 'Unknown Field',
                      style: const TextStyle(
                        fontSize: AdminUIConstants.fontSizeLarge,
                        fontWeight: AdminUIConstants.fontWeightBold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: AdminUIConstants.fontSizeMedium,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM d, y').format(booking.date),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: AdminUIConstants.listItemSpacing),
                        Icon(
                          Icons.access_time,
                          size: AdminUIConstants.fontSizeMedium,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          booking.formattedTimeSlot,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Status Badge & Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: AdminUIConstants.badgePadding,
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        booking.status,
                      ).withValues(alpha: AdminUIConstants.opacityLight),
                      borderRadius: BorderRadius.circular(
                        AdminUIConstants.radiusSmall,
                      ),
                      border: Border.all(
                        color: _getStatusColor(booking.status),
                      ),
                    ),
                    child: Text(
                      booking.status.displayName,
                      style: TextStyle(
                        fontSize: AdminUIConstants.badgeFontSize,
                        fontWeight: AdminUIConstants.fontWeightBold,
                        color: _getStatusColor(booking.status),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    booking.formattedPrice,
                    style: const TextStyle(
                      fontSize: AdminUIConstants.fontSizeMedium,
                      fontWeight: AdminUIConstants.fontWeightBold,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
        return Colors.purple;
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
        return Icons.task_alt;
    }
  }
}
