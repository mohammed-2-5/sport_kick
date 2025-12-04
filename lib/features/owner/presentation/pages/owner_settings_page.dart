import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/settings/settings_section.dart';
import 'package:spo_kick/features/owner/presentation/widgets/settings/settings_tile.dart';
import 'package:spo_kick/features/owner/presentation/widgets/settings/switch_tile.dart';
import 'package:spo_kick/features/settings/presentation/constants/settings_constants.dart';
import 'package:url_launcher/url_launcher.dart';

/// Owner Settings Page
///
/// Settings page for field owners/admins:
/// - Change password
/// - Notification preferences
/// - Business hours configuration
/// - Auto-approve bookings toggle
/// - Account settings
class OwnerSettingsPage extends StatefulWidget {
  const OwnerSettingsPage({super.key});

  @override
  State<OwnerSettingsPage> createState() => _OwnerSettingsPageState();
}

class _OwnerSettingsPageState extends State<OwnerSettingsPage> {
  // Settings state
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _bookingNotifications = true;
  bool _autoApproveBookings = false;

  // Constants
  static const double _sectionSpacing = 24.0;
  static const double _itemSpacing = 8.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            context.goNamed('login');
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildAccountSection(),
            const SizedBox(height: _sectionSpacing),
            _buildNotificationSection(),
            const SizedBox(height: _sectionSpacing),
            _buildBookingSection(),
            const SizedBox(height: _sectionSpacing),
            _buildAboutSection(),
            const SizedBox(height: _sectionSpacing),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          _showLogoutDialog();
        },
        icon: const Icon(Icons.logout),
        label: const Text('Logout'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSection() {
    return SettingsSection(
      title: 'Account',
      icon: Icons.person_outline,
      children: [
        SettingsTile(
          leading: const Icon(Icons.lock_reset, color: AppColors.primary),
          title: 'Change Password',
          subtitle: 'Update your account password',
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            context.pushNamed('changePassword');
          },
        ),
        const SizedBox(height: _itemSpacing),
        SettingsTile(
          leading: const Icon(Icons.edit, color: AppColors.info),
          title: 'Edit Profile',
          subtitle: 'Update your personal information',
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            context.pushNamed('ownerProfile');
          },
        ),
      ],
    );
  }

  Widget _buildNotificationSection() {
    return SettingsSection(
      title: 'Notifications',
      icon: Icons.notifications_outlined,
      children: [
        SwitchTile(
          icon: Icons.email_outlined,
          iconColor: AppColors.primary,
          title: 'Email Notifications',
          subtitle: 'Receive notifications via email',
          value: _emailNotifications,
          onChanged: (value) {
            setState(() {
              _emailNotifications = value;
            });
          },
        ),
        const SizedBox(height: _itemSpacing),
        SwitchTile(
          icon: Icons.notifications_active,
          iconColor: AppColors.secondary,
          title: 'Push Notifications',
          subtitle: 'Receive push notifications on your device',
          value: _pushNotifications,
          onChanged: (value) {
            setState(() {
              _pushNotifications = value;
            });
          },
        ),
        const SizedBox(height: _itemSpacing),
        SwitchTile(
          icon: Icons.event_available,
          iconColor: AppColors.success,
          title: 'Booking Alerts',
          subtitle: 'Get notified about new bookings',
          value: _bookingNotifications,
          onChanged: (value) {
            setState(() {
              _bookingNotifications = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildBookingSection() {
    return SettingsSection(
      title: 'Booking Preferences',
      icon: Icons.settings_outlined,
      children: [
        SwitchTile(
          icon: Icons.check_circle_outline,
          iconColor: AppColors.success,
          title: 'Auto-Approve Bookings',
          subtitle: 'Automatically approve all booking requests',
          value: _autoApproveBookings,
          onChanged: (value) {
            setState(() {
              _autoApproveBookings = value;
            });
            _showAutoApproveDialog(value);
          },
        ),
        const SizedBox(height: _itemSpacing),
        SettingsTile(
          leading: const Icon(Icons.schedule, color: AppColors.info),
          title: 'Business Hours',
          subtitle: 'Set your operating hours',
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            _showBusinessHoursDialog();
          },
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return SettingsSection(
      title: 'About',
      icon: Icons.info_outline,
      children: [
        SettingsTile(
          leading: const Icon(
            Icons.privacy_tip_outlined,
            color: AppColors.info,
          ),
          title: 'Privacy Policy',
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            context.pushNamed('privacyPolicy');
          },
        ),
        const SizedBox(height: _itemSpacing),
        SettingsTile(
          leading: const Icon(
            Icons.description_outlined,
            color: AppColors.info,
          ),
          title: 'Terms of Service',
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            context.pushNamed('termsOfService');
          },
        ),
        const SizedBox(height: _itemSpacing),
        SettingsTile(
          leading: const Icon(Icons.help_outline, color: AppColors.warning),
          title: 'Help & Support',
          trailing: const Icon(Icons.email),
          onTap: () => _launchUrl(
            'mailto:${SettingsConstants.supportEmail}?subject=Sport%20Kick%20Support%20-%20Owner',
          ),
        ),
        const SizedBox(height: _itemSpacing),
        const SettingsTile(
          leading: Icon(Icons.info, color: AppColors.mediumGrey),
          title: 'Version',
          trailing: Text(
            '1.0.0',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  void _showAutoApproveDialog(bool enabled) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(enabled ? 'Auto-Approve Enabled' : 'Auto-Approve Disabled'),
        content: Text(
          enabled
              ? 'All new booking requests will be automatically approved.'
              : 'You will need to manually approve each booking request.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showBusinessHoursDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Business Hours'),
        content: const Text(
          'This feature is coming soon. You will be able to set your operating hours for each day of the week.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 12),
            Text('Logout'),
          ],
        ),
        content: const Text(
          'Are you sure you want to logout from your account?',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthCubit>().logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  /// Launches a URL in the default browser.
  ///
  /// Shows an error message if the URL cannot be launched.
  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open the link'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening link: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
