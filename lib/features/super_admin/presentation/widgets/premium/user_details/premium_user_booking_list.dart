import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';

/// Premium user booking history list.
///
/// Features:
/// - Staggered animations
/// - Status-based color coding
/// - Compact booking cards
/// - Empty state handling
class PremiumUserBookingList extends StatelessWidget {
  final List<BookingEntity> bookings;

  const PremiumUserBookingList({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _BookingListHeader(),
          const SizedBox(height: 12),
          if (bookings.isEmpty)
            const _EmptyBookingsState()
          else
            AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 375),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: bookings
                      .take(10)
                      .map(
                        (booking) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _BookingCard(booking: booking),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          if (bookings.length > 10) _ViewAllButton(totalCount: bookings.length),
        ],
      ),
    );
  }
}

/// Booking list header widget.
class _BookingListHeader extends StatelessWidget {
  const _BookingListHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.accentCyan, AppColors.accentCyanDark],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.history, size: 18, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Text(
          'Booking History',
          style: AppTextStyles.titleMedium.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

/// Booking card widget.
class _BookingCard extends StatelessWidget {
  final BookingEntity booking;

  const _BookingCard({required this.booking});

  Color get _statusColor {
    switch (booking.status) {
      case BookingStatus.completed:
        return Colors.green;
      case BookingStatus.confirmed:
        return Colors.blue;
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.canceled:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => HapticFeedback.lightImpact(),
      child: PremiumCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Date box
            Container(
              width: 56,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: _statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    DateFormat('dd').format(booking.date),
                    style: AppTextStyles.titleLarge.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _statusColor,
                    ),
                  ),
                  Text(
                    DateFormat('MMM').format(booking.date),
                    style: AppTextStyles.labelSmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _statusColor.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.fieldName ?? 'Unknown Field',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppColors.textSecondary.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${booking.startTime} - ${booking.endTime}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 13,
                          color: AppColors.textSecondary.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Status and price
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    booking.status.displayName,
                    style: AppTextStyles.labelSmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _statusColor,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'EGP ${booking.totalPrice.toStringAsFixed(0)}',
                  style: AppTextStyles.priceSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty bookings state widget.
class _EmptyBookingsState extends StatelessWidget {
  const _EmptyBookingsState();

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.accentCyan.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.calendar_today,
              size: 28,
              color: AppColors.accentCyan,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Bookings Yet',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'This user hasn\'t made any bookings',
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 13,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// View all button widget.
class _ViewAllButton extends StatelessWidget {
  final int totalCount;

  const _ViewAllButton({required this.totalCount});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => HapticFeedback.lightImpact(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.accentCyan.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.accentCyan.withValues(alpha: 0.3),
          ),
        ),
        child: Center(
          child: Text(
            'View All $totalCount Bookings',
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.w600, // already 500
              color: AppColors.accentCyan,
            ),
          ),
        ),
      ),
    );
  }
}
