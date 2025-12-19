import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.navyDeep.withValues(alpha: 0.08),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.navyDeep,
            AppColors.navyDeep.withValues(alpha: 0.9),
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
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.event_repeat_rounded,
              color: Colors.white,
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
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (booking.cityName != null)
                  Text(
                    booking.cityName!,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Day and time
          Row(
            children: [
              _buildInfoChip(
                icon: Icons.calendar_today_rounded,
                label: context.l10n.everyDay(
                  LocaleFormatters.weekdayName(
                    context,
                    booking.dayOfWeek,
                    short: true,
                  ),
                ),
                color: AppColors.accentCyan,
              ),
              const SizedBox(width: 12),
              _buildInfoChip(
                icon: Icons.access_time_rounded,
                label: LocaleFormatters.formatTimeRange(
                  context,
                  startTime: booking.startTime,
                  endTime: booking.endTime,
                ),
                color: AppColors.navyDeep,
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Duration and price
          Row(
            children: [
              _buildInfoChip(
                icon: Icons.timer_outlined,
                label: context.l10n.recurringHoursShort(
                  LocaleFormatters.formatNumber(
                    context,
                    booking.durationHours,
                    decimalDigits: 0,
                  ),
                ),
                color: Colors.orange,
              ),
              const SizedBox(width: 12),
              _buildInfoChip(
                icon: Icons.payments_outlined,
                label:
                    '${LocaleFormatters.formatPrice(context, amount: booking.pricePerBooking, currency: 'EGP', decimalDigits: 0)} / ${context.l10n.perWeek}',
                color: const Color(0xFF10B981),
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
                color: AppColors.navyDeep,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.navyDeep.withValues(alpha: 0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildNextBookingSection(BuildContext context) {
    if (booking.nextBookingDate == null) return const SizedBox.shrink();

    final isPaid = booking.nextBookingPaid ?? false;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isPaid
            ? const Color(0xFF10B981).withValues(alpha: 0.1)
            : AppColors.goldAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPaid
              ? const Color(0xFF10B981).withValues(alpha: 0.3)
              : AppColors.goldAccent.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isPaid ? Icons.check_circle_rounded : Icons.payment_rounded,
            color: isPaid ? const Color(0xFF10B981) : AppColors.goldAccent,
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
                    color: AppColors.textSecondary,
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
                    color: AppColors.navyDeep,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isPaid ? const Color(0xFF10B981) : AppColors.goldAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isPaid ? context.l10n.paidLabel : context.l10n.payNow,
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: isProcessing ? null : onCancel,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.error,
            side: BorderSide(color: AppColors.error.withValues(alpha: 0.5)),
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
        color: AppColors.goldAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.goldAccent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.hourglass_empty_rounded,
            color: AppColors.goldAccent,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              context.l10n.pendingApprovalMessage,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.goldAccent.withValues(alpha: 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRejectionMessage(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.block_rounded, color: AppColors.error, size: 20),
              const SizedBox(width: 10),
              Text(
                context.l10n.requestRejected,
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.error,
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
