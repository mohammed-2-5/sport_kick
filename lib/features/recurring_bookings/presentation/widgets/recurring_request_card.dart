import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/recurring_bookings/domain/entities/recurring_booking_entity.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// Card widget for displaying a pending recurring booking request (owner view).
class RecurringRequestCard extends StatelessWidget {
  final RecurringBookingEntity request;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final bool isProcessing;

  const RecurringRequestCard({
    required this.request,
    this.onApprove,
    this.onReject,
    this.isProcessing = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          _buildUserInfo(context),
          _buildScheduleInfo(context),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.goldAccent,
            AppColors.goldAccent.withValues(alpha: 0.8),
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
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.event_repeat_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.newRecurringRequest,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  request.fieldName,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Time ago badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _getTimeAgo(context),
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // User avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.accentCyan.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: request.userAvatarUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      request.userAvatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.person_rounded,
                        color: AppColors.accentCyan,
                      ),
                    ),
                  )
                : const Icon(Icons.person_rounded, color: AppColors.accentCyan),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.userName ?? context.l10n.unknownUser,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navyDeep,
                  ),
                ),
                if (request.userPhone != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.phone_outlined,
                        size: 12,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        request.userPhone!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleInfo(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.navyDeep.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.navyDeep.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildScheduleItem(
                  icon: Icons.calendar_today_rounded,
                  label: context.l10n.everyLabel,
                  value: LocaleFormatters.weekdayName(
                    context,
                    request.dayOfWeek,
                  ),
                ),
              ),
              Container(width: 1, height: 40, color: AppColors.border),
              Expanded(
                child: _buildScheduleItem(
                  icon: Icons.access_time_rounded,
                  label: context.l10n.timeLabel,
                  value: LocaleFormatters.formatTimeRange(
                    context,
                    startTime: request.startTime,
                    endTime: request.endTime,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildScheduleItem(
                  icon: Icons.timer_outlined,
                  label: context.l10n.durationLabel,
                  value: context.l10n.recurringHoursLabel(
                    request.durationHours,
                    LocaleFormatters.formatNumber(
                      context,
                      request.durationHours,
                      decimalDigits: 0,
                    ),
                  ),
                ),
              ),
              Container(width: 1, height: 40, color: AppColors.border),
              Expanded(
                child: _buildScheduleItem(
                  icon: Icons.payments_outlined,
                  label: context.l10n.weeklyLabel,
                  value: LocaleFormatters.formatPrice(
                    context,
                    amount: request.pricePerBooking,
                    currency: 'EGP',
                    decimalDigits: 0,
                  ),
                  valueColor: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: valueColor ?? AppColors.navyDeep,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Reject button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: isProcessing ? null : onReject,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: BorderSide(color: AppColors.error.withValues(alpha: 0.5)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.close_rounded, size: 18),
              label: Text(context.l10n.reject),
            ),
          ),
          const SizedBox(width: 12),
          // Approve button
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: isProcessing ? null : onApprove,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              icon: isProcessing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check_rounded, size: 18),
              label: Text(
                isProcessing
                    ? context.l10n.processingRequest
                    : context.l10n.approve,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(BuildContext context) {
    final now = DateTime.now();
    final diff = now.difference(request.createdAt);

    if (diff.inMinutes < 1) return context.l10n.notificationJustNow;
    if (diff.inMinutes < 60) {
      final minutes = LocaleFormatters.formatNumber(
        context,
        diff.inMinutes,
        decimalDigits: 0,
      );
      return context.l10n.notificationMinutesAgo(minutes);
    }
    if (diff.inHours < 24) {
      final hours = LocaleFormatters.formatNumber(
        context,
        diff.inHours,
        decimalDigits: 0,
      );
      return context.l10n.notificationHoursAgo(hours);
    }
    if (diff.inDays < 7) {
      final days = LocaleFormatters.formatNumber(
        context,
        diff.inDays,
        decimalDigits: 0,
      );
      return context.l10n.notificationDaysAgo(days);
    }

    return LocaleFormatters.formatDate(
      context,
      request.createdAt,
      pattern: 'MMM d',
    );
  }
}
