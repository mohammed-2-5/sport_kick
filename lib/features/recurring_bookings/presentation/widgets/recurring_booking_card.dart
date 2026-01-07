import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/recurring_bookings/domain/entities/recurring_booking_entity.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/widgets/recurring_status_badge.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// Card widget for displaying a recurring booking subscription.
class RecurringBookingCard extends StatelessWidget {
  final RecurringBookingEntity booking;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;
  final bool isProcessing;

  const RecurringBookingCard({
    required this.booking,
    this.onTap,
    this.onCancel,
    this.isProcessing = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildContent(context),
            if (booking.isActive) _buildNextBookingSection(context),
            if (booking.isActive && onCancel != null)
              _buildCancelButton(context),
            if (booking.isPending) _buildPendingMessage(context),
            if (booking.status == RecurringBookingStatus.rejected)
              _buildRejectionMessage(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          // Recurring icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colorScheme.onPrimary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.event_repeat_rounded,
              color: colorScheme.onPrimary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          // Field info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.fieldName,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (booking.cityName != null)
                  Text(
                    booking.cityName!,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: colorScheme.onPrimary.withValues(alpha: 0.7),
                    ),
                  ),
              ],
            ),
          ),
          RecurringStatusBadge(status: booking.status),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Day and time
          Row(
            children: [
              _buildInfoChip(
                context: context,
                icon: Icons.calendar_today_rounded,
                label: context.l10n.everyDay(
                  LocaleFormatters.weekdayName(
                    context,
                    booking.dayOfWeek,
                    short: true,
                  ),
                ),
                color: colorScheme.secondary,
              ),
              const SizedBox(width: 12),
              _buildInfoChip(
                context: context,
                icon: Icons.access_time_rounded,
                label: LocaleFormatters.formatTimeRange(
                  context,
                  startTime: booking.startTime,
                  endTime: booking.endTime,
                ),
                color: colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Duration and price
          Row(
            children: [
              _buildInfoChip(
                context: context,
                icon: Icons.timer_outlined,
                label: context.l10n.recurringHoursShort(
                  LocaleFormatters.formatNumber(
                    context,
                    booking.durationHours,
                    decimalDigits: 0,
                  ),
                ),
                color: colorScheme.tertiary,
              ),
              const SizedBox(width: 12),
              _buildInfoChip(
                context: context,
                icon: Icons.payments_outlined,
                label:
                    '${LocaleFormatters.formatPrice(context, amount: booking.pricePerBooking, currency: 'EGP', decimalDigits: 0)} / ${context.l10n.perWeek}',
                color: colorScheme.primary,
              ),
            ],
          ),
          if (booking.isActive && booking.totalBookingsCount > 0) ...[
            const SizedBox(height: 16),
            _buildProgressBar(context),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final successColor = colorScheme.primary;
    final progress = booking.totalBookingsCount > 0
        ? booking.completedBookingsCount / booking.totalBookingsCount
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.l10n.completedSessionsLabel,
              style: AppTextStyles.caption,
            ),
            Text(
              '${LocaleFormatters.formatNumber(context, booking.completedBookingsCount, decimalDigits: 0)} / ${LocaleFormatters.formatNumber(context, booking.totalBookingsCount, decimalDigits: 0)}',
              style: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: colorScheme.outline.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(successColor),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildNextBookingSection(BuildContext context) {
    if (booking.nextBookingDate == null) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final successColor = colorScheme.primary;
    final isPaid = booking.nextBookingPaid ?? false;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isPaid
            ? successColor.withValues(alpha: 0.1)
            : colorScheme.tertiary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPaid
              ? successColor.withValues(alpha: 0.3)
              : colorScheme.tertiary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isPaid ? Icons.check_circle_rounded : Icons.payment_rounded,
            color: isPaid ? successColor : colorScheme.tertiary,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.nextBooking,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  LocaleFormatters.formatDate(
                    context,
                    booking.nextBookingDate!,
                    pattern: 'EEE, MMM d',
                  ),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isPaid ? successColor : colorScheme.tertiary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isPaid ? context.l10n.paidLabel : context.l10n.payNow,
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: isProcessing ? null : onCancel,
          style: OutlinedButton.styleFrom(
            foregroundColor: errorColor,
            side: BorderSide(color: errorColor.withValues(alpha: 0.5)),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: isProcessing
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.cancel_outlined, size: 18),
          label: Text(
            isProcessing
                ? context.l10n.cancelingSubscription
                : context.l10n.cancelSubscription,
          ),
        ),
      ),
    );
  }

  Widget _buildPendingMessage(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.hourglass_empty_rounded,
            color: Theme.of(context).colorScheme.tertiary,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              context.l10n.pendingApprovalMessage,
              style: AppTextStyles.caption.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.tertiary.withValues(alpha: 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRejectionMessage(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: errorColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: errorColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.block_rounded, color: errorColor, size: 20),
              const SizedBox(width: 10),
              Text(
                context.l10n.requestRejected,
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: errorColor,
                ),
              ),
            ],
          ),
          if (booking.rejectionReason != null) ...[
            const SizedBox(height: 8),
            Text(booking.rejectionReason!, style: AppTextStyles.caption),
          ],
        ],
      ),
    );
  }
}
