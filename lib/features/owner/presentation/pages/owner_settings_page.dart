import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/settings/owner_about_section.dart';
import 'package:spo_kick/features/owner/presentation/widgets/settings/owner_account_section.dart';
import 'package:spo_kick/features/owner/presentation/widgets/settings/owner_booking_section.dart';
import 'package:spo_kick/features/owner/presentation/widgets/settings/owner_logout_button.dart';
import 'package:spo_kick/features/owner/presentation/widgets/settings/owner_notification_section.dart';

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
            const OwnerAccountSection(),
            const SizedBox(height: _sectionSpacing),
            OwnerNotificationSection(
              emailNotifications: _emailNotifications,
              pushNotifications: _pushNotifications,
              bookingNotifications: _bookingNotifications,
              onEmailChanged: (value) {
                setState(() => _emailNotifications = value);
              },
              onPushChanged: (value) {
                setState(() => _pushNotifications = value);
              },
              onBookingChanged: (value) {
                setState(() => _bookingNotifications = value);
              },
            ),
            const SizedBox(height: _sectionSpacing),
            OwnerBookingSection(
              autoApproveBookings: _autoApproveBookings,
              onAutoApproveChanged: (value) {
                setState(() => _autoApproveBookings = value);
              },
            ),
            const SizedBox(height: _sectionSpacing),
            const OwnerAboutSection(),
            const SizedBox(height: _sectionSpacing),
            const OwnerLogoutButton(),
          ],
        ),
      ),
    );
  }
}
