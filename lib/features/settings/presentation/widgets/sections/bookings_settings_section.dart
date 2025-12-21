import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/settings/presentation/constants/settings_constants.dart';
import 'package:spo_kick/features/settings/presentation/widgets/shared/settings_section.dart';
import 'package:spo_kick/features/settings/presentation/widgets/shared/settings_tile.dart';

/// Bookings settings section for user settings page.
///
/// Includes:
/// - My Bookings - View booking history
/// - My Subscriptions - Manage weekly recurring bookings
/// - Favorites - View favorite fields
class BookingsSettingsSection extends StatelessWidget {
  const BookingsSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: context.l10n.bookingsSettings,
      icon: Icons.calendar_month_outlined,
      children: [
        SettingsTile(
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.accentCyan.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.history_rounded,
              color: AppColors.accentCyan,
              size: 20,
            ),
          ),
          title: context.l10n.bookingsHistory,
          subtitle: context.l10n.bookingsHistoryDesc,
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.pushNamed(context.l10n.mybookings),
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        SettingsTile(
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.goldAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.event_repeat_rounded,
              color: AppColors.goldAccent,
              size: 20,
            ),
          ),
          title: context.l10n.weeklySubscriptions,
          subtitle: context.l10n.weeklySubscriptionsDesc,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.goldAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  context.l10n.newLabel,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.goldAccent,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right),
            ],
          ),
          onTap: () => context.pushNamed('myRecurringBookings'),
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        SettingsTile(
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.favorite_rounded,
              color: AppColors.error,
              size: 20,
            ),
          ),
          title: context.l10n.favoritesTitle,
          subtitle: context.l10n.favoritesDesc,
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.pushNamed(context.l10n.favoritesTab),
        ),
      ],
    );
  }
}
