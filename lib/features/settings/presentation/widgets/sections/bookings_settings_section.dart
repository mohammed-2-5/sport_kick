import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
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
      title: 'Bookings',
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
          title: 'My Bookings',
          subtitle: 'View your booking history',
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.pushNamed('myBookings'),
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
          title: 'Weekly Subscriptions',
          subtitle: 'Manage your recurring bookings',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.goldAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'NEW',
                  style: TextStyle(
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
          title: 'Favorites',
          subtitle: 'View your favorite fields',
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.pushNamed('favorites'),
        ),
      ],
    );
  }
}
