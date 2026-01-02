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
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildAvatar(colorScheme, isDark),
          const SizedBox(width: 12),
          Expanded(child: _buildUserDetails(context, colorScheme)),
          _buildSince(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildAvatar(ColorScheme colorScheme, bool isDark) {
    final successColor = isDark ? AppColors.darkSuccess : AppColors.success;
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: successColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: subscription.userAvatarUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                subscription.userAvatarUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.person_rounded, color: successColor),
              ),
            )
          : Icon(Icons.person_rounded, color: successColor),
    );
  }

  Widget _buildUserDetails(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subscription.userName ?? context.l10n.unknownUser,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        if (subscription.userPhone != null)
          Row(
            children: [
              Icon(
                Icons.phone_outlined,
                size: 12,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                subscription.userPhone!,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildSince(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          context.l10n.sinceLabel,
          style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
        ),
        Text(
          _formatStartDate(context),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
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
