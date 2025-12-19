import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/recurring_bookings/domain/entities/recurring_booking_entity.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/widgets/detail/recurring_detail_cancel_button.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/widgets/detail/recurring_detail_next_booking_card.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/widgets/detail/recurring_detail_rejection_card.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/widgets/detail/recurring_detail_schedule_card.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/widgets/detail/recurring_detail_stats_card.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/widgets/recurring_status_badge.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// Detail page for viewing a recurring booking subscription.
class RecurringBookingDetailPage extends StatelessWidget {
  final RecurringBookingEntity booking;

  const RecurringBookingDetailPage({required this.booking, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            RecurringDetailScheduleCard(booking: booking),
            const SizedBox(height: 16),
            RecurringDetailStatsCard(booking: booking),
            if (booking.nextBookingDate != null) ...[
              const SizedBox(height: 16),
              RecurringDetailNextBookingCard(booking: booking),
            ],
            if (booking.status == RecurringBookingStatus.rejected &&
                booking.rejectionReason != null) ...[
              const SizedBox(height: 16),
              RecurringDetailRejectionCard(reason: booking.rejectionReason!),
            ],
            if (booking.isActive) ...[
              const SizedBox(height: 24),
              RecurringDetailCancelButton(
                onConfirm: () async {
                  final confirmed = await _showCancelDialog(context);
                  if (confirmed == true && context.mounted) {
                    context.pop(true);
                  }
                },
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        color: AppColors.navyDeep,
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/bookings');
          }
        },
      ),
      title: Text(
        booking.fieldName,
        style: const TextStyle(
          color: AppColors.navyDeep,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: RecurringStatusBadge(status: booking.status, isCompact: true),
        ),
      ],
    );
  }

  Future<bool?> _showCancelDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.cancel_outlined, color: AppColors.error, size: 24),
            const SizedBox(width: 12),
            Text(context.l10n.cancelSubscriptionTitle),
          ],
        ),
        content: Text(context.l10n.cancelSubscriptionBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.l10n.keepSubscription),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: Text(context.l10n.cancel),
          ),
        ],
      ),
    );
  }
}
