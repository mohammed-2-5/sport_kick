import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/booking_list_item.dart';

/// Tab view widget for displaying bookings in tabs (Upcoming and History).
///
/// Handles:
/// - Empty state display per tab
/// - Animated list rendering
/// - Pull-to-refresh functionality
class MyBookingsTabView extends StatelessWidget {
  final List<BookingEntity> bookings;
  final String emptyMessage;
  final bool isHistory;
  final Future<void> Function() onRefresh;

  const MyBookingsTabView({
    super.key,
    required this.bookings,
    required this.emptyMessage,
    required this.onRefresh,
    this.isHistory = false,
  });

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primary,
      child: AnimationLimiter(
        child: ListView.builder(
          padding: const EdgeInsets.all(BookingConstants.standardPadding),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: BookingListItem(
                    booking: booking,
                    isHistory: isHistory,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Builds empty state for the current tab
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isHistory ? Icons.history : Icons.event_available,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: BookingConstants.standardPadding),
            Text(
              emptyMessage,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
