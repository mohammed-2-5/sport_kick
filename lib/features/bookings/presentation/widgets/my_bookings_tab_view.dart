import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_empty_state.dart';
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
  final VoidCallback? onAction;

  const MyBookingsTabView({
    super.key,
    required this.bookings,
    required this.emptyMessage,
    required this.onRefresh,
    this.isHistory = false,
    this.onAction,
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
    return PremiumEmptyState(
      icon: isHistory ? Icons.history : Icons.event_available,
      title: isHistory ? 'No Past Bookings' : 'No Upcoming Bookings',
      message: emptyMessage,
      actionLabel: onAction != null ? 'Browse Fields' : null,
      onAction: onAction,
    );
  }
}
