import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/super_admin/presentation/constants/admin_ui_constants.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = _getStatusColor(booking.status, isDark);
    final successColor = isDark ? AppColors.darkSuccess : AppColors.success;

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
                  color: statusColor.withValues(
                    alpha: AdminUIConstants.opacityLight,
                  ),
                  borderRadius: AdminUIConstants.borderRadiusMedium,
                ),
                child: Icon(
                  _getStatusIcon(booking.status),
                  color: statusColor,
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
                      booking.fieldName ?? context.l10n.unknownField,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
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
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM d, y').format(booking.date),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: AdminUIConstants.listItemSpacing),
                        Icon(
                          Icons.access_time,
                          size: AdminUIConstants.fontSizeMedium,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          booking.formattedTimeSlot,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colorScheme.onSurfaceVariant,
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
                      color: statusColor.withValues(
                        alpha: AdminUIConstants.opacityLight,
                      ),
                      borderRadius: BorderRadius.circular(
                        AdminUIConstants.radiusSmall,
                      ),
                      border: Border.all(color: statusColor),
                    ),
                    child: Text(
                      booking.status.displayName,
                      style: AppTextStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    booking.formattedPrice,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: successColor,
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

  Color _getStatusColor(BookingStatus status, bool isDark) {
    switch (status) {
      case BookingStatus.pending:
        return isDark ? AppColors.darkWarning : AppColors.warning;
      case BookingStatus.confirmed:
        return isDark ? AppColors.darkSuccess : AppColors.success;
      case BookingStatus.canceled:
        return isDark ? AppColors.darkError : AppColors.error;
      case BookingStatus.completed:
        return isDark ? Colors.purple[300]! : Colors.purple;
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
