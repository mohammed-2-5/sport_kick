import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/cubit/my_recurring_bookings_cubit.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/cubit/my_recurring_bookings_state.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/widgets/my_recurring_bookings_content.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// Page for displaying user's recurring booking subscriptions.
class MyRecurringBookingsPage extends StatefulWidget {
  const MyRecurringBookingsPage({super.key});

  @override
  State<MyRecurringBookingsPage> createState() =>
      _MyRecurringBookingsPageState();
}

class _MyRecurringBookingsPageState extends State<MyRecurringBookingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<MyRecurringBookingsCubit>().loadRecurringBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          color: AppColors.navyDeep,
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: Text(
          context.l10n.mySubscriptions,
          style: const TextStyle(
            color: AppColors.navyDeep,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            color: AppColors.accentCyan,
            tooltip: context.l10n.newSubscription,
            onPressed: () => _navigateToFieldSelection(),
          ),
        ],
      ),
      body: BlocBuilder<MyRecurringBookingsCubit, MyRecurringBookingsState>(
        builder: (context, state) {
          return switch (state) {
            MyRecurringBookingsInitial() => const _LoadingView(),
            MyRecurringBookingsLoading() => const _LoadingView(),
            MyRecurringBookingsLoaded() => MyRecurringBookingsContent(
              state: state,
              onCancel: _handleCancel,
              onRefresh: _handleRefresh,
            ),
            MyRecurringBookingsActionInProgress(:final bookings) =>
              MyRecurringBookingsContent(
                state: MyRecurringBookingsLoaded(bookings: bookings),
                onCancel: null, // Disable cancel while action in progress
                onRefresh: _handleRefresh,
              ),
            MyRecurringBookingsError(:final message) => _ErrorView(
              message: message,
              onRetry: _handleRefresh,
            ),
          };
        },
      ),
    );
  }

  void _navigateToFieldSelection() {
    // Navigate to field selection for creating new recurring booking
    context.pushNamed('fieldsList', queryParameters: {'forRecurring': 'true'});
  }

  Future<void> _handleCancel(String bookingId) async {
    final confirmed = await _showCancelConfirmation();
    if (confirmed && mounted) {
      final success = await context
          .read<MyRecurringBookingsCubit>()
          .cancelRecurringBooking(recurringBookingId: bookingId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? context.l10n.subscriptionCanceled
                  : context.l10n.subscriptionCancelFailed,
            ),
            backgroundColor: success
                ? const Color(0xFF10B981)
                : AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  Future<bool> _showCancelConfirmation() async {
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
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.cancelSubscriptionQuestion),
                const SizedBox(height: 12),
                Text(
                  context.l10n.cancelSubscriptionBody,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(context.l10n.keepSubscription),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(context.l10n.cancel),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _handleRefresh() async {
    await context.read<MyRecurringBookingsCubit>().refresh();
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.accentCyan),
          const SizedBox(height: 16),
          Text(
            context.l10n.loadingSubscriptions,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppColors.error.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentCyan,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
