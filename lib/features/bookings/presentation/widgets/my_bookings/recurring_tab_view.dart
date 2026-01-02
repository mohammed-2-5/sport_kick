import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/recurring_bookings/domain/entities/recurring_booking_entity.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/cubit/my_recurring_bookings_cubit.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/cubit/my_recurring_bookings_state.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/widgets/recurring_booking_card.dart';

/// Tab view for recurring bookings in My Bookings page.
///
/// Follows clean architecture by:
/// - Using BlocBuilder for state management
/// - Separating UI concerns into dedicated widgets
/// - Reusing existing RecurringBookingCard component
/// - No business logic in UI layer (data loading handled by cubit/router)
class RecurringTabView extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final VoidCallback onCreateNew;

  const RecurringTabView({
    required this.onRefresh,
    required this.onCreateNew,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyRecurringBookingsCubit, MyRecurringBookingsState>(
      builder: (context, state) {
        return switch (state) {
          MyRecurringBookingsInitial() => _buildLoading(context),
          MyRecurringBookingsLoading() => _buildLoading(context),
          MyRecurringBookingsError(:final message) => _buildError(
            context,
            message,
          ),
          MyRecurringBookingsLoaded(:final bookings) =>
            bookings.isEmpty
                ? _buildEmptyState(context)
                : _buildContent(context, state),
          MyRecurringBookingsActionInProgress(:final bookings) => _buildContent(
            context,
            MyRecurringBookingsLoaded(bookings: bookings),
          ),
        };
      },
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.accentCyan),
          const SizedBox(height: 16),
          Text(
            context.l10n.loadingSubscriptions,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 56,
              color: (isDark ? AppColors.darkError : AppColors.error)
                  .withValues(alpha: 0.7),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context
                  .read<MyRecurringBookingsCubit>()
                  .loadRecurringBookings(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentCyan,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(context.l10n.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.accentCyan.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.event_repeat_rounded,
                size: 48,
                color: AppColors.accentCyan.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.noRecurringSubscriptions,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.recurringSlotHint,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onCreateNew,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentCyan,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.add_circle_outline_rounded),
              label: Text(context.l10n.createSubscription),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, MyRecurringBookingsLoaded state) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.accentCyan,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Active subscriptions
          if (state.hasActive) ...[
            _SectionHeader(
              title: context.l10n.activeStatus,
              count: state.activeBookings.length,
              color: const Color(0xFF10B981),
            ),
            const SizedBox(height: 12),
            ...state.activeBookings.map(
              (booking) => _buildBookingCard(context, booking, isActive: true),
            ),
          ],

          // Pending approval
          if (state.hasPending) ...[
            const SizedBox(height: 20),
            _SectionHeader(
              title: context.l10n.pendingApproval,
              count: state.pendingBookings.length,
              color: AppColors.goldAccent,
            ),
            const SizedBox(height: 12),
            ...state.pendingBookings.map(
              (booking) => _buildBookingCard(context, booking),
            ),
          ],

          // History (canceled/rejected)
          if (state.otherBookings.isNotEmpty) ...[
            const SizedBox(height: 20),
            _SectionHeader(
              title: context.l10n.historyTab,
              count: state.otherBookings.length,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            ...state.otherBookings.map(
              (booking) => Opacity(
                opacity: 0.6,
                child: _buildBookingCard(context, booking),
              ),
            ),
          ],

          const SizedBox(height: 80), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildBookingCard(
    BuildContext context,
    RecurringBookingEntity booking, {
    bool isActive = false,
  }) {
    return RecurringBookingCard(
      booking: booking,
      onTap: () => _navigateToDetails(context, booking),
      onCancel: isActive ? () => _handleCancel(context, booking.id) : null,
    );
  }

  void _navigateToDetails(
    BuildContext context,
    RecurringBookingEntity booking,
  ) {
    context.pushNamed(
      'recurringBookingDetail',
      pathParameters: {'id': booking.id},
      extra: booking,
    );
  }

  Future<void> _handleCancel(BuildContext context, String bookingId) async {
    final confirmed = await _showCancelDialog(context);
    if (!confirmed) return;

    // Get cubit before any async operations to avoid using context across async gaps
    if (!context.mounted) return;
    await context.read<MyRecurringBookingsCubit>().cancelRecurringBooking(
      recurringBookingId: bookingId,
    );
  }

  Future<bool> _showCancelDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                const Icon(
                  Icons.cancel_outlined,
                  color: AppColors.error,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(context.l10n.cancelSubscriptionTitle),
              ],
            ),
            content: Text(context.l10n.cancelSubscriptionBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(context.l10n.keepBooking),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                ),
                child: Text(context.l10n.cancel),
              ),
            ],
          ),
        ) ??
        false;
  }
}

/// Section header widget with title and count badge.
class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const _SectionHeader({
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            count.toString(),
            style: AppTextStyles.labelMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
