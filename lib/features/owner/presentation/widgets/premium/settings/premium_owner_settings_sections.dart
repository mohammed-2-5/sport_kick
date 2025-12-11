import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';

/// Premium settings sections.
///
/// Features:
/// - Account settings
/// - Notification settings
/// - Booking settings
/// - About section
class PremiumOwnerSettingsSections extends StatelessWidget {
  final bool emailNotifications;
  final bool pushNotifications;
  final bool bookingNotifications;
  final bool autoApproveBookings;
  final ValueChanged<bool> onEmailChanged;
  final ValueChanged<bool> onPushChanged;
  final ValueChanged<bool> onBookingChanged;
  final ValueChanged<bool> onAutoApproveChanged;
  final VoidCallback onLogout;

  const PremiumOwnerSettingsSections({
    super.key,
    required this.emailNotifications,
    required this.pushNotifications,
    required this.bookingNotifications,
    required this.autoApproveBookings,
    required this.onEmailChanged,
    required this.onPushChanged,
    required this.onBookingChanged,
    required this.onAutoApproveChanged,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Account Section
        _SettingsSection(
          title: 'Account',
          icon: Icons.person_outline,
          iconGradient: const [AppColors.accentCyan, AppColors.accentCyanDark],
          children: [
            _SettingsTile(
              icon: Icons.lock_outline,
              title: 'Change Password',
              subtitle: 'Update your password',
              onTap: () {
                HapticFeedback.lightImpact();
                context.pushNamed('changePassword');
              },
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Notification Section
        _SettingsSection(
          title: 'Notifications',
          icon: Icons.notifications_outlined,
          iconGradient: const [Colors.orange, Colors.deepOrange],
          children: [
            _SwitchTile(
              icon: Icons.email_outlined,
              title: 'Email Notifications',
              subtitle: 'Receive updates via email',
              value: emailNotifications,
              onChanged: (value) {
                HapticFeedback.lightImpact();
                onEmailChanged(value);
              },
            ),
            const Divider(height: 1),
            _SwitchTile(
              icon: Icons.phone_android,
              title: 'Push Notifications',
              subtitle: 'Receive push notifications',
              value: pushNotifications,
              onChanged: (value) {
                HapticFeedback.lightImpact();
                onPushChanged(value);
              },
            ),
            const Divider(height: 1),
            _SwitchTile(
              icon: Icons.calendar_today,
              title: 'Booking Notifications',
              subtitle: 'Get notified about bookings',
              value: bookingNotifications,
              onChanged: (value) {
                HapticFeedback.lightImpact();
                onBookingChanged(value);
              },
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Booking Section
        _SettingsSection(
          title: 'Booking Settings',
          icon: Icons.settings_outlined,
          iconGradient: const [Colors.purple, Colors.deepPurple],
          children: [
            _SwitchTile(
              icon: Icons.check_circle_outline,
              title: 'Auto-Approve Bookings',
              subtitle: 'Automatically approve new bookings',
              value: autoApproveBookings,
              onChanged: (value) {
                HapticFeedback.lightImpact();
                onAutoApproveChanged(value);
              },
            ),
          ],
        ),

        const SizedBox(height: 20),

        // About Section
        _SettingsSection(
          title: 'About',
          icon: Icons.info_outline,
          iconGradient: const [Colors.grey, Colors.blueGrey],
          children: [
            _SettingsTile(
              icon: Icons.article_outlined,
              title: 'Terms & Conditions',
              subtitle: 'Read our terms',
              onTap: () {
                HapticFeedback.lightImpact();
                // Navigate to terms
              },
            ),
            const Divider(height: 1),
            _SettingsTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'Read our privacy policy',
              onTap: () {
                HapticFeedback.lightImpact();
                // Navigate to privacy
              },
            ),
            const Divider(height: 1),
            const _InfoTile(icon: Icons.info, title: 'Version', value: '1.0.0'),
          ],
        ),

        const SizedBox(height: 20),

        // Logout Button
        PremiumCard(
          onTap: () {
            HapticFeedback.mediumImpact();
            onLogout();
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, color: Colors.red),
                SizedBox(width: 12),
                Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Settings section with title.
class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Color> iconGradient;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.iconGradient,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: iconGradient),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        PremiumCard(child: Column(children: children)),
      ],
    );
  }
}

/// Settings tile with tap action.
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

/// Switch tile for toggles.
class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.accentCyan,
            activeThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

/// Info tile with static value.
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
