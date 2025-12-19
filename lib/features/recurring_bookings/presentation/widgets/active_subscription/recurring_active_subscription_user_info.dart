import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/recurring_bookings/domain/entities/recurring_booking_entity.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// User info section for active subscription card.
class RecurringActiveSubscriptionUserInfo extends StatelessWidget {
  final RecurringBookingEntity subscription;

  const RecurringActiveSubscriptionUserInfo({
    required this.subscription,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildAvatar(),
          const SizedBox(width: 12),
          Expanded(child: _buildUserDetails(context)),
          _buildSince(context),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: subscription.userAvatarUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                subscription.userAvatarUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.person_rounded, color: Color(0xFF10B981)),
              ),
            )
          : const Icon(Icons.person_rounded, color: Color(0xFF10B981)),
    );
  }

  Widget _buildUserDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subscription.userName ?? context.l10n.unknownUser,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.navyDeep,
          ),
        ),
        if (subscription.userPhone != null)
          Row(
            children: [
              const Icon(
                Icons.phone_outlined,
                size: 12,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                subscription.userPhone!,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildSince(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          context.l10n.sinceLabel,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        Text(
          _formatStartDate(context),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.navyDeep,
          ),
        ),
      ],
    );
  }

  String _formatStartDate(BuildContext context) {
    if (subscription.startedAt == null) return context.l10n.notAvailable;
    return LocaleFormatters.formatDate(
      context,
      subscription.startedAt!,
      pattern: 'MMM d',
    );
  }
}
