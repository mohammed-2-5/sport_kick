import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/recurring_bookings/domain/entities/recurring_booking_entity.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/cubit/my_recurring_bookings_cubit.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/cubit/my_recurring_bookings_state.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/widgets/recurring_booking_card.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings/recurring/recurring_cancel_dialog.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings/recurring/recurring_section_header.dart';

/// Content list for recurring bookings.
class RecurringContentList extends StatelessWidget {
  final MyRecurringBookingsLoaded state;
  final Future<void> Function() onRefresh;

  const RecurringContentList({
    super.key,
    required this.state,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successColor = isDark ? AppColors.darkSuccess : AppColors.success;
    final warningColor = isDark ? AppColors.darkWarning : AppColors.warning;

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: colorScheme.primary,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Active subscriptions
          if (state.hasActive) ...[
            RecurringSectionHeader(
              title: context.l10n.activeStatus,
              count: state.activeBookings.length,
              color: successColor,
            ),
            const SizedBox(height: 12),
            ...state.activeBookings.map(
              (booking) => _BookingCardItem(booking: booking, isActive: true),
            ),
          ],

          // Pending approval
          if (state.hasPending) ...[
            const SizedBox(height: 20),
            RecurringSectionHeader(
              title: context.l10n.pendingApproval,
              count: state.pendingBookings.length,
              color: warningColor,
            ),
            const SizedBox(height: 12),
            ...state.pendingBookings.map(
              (booking) => _BookingCardItem(booking: booking),
            ),
          ],

          // History (canceled/rejected)
          if (state.otherBookings.isNotEmpty) ...[
            const SizedBox(height: 20),
            RecurringSectionHeader(
              title: context.l10n.historyTab,
              count: state.otherBookings.length,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            ...state.otherBookings.map(
              (booking) => Opacity(
                opacity: 0.6,
                child: _BookingCardItem(booking: booking),
              ),
            ),
          ],

          const SizedBox(height: 80), // Bottom padding
        ],
      ),
    );
  }
}

/// Individual booking card item with navigation and cancel handling.
class _BookingCardItem extends StatelessWidget {
  final RecurringBookingEntity booking;
  final bool isActive;

  const _BookingCardItem({required this.booking, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return RecurringBookingCard(
      booking: booking,
      onTap: () => _navigateToDetails(context),
      onCancel: isActive ? () => _handleCancel(context) : null,
    );
  }

  void _navigateToDetails(BuildContext context) {
    context.pushNamed(
      'recurringBookingDetail',
      pathParameters: {'id': booking.id},
      extra: booking,
    );
  }

  Future<void> _handleCancel(BuildContext context) async {
    final confirmed = await RecurringCancelDialog.show(context);
    if (!confirmed || !context.mounted) return;

    await context.read<MyRecurringBookingsCubit>().cancelRecurringBooking(
      recurringBookingId: booking.id,
    );
  }
}
